import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:soteriax/models/lifeguardSingleton.dart';

class LightRPI {
  Future<bool> RPiLighton() async {
    print("works");
    final response =
        await http.get(Uri.parse('http://${LifeguardSingleton().company.staticIP}:4000/lighton'));

    if (response.statusCode == 200) {
      print("Reached RPI endpoint");
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Future.value(true);
    } else {
      print("Error cant reach RPI endpoint");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return Future.value(false);
    }
  }

  Future<bool> RPiLightoff() async {
    final response =
        await http.get(Uri.parse('http://${LifeguardSingleton().company.staticIP}:4000/lightoff'));

    if (response.statusCode == 200) {
      print("works 1");
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Future.value(true);
    } else {
      print("works 2");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return Future.value(false);
    }
  }
}
