import 'package:flutter/cupertino.dart';

class AppColor {
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [primary, Color(0xFF0F50C6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

    static LinearGradient greenGradient = const LinearGradient(
    colors: [green, Color(0xFF076110)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color primary = Color(0xFFAE511A);

  static Color primarySoft = Color(0xFFF9D396); 
  static Color primaryExtraSoft = const Color(0xFFEFF3FC);
  static Color secondary = const Color(0xFF1B1F24);
  static Color secondarySoft = const Color(0xFF9D9D9D);
  static Color secondaryExtraSoft = const Color(0xFFE9E9E9);
  static Color error = const Color(0xFFD00E0E);
  static Color success = const Color(0xFF16AE26);
  static const Color green =  Color(0xFF076110);

  static Color warning = const Color(0xFFEB8600);
  static Color secondaryColor = const Color(0xFFE0EC53);
  static const Color primaryColor = Color(0xFF0000000);//xFF003E47
  static Color whiteColor = const Color(0xFFFFFFFF);
  static Color blackColor = const Color(0xFF000000);
  static Color gradientColor = const Color(0xFF45A735);
  static Color backgroundColor = const Color(0xFFE5E5E5);
  static Color balanceTextColor = const Color(0xFF393939);
  static Color cardOrangeColor = const Color(0xFFFFCB66);
  static Color cardPinkColor = const Color(0xFFF6BDE9);
  static Color cardPestColor = const Color(0xFFACD9B3);
  static Color containerShedow = const Color(0xFF757575);
  static Color websiteTextColor = const Color(0xFF344968);
  static Color nevDefaultColor = const Color(0xFFAAAAAA);
  static Color blueColor = const Color(0xFF5680F9);
  static Color textFieldColor = const Color(0xFFF2F2F6);
  static Color otpFieldColor = const Color(0xFFF2F2F7);
  static Color redColor = const Color(0xFFFF0000);
  static Color phoneNumberColor = const Color(0xFF484848);
  static Color themeLightBackgroundColor = const Color(0xFFFAFAFA);
  static Color themeDarkBackgroundColor = const Color(0xFF343636);
  static Color greyColor = const Color(0xFFEEEEEE);
  static Color tealShade300 = const Color(0xFF9D9D9D);
  static Color greyShade200 = const Color(0xFFEEEEEE);

  //other info
  //#6a6e81
  static Color genderDefaultColor = const Color(0xFFe3f3fd);
  static Color hintColor = const Color(0xFF8E8E93);
  static Color textFieldBorderColor = const Color(0xFFD1D1D6);

//shimmer Color

  /// qr code scanner screen
  static Color containerColor = const Color(0xFFD1D1D6);
  MyWidget() {
    int colorHex = int.parse("92BCEA", radix: 16);
    color = Color(colorHex);
  }

  Color? color;
}
