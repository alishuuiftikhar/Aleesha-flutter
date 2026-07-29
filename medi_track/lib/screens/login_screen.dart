import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState()=>_LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

final emailController=TextEditingController();
final passwordController=TextEditingController();

final supabase=Supabase.instance.client;

bool isLoading=false;
bool obscurePassword=true;
bool rememberMe=false;

final pink=const Color(0xFFEC4899);


@override
void initState(){
super.initState();
loadSavedData();
}


Future<void> loadSavedData()async{

final prefs=await SharedPreferences.getInstance();

setState((){

emailController.text=prefs.getString("email")??"";
passwordController.text=prefs.getString("password")??"";
rememberMe=prefs.getBool("remember")??false;

});

}



Future<void> saveData()async{

final prefs=await SharedPreferences.getInstance();

if(rememberMe){

await prefs.setString(
"email",
emailController.text.trim(),
);

await prefs.setString(
"password",
passwordController.text.trim(),
);

await prefs.setBool(
"remember",
true,
);

}
else{

await prefs.clear();

}

}



Future<void> login()async{

if(emailController.text.trim().isEmpty ||
passwordController.text.trim().isEmpty){

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content:Text("Enter email and password"),
),
);

return;
}


setState((){
isLoading=true;
});


try{

await supabase.auth.signInWithPassword(

email:emailController.text.trim(),

password:passwordController.text.trim(),

);


await saveData();


if(!mounted)return;


Navigator.pushReplacement(

context,

MaterialPageRoute(
builder:(_)=>const HomeScreen(),
),

);


}
catch(e){

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content:Text("Login Failed"),
),
);

}


setState((){
isLoading=false;
});

}
@override
Widget build(BuildContext context){

return Scaffold(

backgroundColor:Colors.white,

body:SafeArea(

child:SingleChildScrollView(

padding:const EdgeInsets.all(20),

child:Column(

children:[

const SizedBox(height:40),


CircleAvatar(

radius:60,

backgroundColor:pink,

child:const Icon(

Icons.local_hospital,

size:60,

color:Colors.white,

),

),


const SizedBox(height:25),


const Text(

"Welcome Back",

style:TextStyle(

fontSize:30,

fontWeight:FontWeight.bold,

),

),


const SizedBox(height:8),


const Text(

"Login to continue",

style:TextStyle(

color:Colors.grey,

fontSize:16,

),

),


const SizedBox(height:35),



TextField(

controller:emailController,

keyboardType:TextInputType.emailAddress,

decoration:input(
"Email Address",
Icons.email_outlined,
),

),



const SizedBox(height:15),



TextField(

controller:passwordController,

obscureText:obscurePassword,


decoration:InputDecoration(

labelText:"Password",

prefixIcon:Icon(
Icons.lock_outline,
color:pink,
),


suffixIcon:IconButton(

icon:Icon(

obscurePassword
?Icons.visibility_off
:Icons.visibility,

color:pink,

),

onPressed:(){

setState((){

obscurePassword=!obscurePassword;

});

},

),


border:OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

),

),



const SizedBox(height:10),



Row(

mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children:[


Row(

children:[

Checkbox(

activeColor:pink,

value:rememberMe,

onChanged:(value){

setState((){

rememberMe=value!;

});

},

),


const Text(
"Remember Me",
),

],

),



TextButton(

onPressed:forgotPassword,

child:Text(

"Forgot Password?",

style:TextStyle(
color:pink,
),

),

),


],

),



const SizedBox(height:15),



SizedBox(

width:double.infinity,

height:55,


child:ElevatedButton(

onPressed:isLoading?null:login,


style:ElevatedButton.styleFrom(

backgroundColor:pink,

foregroundColor:Colors.white,


shape:RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(15),

),

),


child:isLoading

?const CircularProgressIndicator(
color:Colors.white,
)

:const Text(

"Login",

style:TextStyle(

fontSize:18,

fontWeight:FontWeight.bold,

),

),

),

),



const SizedBox(height:20),



Row(

mainAxisAlignment:
MainAxisAlignment.center,

children:[


const Text(
"Don't have an account? ",
),


TextButton(

onPressed:(){

Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>const SignupScreen(),

),

);

},


child:Text(

"Sign Up",

style:TextStyle(
color:pink,
),

),

),

],

),


],

),

),

),

);

}
Future<void> forgotPassword()async{

  if(emailController.text.trim().isEmpty){

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content:Text(
          "Enter your email first",
        ),

      ),

    );

    return;

  }


  try{

    await supabase.auth.resetPasswordForEmail(

      emailController.text.trim(),

    );


    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content:Text(
          "Password reset link sent to email",
        ),

      ),

    );


  }
  catch(e){

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content:Text(
          "Failed to send reset email",
        ),

      ),

    );

  }

}



InputDecoration input(
    String text,
    IconData icon
    ){

  return InputDecoration(

    labelText:text,

    prefixIcon:Icon(

      icon,

      color:pink,

    ),


    border:OutlineInputBorder(

      borderRadius:
      BorderRadius.circular(15),

    ),

  );

}



@override
void dispose(){

  emailController.dispose();

  passwordController.dispose();

  super.dispose();

}

}