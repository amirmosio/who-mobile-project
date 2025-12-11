import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CsvDecryptionUtil {
  static Future<String> loadEncryptedCsv(String assetPath) async {
    try {
      final encryptionKey = dotenv.env['CSV_ENCRYPTION_KEY'];
      if (encryptionKey == null || encryptionKey.isEmpty) {
        throw DecryptionException(
          'CSV_ENCRYPTION_KEY not found in .env file. '
          'Please run: dart run scripts/generate_encryption_key.dart',
        );
      }

      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List encryptedBytes = data.buffer.asUint8List();
      final decryptedContent = _decryptData(encryptedBytes, encryptionKey);
      return decryptedContent;
    } on FlutterError catch (e) {
      throw AssetNotFoundException(
        'Could not load encrypted CSV file: $assetPath. Error: ${e.message}',
      );
    } catch (e) {
      throw DecryptionException(
        'Failed to decrypt CSV file: $assetPath. Error: $e',
      );
    }
  }

  static String _decryptData(Uint8List encryptedData, String keyBase64) {
    try {
      final keyBytes = base64.decode(keyBase64);
      final key = encrypt.Key(Uint8List.fromList(keyBytes.take(32).toList()));
      final iv = encrypt.IV(
        Uint8List.fromList(encryptedData.take(16).toList()),
      );
      final encryptedContent = Uint8List.fromList(
        encryptedData.skip(16).toList(),
      );
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );
      final encrypted = encrypt.Encrypted(encryptedContent);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      throw DecryptionException('Decryption failed: $e');
    }
  }

  static Future<List<List<String>>> loadAndParseCsv(
    String assetPath, {
    String delimiter = ',',
    bool skipEmptyLines = true,
  }) async {
    final csvContent = await loadEncryptedCsv(assetPath);
    return parseCsvContent(
      csvContent,
      delimiter: delimiter,
      skipEmptyLines: skipEmptyLines,
    );
  }

  static List<List<String>> parseCsvContent(
    String csvContent, {
    String delimiter = ',',
    bool skipEmptyLines = true,
  }) {
    final lines = csvContent.split('\n');
    final result = <List<String>>[];

    for (final line in lines) {
      final trimmedLine = line.trim();

      if (skipEmptyLines && trimmedLine.isEmpty) {
        continue;
      }

      final values = trimmedLine.split(delimiter).map((v) => v.trim()).toList();
      result.add(values);
    }

    return result;
  }

  static Future<List<List<String>>> loadQuizCsv(String assetPath) async {
    return loadAndParseCsv(assetPath, delimiter: '__', skipEmptyLines: true);
  }

  static Future<List<List<String>>> loadIdQuizzesCsv(String assetPath) async {
    return loadAndParseCsv(assetPath, delimiter: ',', skipEmptyLines: true);
  }
}

class AssetNotFoundException implements Exception {
  final String message;
  AssetNotFoundException(this.message);

  @override
  String toString() => 'AssetNotFoundException: $message';
}

class DecryptionException implements Exception {
  final String message;
  DecryptionException(this.message);

  @override
  String toString() => 'DecryptionException: $message';
}
