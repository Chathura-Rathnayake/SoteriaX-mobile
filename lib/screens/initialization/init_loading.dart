import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade500,
              Colors.orange.shade400
            ]
          )
        ),
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.white,
            size: 80,
          ),
        ),
      ),
    );
  }
}
