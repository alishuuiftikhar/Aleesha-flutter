import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'theme/app_theme.dart';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/category_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/search_provider.dart';
import 'providers/profile_provider.dart';

import 'routes/app_routes.dart';


Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:SupabaseConfig.url,
    anonKey:SupabaseConfig.anonKey,
  );

  runApp(const MyApp());

}


class MyApp extends StatelessWidget{

  const MyApp({super.key});


  @override
  Widget build(BuildContext context){

    return MultiProvider(

      providers:[

        ChangeNotifierProvider(create:(_)=>AuthProvider()),
        ChangeNotifierProvider(create:(_)=>ProductProvider()),
        ChangeNotifierProvider(create:(_)=>CartProvider()),
        ChangeNotifierProvider(create:(_)=>OrderProvider()),
        ChangeNotifierProvider(create:(_)=>CategoryProvider()),
        ChangeNotifierProvider(create:(_)=>WishlistProvider()),
        ChangeNotifierProvider(create:(_)=>SearchProvider()),
        ChangeNotifierProvider(create:(_)=>ProfileProvider()),

      ],

      child:MaterialApp(

        debugShowCheckedModeBanner:false,

        title:"E-Commerce App",

        theme:AppTheme.lightTheme,

        initialRoute:AppRoutes.splash,

        routes:AppRoutes.routes,

      ),

    );

  }

}