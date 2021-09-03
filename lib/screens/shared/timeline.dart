import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/operations_database_services.dart';
import 'package:soteriax/database/view_operations_database_services.dart';
import 'package:timelines/timelines.dart';

const kitHeight=50.0;

const inProgressColor=Color(0xff5e6172);
const completeColor = Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);

class ProcessTimelinePage extends StatefulWidget {
  String? operationId;
  String? operationFlag;
  ProcessTimelinePage({this.operationId, this.operationFlag});

  @override
  _ProcessTimelinePageState createState() => _ProcessTimelinePageState();
}

class _ProcessTimelinePageState extends State<ProcessTimelinePage> {
  int _processIndex=1;

  Color getColor(int index){
    if(index==_processIndex){
      return inProgressColor;
    }else if(index<_processIndex){
      return completeColor;
    }else{
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot?>(
        stream: widget.operationFlag=="live" ? ViewOperationDBServices(operationId: widget.operationId).currentLiveOpdata:ViewOperationDBServices(operationId: widget.operationId).currentTrainingOpdata ,
        builder: (context, snapshot){
          if(snapshot.hasData){
            _processIndex=snapshot.data!.get("currentStage")-1;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.orange[800],
                title: Text("Progress Timeline"),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Timeline.tileBuilder(
                  theme: TimelineThemeData(
                      direction: Axis.vertical,
                      connectorTheme: ConnectorThemeData(
                        space: 30,
                        thickness: 5,
                      )
                  ),
                  builder: TimelineTileBuilder.connected(
                    itemCount: _processes.length,
                    connectionDirection: ConnectionDirection.before,
                    itemExtentBuilder: (_, __) =>
                    MediaQuery
                        .of(context)
                        .size
                        .width / _processes.length,
                    oppositeContentsBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Image.asset(
                          'assets/images/process_timeline/status${index + 1}.png',
                          width: 100.0,
                          color: getColor(index),
                        ),
                      );
                    },
                    contentsBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15, left: 10),
                        child: Text(
                          _processes[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getColor(index),
                          ),
                        ),
                      );
                    },
                    indicatorBuilder: (_, index) {
                      var color;
                      var child;
                      if (index == _processIndex) {
                        color = inProgressColor;
                        child = Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        );
                      } else if (index < _processIndex) {
                        color = completeColor;
                        child = Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        );
                      } else {
                        color = todoColor;
                      }
                      if (index <= _processIndex) {
                        return Stack(
                          children: [
                            CustomPaint(
                              size: Size(30, 30),
                              painter: _BrezierPainter(
                                color: color,
                                drawEnd: index < _processes.length - 1,
                              ),
                            ),
                            OutlinedDotIndicator(
                              backgroundColor: color,
                              borderWidth: 4,
                              color: color,
                              size: 30,
                              child: child,
                            ),
                          ],
                        );
                      }
                    },
                    connectorBuilder: (_, index, type) {
                      if (index > 0) {
                        if (index == _processIndex) {
                          final prevColor = getColor(index - 1);
                          final color = getColor(index);
                          List<Color> gradientColors;
                          if (type == ConnectorType.start) {
                            gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
                          } else {
                            gradientColors = [
                              prevColor,
                              Color.lerp(prevColor, color, 0.5)!
                            ];
                          }
                          return DecoratedLineConnector(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                              ),
                            ),
                          );
                        } else {
                          return SolidLineConnector(
                            color: getColor(index),
                          );
                        }
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.chevron_right,
                ),
                onPressed: (){
                  setState(() {
                    _processIndex=(_processIndex+1)%_processes.length;
                  });
                },
                backgroundColor: inProgressColor,
              ),
            );
          }else{
            return Scaffold(
              appBar:AppBar(
                backgroundColor: Colors.orange[800],
                title: Text("Progress Timeline"),
              ) ,
              body: CircularProgressIndicator()
            );
          }
        }
    );
  }
}

class _BrezierPainter extends CustomPainter {
  const _BrezierPainter({
    required this.color,
    this.drawStart=true,
    this.drawEnd=true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle){
    return Offset(
      radius = cos(angle)+radius,
      radius = sin(angle)+radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final paint = Paint()..style=PaintingStyle.fill..color=color;
    final radius=size.width/2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if(drawEnd){
      angle=-pi/4;
      offset1=_offset(radius, angle);
      offset2=_offset(radius, -angle);

      path=Path()..moveTo(offset1.dx, offset2.dy)
        ..quadraticBezierTo(0, size.height/2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);

    }
  }


  @override
  bool shouldRepaint(_BrezierPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }

}


  final _processes = [
    'Mission \nInitiated',
    'Reached \nVictim',
    'Rest-Tube \nDropped',
    'Lifeguard \nReached',
    'Mission \nCompleted',
  ];


