class Offer {
  String id;
  final String ownerKey;
  final String position;
  final String company;
  final String city;
  final String description;
  final String phoneNumber;
  final String email;

  Offer(
      {required this.id,
      required this.ownerKey,
      required this.position,
      required this.company,
      required this.city,
      required this.description,
      required this.phoneNumber,
      required this.email});

  factory Offer.fromJson(Map<String, dynamic> jsonData) {
    return Offer(
        id: jsonData["id"] as String,
        ownerKey: jsonData["ownerKey"] as String,
        position: jsonData["position"] as String,
        company: jsonData["company"] as String,
        city: jsonData["city"] as String,
        description: jsonData["description"] as String,
        phoneNumber: jsonData["phoneNumber"] as String,
        email: jsonData["email"] as String);
  }
}
