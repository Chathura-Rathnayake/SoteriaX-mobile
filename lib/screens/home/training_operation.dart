import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:soteriax/database/training_operations_database_services.dart';
import 'package:soteriax/screens/custom_widgets/counter_tile.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/alert_code_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/audio_stream_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/drop_resttube_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/emmit_audio_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/flash_light_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/training_timelap_drawer.dart';
import 'package:soteriax/screens/custom_widgets/operation_btn.dart';
import 'package:soteriax/screens/home/training_overview.dart';
import 'package:soteriax/services/webrtc_audiostream_services.dart';
import 'package:soteriax/services/webrtc_services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'main_menu.dart';

class TrainingOperation extends StatefulWidget {
  TrainingOperation({required this.trainingOpId, this.startTime});
  final String trainingOpId;
  int? startTime;

  @override
  _TrainingOperationState createState() => _TrainingOperationState();
}

class _TrainingOperationState extends State<TrainingOperation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? type;
  late WebRTCServices webRTCServices;
  late WebRTCAudioStream webRTCAudioStream;
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  Timer? stopWatchTimeStampTimer;
  bool isWaitingStopWatchPing = false;
  late TrainingOperationsDBServices trainingOpDB;

  void pingStopWatchTime() {
    print('operation Id: ${widget.trainingOpId}');
    stopWatchTimeStampTimer =
        Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!isWaitingStopWatchPing) {
        isWaitingStopWatchPing = true;
        await TrainingOperationsDBServices(operationId: widget.trainingOpId)
            .stopWatchPing(_stopWatchTimer.rawTime.value);
        isWaitingStopWatchPing = false;
      }
    });
  }

  void setPresetStopWatchTime() async {
    var currTime = Timestamp.now();
    var latestTimePings =
        await TrainingOperationsDBServices(operationId: widget.trainingOpId)
            .getLastestTimePing();

    if (latestTimePings!['stopWatch'] > 0) {
      var timeDiff = currTime.millisecondsSinceEpoch -
          latestTimePings['timePing'].millisecondsSinceEpoch;
      int timeToAdd = latestTimePings['stopWatch'] + timeDiff;
      _stopWatchTimer.setPresetTime(mSec: timeToAdd);
    }
  }

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChangeRawSecond: (val) => print('onChangedRawSecond: $val'),
  );

  void showDrawerWithBtns() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void setType(int type) {
    setState(() {
      this.type = type;
    });
  }

  @override
  void initState() {
    trainingOpDB=TrainingOperationsDBServices(operationId: widget.trainingOpId);
    webRTCServices = WebRTCServices(operationId: widget.trainingOpId, operationType: 'training');
    print('training op id: ${widget.trainingOpId}');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    setPresetStopWatchTime();
    remoteRenderer.initialize();
    webRTCServices.onAddRemoteStream = ((stream) {
      remoteRenderer.srcObject = stream;
      setState(() {});
    });
    pingStopWatchTime();
    super.initState();
    webRTCAudioStream=WebRTCAudioStream();
    webRTCServices.startConnection(remoteRenderer);
  }

  @override
  void deactivate() {
    super.deactivate();
    stopWatchTimeStampTimer?.cancel();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    stopWatchTimeStampTimer?.cancel();
    await remoteRenderer.dispose();
    await webRTCServices.endConnection();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: type == 2
          ? DropRTDrawer(
              operationId: widget.trainingOpId,
              operationType: 'training',
              stopWatchTimer: _stopWatchTimer,
            )
          : type == 1
              ? AudioStreamDrawer(
                  operationId: widget.trainingOpId,
                  operationType: 'training',
                  webRTCAudioStream: webRTCAudioStream,
                  stopWatchTimer: _stopWatchTimer,
                  )
              : type == 4
                  ? AlertCodeDrawer(
                      operationId: widget.trainingOpId,
                      operationType: 'training',
                    )
                  : type == 5
                      ? TimeLapDrawer(
                          operationId: widget.trainingOpId,
                          stopWatchTimer: _stopWatchTimer,
                        )
                    : type == 6
                      ? FlashLightDrawer()
                        : EmmitAudioDrawer(
                            isEmmitSuccesful: true,
                            operationId: widget.trainingOpId,
                            operationType: 'training',
                            stopWatchTimer: _stopWatchTimer,
                              ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          Container(
            child: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "ForceEnd") {
                await trainingOpDB.forceEndOperation(_stopWatchTimer.rawTime.value);
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
        title: Text("Training Operation"),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.orange.shade800,
                Colors.orange.shade700,
              ],
            ),
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
                    child: RTCVideoView(remoteRenderer),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(2),
              width: MediaQuery.of(context).size.width * 0.40,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder<DocumentSnapshot?>(
                      stream: TrainingOperationsDBServices(operationId: widget.trainingOpId).getTrainingOp,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          if(snapshot.data!=null){
                            var operationStatus=snapshot.data!.get("operationStatus");
                            var currentStage=snapshot.data!.get("currentStage");
                            if(operationStatus=='pending'){ //hasn't been initiated  yet
                              return Column(
                                children: [
                                  Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    width: double.infinity,
                                    height: 25,
                                    color: Colors.red[300],
                                    child: Text(
                                      "Current Status: ${snapshot.data!.get('currentStage')}",
                                      style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  CounterTile(
                                    onClicked: showDrawerWithBtns,
                                    setType: setType,
                                    type: 5,
                                    stopWatchTimer: _stopWatchTimer,
                                    trainingOperationId: widget.trainingOpId,
                                  ),
                                  Container(child: Text("Please start the training operation"),),
                                ],
                              );
                            }else if(operationStatus=='live'){ //live ongoing
                              if(currentStage<5){  //ongoing
                                return Column(
                                  children: [
                                    Container(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      width: double.infinity,
                                      height: 25,
                                      color: Colors.red[300],
                                      child: Text(
                                        "Current Status: ${snapshot.data!.get("currentStatus")}",
                                        style: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    CounterTile(
                                      onClicked: showDrawerWithBtns,
                                      setType: setType,
                                      type: 5,
                                      stopWatchTimer: _stopWatchTimer,
                                      trainingOperationId: widget.trainingOpId,
                                    ),
                                    if(snapshot.data!.get('currentStage')>=3)
                                      MaterialButton(
                                        onPressed: () async {
                                          await trainingOpDB.endOperation(_stopWatchTimer.rawTime.value);
                                          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>TrainingOverview()));
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
                                    ),OperationBtn(
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
                              }else{ //being uploaded
                                if(_stopWatchTimer.isRunning){
                                  _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                }
                                return Column(
                                  children: [
                                    Container(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      width: double.infinity,
                                      height: 25,
                                      color: Colors.red[300],
                                      child: Text(
                                        "Current Status: ${snapshot.data!.get('currentStage')}",
                                        style: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    CounterTile(
                                      onClicked: showDrawerWithBtns,
                                      setType: setType,
                                      type: 5,
                                      stopWatchTimer: _stopWatchTimer,
                                      trainingOperationId: widget.trainingOpId,
                                    ),
                                    Container(child: Text("Training operation recording is being uploaded.."),),
                                  ],
                                );
                              }
                            }else{
                              if(_stopWatchTimer.isRunning){
                                _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                              }
                              return Column(
                                children: [
                                  Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    width: double.infinity,
                                    height: 25,
                                    color: Colors.red[300],
                                    child: Text(
                                      "Current Status: ${snapshot.data!.get('currentStage')}",
                                      style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  CounterTile(
                                    onClicked: showDrawerWithBtns,
                                    setType: setType,
                                    type: 5,
                                    stopWatchTimer: _stopWatchTimer,
                                    trainingOperationId: widget.trainingOpId,
                                  ),
                                  Container(child: Text("Training operation has ended"),),
                                ],
                              );
                            }
                          }else{
                            if(_stopWatchTimer.isRunning){
                              _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                            }
                            return Container(child: Text("Training operation has been removed"),);
                          }
                        }else if(snapshot.hasError){
                          if(_stopWatchTimer.isRunning){
                            _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                          }
                          return Container(child: Text("Error occurred while retrieving data"),);
                        }else{
                          if(_stopWatchTimer.isRunning){
                            _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                          }
                          return Container(child: Text("No training data"),);
                        }
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
