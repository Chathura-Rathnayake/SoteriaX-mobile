import 'package:flutter/material.dart';
class WaitingOpResponse extends StatelessWidget {
  const WaitingOpResponse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[800],
          title: Text("View Operation"),
        ),
        body: Container(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Please wait...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    CircularProgressIndicator(),
                  ],
                )
            )
        )
      );;
  }
}
