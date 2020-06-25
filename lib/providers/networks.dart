import 'dart:convert';

import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:http/http.dart' as http;

Future<CookieList> fetchCookie() async {
  final response =
      await http.get('https://ecommerce-product-app.herokuapp.com/products');

  if (response.statusCode == 200) {
    return CookieList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Cookies');
  }
}

Future<CookieModel> getCookieDetail(int id) async {
  final response =
      await http.get('https://ecommerce-product-app.herokuapp.com/products/${id}');

  if (response.statusCode == 200) {
    return CookieModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Cookies');
  }
}