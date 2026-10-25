import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(

  scaffoldBackgroundColor: Color(0xffF6F7F9),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Color(0xff15B86C)),
      foregroundColor: WidgetStateProperty.all(Color(0xffFFFCFC)),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.black),
    )
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xffF6F7F9),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Color(0xff161F1B),
    ),
    iconTheme: IconThemeData(color: Color(0xff161F1B)),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color(0xff15B86C);
      }
      return Colors.white;
    }),
    thumbColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color(0xffFFFCFC);
      }
      return Color(0xff9E9E9E);
    }),

    trackOutlineColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.transparent;
      }
      return Color(0xff9E9E9E);
    }),
    trackOutlineWidth: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return 0;
      }
      return 2;
    }),
  ),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color(0xffFFFCFC);
      }
      return Colors.transparent;
    }),
    fillColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color(0xff15B86C);
      }
      return Colors.transparent;
    }),
    side: BorderSide(color: Color(0xffD1DAD6), width: 2),
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Colors.white,
    selectionHandleColor:Colors.white,
    cursorColor: Colors.black),
  colorScheme: ColorScheme.light(

    primaryContainer: Color(0xffFFFFFF),
    secondary: Color(0xff161F1B)
  ),
  
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Color(0xff161F1B),
    ),
    headlineSmall: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff3A4640),
                    ),
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: Color(0xff161F1B),
    ),
    displayMedium: TextStyle(
      color: Color(0xff161F1B),
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      color: Color(0xff161F1B),
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(0xff161F1B),
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xff3A4640),
    ),
    titleLarge: TextStyle(
      color: Color(0xff6A6A6A),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
      decorationColor: Color(0xff6A6A6A),
    ),
  
    labelSmall: TextStyle(color: Colors.black, fontSize: 16),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(16),
    ),
    filled: true,
    fillColor: Color(0xffffffff),

    hintStyle: TextStyle(
      color: Color(0xff9E9E9E),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),

    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 0.5),
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  iconTheme: IconThemeData(
    color: Color(0xff161F1B)
  ),


 listTileTheme: ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(0xff161F1B),
    ),
    
  ),


  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Color(0xffF6F7F9),
    unselectedItemColor: Color(0xff3A4640),
    selectedItemColor: Color(0xff14A662),
  ),

  splashFactory: NoSplash.splashFactory,

  popupMenuTheme: PopupMenuThemeData(
    color: Color(0xffF6F7F9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16)
    ),
    elevation: 10,
    shadowColor: Color(0xff15B86C),
    labelTextStyle:WidgetStateProperty.all( TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    )),
  ),
  
);
