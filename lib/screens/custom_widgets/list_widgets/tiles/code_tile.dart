import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CodeTile extends StatelessWidget {
  CodeTile({this.codeName, this.code, this.subTitle});
  String? codeName;
  String? code;
  String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Card(
        margin: EdgeInsets.fromLTRB(10,3,10,3),
        child: MaterialButton(
          onPressed: (){},
          child: ListTile(
            trailing: Icon(Icons.send),
            title: Text("${codeName ?? "Unknown Code Name"}   ${code ?? "Unknown"}", style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text("${subTitle ?? ""}"),
          ),
        ),
      ),
    );
  }
}
