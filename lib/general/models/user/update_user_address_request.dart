/// Request model for updating user address
/// Used for PATCH /users/{id}/ endpoint
class UpdateUserAddressRequest {
  final String? address;
  final String? city;
  final String? zipCode;
  final String? province;

  const UpdateUserAddressRequest({
    this.address,
    this.city,
    this.zipCode,
    this.province,
  });

  factory UpdateUserAddressRequest.fromJson(Map<String, dynamic> json) {
    return UpdateUserAddressRequest(
      address: json['address'] as String?,
      city: json['city'] as String?,
      zipCode: json['zip_code'] as String?,
      province: json['provincia'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (address != null) json['address'] = address;
    if (city != null) json['city'] = city;
    if (zipCode != null) json['zip_code'] = zipCode;
    if (province != null) json['provincia'] = province;

    return json;
  }
}
