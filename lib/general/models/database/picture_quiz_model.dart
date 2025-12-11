/// PictureQuiz model from API
/// Maps to PictureQuizzes table in local database
/// Used for images in Arguments, LicenseTypes, and Manuals
class PictureQuizModel {
  final int id;
  final String? image;
  final String? imageHd;
  final double? aspectRatio;
  final String? symbol;

  PictureQuizModel({
    required this.id,
    this.image,
    this.imageHd,
    this.aspectRatio,
    this.symbol,
  });

  factory PictureQuizModel.fromJson(Map<String, dynamic> json) {
    return PictureQuizModel(
      id: json['id'] as int,
      image: json['image'] as String?,
      imageHd: json['image_hd'] as String?,
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
      symbol: json['symbol'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (image != null) 'image': image,
      if (imageHd != null) 'image_hd': imageHd,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (symbol != null) 'symbol': symbol,
    };
  }
}
