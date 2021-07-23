import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTile extends StatelessWidget {

  String? contactName="Unknown";
  String? contactNo="Unknown";
  String? image="unknown_contact_icon";

  ContactTile({this.contactName, this.contactNo, this.image});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
        child: Card(
          margin: EdgeInsets.only(top: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: MaterialButton(
              onPressed: (){
                launch("tel:${contactNo??null}");
              },
              child: ListTile(
                leading: Image(
                  image: AssetImage('assets/icons/${image ?? "unknown_contact_icon"}.png'),
                ),
                title: Text("${contactName ?? "Unknown"}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                subtitle: Text("${contactNo??"Unknown"}", style: TextStyle(fontSize: 12),),
                trailing: Image(
                  image: AssetImage('assets/icons/call_icon.png'),
                  width: 50,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
