import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropPackageRPI {
  Future<bool> RPiLock() async {
    print("works");
    final response = await http.get(Uri.parse('http://192.168.1.6:4000/'));

    if (response.statusCode == 200) {
      print(response);
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
