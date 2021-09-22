import 'dart:async';
import 'package:http/http.dart' as http;

class ProductApi {
  static Future getProducts() {
    return http.get(Uri.parse(
        "https://startupify-sample-apis.herokuapp.com/products?start=0&rows=20&category=kids"));
  }
}
