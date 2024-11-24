import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oferty_pracy/model/offer.dart';

class ServerWrapper {
  final RequestExecutor _executor = RequestExecutor();

  void initConnection() {}
  String getUrl() =>
      "https://71a36674-7115-47d3-b5a4-627f135438c1.mock.pstmn.io";

  Future<List<Offer>> postOffers(
      List<String> cityFilters, List<String> positionFilters) async {
    final body = {
      "cities": jsonEncode(cityFilters),
      "positions": jsonEncode(positionFilters)
    };
    final request = Request(
        method: RequestMethod.postMethod,
        path: "${getUrl()}/offers",
        requestBody: body);

    final response = await _executor.execute(request);

    if (response.statusCode == 200) {
      final body = response.responseBody;
      if (body["filters"] == null) {
        print("Invalid response format: Missing filters field");
        return [];
      }

      final filters = body["filters"] as Map<String, dynamic>;
      if (filters["cities"] == null || filters["positions"] == null) {
        print("Invalid response format: Missing cities and positions");
        return [];
      }

      if (body["offers"] == null) {
        print("Invalid response format: Missing offers");
        return [];
      }

      final offers = body["offers"] as List<dynamic>;
      return List<Offer>.from(
          offers.map((offer) => Offer.fromJson(offer as Map<String, dynamic>)));
    }

    print(
        "Status code: ${response.statusCode}, ${response.responseBody.toString()}");
    return [];
  }

  Future<List<String>> getCities() async {
    final request = Request(
        method: RequestMethod.getMethod, path: getUrl() + "/cityFilters");

    final response = await _executor.execute(request);

    if (response.statusCode == 200) {
      final body = response.responseBody;
      if (body["filters"] == null) {
        print("Invalid response format: Missing filters field");
        return [];
      }

      final filters = body["filters"] as List<dynamic>;
      return List<String>.from(filters.map((filter) => filter.toString()));
    }

    print(
        "Status code: ${response.statusCode}, ${response.responseBody.toString()}");
    return [];
  }

  Future<List<String>> getPositions() async {
    final request = Request(
        method: RequestMethod.getMethod, path: getUrl() + "/positionFilters");

    final response = await _executor.execute(request);

    if (response.statusCode == 200) {
      final body = response.responseBody;
      if (body["filters"] == null) {
        print("Invalid response format: Missing filters field");
        return [];
      }

      final filters = body["filters"] as List<dynamic>;
      return List<String>.from(filters.map((filter) => filter.toString()));
    }

    print(
        "Status code: ${response.statusCode}, ${response.responseBody.toString()}");
    return [];
  }

  Future<Offer?> addNewOffer(Offer offer) async {
    final body = {
      "position": offer.position,
      "company": offer.company,
      "city": offer.city,
      "description": offer.description,
      "phoneNumber": offer.phoneNumber,
      "email": offer.email
    };
    final request = Request(
        method: RequestMethod.postMethod,
        path: getUrl() + "/offer",
        requestBody: body);

    final response = await _executor.execute(request);

    if (response.statusCode == 200) {
      final body = response.responseBody;
      if (body["offerId"] == null) {
        print("Invalid response format: Missing offerId field");
        return null;
      }
      final returnedOffer = offer..id = body["offerId"];
      return returnedOffer;
    }

    print(
        "Status code: ${response.statusCode}, ${response.responseBody.toString()}");
    return null;
  }
}

enum RequestMethod { getMethod, postMethod, deleteMethod }

class Request {
  final RequestMethod method;
  final String path;
  final Map<String, String> headers;
  final Map<String, dynamic> requestBody;

  Request(
      {required this.method,
      required this.path,
      this.requestBody = const {},
      this.headers = const {}});
}

class ServerResponse {
  final int statusCode;
  final Map<String, dynamic> responseBody;

  ServerResponse({required this.statusCode, required this.responseBody});
}

class RequestExecutor {
  Future<ServerResponse> execute(Request request) async {
    try {
      final url = Uri.parse(request.path);
      Response? response;
      switch (request.method) {
        case RequestMethod.getMethod:
          response = await http.get(url, headers: request.headers);
        case RequestMethod.postMethod:
          response = await http.post(url,
              headers: request.headers, body: request.requestBody);
        case RequestMethod.deleteMethod:
          response = await http.delete(url,
              headers: request.headers, body: request.requestBody);
      }

      if (response == null) {
        print("Response not received");
        return ServerResponse(statusCode: 411, responseBody: {});
      }

      return ServerResponse(
          statusCode: response.statusCode,
          responseBody: jsonDecode(response.body));
    } catch (e) {
      print("Error: ${e}");
      return ServerResponse(statusCode: 410, responseBody: {});
    }
  }
}
