import 'package:flutter/material.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/contact_tile.dart';

class EmergencyCall extends StatelessWidget {
  const EmergencyCall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Center(child: Text("Emergency Contacts")),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 60,),
            ContactTile(contactName: "HEAD LIFEGUARD", contactNo: "011 1234586", image: "life_buoy_icon",),
            ContactTile(contactName: "SUWA SERIYA", contactNo: "011 1254789", image: "ambulance_icon",),
            ContactTile(contactName: "POLICE", contactNo: "011 1919191", image: "police_man_icon",),
            ContactTile(contactName: "FIRE-DEPARTMENT", contactNo: "011 1847596", image: "fire_estinguisher_icon",),
          ],
        )
      ),
    );
  }
}
