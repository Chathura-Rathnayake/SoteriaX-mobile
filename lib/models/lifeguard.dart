class Sys_user{
  Sys_user({this.uid, this.email});
  final String? uid;
  final String? email;
}


class Lifeguard{

  Lifeguard({this.uid, this.email, this.firstname, this.lastname, this.birthDate, this.noOfOperations, this.isPilot, this.certificateLevel});

  String? uid;
  String? firstname;
  String? lastname;
  String? email;
  String? certificateLevel;
  String? birthDate;
  int? noOfOperations;
  bool? isPilot;

  Lifeguard.fromJson(Map<String, dynamic> json){
    uid=json['uid'];
    firstname=json['firstName'];
    lastname=json['lastName'];
    email=json['email'];
    certificateLevel=json['certificateLevel'];
    birthDate=json['birthDate'];
    noOfOperations=json['noOfOperations'];
    isPilot=json['isPilot'];
  }

  @override
  String toString() {
    // TODO: implement toString
    return '{"uid": "$uid","firstName": "$firstname", "lastName": "$lastname", "email": "$email", "certificateLevel": "$certificateLevel", "birthDate": "$birthDate", "noOfOperations": $noOfOperations, "isPilot": $isPilot}';
  }


}