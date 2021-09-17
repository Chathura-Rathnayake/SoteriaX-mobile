import 'package:flutter/material.dart';
import 'package:soteriax/screens/home/current_assignments.dart';
import 'package:soteriax/screens/home/emergency_call.dart';
import 'package:soteriax/screens/home/past_assignments.dart';

class NavigationButton extends StatelessWidget {
  String? title="";
  String? image="question_mark";
  int? onPressedFunFlag;
  int? textSize;
  NavigationButton({this.title, this.image, this.onPressedFunFlag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: Card(
        margin: EdgeInsets.only(top: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: MaterialButton(
            onPressed: (){
              switch(onPressedFunFlag){
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CurrentAssignment()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PastAssignments()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmergencyCall()),
                  );
                  break;
              }
            },
            child: ListTile(
              leading: Image(
                image: AssetImage('assets/icons/${image ?? "unknown_contact_icon"}.png'),
              ),
              title: Text("${title ?? "Unknown"}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                trailing: Icon(
                 Icons.chevron_right,
                  size: 50,
                  color: Colors.black,
                )
            ),
          ),
        ),
      ),
    );
  }
}
