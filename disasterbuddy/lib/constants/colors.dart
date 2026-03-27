import 'package:flutter/material.dart';

class MyColors {
  static Color primaryThemeColor = const Color.fromARGB(255, 43, 59, 44);
  static Color whiteColor = const Color(0xffFFFFFF);
  static Color lockRedColor = const Color(0xffEB5757);
  static Color blackColor = const Color(0xff000000);
  static Color borderColor = const Color(0xffCCCCCC);
  static Color greyColor = const Color.fromRGBO(134, 136, 137, 1);
  static Color lightGreyColor = const Color.fromARGB(255, 215, 216, 216);
  static Color greenColor = Colors.green;
  static Color blueColor = Colors.blue;
  static Color redColor = Colors.red;
  static Color transparent = Colors.transparent;
  static var tetxFieldIconsColor = Colors.black54;
  static var textFieldFillColor = Colors.grey[300];
  static var pinkColor = Colors.pink;
}

const kPrimaryColor = Color(0xff121b22);

const kSecondaryColor = Color(0xff8596a0);

const kAccentColor = Color(0xff00a884);

const kAppBarColor = Color(0xff1f2c34);

const kTextPrimaryColor = Colors.white;

const kPopupMenuColor = Color(0xff233239);

const kDividerColor = Color(0xff232d34);

const kPopupMenuIconColor = Color(0xffbbc0c3);

const kMyTextBubbleColor = Color(0xff005d4b);

const kCheckColor = Color(0xff7eafa5);

const kActiveCheckColor = Colors.blue;

const kTextLinkColor = Color(0xff56bde9);

const kIconSecondaryColor = Color(0xff627884);

const kDisabledTextColor = Color(0xff3c4a55);

const kThumbActiveColor = WidgetStatePropertyAll(Color(0xff00a682));

const kThumbInctiveColor = WidgetStatePropertyAll(Color(0xff82939d));

const kTrackActiveColor = WidgetStatePropertyAll(Color(0xff0d463f));

const kTrackInctiveColor = WidgetStatePropertyAll(Color(0xff334048));

const kTextBoxBorderColor = Color(0xff222e34);

const kCountryCodeTextStyle = TextStyle(
  color: kSecondaryColor,
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);

const kTitleTextStyle = TextStyle(
  color: kTextPrimaryColor,
  fontSize: 17.5,
);

const kSubTitleTextStyle = TextStyle(
  color: kSecondaryColor,
  fontSize: 15.0,
);

const kTimeTextStyle = TextStyle(
  color: kSecondaryColor,
  fontSize: 12.5,
);

const kInfoTextStyle = TextStyle(
  color: kSecondaryColor,
  fontSize: 14.5,
  height: 1.5,
);

const kRedColor = Color(0xfff05c6c);

const kInfoTextStyle2 = TextStyle(
  color: Colors.white,
  fontSize: 15.5,
);

final kThemeData = ThemeData(
  scaffoldBackgroundColor: kPrimaryColor,
  iconTheme: const IconThemeData(color: kSecondaryColor),
  appBarTheme: const AppBarTheme(
    backgroundColor: kAppBarColor,
    iconTheme: IconThemeData(
      color: kSecondaryColor,
      size: 22.0,
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: kAccentColor.withOpacity(0.5),
    selectionHandleColor: kAccentColor,
  ),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  splashFactory: NoSplash.splashFactory,
  unselectedWidgetColor: const Color(0xff3c4a55),
  listTileTheme: const ListTileThemeData(iconColor: kSecondaryColor),
  tabBarTheme: const TabBarThemeData(
    labelStyle: TextStyle(fontSize: 16.5),
    unselectedLabelStyle: TextStyle(fontSize: 16.5),
    labelColor: kAccentColor,
    unselectedLabelColor: kSecondaryColor,
    indicatorColor: kAccentColor,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 2.5, color: kAccentColor),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kAccentColor,
  ),
  switchTheme: const SwitchThemeData(
    thumbColor: kThumbActiveColor,
    trackColor: kTrackInctiveColor,
  ),
);
