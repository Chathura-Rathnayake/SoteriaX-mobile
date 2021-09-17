import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:soteriax/screens/custom_widgets/counter_tile.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/alert_code_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/audio_stream_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/drop_resttube_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/emmit_audio_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/training_timelap_drawer.dart';
import 'package:soteriax/screens/custom_widgets/operation_btn.dart';
import 'package:soteriax/services/webrtc_services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TrainingOperation extends StatefulWidget {
  TrainingOperation({required this.trainingOpId});
  final String trainingOpId;

  @override
  _TrainingOperationState createState() => _TrainingOperationState();
}

class _TrainingOperationState extends State<TrainingOperation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? type;
  WebRTCServices webRTCServices = WebRTCServices();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

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
    _stopWatchTimer.setPresetSecondTime(189);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    remoteRenderer.initialize();
    webRTCServices.onAddRemoteStream = ((stream) {
      remoteRenderer.srcObject = stream;
      setState(() {});
    });
    super.initState();
    webRTCServices.startConnection(remoteRenderer);
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
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
          ? DropRTDrawer()
          : type == 1
              ? AudioStreamDrawer()
              : type == 4
                  ? AlertCodeDrawer(operationId: widget.trainingOpId)
                  : type == 5
                      ? TimeLapDrawer(
                          stopWatchTimer: _stopWatchTimer,
                        )
                      : EmmitAudioDrawer(isEmmitSuccesful: true),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          Container(),
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
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      width: double.infinity,
                      height: 25,
                      color: Colors.red[300],
                      child: Text(
                        "Current Status: Reached Victim",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    CounterTile(
                      onClicked: showDrawerWithBtns,
                      setType: setType,
                      type: 5,
                      stopWatchTimer: _stopWatchTimer,
                    ),
                    OperationBtn(
                      btnText: "EMMIT AUDIO",
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
                      btnText: "CONTACT HEAD \nLIFEGUARD",
                      btnImage: "alarm_bulb_icon",
                      onClicked: showDrawerWithBtns,
                      setType: setType,
                      type: 4,
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
