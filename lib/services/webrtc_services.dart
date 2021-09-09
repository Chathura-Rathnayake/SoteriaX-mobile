
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

typedef void StreamStateCallback(MediaStream stream);

class WebRTCServices{
  Map<String, dynamic> configuration = {
    'iceServers': [
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

  RTCPeerConnection? peerConnection;
  MediaStream? remoteStream;
  StreamStateCallback? onAddRemoteStream;

  void startConnection(RTCVideoRenderer remoteRenderer) async{
    peerConnection=await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    RTCSessionDescription offer=await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    print('created offer');
    var d=await peerConnection!.getLocalDescription();
    Map<String, dynamic> payLoad={
      'sdp': jsonEncode(d!.toMap())
    };
    var url=Uri.parse("http://192.168.43.5:5000/consumer");
    http.Response uriResponse=await http.post(url, body: payLoad);

    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');

      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };

    RTCSessionDescription description=RTCSessionDescription(jsonDecode(uriResponse.body)['sdp']['sdp'], jsonDecode(uriResponse.body)['sdp']['type']);
    peerConnection!.setRemoteDescription(description).catchError((e)=>print('error: ${e.toString()}'));

  }

  Future<void> endConnection() async{
    if(remoteStream!=null){
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    peerConnection?.close();
    remoteStream?.dispose();
  }




  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
}