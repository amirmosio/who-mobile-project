class AddressModel {
  final String? street;
  final String? houseNumber;
  final String? postalCode;
  final String? city;
  final String? province;

  AddressModel({
    this.street,
    this.houseNumber,
    this.postalCode,
    this.city,
    this.province,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'],
      houseNumber: json['house_number'],
      postalCode: json['postal_code'],
      city: json['city'],
      province: json['province'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'house_number': houseNumber,
      'postal_code': postalCode,
      'city': city,
      'province': province,
    };
  }

  String get fullAddress {
    final parts = <String>[];

    if (street != null && street!.isNotEmpty) {
      parts.add(street!);
    }

    if (houseNumber != null && houseNumber!.isNotEmpty) {
      parts.add(houseNumber!);
    }

    if (postalCode != null && postalCode!.isNotEmpty) {
      parts.add(postalCode!);
    }

    if (city != null && city!.isNotEmpty) {
      parts.add(city!);
    }

    if (province != null && province!.isNotEmpty) {
      parts.add(province!);
    }

    return parts.join(', ');
  }

  bool get isEmpty {
    return (street == null || street!.isEmpty) &&
        (houseNumber == null || houseNumber!.isEmpty) &&
        (postalCode == null || postalCode!.isEmpty) &&
        (city == null || city!.isEmpty) &&
        (province == null || province!.isEmpty);
  }

  bool get isComplete {
    return street != null &&
        street!.isNotEmpty &&
        houseNumber != null &&
        houseNumber!.isNotEmpty &&
        postalCode != null &&
        postalCode!.isNotEmpty &&
        city != null &&
        city!.isNotEmpty &&
        province != null &&
        province!.isNotEmpty;
  }
}
