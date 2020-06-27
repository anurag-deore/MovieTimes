class CellModel {
  String name;
  int id;
 
  CellModel({this.name, this.id});
 
  factory CellModel.fromJson(Map<String, dynamic> json) {
    return CellModel(
        name: json['name'] as String,
        id: json['id'] as int,);
  }
}