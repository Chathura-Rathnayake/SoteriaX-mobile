
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:soteriax/models/lifeguardSingleton.dart';

typedef void ConnectionStateCallback(RTCPeerConnectionState state);

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
  bool muted=true;
  bool connected=false;
  bool waiting=false;
  ConnectionStateCallback? onConnectionStateCallback;

  void startAudioStream() async{
    try {
      waiting=true;
      peerConnection= await createPeerConnection(configuration);
      peerConnection!.onRenegotiationNeeded=()=>handleAudioStreamReNegotiation();
      localStream=await navigator.mediaDevices.getUserMedia({'video': false, 'audio': true});
      localStream!.getTracks().forEach((track) {
        peerConnection!.addTrack(track, localStream!);
      });
      localStream!.getTracks().forEach((track) {
        track.enabled=true;
      });
      peerConnection!.onConnectionState=(RTCPeerConnectionState state){
        onConnectionStateCallback?.call(state);
      };
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
    var url=Uri.parse('http://${LifeguardSingleton().company.staticIP}:5000/audioBroadcaster');
    http.Response uriResponse=await http.post(url, body: payLoad);

    RTCSessionDescription description=RTCSessionDescription(jsonDecode(uriResponse.body)['sdp']['sdp'], jsonDecode(uriResponse.body)['sdp']['type']);
    peerConnection!.setRemoteDescription(description);
    this.connected=true;
    this.waiting=true;
    
  }

  void muteAudioStream(){
    if(connected){
      var tracks=localStream!.getTracks();
      tracks.forEach((track) {
        track.enabled=false;
      });
      this.muted=true;
    }
  }


  void stopAudioStream(){
    var tracks=localStream!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });
    localStream!.dispose();
    peerConnection!.close();
  }

  void unMuteAudioStream(){
    var tracks=localStream!.getTracks();

    tracks.forEach((track) {
      track.enabled=true;
    });
    this.muted=false;
  }






}