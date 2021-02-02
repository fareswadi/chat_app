import 'package:shared_preferences/shared_preferences.dart';

class Helper{

  static String mynamekey='myname';
  static String myemailkey='myemail';
  static String myimagekey='myImage';
  static Future<String>getmyname()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
      return   await pref.getString(mynamekey);

  }
  static Future<String>getmyemail()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    return   await pref.getString(myemailkey);

  }


  static Future<void>setmyname(String myname)async{
    SharedPreferences pref= await SharedPreferences.getInstance();
   return await pref.setString(mynamekey,myname);
  }
  static Future<void>setmyemail(String myemail)async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    return await pref.setString(myemailkey,myemail);
  }

  static Future<String>getimage()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    return   await pref.getString(myimagekey);

  }


  static Future<void>setimage(String image)async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    return await pref.setString(myimagekey,image);
  }
}