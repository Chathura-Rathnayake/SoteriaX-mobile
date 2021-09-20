import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/live_operations_database_services.dart';
import 'package:soteriax/database/training_operations_database_services.dart';
import 'package:soteriax/services/webrtc_audiostream_services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class AudioStreamDrawer extends StatefulWidget {
  AudioStreamDrawer({required this.operationId, required this.operationType, required this.webRTCAudioStream, this.stopWatchTimer}){
    if(operationType=='live'){
      liveOpDB=LiveOperationDBServices(operationId: operationId);
    }else{
      trainingOpDB=TrainingOperationsDBServices(operationId: operationId);
    }
  }
  LiveOperationDBServices? liveOpDB;
  TrainingOperationsDBServices? trainingOpDB;
  WebRTCAudioStream webRTCAudioStream;
  final String operationId;
  final String operationType;
  StopWatchTimer? stopWatchTimer;

  @override
  _AudioStreamDrawerState createState() => _AudioStreamDrawerState();

}

class _AudioStreamDrawerState extends State<AudioStreamDrawer> {
   bool isRecording=false;
   // WebRTCAudioStream webRTCAudioStream=WebRTCAudioStream();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // widget.webRTCAudioStream.muteAudioStream();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              color: Colors.orange.shade600,
              height: 80,
              padding: EdgeInsets.only(top: 40),
              width: double.infinity,
              child: Text("Audio Stream", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child:Container(
              ),
            ),
            IconButton(
              onPressed: (){
                setState(() {
                  if(!widget.webRTCAudioStream.connected || widget.webRTCAudioStream.muted){
                    if(!widget.webRTCAudioStream.connected){
                      widget.webRTCAudioStream.startAudioStream();
                    }else{
                      if(widget.webRTCAudioStream.muted){
                        widget.webRTCAudioStream.unMuteAudioStream();
                      }
                    }
                    widget.operationType == 'live' ? widget.liveOpDB!.streamAudio() : widget.trainingOpDB!
                        .streamAudio(widget.stopWatchTimer!.rawTime.value);
                  }else{
                    if(!widget.webRTCAudioStream.muted){
                      widget.webRTCAudioStream.muteAudioStream();
                    }
                  }
                });
              },
              color: widget.webRTCAudioStream.muted==false ? Colors.red[900]: Colors.blue[900],
              iconSize: 60,
              icon: Icon(widget.webRTCAudioStream.muted==false ? Icons.stop : Icons.mic, size: 60,)
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.webRTCAudioStream.muted==false ? "Stop Audio Stream": "Start Audio Stream",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16),
              ),
            ),
            MaterialButton(
              child: Text("BACK", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
              onPressed: (){
                Navigator.pop(context);
              },
              minWidth: 125,
              color: Colors.red[900],
            ),
          ],
        ),
      ),
    );
  }
}
