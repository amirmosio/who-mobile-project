import 'package:intl/intl.dart';
import 'package:who_mobile_project/app_core/config/environment_constants.dart';

extension MoneyExtension on double {
  String get stringRoundedIntMoney {
    final formatter = NumberFormat("#,##0.##", "en_US");

    // Format the amount
    String formattedAmount = formatter.format(this);

    return formattedAmount;
  }

  String get stringRoundedWithOneDecimal {
    String roundedString = toStringAsFixed(1);
    double roundedDouble = double.parse(roundedString);
    if (roundedDouble == roundedDouble.toInt()) {
      return roundedDouble.toInt().toString();
    }
    return roundedString;
  }
}

extension StringExtension on String {
  String get capitalizeFirstLetter {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension URLStringExtension on String {
  String get addDomainIfNeeded {
    String result = this;
    if (!startsWith('http://') && !startsWith('https://')) {
      try {
        final domain = Constants.domain;
        if (startsWith('/')) {
          result = '$domain$this';
        } else {
          result = '$domain/$this';
        }
      } catch (e) {
        result = this;
      }
    }
    if (Constants.env == Environment.local) {
      result = result.replaceAll("staging.", "app.");
    }
    return result;
  }
}
