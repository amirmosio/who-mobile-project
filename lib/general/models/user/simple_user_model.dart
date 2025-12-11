class SimpleUserModel {
  final int id;
  final String email;
  final String? firstName;
  final String? surname;

  const SimpleUserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.surname,
  });

  String? get fullName {
    if (firstName == null && surname == null) return null;
    return "${firstName ?? ''} ${surname ?? ''}".trim();
  }

  factory SimpleUserModel.fromJson(Map<String, dynamic> json) {
    return SimpleUserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstname'] as String?,
      surname: json['surname'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (firstName != null) 'firstname': firstName,
      if (surname != null) 'surname': surname,
    };
  }

  SimpleUserModel copyWith({
    int? id,
    String? email,
    String? firstName,
    String? surname,
    bool? isGuest,
    String? image,
  }) {
    return SimpleUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      surname: surname ?? this.surname,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleUserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => Object.hash(id, email);

  @override
  String toString() =>
      'SimpleUserModel(id: $id, email: $email, fullName: $fullName)';
}
