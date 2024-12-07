import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oferty_pracy/model/offer.dart';
import 'package:oferty_pracy/model/user.dart';
import 'package:oferty_pracy/utils/user_wrapper.dart';

class ServerWrapper {
  final RequestExecutor _executor = RequestExecutor();

  Future<List<Offer>> postOffers(
      List<String> cityFilters, List<String> positionFilters) async {
    final queryParams = {
      if (cityFilters.isNotEmpty) "city": cityFilters.join(","),
      if (positionFilters.isNotEmpty) "position": positionFilters.join(",")
    };
    final request = Request.withContentTypeJson(
        method: RequestMethod.getMethod,
        path: "/offers",
        queryParams: queryParams);

    final response = await _executor.execute(request);

    if (response.statusCode == 200) {
      final body = response.responseBody;
      if (body["offers"] == null) {
        print("Invalid response format: Missing offers field");
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
    final request =
        Request(method: RequestMethod.getMethod, path: "/cityFilters");

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
    final request =
        Request(method: RequestMethod.getMethod, path: "/positionFilters");

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
      "ownerKey": UserWrapper.key,
      "position": offer.position,
      "company": offer.company,
      "city": offer.city,
      "description": offer.description,
      "phoneNumber": offer.phoneNumber,
      "email": offer.email
    };
    final request = Request.withHeaderAcceptJson(
        method: RequestMethod.postMethod,
        path: "/offers",
        requestBody: body,
        headers: UserWrapper.toQueryMap());

    final response = await _executor.execute(request);

    if (response.statusCode == 200) {
      final body = response.responseBody;
      if (body["id"] == null) {
        print("Invalid response format: Missing offerId field");
        return null;
      }
      final returnedOffer = offer..id = body["id"];
      return returnedOffer;
    }

    print(
        "Status code: ${response.statusCode}, ${response.responseBody.toString()}");
    return null;
  }

  Future<String> logIn(User user) async {
    final body = {"username": user.login, "password": user.password};

    final request = Request.withContentTypeJson(
        method: RequestMethod.postMethod, path: '/login', requestBody: body);
    final response = await _executor.execute(request);

    if (response.statusCode == 200) {
      final body = response.responseBody;
      if (body["api_key"] == null) {
        print("Invalid response format: Missing api_key field");
        return "";
      }
      final apiKey = body["api_key"];
      return apiKey.toString();
    }
    print(
        "Status code: ${response.statusCode}, ${response.responseBody.toString()}");
    return "";
  }

  Future<bool> register(User user) async {
    final body = {"username": user.login, "password": user.password};

    final request = Request.withContentTypeJson(
        method: RequestMethod.postMethod, path: '/register', requestBody: body);
    final response = await _executor.execute(request);

    if (response.statusCode == 200) {
      return true;
    }
    print(
        "Status code: ${response.statusCode}, ${response.responseBody.toString()}");
    return false;
  }

  Future<bool> removeOffer(Offer offer) async {
    final request = Request.withHeaderAcceptJson(
        method: RequestMethod.deleteMethod,
        path: '/offers/${offer.id}',
        headers: UserWrapper.toQueryMap());
    final response = await _executor.execute(request);

    if (response.statusCode == 200) {
      return true;
    }
    print(
        "Status code: ${response.statusCode}, ${response.responseBody.toString()}");
    return false;
  }
}

enum RequestMethod { getMethod, postMethod, deleteMethod }

class Request {
  final RequestMethod method;
  final String path;
  final Map<String, String> queryParams;
  final Map<String, String> headers;
  final Map<String, String> requestBody;

  Request(
      {required this.method,
      required this.path,
      this.requestBody = const {},
      this.queryParams = const {},
      this.headers = const {}});

  Request.withHeaderAcceptJson(
      {required this.method,
      required this.path,
      this.requestBody = const {},
      this.queryParams = const {},
      this.headers = const {}}) {
    headers.addAll({"Content-Type": "application/json"});
  }

  Request.withContentTypeJson(
      {required this.method,
      required this.path,
      this.requestBody = const {},
      this.queryParams = const {},
      this.headers = const {"Content-Type": "application/json"}});
}

class ServerResponse {
  final int statusCode;
  final Map<String, dynamic> responseBody;

  ServerResponse({required this.statusCode, required this.responseBody});
}

class RequestExecutor {
  String getUrl() =>
      "127.0.0.1:8000"; // 71a36674-7115-47d3-b5a4-627f135438c1.mock.pstmn.io";
  //"localhost:8000";

  Future<ServerResponse> execute(Request request) async {
    try {
      final url = Uri.http(getUrl(), request.path, request.queryParams);
      Response? response;
      switch (request.method) {
        case RequestMethod.getMethod:
          response = await http.get(url, headers: request.headers);
        case RequestMethod.postMethod:
          response = await http.post(url,
              headers: request.headers, body: json.encode(request.requestBody));
        case RequestMethod.deleteMethod:
          response = await http.delete(url,
              headers: request.headers, body: json.encode(request.requestBody));
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
