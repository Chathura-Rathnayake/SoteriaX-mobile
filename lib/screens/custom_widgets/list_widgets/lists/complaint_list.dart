import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/current_assignment_database_services.dart';
import 'package:soteriax/database/get_complaints_database_services.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/view_request_tile.dart';

class ViewcomplaintsList extends StatefulWidget {
  const ViewcomplaintsList({Key? key}) : super(key: key);

  @override
  _ViewcomplaintsListState createState() => _ViewcomplaintsListState();
}

class _ViewcomplaintsListState extends State<ViewcomplaintsList> {
  @override
  Widget build(BuildContext context) {
    // String d='2021-09-12 14:03';
    // print(DateTime.parse(d).toString());
    return StreamBuilder<QuerySnapshot?>(
        stream: GetComplaintDB().getAllComplaints,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemBuilder: (context, index){
                //print(snapshot.data!.docs[index].get('dateTime').seconds>Timestamp.now().seconds);
                return ViewRequestTile(
                  title: snapshot.data!.docs[index].get('headline'),
                  headline: "Complaint",
                  image: "Complaint",
                  date: snapshot.data!.docs[index].get('date'),
                  // reply: snapshot.data!.docs[index].get('reply'),
                  // assignmentId: snapshot.data!.docs[index].id,
                  // date: snapshot.data!.docs[index].get('date'),
                  // roleNo: snapshot.data!.docs[index].get('participantIDs').indexOf(LifeguardSingleton().uid),
                  // time: snapshot.data!.docs[index].get('startTime'),
                );
              },
              itemCount: snapshot.data?.size,
            );
          }else{
            return Container(
              child: Text('There Seems to be no assignments'),
            );
          }
        }
    );
  }
}
