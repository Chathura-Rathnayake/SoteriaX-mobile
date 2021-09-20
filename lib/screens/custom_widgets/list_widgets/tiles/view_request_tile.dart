import 'package:flutter/material.dart';

class ViewRequestTile extends StatelessWidget {
  String? image="question";
  String? title="";
  String? headline="";
  String? date="";
  String? reply="";
  ViewRequestTile({this.title, this.headline, this.image ,this.date,this.reply});

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
          title: Text("Headline: ${title ?? "Unknown"} |\nDate: ${date ?? "Unknown"} ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          subtitle: Text("Request type: ${headline??"Unknown"}", style: TextStyle(fontSize: 12),),
        ),
      ),
    );
  }
}
