import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';


class StorageService{


  StorageService._();


  static final SupabaseClient _supabase =
      Supabase.instance.client;



  static Future<String> uploadProfileImage(
      File image,
      String userId
      ) async{


    final fileName =
        "$userId-${DateTime.now().millisecondsSinceEpoch}.jpg";


    await _supabase.storage
        .from('profile_images')
        .upload(
      fileName,
      image,
      fileOptions: const FileOptions(
        upsert:true,
      ),
    );


    final url =
    _supabase.storage
        .from('profile_images')
        .getPublicUrl(fileName);



    return url;

  }


}