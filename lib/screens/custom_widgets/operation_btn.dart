import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OperationBtn extends StatefulWidget {
  OperationBtn({this.btnText, this.btnImage, this.onClicked, this.setType, this.type, this.height});
  String? btnImage;
  String? btnText;
  int? type=0;
  Function? onClicked;
  Function? setType;
  double? height;

  @override
  _OperationBtnState createState() => _OperationBtnState();
}

class _OperationBtnState extends State<OperationBtn> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child: MaterialButton(
        onPressed: (){
          widget.setType!(widget.type);
          widget.onClicked!();
          },
        height: widget.height!=null ? widget.height : MediaQuery.of(context).size.height * 0.20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Image(
            image: AssetImage('assets/icons/${widget.btnImage}.png'),
          ),
          title: Text(widget.btnText!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),),
          trailing: Icon(CupertinoIcons.chevron_right, color: Colors.black, size: 30,),
        ),
      ),
    );
  }
}
// 'assets/icons/${widget.btnImage}.png'
// 'assets/icons/right_arrow_icon.png'
// widget.btnText!

