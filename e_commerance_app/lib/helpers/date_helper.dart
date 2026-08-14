class DateHelper{


  DateHelper._();



  static String formatDate(
      String date
      ){


    final parsedDate =
    DateTime.parse(date);



    return "${parsedDate.day}/"
        "${parsedDate.month}/"
        "${parsedDate.year}";


  }




  static String formatDateTime(
      String date
      ){


    final parsedDate =
    DateTime.parse(date);



    return "${parsedDate.day}/"
        "${parsedDate.month}/"
        "${parsedDate.year} "
        "${parsedDate.hour}:"
        "${parsedDate.minute}";


  }


}