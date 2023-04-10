class Menuitem{
  String? name;
  List<String>? ingredients=[];
  Map<String,dynamic>? size={};
  Map<String,List<String>>? categories={};
  String? price;
  bool? disabled;
  Map<String,dynamic>? selectedcategory={};
  double? VAT;
  Menuitem({this.name,this.price, this.ingredients,this.size,this.categories,this.selectedcategory,this.disabled,this.VAT});
}