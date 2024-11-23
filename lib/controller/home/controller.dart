import 'package:oferty_pracy/controller/home/filter_bloc.dart';
import 'package:oferty_pracy/model/offer.dart';
import 'package:oferty_pracy/server/server_wrapper.dart';

class HomeController {
  final ServerWrapper _serverWrapper = ServerWrapper();
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

  List<String> cityFilters = [
    "Wroclaw",
    "Krakow",
    "Warszawa",
    "Poznan",
    "Lodz",
    "Gdansk",
    "Szczecin"
  ];
  List<String> positionFilters = [
    "Software Developer",
    "Game Designer",
    "Graphics Designer"
  ];

  Set<String> cityEnabledFilters = {};
  Set<String> positionEnabledFilters = {};

  Future<List<Offer>> fetchOffers(FilterState filterState) async {
    return await Future.delayed(const Duration(seconds: 2)).then((_) {
      // return _serverWrapper.postOffers(filterState.cityFilters as List<String>,
      //     filterState.positionFilters as List<String>);
      return staticOffers;
    });
  }

  Future<List<String>> fetchCityFilters(FilterState filterState) async {
    return await Future.delayed(const Duration(seconds: 2)).then((_) {
      return cityFilters; //_serverWrapper.getCities();
    });
  }

  Future<List<String>> fetchPositionFilters(FilterState filterState) async {
    return await Future.delayed(const Duration(seconds: 2)).then((_) {
      return positionFilters; //_serverWrapper.getPositions();
    });
  }
}
