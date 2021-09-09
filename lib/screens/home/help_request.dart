import "package:flutter/material.dart";
import 'package:soteriax/database/help_request_database.dart';

class helpRequest extends StatefulWidget {
  const helpRequest({Key? key}) : super(key: key);

  @override
  _helpRequestState createState() => _helpRequestState();
}

class _helpRequestState extends State<helpRequest> {
  @override
  final _formKey=GlobalKey<FormState>();
  String? name;
  String? age;
  String? formType;
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Colors.orange.shade800,
    title: Center(child: Text("Help request")),),
    body: Container(
      child: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Text("Help request form",style: TextStyle(fontSize: 30),),
            SizedBox(height: 20,),
            Row(
              children: [
                Text("Select request type",style: TextStyle(fontSize: 20),),
                SizedBox(width: 20,),
                DropdownButton<String>(
                    value: formType,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                        color: Colors.orange
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.orange,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        formType = newValue!;
                      });
                    },
                    items: <String>['Help Request', 'Suggestion', 'Complaints']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                        .toList(),
                  ),
              ],
            ),
              SizedBox(height: 20,),
              TextFormField(
              decoration: InputDecoration(
                  hintText: "Headline",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
              validator: (value)=> value==''? 'Please enter name':null,
              onChanged: (value){
                name=value;
                },
            ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Message",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                validator: (value)=> value==''? 'Please enter age':null,
                onChanged: (value){
                  age=value;
                },
                maxLines: 3,

              ),

              SizedBox(height: 40,),
              // TextField(
              //   maxLines: 3,
              //   decoration: InputDecoration(
              //
              //   ),
              // ),
              MaterialButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      print("Button pressed: $name $age");
                      HelpRequestDBServices().addRequest(name!, age!,formType!);
                    }else{
                      print("Not validated");
                    }
                  },
                  color: Colors.orange,
                  child: Text("Click me"),
              ),


            ]



          ),
        ),
      ),
    )
      ,)
      ,);
  }
}
