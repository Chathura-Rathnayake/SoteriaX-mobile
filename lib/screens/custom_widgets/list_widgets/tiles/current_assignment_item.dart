import 'package:flutter/material.dart';

class CurrentAssignmentItem extends StatelessWidget {
  CurrentAssignmentItem({this.date, this.time, this.roleNo, this.assignmentId}){
    if(roleNo!=null){
      switch(roleNo){
        case 0:
          role="Mobile Handler";
          break;
        case 1:
          role="Drone Pilot";
          break;
        case 2:
          role= "Swimmer";
          break;
      }
    }
  }
  String? date;
  String? time;
  int? roleNo;
  String? role;
  String? assignmentId;
  String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: Card(
        margin: EdgeInsets.only(top: 5),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: MaterialButton(
            onPressed: (){},
            child: ListTile(
              leading: Image(
                image: AssetImage('assets/icons/assignment.png'),
              ),
              title: Text("Date: ${date ?? "Unknown"} |\nTime: ${time ?? "Unknown"} |\nRole: ${role ?? "Unknown"}\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              subtitle: Text("Assignment Id: ${assignmentId ?? "Unknown"}", style: TextStyle(fontSize: 12),),
            ),
          ),
        ),
      ),
    );
  }
}
