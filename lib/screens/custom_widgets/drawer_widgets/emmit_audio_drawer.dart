import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/live_operations_database_services.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/code_tile.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class EmmitAudioDrawer extends StatefulWidget {
  EmmitAudioDrawer({this.isEmmitSuccesful, required this.operationId, required this.operationType, this.stopWatchTimer});
  final String operationType;
  final String operationId;
  StopWatchTimer? stopWatchTimer;

  bool? isEmmitSuccesful = false;
  @override
  _EmmitAudioDrawerState createState() => _EmmitAudioDrawerState();
}

class _EmmitAudioDrawerState extends State<EmmitAudioDrawer> {
  late LiveOperationDBServices _liveOpDB;

  @override
  void initState() {
    _liveOpDB=LiveOperationDBServices(operationId: widget.operationId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEmmitSuccessful = widget.isEmmitSuccesful!;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.orange.shade600,
              height: 80,
              padding: EdgeInsets.only(top: 40),
              width: double.infinity,
              child: Text(
                "Emmit Audio",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(),
            ),
            SizedBox(
              height: 10,
            ),
            CodeTile(
              codeName: "Alarm ",
              code: "01",
              subTitle: " Get attention",
              endpoint: "alarm01",
              operationID: widget.operationId,
              operationType: widget.operationType,
              stopWatchTimer: widget.stopWatchTimer,
            ),
            CodeTile(
              codeName: "Alarm",
              code: "02",
              subTitle: "Victim is under water",
              endpoint: "alarm02",
              operationID: widget.operationId,
              operationType: widget.operationType,
              stopWatchTimer: widget.stopWatchTimer,
            ),
            CodeTile(
              codeName: "Alarm",
              code: "03",
              subTitle: "Victim missed the Restube",
              endpoint: "alarm03",
              operationID: widget.operationId,
              operationType: widget.operationType,
              stopWatchTimer: widget.stopWatchTimer,
            ),
            CodeTile(
              codeName: "Alarm",
              code: "04",
              subTitle: "Victim has the Restube",
              endpoint: "alarm04",
              operationID: widget.operationId,
              operationType: widget.operationType,
              stopWatchTimer: widget.stopWatchTimer,
            ),
          ],
        ),
      ),
    );
  }
}
