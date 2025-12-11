class SchoolModel {
  final int id;
  final String name;
  final String? email;
  final String? address;
  final String? city;
  final String? vatName;
  final String? vatNumber;
  final String? cf;
  final String? pec;
  final String? zipCode;
  final String? provincia;
  final String? country;
  final String? latitude;
  final String? longitude;
  final String? phone;
  final String? fax;
  final String? image;
  final String? advertisingImage;
  final DateTime? registrationDatetime;
  final bool? isActive;
  final bool? mailConfirmed;
  final bool hasRetargetingEnabled;
  final bool isGev;
  final bool isSmart;
  final bool hasZeroPensieriEnabled;

  const SchoolModel({
    required this.id,
    required this.name,
    this.email,
    this.address,
    this.city,
    this.vatName,
    this.vatNumber,
    this.cf,
    this.pec,
    this.zipCode,
    this.provincia,
    this.country,
    this.latitude,
    this.longitude,
    this.phone,
    this.fax,
    this.image,
    this.advertisingImage,
    this.registrationDatetime,
    this.isActive,
    this.mailConfirmed,
    this.hasRetargetingEnabled = false,
    this.isGev = false,
    this.isSmart = false,
    this.hasZeroPensieriEnabled = false,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      vatName: json['vat_name'] as String?,
      vatNumber: json['vat_number'] as String?,
      cf: json['c_f'] as String?,
      pec: json['pec'] as String?,
      zipCode: json['zip_code'] as String?,
      provincia: json['provincia'] as String?,
      country: json['country'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      phone: json['phone'] as String?,
      fax: json['fax'] as String?,
      image: json['image'] as String?,
      advertisingImage: json['advertising_image'] as String?,
      registrationDatetime: json['registration_datetime'] != null
          ? DateTime.tryParse(json['registration_datetime'] as String)
          : null,
      isActive: json['is_active'] as bool?,
      mailConfirmed: json['mail_confirmed'] as bool?,
      hasRetargetingEnabled: json['has_retargeting_enabled'] as bool? ?? false,
      isGev: json['is_gev'] as bool? ?? false,
      isSmart: json['is_smart'] as bool? ?? false,
      hasZeroPensieriEnabled:
          json['has_zero_pensieri_enabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (vatName != null) 'vat_name': vatName,
      if (vatNumber != null) 'vat_number': vatNumber,
      if (cf != null) 'c_f': cf,
      if (pec != null) 'pec': pec,
      if (zipCode != null) 'zip_code': zipCode,
      if (provincia != null) 'provincia': provincia,
      if (country != null) 'country': country,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (fax != null) 'fax': fax,
      if (image != null) 'image': image,
      if (advertisingImage != null) 'advertising_image': advertisingImage,
      if (registrationDatetime != null)
        'registration_datetime': registrationDatetime!.toIso8601String(),
      if (isActive != null) 'is_active': isActive,
      if (mailConfirmed != null) 'mail_confirmed': mailConfirmed,
      'has_retargeting_enabled': hasRetargetingEnabled,
      'is_gev': isGev,
      'is_smart': isSmart,
      'has_zero_pensieri_enabled': hasZeroPensieriEnabled,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SchoolModel(id: $id, name: $name)';
}
