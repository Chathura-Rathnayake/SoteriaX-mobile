import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioStreamDrawer extends StatefulWidget {
  AudioStreamDrawer({required this.operationId});
  final String operationId;

  @override
  _AudioStreamDrawerState createState() => _AudioStreamDrawerState();


}

class _AudioStreamDrawerState extends State<AudioStreamDrawer> {
   bool isRecording=false;

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
                  isRecording=!isRecording;
                });
              },
              color: isRecording ? Colors.lightBlue[200] : Colors.lightBlue,
              iconSize: 60,
              icon: Icon(Icons.mic, size: 60,)
            ),
            SizedBox(height: 20,),
            if(!isRecording)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Please press the mic to start recording", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
              ),
            if(isRecording)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Recording in progress...", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
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
