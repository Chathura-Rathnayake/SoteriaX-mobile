import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoCurrentOP extends StatelessWidget {
  const NoCurrentOP({Key? key}) : super(key: key);

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
                    Container(
                      padding: EdgeInsets.fromLTRB(90, 10, 90, 30),
                      child: Image(
                        image: AssetImage('assets/icons/lifeguard_chair_icon.png'),
                      ),
                    ),
                    Text(
                      "No Live Operations or No Live Training Sessions",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            )
        )
    );
  }
}
