import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/training_operations_database_services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CounterTile extends StatefulWidget {
  CounterTile({this.tileImage, this.tileText, this.onClicked, this.setType, this.type, this.height, required this.stopWatchTimer, required this.trainingOperationId});
  String? tileImage;
  String? tileText;
  int? type=0;
  Function? onClicked;
  Function? setType;
  double? height;
  String trainingOperationId;
  StopWatchTimer stopWatchTimer;



  @override
  _CounterTileState createState() => _CounterTileState();
}

class _CounterTileState extends State<CounterTile> {
  bool _isHours=false;
  bool started=false;


  @override
  void initState() {
    super.initState();
    widget.stopWatchTimer.secondTime.listen((val)=>print('secondTime: $val'));
  }

  @override
  void dispose() async {
    super.dispose();
    await widget.stopWatchTimer.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: MaterialButton(
        onPressed: (){
          widget.setType!(widget.type);
          widget.onClicked!();
        },
        height: MediaQuery.of(context).size.height * 0.15,
        child: StreamBuilder<int>(
          stream: widget.stopWatchTimer.rawTime,
          initialData: widget.stopWatchTimer.rawTime.value,
          builder: (context, snap){
            final value=snap.data!;
            if(!started){
              if(value>0){
                print('restarted stopwatch'); //automatically restart of continuing after a network error so the previously recorded times wont be affected
                widget.stopWatchTimer.onExecute
                    .add(StopWatchExecute.start);
                started=true;
              }
            }
            final displayTime=StopWatchTimer.getDisplayTime(value, hours: _isHours);
            return ListTile(
              leading: Image(
                image: AssetImage('assets/icons/stop_watch_icon.png'),
              ),
              title: Text('Elapsed Time: $displayTime', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
              subtitle:  !started ? Text('Start training'):Text('Recorded Times'),
              trailing: started ? IconButton(
                onPressed: (){
                  // widget.stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                  widget.setType!(widget.type);
                  widget.onClicked!();
                },
                icon: Icon(
                  CupertinoIcons.chevron_right,
                  color: Colors.black,
                  size: 20,
                ),
              ) : IconButton(
                  icon: Icon(Icons.not_started, color: Colors.green[300],),
                  onPressed: () async{
                    if(!started){
                      bool wasInitiated=await TrainingOperationsDBServices(operationId: widget.trainingOperationId).
                          initiateOperation(widget.stopWatchTimer.rawTime.value);
                      if(wasInitiated){
                        widget.stopWatchTimer.onExecute
                            .add(StopWatchExecute.start);
                        setState(() {
                          started=true;
                        });
                      }
                    }
                  }
              ),
            );
          },
        ),
      ),
    );
  }
}
