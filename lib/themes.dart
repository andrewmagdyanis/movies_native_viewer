import 'package:flutter/material.dart';
import 'colors_constants.dart';

class Themes {
  final Size size;
  final double aspectRatio;

  Themes({
    required this.size,
    required this.aspectRatio,
  });

  ThemeData themeDataProvider(String themeName) {
    double h = (size.height / aspectRatio) * 1.8;
    double w = (size.width / aspectRatio) * 1.5;
    double s = h * w / (3.3);

    bool darkFlag = false;
    Color color = kAccentColor;
    Brightness brightness = Brightness.light;

    if (themeName == 'dark') {
      darkFlag = true;
      color = Colors.white;
      brightness = Brightness.dark;
    }
    ThemeData themeData = ThemeData(
      brightness: brightness,
      cardColor: Colors.transparent,
      primaryColor: (darkFlag) ? ORANGE900 : kAccentColor,
      buttonBarTheme: const ButtonBarThemeData(
        mainAxisSize: MainAxisSize.max,
        buttonTextTheme: ButtonTextTheme.primary,
      ),
      indicatorColor: color,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      }),
      popupMenuTheme: PopupMenuThemeData(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 20,
        textStyle: TextStyle(
            fontSize: s * 0.00007, fontWeight: FontWeight.bold, color: color),
        //color: Colors.blueGrey,
      ),
      bottomAppBarTheme:
          const BottomAppBarTheme(color: Colors.transparent, elevation: 0.0),
      appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.transparent,

          // color: (darkFlag)?Colors.yellow.shade700:Colors.yellow.shade300,
          iconTheme: IconThemeData(color: color, size: s * 0.00009),
          actionsIconTheme: IconThemeData(color: color),
          toolbarTextStyle: TextTheme(
                  titleLarge: TextStyle(
                      fontSize: s * 0.00009,
                      fontWeight: FontWeight.bold,
                      color: color))
              .bodyMedium,
          titleTextStyle: TextTheme(
                  titleLarge: TextStyle(
                      fontSize: s * 0.00009,
                      fontWeight: FontWeight.bold,
                      color: color))
              .titleLarge //,size: 20),
          ),
      primaryIconTheme: IconThemeData(color: color),
      cardTheme: CardTheme(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          color: darkFlag ? Colors.grey[900] : Colors.grey[100],
          clipBehavior: Clip.hardEdge),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: (darkFlag) ? Colors.grey : Colors.blueGrey,
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        labelColor: color,
        indicator: BoxDecoration(
          border: Border(bottom: BorderSide(width: s * 0.000008, color: color)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      dialogTheme: DialogTheme(
        contentTextStyle:
            TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
        titleTextStyle:
            TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: color,
        unselectedItemColor: (darkFlag) ? Colors.grey : Colors.blueGrey,
        selectedLabelStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        selectedIconTheme: IconThemeData(
          size: 25,
          color: color,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 22,
          color: Colors.blueGrey,
        ),
      ),
      iconTheme: IconThemeData(
        size: 22,
        color: color,
      ),
      buttonTheme: ButtonThemeData(
          buttonColor: color,
          alignedDropdown: true,
          minWidth: 25,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: darkFlag ? Colors.black : WHITE,
          backgroundColor: color,
          hoverColor: Colors.greenAccent),
      textTheme: TextTheme(
        displayLarge:
            TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        displayMedium:
            TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
        displaySmall:
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        headlineMedium:
            TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        headlineSmall:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        titleLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
            color: color),
        titleMedium:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        titleSmall: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
            color: kPrimaryColor),
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: color),
        bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.normal, color: color),
        labelLarge: TextStyle(
            fontSize: 18, fontWeight: FontWeight.normal, color: color),
      ),
    );

    return themeData;
  }
}
