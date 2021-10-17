import 'package:http/http.dart' as http;
import 'package:restaurant_demo/models/products_data.dart';

class ApiService {
  static Future<List<TableMenuList>> getProducts() async {
    var request = http.Request(
        'GET', Uri.parse('https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var source = await response.stream.bytesToString();
      final products = productsDataFromJson(source);
      return products[0].tableMenuList;
    } else {
      List<TableMenuList> emptyList = [];
      print(response.reasonPhrase);
      return emptyList;
    }
  }
}
