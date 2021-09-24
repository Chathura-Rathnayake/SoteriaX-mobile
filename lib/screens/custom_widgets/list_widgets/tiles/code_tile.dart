import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/live_operations_database_services.dart';
import 'package:soteriax/database/training_operations_database_services.dart';
import 'package:soteriax/services/raspberryPi/pre_recorded_audio.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CodeTile extends StatelessWidget {
  // TrainingOperationsDBServices trainingDB = TrainingOperationsDBServices();
  CodeTile(
      {this.codeName,
      this.code,
      this.subTitle,
      this.endpoint,
      required this.operationID,
      required this.operationType,
      this.stopWatchTimer}) {
    if (operationType == 'live') {
      _liveOpDB = LiveOperationDBServices(operationId: operationID);
    } else {
      _trainingOpDB = TrainingOperationsDBServices(operationId: operationID);
    }
  }
  LiveOperationDBServices? _liveOpDB;
  TrainingOperationsDBServices? _trainingOpDB;
  String? codeName;
  String? code;
  String? subTitle;
  String? endpoint;
  String operationID;
  String operationType;
  StopWatchTimer? stopWatchTimer;

  RecordedAudioRPI play = RecordedAudioRPI();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
        child: MaterialButton(
          onPressed: () {
            if (endpoint == "0") {
              print("firebase call");
              if (codeName == "DRONE FAILURE") {
                operationType == 'live'
                    ? _liveOpDB!.setCodes("100 : DRONE FAILURE")
                    : _trainingOpDB!.setCodes("100 : DRONE FAILURE");
              } else if (codeName == "TECH FAILURE") {
                operationType == 'live'
                    ? _liveOpDB!.setCodes("200 : TECH FAILURE")
                    : _trainingOpDB!.setCodes("200 : TECH FAILURE");
              } else if (codeName == "LOW BATTERY") {
                operationType == 'live'
                    ? _liveOpDB!.setCodes("300 : LOW BATTERY")
                    : _trainingOpDB!.setCodes("300 : LOW BATTERY");
              } else if (codeName == "DROP PROBLEM") {
                operationType == 'live'
                    ? _liveOpDB!.setCodes("400 : DROP PROBLEM")
                    : _trainingOpDB!.setCodes("400 : DROP PROBLEM");
              }

              //Goes to firebase

            } else if (endpoint == "alarm01") {
              print("Rpi alarm01");
              //Goes to RPI
              play.RPI_Recorded_Audio_01();
            } else if (endpoint == "alarm02") {
              //Goes to RPI
              play.RPI_Recorded_Audio_02();
            } else if (endpoint == "alarm03") {
              print("Rpi alarm03");
              //Goes to RPI
              play.RPI_Recorded_Audio_03();
            } else {
              play.RPI_Recorded_Audio_04();
            }
          },
          onLongPress: () {
            if (endpoint == "alarm01") {
              //Goes to RPI
              print('herer');
              play.RPI_Recorded_Audio_01();
              this.operationType == 'live'
                  ? _liveOpDB!.emmitAudio()
                  : _trainingOpDB!.emmitAudio(stopWatchTimer!.rawTime.value);
            }
          },
          child: ListTile(
            trailing: Icon(Icons.send),
            title: Text(
              "${codeName ?? "Unknown Code Name"}   ${code ?? "Unknown"}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${subTitle ?? ""}"),
          ),
        ),
      ),
    );
  }
}
