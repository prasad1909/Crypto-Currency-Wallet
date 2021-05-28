import 'dart:convert';

import 'package:http/http.dart' as http;

Future<double> getAmount(String id) async {
  try {
    String url = 'https://api.coingecko.com/api/v3/coins/' + id;
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var amt = json['market_data']['current_price']['inr'].toString();
    print(amt);
    return double.parse(amt);
  } catch (e) {
    print(e);
  }
}
