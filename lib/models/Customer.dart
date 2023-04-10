class Customer{
  String? name;
  String? active;
  Customer({this.name,this.active});
  factory Customer.fromJson(Map<String,dynamic> data){
    return Customer(
      name: data['name'],
      active: data['active']);
    
  }
}