class ServiceAccount{

  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? duty;
  int? phonenumber;

  ServiceAccount({this.firstname,this.lastname,this.password,this.email,this.duty,this.phonenumber});
  static ServiceAccount fromJson(Map<String,dynamic> json){
    return ServiceAccount(firstname: json['first name'],
    lastname: json['last name'],
    duty: json['duty'],
    email: json['email'],
    password: json['password'],
    phonenumber: json['phone']);
  }
}