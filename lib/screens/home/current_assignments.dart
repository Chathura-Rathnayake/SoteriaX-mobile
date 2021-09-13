import 'package:flutter/material.dart';
import 'package:soteriax/database/current_assignment_database_services.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/lists/current_assignment_list.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/current_assignment_item.dart';

class CurrentAssignment extends StatefulWidget {
  const CurrentAssignment({Key? key}) : super(key: key);

  @override
  _CurrentAssignmentState createState() => _CurrentAssignmentState();
}

class _CurrentAssignmentState extends State<CurrentAssignment> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text("Current Assignments"),
      ),
      body: Container(
        child: CurrentAssignmentList(),
      ),
    );
  }
}
