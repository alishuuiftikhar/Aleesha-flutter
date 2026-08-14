import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme{

  AppTheme._();

  static ThemeData get lightTheme{

    return ThemeData(

      useMaterial3:true,

      scaffoldBackgroundColor:AppColors.background,

      colorScheme:ColorScheme.fromSeed(
        seedColor:AppColors.primary,
      ),

      appBarTheme:const AppBarTheme(
        backgroundColor:AppColors.primary,
        foregroundColor:AppColors.white,
        centerTitle:true,
        elevation:0,
      ),

      elevatedButtonTheme:ElevatedButtonThemeData(
        style:ElevatedButton.styleFrom(
          backgroundColor:AppColors.primary,
          foregroundColor:AppColors.white,
          minimumSize:const Size(double.infinity,55),
          shape:RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(12),
          ),
        ),
      ),

      inputDecorationTheme:InputDecorationTheme(
        border:OutlineInputBorder(
          borderRadius:BorderRadius.circular(12),
        ),
        enabledBorder:OutlineInputBorder(
          borderRadius:BorderRadius.circular(12),
        ),
        focusedBorder:OutlineInputBorder(
          borderRadius:BorderRadius.circular(12),
          borderSide:const BorderSide(
            color:AppColors.primary,
            width:2,
          ),
        ),
      ),

    );

  }

}