import 'dart:convert';
import 'dart:io';

import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CookieNetworkHandle {
  final http.Client client;

  CookieNetworkHandle({this.client});

  Future<CookieList> fetchCookie() async {
    Response response;
    // checking client for testing mode
    if (client == null) {
      response = await http
          .get('https://ecommerce-product-app.herokuapp.com/products');
    } else {
      response = await client
          .get('https://ecommerce-product-app.herokuapp.com/products');
    }

    if (response.statusCode == 200) {
      final json = await jsonDecode(response.body);
      return CookieList.fromJson(json);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<CookieModel> getCookieDetail(int id) async {
    Response response;
    // checking client for testing mode
    if (client == null) {
      response = await http
          .get('https://ecommerce-product-app.herokuapp.com/products/${id}');
    } else {
      response = await client
          .get('https://ecommerce-product-app.herokuapp.com/products/${id}');
    }

    if (response.statusCode == 200) {
      return CookieModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Cookies');
    }
  }
}
