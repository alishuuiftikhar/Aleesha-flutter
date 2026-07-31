class FormatHelper{


  FormatHelper._();



  static String price(double price){


    return "\$${price.toStringAsFixed(2)}";


  }




  static String shortText(
      String text,
      int length
      ){


    if(text.length <= length){

      return text;

    }


    return "${text.substring(0,length)}...";


  }




  static String capitalize(
      String text
      ){


    if(text.isEmpty){

      return text;

    }


    return text[0].toUpperCase()
        + text.substring(1);


  }


}