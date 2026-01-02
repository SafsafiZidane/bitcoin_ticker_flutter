import 'dart:convert';
import 'package:http/http.dart';


class NetworkHelper{
  final String  url;
  NetworkHelper({ required this.url});

  Future getData() async{

    var ur = Uri.parse(url);
    Response response = await get(ur);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      return 'Error: ${response.statusCode}';

    }
  }
}