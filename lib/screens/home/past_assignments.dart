import 'package:flutter/material.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/lists/past_assignment_list.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/past_assignment_item.dart';

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
      body: PastAssignmentList(),
    );
  }
}
