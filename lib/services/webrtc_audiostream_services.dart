
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

class WebRTCAudioStream{
  Map<String,dynamic> configuration={
    'iceServers':[
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
          "stun:stun.stunprotocol.org:3478",
          "stun:stun1.l.google.com:19302",
          "stun:stun2.l.google.com:19302",
          "stun:stun3.l.google.com:19302",
          "stun:stun4.l.google.com:19302",
        ],
      },
    ]
  };

  MediaStream? localStream;
  RTCPeerConnection? peerConnection;

  void startAudioStream() async{
    try {
      peerConnection= await createPeerConnection(configuration);
      peerConnection!.onRenegotiationNeeded=()=>handleAudioStreamReNegotiation();
      localStream=await navigator.mediaDevices.getUserMedia({'video': false, 'audio': true});
      localStream!.getTracks().forEach((track) {
        peerConnection!.addTrack(track, localStream!);
      });
    } on Exception catch (e) {
      print('error occurred while audio transmission: ${e.toString()}');
    }
  }

  void handleAudioStreamReNegotiation() async{
    RTCSessionDescription offer=await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    var d=await peerConnection!.getLocalDescription();
    Map<String, dynamic> payLoad={
      'sdp': jsonEncode(d!.toMap()),
      'isAudio' : "true",
    };
    
    log('audio payload: $payLoad');
    var url=Uri.parse('http://192.168.43.5:5000/audioBroadcaster');
    http.Response uriResponse=await http.post(url, body: payLoad);

    RTCSessionDescription description=RTCSessionDescription(jsonDecode(uriResponse.body)['sdp']['sdp'], jsonDecode(uriResponse.body)['sdp']['type']);
    peerConnection!.setRemoteDescription(description);
    
  }

  void stopAudioStream(){
    var tracks=localStream!.getTracks();
    
    tracks.forEach((track) {
      track.stop();
    });
    // localStream!.dispose();
    peerConnection!.close();
  }




}