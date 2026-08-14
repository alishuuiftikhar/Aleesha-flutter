class Validators{


  Validators._();



  static String? validateEmail(String? value){


    if(value==null || value.trim().isEmpty){

      return "Email is required";

    }


    if(!value.contains("@")){

      return "Enter valid email";

    }


    return null;

  }




  static String? validatePassword(String? value){


    if(value==null || value.isEmpty){

      return "Password is required";

    }


    if(value.length < 6){

      return "Password must be 6 characters";

    }


    return null;

  }




  static String? validateName(String? value){


    if(value==null || value.trim().isEmpty){

      return "Name is required";

    }


    return null;

  }




  static String? validatePhone(String? value){


    if(value==null || value.trim().isEmpty){

      return "Phone number is required";

    }


    if(value.length < 10){

      return "Enter valid phone number";

    }


    return null;

  }




  static String? validateField(
      String? value,
      String fieldName
      ){


    if(value==null || value.trim().isEmpty){

      return "$fieldName is required";

    }


    return null;

  }


}