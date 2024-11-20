import 'package:oferty_pracy/model/offer.dart';

class HomeController {
  final List<Offer> staticOffers = [
    Offer(
        id: "sokdjflskdjfl",
        position: "Software Developer",
        company: "Nokia",
        city: "Wroclaw",
        description: "Bla bla bla .... ksdlfksd",
        phoneNumber: "+48 123 456 789",
        email: "haha@gmail.com",
        creationDate: DateTime(2024, 10, 12, 14, 30),
        endDate: DateTime(2024, 12, 22, 15, 34)),
    Offer(
        id: "bldjkfmvldkfmg",
        position: "Software Architect",
        company: "Capegemini",
        city: "Wroclaw",
        description: "Bla bla bla .... kvkldfkglksdfmsklv",
        phoneNumber: "+48 456 789 123",
        email: "hehe@gmail.com",
        creationDate: DateTime(2024, 10, 11, 14, 30),
        endDate: DateTime(2024, 12, 20, 15, 20)),
    Offer(
        id: "owierowiefomv",
        position: "Graphic Designer",
        company: "Google",
        city: "Krakow",
        description: "Bla bla... fslklk",
        phoneNumber: "+48 789 123 456",
        email: "kfkkfk@gmail.com",
        creationDate: DateTime(2024, 8, 12, 14, 30),
        endDate: DateTime(2024, 12, 30, 15, 34))
  ];

  Future<List<Offer>> fetchOffers() async {
    return await Future.delayed(const Duration(seconds: 2)).then((_) {
      return staticOffers;
    });
  }

  Future<List<String>> fetchCityFilters() async {
    return await Future.delayed(const Duration(seconds: 2)).then((_) {
      return [
        "Wroclaw",
        "Krakow",
        "Warszawa",
        "Poznan",
        "Lodz",
        "Gdansk",
        "Szczecin"
      ];
    });
  }

  Future<List<String>> fetchPositionFilters() async {
    return await Future.delayed(const Duration(seconds: 2)).then((_) {
      return ["Software Developer", "Game Designer", "Graphics Designer"];
    });
  }

  bool isCityFilterClikced(int index) => false;
  bool isPositionFilterClikced(int index) => false;
}
