import 'package:flutter/material.dart';

import '../screens/admin_login_screen.dart';
import '../screens/admin_home_screen.dart';
import '../screens/add_product_screen.dart';
import '../screens/product_list_screen.dart';
import '../screens/add_category_screen.dart';
import '../screens/category_list_screen.dart';
import '../screens/order_list_screen.dart';
import '../screens/admin_profile_screen.dart';


class AppRoutes{

  static Map<String,WidgetBuilder> routes={


    '/login':(context)=>const AdminLoginScreen(),


    '/home':(context)=>const AdminHomeScreen(),


    '/addProduct':(context)=>const AddProductScreen(),


    '/products':(context)=>const ProductListScreen(),


    '/addCategory':(context)=>const AddCategoryScreen(),


    '/categories':(context)=>const CategoryListScreen(),


    '/orders':(context)=>const OrderListScreen(),


    '/profile':(context)=>const AdminProfileScreen(),


  };

}