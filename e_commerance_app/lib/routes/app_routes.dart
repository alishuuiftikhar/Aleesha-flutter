import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/order_screen.dart';
import '../screens/profile_screen.dart';


class AppRoutes{


  AppRoutes._();


  static const String splash="/";

  static const String login="/login";

  static const String signup="/signup";

  static const String forgotPassword="/forgot-password";

  static const String home="/home";

  static const String cart="/cart";

  static const String orders="/orders";

  static const String profile="/profile";



  static Map<String,WidgetBuilder> routes = {


    splash:(context)=>const SplashScreen(),


    login:(context)=>const LoginScreen(),


    signup:(context)=>const SignupScreen(),


    forgotPassword:(context)=>
    const ForgotPasswordScreen(),


    home:(context)=>const HomeScreen(),


    cart:(context)=>const CartScreen(),


    orders:(context)=>const OrdersScreen(),


    profile:(context)=>const ProfileScreen(),


  };

}