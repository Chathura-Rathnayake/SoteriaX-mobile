import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class EngageMissionHttp {
  var url;

  EngageMissionHttp() {
    url = Uri.parse('http://192.168.43.5:3000');
  }

  Future<Map?> checkRPiAvailability() async {
    Map map = {'status': null};
    var client = http.Client();
    try {
      http.Response uriResponse =
          await client.post(url, body: {'name': 'doodle', 'color': 'blue'});
      map['status'] = jsonDecode(uriResponse.statusCode.toString());
      // print('Response body: ${uriResponse.body}');
    } on SocketException catch (e) {
      map['status'] = e.osError!.errorCode;
      print(e.osError!.errorCode);
    } finally {
      client.close();
    }
    return map;
  }
}
