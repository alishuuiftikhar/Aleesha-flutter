class OrderModel{

  final int? id;
  final String userId;
  final double totalPrice;
  final String status;
  final DateTime? createdAt;


  OrderModel({
    this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    this.createdAt,
  });



  factory OrderModel.fromJson(
      Map<String,dynamic> json){

    return OrderModel(

      id:json['id'],

      userId:
      json['user_id']??'',

      totalPrice:
      (json['total_price'] as num).toDouble(),

      status:
      json['status']??'Pending',

      createdAt:
      json['created_at']!=null
          ?DateTime.parse(json['created_at'])
          :null,

    );

  }



  Map<String,dynamic> toJson(){

    return{

      'id':id,

      'user_id':userId,

      'total_price':totalPrice,

      'status':status,

      'created_at':
      createdAt?.toIso8601String(),

    };

  }

}