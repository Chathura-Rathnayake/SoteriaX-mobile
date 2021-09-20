import 'package:flutter/material.dart';
import 'package:soteriax/database/current_assignment_database_services.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/lists/complaint_list.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/current_assignment_item.dart';

class ViewComplaints extends StatefulWidget {
  const ViewComplaints({Key? key}) : super(key: key);

  @override
  _ViewComplaintsState createState() => _ViewComplaintsState();
}

class _ViewComplaintsState extends State<ViewComplaints> {


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
        title: Text("All Complaints"),
      ),
      body: Container(
        child: ViewcomplaintsList(),
      ),
    );
  }
}
