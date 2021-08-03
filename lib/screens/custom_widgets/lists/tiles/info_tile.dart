import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  String? image="question";
  String? title="";
  String? subtitle="";
  InfoTile({this.title, this.subtitle, this.image });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10,3,10,3),
      child: Card(
        margin: EdgeInsets.only(top: 10),
        child: ListTile(
          leading: Image(
              image: AssetImage('assets/icons/${image ?? "unknown_contact_icon"}.png'),
          ),
          title: Text("${title ?? "Unknown"}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          subtitle: Text("${subtitle??"Unknown"}", style: TextStyle(fontSize: 12),),
        ),
      ),
    );
  }
}
