class ContactModel {
  final String id;
  final String name;
  final String phone;
  final String walletType;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.walletType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'walletType': walletType,
    };
  }

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      walletType: json['walletType'],
    );
  }
}
