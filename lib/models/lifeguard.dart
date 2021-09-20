class Sys_user{
  Sys_user({this.uid, this.email});
  final String? uid;
  final String? email;
}


class Lifeguard{

  Lifeguard({this.uid, this.email, this.firstname, this.lastname, this.birthDate, this.designation,
    this.noOfOperations, this.isPilot, this.certificateLevel, this.company, this.mobileNo, this.nic, this.gender});

  String? uid;
  String? firstname;
  String? lastname;
  String? email;
  String? nic;
  String? mobileNo;
  String? certificateLevel="";
  String? birthDate;
  int? noOfOperations=0;
  bool? isPilot=false;
  String? designation="";
  Company? company;
  String? gender;

  Lifeguard.fromJson(Map<String, dynamic> json){
    uid=json['uid'];
    firstname=json['firstName'];
    lastname=json['lastName'];
    email=json['email'];
    certificateLevel=json['certificateLevel'];
    birthDate=json['birthDate'];
    noOfOperations=json['noOfOperations'];
    isPilot=json['isPilot'];
    designation=json['designation'];
    gender=json['gender'];
    company= json['company'] == null ? null : Company.fromJson(json['company']);
  }

  @override
  String toString() {
    // TODO: implement toString
    return '{"uid": "$uid","firstName": "$firstname", "lastName": "$lastname", "email": "$email", "certificateLevel": "$certificateLevel", "gender": "$gender",'
        ' "birthDate": "$birthDate", "noOfOperations": $noOfOperations, "isPilot": $isPilot,"designation": "$designation", "company": ${company.toString()}}';
  }


}

class Company{
  Company({this.companyId, this.companyEmail, this.companyAddress, this.companyName, this.staticIP});

  String? companyId="";
  String? companyEmail="";
  String? companyAddress="";
  String? companyName="";
  String? staticIP="";

  Company.fromJson(Map<String, dynamic> json){
    companyId=json['companyId'];
    companyName=json['companyName'];
    companyAddress=json['companyAddress'];
    companyEmail=json['companyEmail'];
    staticIP=json['staticIP'];
  }

  @override
  String toString() {
    return '{"companyId": "$companyId", "companyEmail": "$companyEmail", "staticIP": "$staticIP", '
        ' "companyAddress": "$companyAddress", "companyName": "$companyName"}';
  }

}