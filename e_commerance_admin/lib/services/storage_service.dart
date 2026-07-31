import 'dart:io';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService{

  StorageService._();

  static final SupabaseClient _supabase=
      Supabase.instance.client;

  static Future<String> uploadImage(File file) async{

    final fileName=
        "${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}";

    await _supabase.storage
        .from('products')
        .upload(fileName,file);

    return _supabase.storage
        .from('products')
        .getPublicUrl(fileName);

  }

}