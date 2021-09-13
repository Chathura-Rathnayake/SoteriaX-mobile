import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:soteriax/database/past_assignments_database_services.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/past_assignment_item.dart';

class PastAssignmentList extends StatefulWidget {
  const PastAssignmentList({Key? key}) : super(key: key);

  @override
  _PastAssignmentListState createState() => _PastAssignmentListState();
}

class _PastAssignmentListState extends State<PastAssignmentList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot?>(
      stream: PastAssignmentDB().getPastAssignments,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
              itemBuilder: (context, index){
                return PastAssignmentItem(assignmentId: snapshot.data!.docs[index].id,
                  date: snapshot.data!.docs[index].get('date'),
                  roleNo: snapshot.data!.docs[index].get('participantIDs').indexOf(LifeguardSingleton().uid),
                  time: snapshot.data!.docs[index].get('startTime'),);
              },
            itemCount: snapshot.data!.size,
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
