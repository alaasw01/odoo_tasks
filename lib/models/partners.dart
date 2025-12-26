class Partner {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? country;

  Partner({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.country,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] == false ? '' : json['email'],
      phone: json['phone'] == false ? '' : json['phone'],
      country: json['country_id'] != false ? json['country_id'][1] : null,
    );
  }
}
