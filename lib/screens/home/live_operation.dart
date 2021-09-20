import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:soteriax/database/live_operations_database_services.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/alert_code_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/audio_stream_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/drop_resttube_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/emmit_audio_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/flash_light_drawer.dart';
import 'package:soteriax/screens/custom_widgets/operation_btn.dart';
import 'package:soteriax/screens/home/engage_mission.dart';
import 'package:soteriax/screens/home/main_menu.dart';
import 'package:soteriax/services/webrtc_audiostream_services.dart';
import 'package:soteriax/services/webrtc_services.dart';

class LiveOperations extends StatefulWidget {
  LiveOperations({required this.operationID});
  final String operationID;

  @override
  _LiveOperationsState createState() => _LiveOperationsState();
}

class _LiveOperationsState extends State<LiveOperations> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late WebRTCServices webRTC;
  RTCVideoRenderer remoteRenderer=RTCVideoRenderer();
  int? type;
  late LiveOperationDBServices liveOpDB;
  Timer? operationPing;
  bool waitingForOperationPing = false;
  late WebRTCAudioStream webRTCAudioStream;

  void sendOperationPing() {
    operationPing?.cancel();
    operationPing = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!waitingForOperationPing) {
        waitingForOperationPing = true;
        liveOpDB.pingEngagement();
        waitingForOperationPing = false;
      }
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    operationPing?.cancel();
    super.deactivate();
  }

  @override
  void initState() {
    // TODO: implement initState
    liveOpDB = LiveOperationDBServices(operationId: widget.operationID);
    liveOpDB.setEngaged();
    webRTC=WebRTCServices(operationId: widget.operationID, operationType: 'operation');
    webRTCAudioStream=WebRTCAudioStream();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    remoteRenderer.initialize();
    webRTC.onAddRemoteStream=((stream){
      remoteRenderer.srcObject=stream;
      setState(() {});
    });
    webRTC.startConnection(remoteRenderer);
    sendOperationPing();
    super.initState();
  }

  @override
  void dispose() async{
    operationPing?.cancel();
    await remoteRenderer.dispose();
    await webRTC.endConnection();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
    super.dispose();
  }

  // final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Widget dr=DropRTDrawer as Widget;
    void showDrawerWithBtns() {
      _scaffoldKey.currentState!.openEndDrawer();
    }

    void setType(int type) {
      setState(() {
        this.type = type;
      });
    }

    return Scaffold(
        key: _scaffoldKey,
        endDrawer: type == 2
            ? DropRTDrawer(
                operationId: widget.operationID,
                operationType: 'live',
              )
            : type == 1
                ? AudioStreamDrawer(
                    operationId: widget.operationID,
                    operationType: 'live',
                    webRTCAudioStream: webRTCAudioStream,
                  )
                : type == 4
                    ? AlertCodeDrawer(
                        operationId: widget.operationID,
                        operationType: 'live',
                      )
                  : type == 6
                      ? FlashLightDrawer()
                    : EmmitAudioDrawer(
                        isEmmitSuccesful: true,
                        operationId: widget.operationID,
                        operationType: 'live',
                          ),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          actions: [
            Container(
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == "ForceEnd") {
                    await liveOpDB.forceEndOperation();
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainMenu()));
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                        value: "ForceEnd", child: Text("Force End Mission"))
                  ];
                },
              ),
            ),
          ],
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange.shade800,
                    Colors.orange.shade700,
                  ]),
            ),
          ),
        ),
        body: SafeArea(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      height: 20,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Text(
                        "Live",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: RTCVideoView(remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,),
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: Column(
                    children: [
                      StreamBuilder<DocumentSnapshot?>(
                          stream: liveOpDB.getOperation,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Container();
                            } else if (snapshot.hasData) {
                              if (snapshot.data == null) {
                                return Container(
                                  child: Text("Something went wrong.. no data"),
                                );
                              } else {
                                var operationStatus=snapshot.data!.get('operationStatus');
                                var currentStage=snapshot.data!.get('currentStage');
                                var currentStatus=snapshot.data!.get('currentStatus');
                                if (operationStatus=='live') {
                                  if(currentStage<5){
                                    return Column(
                                      children: [
                                        Container(
                                          padding:
                                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                          height: 25,
                                          width: double.infinity,
                                          color: Colors.red[300],
                                          child: Text(
                                            "Current Status: $currentStatus",
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        if(currentStage>=3)
                                          MaterialButton(
                                            onPressed: () async {
                                              await liveOpDB.endOperation();
                                            },
                                            color: Colors.red[800],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: Text("End Mission", style: TextStyle(color: Colors.white),),
                                          ),
                                        OperationBtn(
                                          btnText: "EMMIT SIREN",
                                          btnImage: "sound_icon",
                                          onClicked: showDrawerWithBtns,
                                          setType: setType,
                                          type: 3,
                                        ),
                                        OperationBtn(
                                          btnText: "DROP REST-TUBE",
                                          btnImage: "lb_drop_icon",
                                          onClicked: showDrawerWithBtns,
                                          setType: setType,
                                          type: 2,
                                        ),
                                        OperationBtn(
                                          btnText: "AUDIO STREAM",
                                          btnImage: "mic_icon",
                                          onClicked: showDrawerWithBtns,
                                          setType: setType,
                                          type: 1,
                                        ),
                                        OperationBtn(
                                          btnText: "FLASH LIGHT",
                                          btnImage: "torch",
                                          onClicked: showDrawerWithBtns,
                                          setType: setType,
                                          type: 6,
                                        ),
                                        OperationBtn(
                                          btnText: "CONTACT HEAD \nLIFEGUARD",
                                          btnImage: "alarm_bulb_icon",
                                          onClicked: showDrawerWithBtns,
                                          setType: setType,
                                          type: 4,
                                        ),
                                      ],
                                    );
                                  }else{ //mission completed recording stages 6, 7
                                    return Column(
                                      children: [
                                        Container(
                                          padding:
                                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                          height: 25,
                                          width: double.infinity,
                                          color: Colors.red[300],
                                          child: Text(
                                            "Current Status: $currentStatus",
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(child: Text("Recorded Operation Video is being uploaded")),
                                      ],
                                    );
                                  }
                                } else { //mission has somehow ended
                                  return Column(
                                    children: [
                                      Container(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        height: 25,
                                        width: double.infinity,
                                        color: Colors.red[300],
                                        child: Text(
                                          "Current Status: $currentStatus",
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(child: Text("Operation has been ended")),
                                      MaterialButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EngageMission()));
                                        },
                                        color: Colors.red[800],
                                        child: Text('Back', style: TextStyle(color: Colors.white),),
                                      ),
                                    ],
                                  );
                                }
                              }
                            } else {
                              return Container(child: Text("No data to display"),);
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
