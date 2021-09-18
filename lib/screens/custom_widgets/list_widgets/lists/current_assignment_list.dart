import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/current_assignment_database_services.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/current_assignment_item.dart';

class CurrentAssignmentList extends StatefulWidget {
  const CurrentAssignmentList({Key? key}) : super(key: key);

  @override
  _CurrentAssignmentListState createState() => _CurrentAssignmentListState();
}

class _CurrentAssignmentListState extends State<CurrentAssignmentList> {
  @override
  Widget build(BuildContext context) {
    String d='2021-09-12 14:03';
    print(DateTime.parse(d).toString());
    return StreamBuilder<QuerySnapshot?>(
      stream: CurrentAssignmentDB().getCurrentAssignments,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
            itemBuilder: (context, index){
              print(snapshot.data!.docs[index].get('dateTime').seconds>Timestamp.now().seconds);
              return CurrentAssignmentItem(
                assignmentId: snapshot.data!.docs[index].id,
                date: snapshot.data!.docs[index].get('date'),
                roleNo: snapshot.data!.docs[index].get('participantIDs').indexOf(LifeguardSingleton().uid),
                time: snapshot.data!.docs[index].get('startTime'),);
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
