import 'package:flutter/material.dart';
import 'package:soteriax/screens/custom_widgets/lists/tiles/past_assignment_item.dart';

class PastAssignments extends StatefulWidget {
  const PastAssignments({Key? key}) : super(key: key);

  @override
  _PastAssignmentsState createState() => _PastAssignmentsState();
}

class _PastAssignmentsState extends State<PastAssignments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text("Past Assignments"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              PastAssignmentItem(date: "2021/08/01", time: "08:30am", role: "Swimmer", assignmentId: "0084646",),
              PastAssignmentItem(date: "2021/07/28", time: "03:30pm", role: "Assistant Pilot", assignmentId: "9984423",),
              PastAssignmentItem(date: "2021/07/20", time: "11:30am", role: "Swimmer", assignmentId: "0587952",),
              PastAssignmentItem(date: "2021/07/02", time: "04:30pm", role: "Pilot", assignmentId: "546862",),
              PastAssignmentItem(date: "2021/06/24", time: "02:30pm", role: "Assistant Pilot", assignmentId: "8465153",),
            ],
          ),
        ),
      ),
    );
  }
}
