import 'package:flutter/material.dart';

String _appTheme="lightCode";
LightCodeColors get appTheme=>ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
class ThemeHelper{
  Map<String, LightCodeColors>_supportedCustomColor={
    'lightCode': LightCodeColors()
  };
  Map<String, ColorScheme> _supportedColorScheme={
    'lightCode': ColorSchemes.lightCodeColorScheme
  };
  void changeTheme(String _newTheme){
    _appTheme=_newTheme;
  }
  LightCodeColors _getThemeColors(){
    return _supportedCustomColor[_appTheme]?? LightCodeColors();

  }
  ThemeData _getThemeData(){
    var colorScheme=_supportedColorScheme
    [_appTheme]?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: Colors.grey,
      outlinedButtonTheme: OutlinedButtonThemeData(

          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,

            side: BorderSide(
              color: Colors.grey,
              width: 1,
            ),


           visualDensity:  VisualDensity(
             vertical: -4,
             horizontal: -4,
           ),
            padding: EdgeInsets.zero

          )      ),
    );
  }
  LightCodeColors themeColor()=>_getThemeColors();
  ThemeData themeData()=>_getThemeData();
}


class AppColors{
  static Color primaryColor=Colors.black;
}
class TextThemes{
  static TextTheme textTheme(ColorScheme colorScheme)=>
      TextTheme(
        bodyLarge: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
          fontFamily: 'Figtree',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
          fontFamily: 'Figtree',
          fontWeight: FontWeight.w500

        )
      );
}


class ColorSchemes{
  static final lightCodeColorScheme=ColorScheme.light();

}
class LightCodeColors{
  Color get gray800=>Color(0xFF383838);
  Color get gray900=>Color(0xFF1E1E1E);
  Color get gray90001=>Color(0xFF262626);
  Color get whiteA700=>Color(0xFFFFFFFF);
  Color get yellow700=>Color(0xFFF7B52C);
  Color get gray60001=>Color(0xFF716F6F);
  Color get gray80001=>Color(0xFF383838);
  Color get black900=>Color(0xFF000000);
  Color get blueGray900=>Color(0xFF383838);
  Color get gray90003=>Color(0xFF1E1E1E);

}
class CustomTextStyles{
  static get bodySmall_1=>theme.textTheme.bodySmall!;
  static get bodyMediumGray60001=>theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.gray60001,
  );
}
class CustomButtonStyles{
  static BoxDecoration get gradientErrorContainerToPrimaryDecoration=>
      BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment(0.07,0),
          end: Alignment(1.0,1),
          colors: [theme.colorScheme.errorContainer,theme.colorScheme.primary],

        )
      );
  static ButtonStyle get none =>ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    elevation: MaterialStateProperty.all<double>(0),
  );
}

