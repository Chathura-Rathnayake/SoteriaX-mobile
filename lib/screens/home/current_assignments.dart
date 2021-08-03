import 'package:flutter/material.dart';
import 'package:soteriax/screens/custom_widgets/lists/tiles/current_assignment_item.dart';

class CurrentAssignment extends StatefulWidget {
  const CurrentAssignment({Key? key}) : super(key: key);

  @override
  _CurrentAssignmentState createState() => _CurrentAssignmentState();
}

class _CurrentAssignmentState extends State<CurrentAssignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text("Current Assignments"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              CurrentAssignmentItem(date: "2021/08/05", time: "10:30am", role: "Pilot", assignmentId: "546484",),
              CurrentAssignmentItem(date: "2021/08/12", time: "02:30pm", role: "Assistant Pilot", assignmentId: "986484",),
              CurrentAssignmentItem(date: "2021/08/17", time: "10:30am", role: "Pilot", assignmentId: "0044866",),
              CurrentAssignmentItem(date: "2021/08/20", time: "12:30pm", role: "Swimmer", assignmentId: "765468",),
            ],
          ),
        ),
      ),
    );
  }
}
