import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:soteriax/database/view_operations_database_services.dart';
import 'package:soteriax/screens/custom_widgets/navigate_button.dart';
import 'package:soteriax/screens/custom_widgets/operation_status_tile.dart';
import 'package:soteriax/screens/home/main_menu.dart';
import 'package:soteriax/screens/home/viewOp/no_current_operation.dart';
import 'package:soteriax/screens/home/viewOp/waiting_operation_response.dart';
import 'package:soteriax/screens/shared/timeline.dart';
import 'package:video_player/video_player.dart';


class ViewOperation extends StatefulWidget {
  const ViewOperation({Key? key}) : super(key: key);

  @override
  _ViewOperationState createState() => _ViewOperationState();
}

class _ViewOperationState extends State<ViewOperation> {
  final _remoteRenderer=new RTCVideoRenderer();
  final _localRenderer=new RTCVideoRenderer();
  late VideoPlayerController _videoPlayerController;
  late Future<Map?> _currentLiveOp;
  RTCPeerConnection? _peerConnection;
  MediaStream? remoteStream;
  MediaStream? _localStream;

  void initRenderers() async{
    // await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<RTCPeerConnection> _createPeerConnection() async{

    Map<String, dynamic> configuration = {
      'iceServers': [
        {'url': 'stun:stun1.l.google.com:19302'},
        {'url': 'stun:stun2.l.google.com:19302'},
        {'url': "stun:stun.stunprotocol.org:3478"},
        {'url': "stun:stun1.l.google.com:19302"},
        {'url': "stun:stun2.l.google.com:19302"},
        {'url': "stun:stun3.l.google.com:19302"},
        {'url': "stun:stun4.l.google.com:19302"},
      ],
      'sdpSemantics': 'unified-plan'
    };

    final Map<String,dynamic> offerSdpConstraints={
      'mandatory':{
        'OfferToReceiveAudio':false,
        'OfferToReceiveVideo': true,
      },
      'optional':[],
    };
    RTCPeerConnection peerConnection=await createPeerConnection(configuration, offerSdpConstraints);
    // peerConnection.onTrack=handleTrackEvent;
    peerConnection.onRenegotiationNeeded=()=>handleNegotiationNeededEvent(peerConnection);
    peerConnection.onConnectionState=(con)=>{print("on Connection State: $con")};
    peerConnection.onAddStream=(stream){
      print('here on add stream: ${stream.id}');
      _remoteRenderer.srcObject=stream;
      setState(() {});
    };

    
    return peerConnection;

  }



  void handleNegotiationNeededEvent(RTCPeerConnection peer) async{
    RTCSessionDescription offer=await peer.createOffer();
    await peer.setLocalDescription(offer);
    var d=await peer.getLocalDescription();
    Map<String, dynamic> payLoad={
      'sdp': jsonEncode(d!.toMap())
    };
    var url=Uri.parse("http://192.168.43.5:5000/consumer");
    http.Response uriResponse=await http.post(url, body: payLoad);
    print(jsonDecode(uriResponse.body)['sdp']['type']);
    RTCSessionDescription description=RTCSessionDescription(jsonDecode(uriResponse.body)['sdp']['sdp'], jsonDecode(uriResponse.body)['sdp']['type']);
    peer.setRemoteDescription(description).catchError((e)=>print('error: ${e.toString()}'));
    var r=await peer.getRemoteDescription();
    log('remote sdp: ${r!.sdp}');


  }
  void handleTrackEvent(RTCTrackEvent e){
    print(e.streams[0]);
    _remoteRenderer.srcObject=e.streams[0];
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRenderers();
    initWebrtc();
    _currentLiveOp=ViewOperationDBServices().getCurrentLiveOp();
  }

  void initWebrtc()async{
    RTCPeerConnection peer=await _createPeerConnection();
    await peer.addTransceiver(kind: RTCRtpMediaType.RTCRtpMediaTypeVideo, init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly));
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    // _remoteRenderer.dispose();
    await _remoteRenderer.dispose();
    // _videoPlayerController.dispose();
    // _localStream?.dispose();
  }

  // disconnect


  _getUserMedia() async {
    print('getusermeadia');
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': true,
    };

    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = _localStream;
  }




  @override
  Widget build(BuildContext context) {
    // initWebrtc();


    GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    return FutureBuilder<Map?>(
        future: _currentLiveOp,
        builder: (BuildContext context, AsyncSnapshot<Map?> snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return WaitingOpResponse();
            default:
              if(snapshot.hasError){
                return Scaffold(
                  appBar: AppBar(backgroundColor: Colors.orange[800], title: Text("View Operation"),),
                  body: Container(child: Center(child: Text("Error: ${snapshot.error}"))));
              }else{
                if(snapshot.data==null){
                  return NoCurrentOP();
                }else{
                  print("hera");
                  print(snapshot.data!["currentOp"].id);
                  print(snapshot.data!['currentOp'].data().toString());
                  return Scaffold(
                    key: _scaffoldKey,
                    drawer: Drawer(
                      child: ProcessTimelinePage(operationId: snapshot.data!["currentOp"].id, operationFlag: snapshot.data!['opFlag']),
                    ),
                    appBar: AppBar(
                      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);},),
                      title: Center(child: Text("View Operation" ,style: TextStyle(fontWeight: FontWeight.bold),)),
                      backgroundColor: Colors.orange[800],
                      elevation: 0,
                    ),
                    body: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Colors.orange[800],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                                child: MaterialButton(
                                  onPressed: (){
                                    _scaffoldKey.currentState!.openDrawer();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_back_ios),
                                      Text("Mission Progress", style: TextStyle(fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 20,
                              color: Colors.redAccent.shade700,
                            ),
                            OperationStatusTile(operationId: snapshot.data!["currentOp"].id, operationFlag: snapshot.data!["opFlag"],),
                            Container(
                              color: Colors.grey,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text("Live", style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Container(
                              key: new Key('remote'),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height*0.30,
                              child: RTCVideoView(_remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover, ),
                              ),
                            StreamBuilder<DocumentSnapshot?>(
                                stream: snapshot.data!["opFlag"]=="live" ? ViewOperationDBServices(operationId: snapshot.data!["currentOp"].id).currentLiveOpdata : ViewOperationDBServices(operationId: snapshot.data!["currentOp"].id).currentTrainingOpdata,
                                builder: (context, snap){
                                  if(snap.hasData){
                                    if (snap.data!.get("operationStatus")!="live") {
                                      return Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Operation has ended",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                                            ),
                                            MaterialButton(
                                              color: Colors.red.shade900,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => MainMenu()),
                                                );
                                              },
                                              child: Text(
                                                "Return Main Menu",
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }else{
                                      return Container();//empty container
                                    }
                                  }else{
                                    return Container();//empty container
                                  }
                                }
                            ),
                            NavigationButton(image: "alarm_bulb_icon", title: "CONTACT EMERGENCY SERVICES", onPressedFunFlag: 3,),
                            SizedBox(height: 20,),
                            Container(
                                padding: EdgeInsets.only(left: 50),
                                alignment: Alignment.centerLeft ,
                                child: Text("Mission details: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                            ),
                            SizedBox(height: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("Start Time: 01:32 PM"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("Drone Pilot: Susantha perera"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("Mobile Handler: Amal Dassanayake"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
          }
        }
      );
  }
}

// Center(
// child: _videoPlayerController.value.isInitialized ? AspectRatio(
// aspectRatio: _videoPlayerController.value.aspectRatio,
// child: VideoPlayer(_videoPlayerController),)
// : Container(
// child: Center(
// child: CircularProgressIndicator(),
// ),
// )
// ),