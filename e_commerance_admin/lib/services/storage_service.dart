import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class StorageService{

  StorageService._();

  static final SupabaseClient _supabase=
      Supabase.instance.client;

  static Future<String> uploadImage(XFile file) async{

    final fileName=
        "${DateTime.now().millisecondsSinceEpoch}_${file.name}";

    final bytes = await file.readAsBytes();

    await _supabase.storage
        .from('products')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    return _supabase.storage
        .from('products')
        .getPublicUrl(fileName);

  }

}