import 'dart:async';
import 'package:http/http.dart' as http;

class RecordedAudioRPI {
  Future<bool> RPI_Recorded_Audio_01() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:4000/alarm01'));

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

  Future<bool> RPI_Recorded_Audio_02() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:4000/alarm02'));

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

  Future<bool> RPI_Recorded_Audio_03() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:4000/alarm03'));

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

  Future<bool> RPI_Recorded_Audio_04() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:4000/alarm04'));

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
