import 'package:flutter/material.dart';
class PatientDetailScreen extends StatelessWidget{
  final Map patient;
  const PatientDetailScreen({super.key,required this.patient});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:const Text("Patient Details"),
        backgroundColor:Colors.blue,
        foregroundColor:Colors.white,
      ),
      body:Padding(
        padding:const EdgeInsets.all(15),
        child:Column(
          children:[
            const CircleAvatar(
              radius:40,
              backgroundColor:Colors.blue,
              child:Icon(
                Icons.person,
                size:45,
                color:Colors.white,
              ),),
            const SizedBox(height:20),
            detailCard("Name",patient['name']),
            detailCard("Age",patient['age']),
            detailCard("Disease",patient['disease']),
            detailCard("Phone",patient['phone']),
          ],
        ),
      ),
    );}
  Widget detailCard(String title,String value){
    return Card(
      child:ListTile(
        leading:const Icon(
          Icons.info,
          color:Colors.blue,
        ),
        title:Text(
          title,
          style:const TextStyle(
            fontWeight:FontWeight.bold,
          ),
        ),
        subtitle:Text(value),
      ),
    );
  }
}