import 'package:flutter/material.dart';
import 'package:soteriax/screens/custom_widgets/lists/tiles/info_tile.dart';
import 'package:soteriax/screens/custom_widgets/navigate_button.dart';
import 'package:soteriax/screens/home/main_menu.dart';
class TrainingOverview extends StatefulWidget {
  const TrainingOverview({Key? key}) : super(key: key);

  @override
  _TrainingOverviewState createState() => _TrainingOverviewState();
}

class _TrainingOverviewState extends State<TrainingOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text("Training Overview"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20,),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text("Next Training Assignment"),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              InfoTile(title: "2021-08-05", subtitle: "Date",image: "calendar"),
              InfoTile(title: "12:30pm", subtitle: "Time",image: "clock"),
              InfoTile(title: "Assistant Pilot", subtitle: "Role",image: "role"),
              SizedBox(height: 5),
              MaterialButton(
                color: Colors.orange[600],
                onPressed: (){},
                disabledElevation: null,
                disabledTextColor: Colors.black,
                disabledColor: Colors.grey[500],
                child: Text("Initiate Exercise", style: TextStyle(fontSize: 20, color: Colors.white),),
              ),
              Text("Button will be automatically activated at the afforementioned time",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 20,),
              NavigationButton(title: "Current Assignments", image: "swimming-trainer", onPressedFunFlag: 1,),
              SizedBox(height: 5,),
              NavigationButton(title: "Past Assignments", image: "stat",  onPressedFunFlag: 2,),
            ],
          ),
        ),
      ),
    );
  }
}
