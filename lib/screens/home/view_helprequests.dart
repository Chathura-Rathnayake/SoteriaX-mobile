import 'package:flutter/material.dart';
import 'package:soteriax/database/current_assignment_database_services.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/lists/help_request_list.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/current_assignment_item.dart';

class ViewHelpRequests extends StatefulWidget {
  const ViewHelpRequests({Key? key}) : super(key: key);

  @override
  _ViewHelpRequestsState createState() => _ViewHelpRequestsState();
}

class _ViewHelpRequestsState extends State<ViewHelpRequests> {


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
        title: Text("All Help Requests"),
      ),
      body: Container(
        child: ViewHelpRequestsList(),
      ),
    );
  }
}
