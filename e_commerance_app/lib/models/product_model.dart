class ProductModel {

  final int id;
  final String name;
  final String image;
  final double price;
  final String description;
  final int categoryId;


  ProductModel({

    required this.id,

    required this.name,

    required this.image,

    required this.price,

    required this.description,

    required this.categoryId,

  });



  factory ProductModel.fromJson(
      Map<String, dynamic> json) {

    return ProductModel(

      id: json['id'] ?? 0,

      name: json['name'] ?? '',

      image: json['image'] ?? '',

      price: (json['price'] ?? 0).toDouble(),

      description: json['description'] ?? '',

      categoryId: json['category_id'] ?? 0,

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'name': name,

      'image': image,

      'price': price,

      'description': description,

      'category_id': categoryId,

    };

  }

}