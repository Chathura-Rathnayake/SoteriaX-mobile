import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/live_operations_database_services.dart';

class EmmitAudioDrawer extends StatefulWidget {
  EmmitAudioDrawer({this.isEmmitSuccesful, required this.operationId });
  final String operationId;
  bool? isEmmitSuccesful=false;
  @override
  _EmmitAudioDrawerState createState() => _EmmitAudioDrawerState();
}

class _EmmitAudioDrawerState extends State<EmmitAudioDrawer> {
  late LiveOperationDBServices _liveOpDB;

  @override
  void initState() {
    // TODO: implement initState
    _liveOpDB=LiveOperationDBServices(operationId: widget.operationId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEmmitSuccessful=widget.isEmmitSuccesful!;
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              color: Colors.orange.shade600,
              height: 80,
              padding: EdgeInsets.only(top: 40),
              width: double.infinity,
              child: Text("Emmit Audio", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child:Container(

              ),
            ),
            MaterialButton(
              onPressed: (){_liveOpDB.emmitAudio();},
              child: Text("sound"),
            ),
            SizedBox(height: 20,),
            if(!isEmmitSuccessful)
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.volume_off, size: 60,),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Something went wrong...\nAudio transmission unsuccessful", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20,),
            if(isEmmitSuccessful)
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.volume_up_rounded, size: 60,),
                        Icon(Icons.mood_sharp, size: 60,),
                      ],
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Audio transmission successful", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
            ),
          ],
        ),
      ),
    );
  }
}
