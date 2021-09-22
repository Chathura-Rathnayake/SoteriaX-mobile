import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';
import 'package:intl/intl.dart';

class HelpRequestDBServices {
  LifeguardSingleton lifeguardSingleton = LifeguardSingleton();
  final CollectionReference helpRequest =
      FirebaseFirestore.instance.collection("helpRequests");
  final CollectionReference complaints =
      FirebaseFirestore.instance.collection("complaints");
  final CollectionReference suggestion =
      FirebaseFirestore.instance.collection("suggestions");

  Future<bool> addRequest(String name, String age, String formType) async{
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    bool didSubmit=false;
    print(formatted);
    final String designation;
    if ('${lifeguardSingleton.uid}' ==
        '${lifeguardSingleton.company.companyId}') {
      designation = "headLifeguard";
    } else {
      designation = "lifeguard";
    }

    if (formType == "Help Request") {
      didSubmit= await helpRequest
          .add({
            "headline": name,
            "msg": age,
            "name":
                '${lifeguardSingleton.firstname} ${lifeguardSingleton.lastname}',
            "status": 0,
            "viewed": 0,
            "date": formatted,
            "accountType": '${designation}',
            "companyID": '${lifeguardSingleton.company.companyId}',
            "companyName": '${lifeguardSingleton.company.companyName}',
            "userID": '${lifeguardSingleton.uid}',
          })
          .then((value) {
        print(value.id);
        return true;
      });
    } else if (formType == "Complaints") {
      didSubmit=await complaints
          .add({
            "headline": name,
            "msg": age,
            "name":
                '${lifeguardSingleton.firstname} ${lifeguardSingleton.lastname}',
            "status": 0,
            "viewed": 0,
            "date": formatted,
            "accountType": '${designation}',
            "companyID":'${lifeguardSingleton.company.companyId}',
            "companyName":'${lifeguardSingleton.company.companyName}',
            "userID":'${lifeguardSingleton.uid}',
          }
      ).then((value){
        print(value.id);
        return true;
      });
    } else {
      didSubmit=await suggestion
          .add({
            "headline": name,
            "msg": age,
            "name":
                '${lifeguardSingleton.firstname} ${lifeguardSingleton.lastname}',
            "status": 0,
            "viewed": 0,
            "date": formatted,
            "accountType": '${designation}',
            "companyID":'${lifeguardSingleton.company.companyId}',
            "companyName":'${lifeguardSingleton.company.companyName}',
            "userID":'${lifeguardSingleton.uid}',
          }
      ).then((value) {
        print(value.id);
        return true;
      });
    }

    return didSubmit;
  }
}
