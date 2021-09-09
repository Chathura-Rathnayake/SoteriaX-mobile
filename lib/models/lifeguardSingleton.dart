import 'lifeguard.dart';

class LifeguardSingleton{
  static LifeguardSingleton? _instance;

  String? _uid;
  String? _firstname;
  String? _lastname;
  String? _email;
  String? _certificateLevel="";
  String? _birthDate;
  String? _mobileNo;
  String? _nic;
  bool? _isPilot=false;
  String? _designation="";
  Company? _company;

  LifeguardSingleton._internal();

  factory LifeguardSingleton(){
    if(_instance==null){
      _instance=LifeguardSingleton._internal();
    }
    return _instance!;
  }

  Company get company => _company!;

  set company(Company value) {
    _company = value;
  }

  String get designation => _designation!;

  set designation(String value) {
    _designation = value;
  }

  bool get isPilot => _isPilot!;

  set isPilot(bool value) {
    _isPilot = value;
  }


  String get mobileNo => _mobileNo!;

  set mobileNo(String value) {
    _mobileNo = value;
  }

  String get nic => _nic!;

  set nic(String value) {
    _nic = value;
  }



  String get birthDate => _birthDate!;

  set birthDate(String value) {
    _birthDate = value;
  }

  String get certificateLevel => _certificateLevel!;

  set certificateLevel(String value) {
    _certificateLevel = value;
  }

  String get email => _email!;

  set email(String value) {
    _email = value;
  }

  String get lastname => _lastname!;

  set lastname(String value) {
    _lastname = value;
  }

  String get firstname => _firstname!;

  set firstname(String value) {
    _firstname = value;
  }

  String get uid => _uid!;

  set uid(String value) {
    _uid = value;
  }

}