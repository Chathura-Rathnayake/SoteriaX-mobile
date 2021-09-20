import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

class DisplayTimeline extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<_TimelineStatus> data = [
      _TimelineStatus.done,
      _TimelineStatus.inProgress,
      _TimelineStatus.inProgress,
      _TimelineStatus.todo
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.shade700,),
      body: Container(
        child: Timeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xffc2c5c9),
            connectorTheme: ConnectorThemeData(
              thickness: 3.0,
            ),
          ),
          padding: EdgeInsets.only(top: 20.0),
          builder: TimelineTileBuilder.connected(
            indicatorBuilder: (context, index) {
              return DotIndicator(
                color: data[index].isInProgress ? Color(0xff193fcc) : null,
              );
            },
            connectorBuilder: (_, index, connectorType) {
              var color;
              if (index + 1 < data.length - 1) {
                color = data[index].isInProgress && data[index + 1].isInProgress
                    ? Color(0xff193fcc)
                    : null;
              }
              return SolidLineConnector(
                indent: connectorType == ConnectorType.start ? 0 : 2.0,
                endIndent: connectorType == ConnectorType.end ? 0 : 2.0,
                color: color,
              );
            },
            contentsBuilder: (_, __) => _EmptyContents(),
            itemExtentBuilder: (_, __) {
              return kTileHeight;
            },
            itemCount: data.length,
          ),
        ),
      ),
    );
  }
}

class _EmptyContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("hello");
  }
}

enum _TimelineStatus {
  done,
  sync,
  inProgress,
  todo,
}

extension on _TimelineStatus {
  bool get isInProgress => this == _TimelineStatus.inProgress;
}