import 'dart:async';
import 'package:http/http.dart' as http;

class DropPackageRPI {
  Future<bool> RPiLock() async {
    print("works");
    final response = await http.get(Uri.parse('http://192.168.1.6:4000/lock'));

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

  Future<bool> RPiUnlock() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:4000/unlock'));

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
