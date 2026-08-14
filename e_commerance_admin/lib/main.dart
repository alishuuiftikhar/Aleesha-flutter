import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'screens/admin_login_screen.dart';


Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(

    url:SupabaseConfig.supabaseUrl,

    anonKey:SupabaseConfig.supabaseAnonKey,

  );

  runApp(
    const MyApp(),
  );

}



class MyApp extends StatelessWidget{

  const MyApp({super.key});


  @override
  Widget build(BuildContext context){

    return MaterialApp(

      debugShowCheckedModeBanner:false,

      title:"E-Commerce Admin",

      theme:AppTheme.lightTheme,

      routes:AppRoutes.routes,

      home:const AdminLoginScreen(),

    );

  }

}