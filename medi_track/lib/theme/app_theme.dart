import 'package:flutter/material.dart';

class AppTheme{

  static ThemeData lightTheme=ThemeData(

    useMaterial3:true,

    scaffoldBackgroundColor:
    const Color(0xFFFFF8FB),


    colorScheme:ColorScheme.fromSeed(

      seedColor:
      const Color(0xFFEC4899),

      primary:
      const Color(0xFFEC4899),

      secondary:
      const Color(0xFFF9A8D4),

      surface:
      Colors.white,

    ),


    appBarTheme:const AppBarTheme(

      backgroundColor:
      Color(0xFFEC4899),

      foregroundColor:
      Colors.white,

      centerTitle:true,

      elevation:0,

      titleTextStyle:TextStyle(

        color:Colors.white,

        fontSize:22,

        fontWeight:
        FontWeight.bold,

      ),

    ),



    textTheme:const TextTheme(

      titleLarge:TextStyle(

        fontSize:24,

        fontWeight:
        FontWeight.bold,

        color:
        Color(0xFF374151),

      ),


      bodyLarge:TextStyle(

        fontSize:16,

        color:
        Color(0xFF4B5563),

      ),


      bodyMedium:TextStyle(

        fontSize:14,

        color:
        Color(0xFF6B7280),

      ),

    ),



    elevatedButtonTheme:
    ElevatedButtonThemeData(

      style:ElevatedButton.styleFrom(

        backgroundColor:
        Color(0xFFEC4899),

        foregroundColor:
        Colors.white,

        elevation:4,

        minimumSize:
        const Size(double.infinity,55),

        shape:
        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(18),

        ),

      ),

    ),



    inputDecorationTheme:
    InputDecorationTheme(

      filled:true,

      fillColor:
      Colors.white,


      contentPadding:
      const EdgeInsets.symmetric(

        horizontal:18,

        vertical:16,

      ),


      prefixIconColor:
      Color(0xFFEC4899),


      border:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(18),

        borderSide:
        BorderSide.none,

      ),


      enabledBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(18),

        borderSide:
        BorderSide.none,

      ),


      focusedBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(18),

        borderSide:
        BorderSide(

          color:
          Color(0xFFEC4899),

          width:2,

        ),

      ),

    ),



    cardTheme:
    CardThemeData(

      color:
      Colors.white,

      elevation:4,

      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(20),

      ),

    ),



    floatingActionButtonTheme:
    const FloatingActionButtonThemeData(

      backgroundColor:
      Color(0xFFEC4899),

      foregroundColor:
      Colors.white,

      elevation:6,

    ),


  );

}