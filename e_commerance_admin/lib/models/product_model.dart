class ProductModel{

  final int? id;
  final String name;
  final double price;
  final String description;
  final int categoryId;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
  });

  factory ProductModel.fromJson(
      Map<String,dynamic> json){

    return ProductModel(

      id:json['id'],

      name:json['name']??'',

      price:(json['price'] as num?)?.toDouble()??0,

      description:json['description']??'',

      categoryId:json['category_id']??0,

    );

  }

  Map<String,dynamic> toJson(){

    return{

      'id':id,

      'name':name,

      'price':price,

      'description':description,

      'category_id':categoryId,

    };

  }

}