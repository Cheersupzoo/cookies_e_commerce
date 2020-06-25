import 'dart:convert';
import 'dart:io';

import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:http/http.dart' as http;

class CookieNetworkHandle {
  Future<CookieList> fetchCookie() async {
    final response =
        await http.get('https://ecommerce-product-app.herokuapp.com/products');
    if (response.statusCode == 200) {
      final json = await jsonDecode(response.body) ;
      return CookieList.fromJson(json);
    } else {
      throw response.statusCode;
    }
  }

  Future<CookieModel> getCookieDetail(int id) async {
    final response = await http
        .get('https://ecommerce-product-app.herokuapp.com/products/${id}');

    if (response.statusCode == 200) {
      return CookieModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Cookies');
    }
  }
}
