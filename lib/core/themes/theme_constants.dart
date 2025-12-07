// Archivo comentado: AppTheme (con explicaciones de dónde se usa cada color)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_pro/core/utils/extensions.dart';

import '../constants/app_colors.dart';
import '../constants/app_defaults.dart';

class AppTheme {
  /// Fuente global de la app
  static const fontName = 'Montserrat';

  /// ------------------------------
  ///        TEMA CLARO
  /// ------------------------------
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,

        // ColorScheme general: usa AppColors.primary como color base
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(
              255, 255, 255, 255), // 🌈 Color principal de toda la app
          primary:
              const Color(0xFF1b1464), // Usado en botones, highlights, etc.
          surface: const Color.fromARGB(
              255, 255, 255, 255), // Fondos de contenedores
        ),

        // 🎨 Color del texto
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: fontName,
              bodyColor: const Color(0xFF1b1464), // Texto principal morado
              displayColor: const Color(0xFF1b1464),
            ),

        // 🌕 Fondo principal del Scaffold
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),

        // 🎴 Color de tarjetas/contenedores
        cardColor: const Color.fromARGB(255, 255, 255, 255),
        canvasColor: const Color.fromARGB(255, 255, 255, 255),

        // ✏️ TextFields (inputs)
        inputDecorationTheme: InputDecorationTheme(
          // Espaciado interno
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
            vertical: AppDefaults.padding,
          ),

          // Borde sin seleccionar
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDefaults.borderRadius,
            borderSide: BorderSide.none,
          ),

          // Borde cuando se enfoca → usa el color principal
          focusedBorder: OutlineInputBorder(
            borderRadius: AppDefaults.borderRadius,
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 255, 255), // 🌈 Color morado
              width: 1.5,
            ),
          ),

          // Bordes de error
          errorBorder: OutlineInputBorder(
            borderRadius: AppDefaults.borderRadius,
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 253, 253, 253)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppDefaults.borderRadius,
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 255, 255, 255), width: 1.5),
          ),

          // Fondo del TextField
          fillColor:
              const Color.fromARGB(255, 255, 255, 255), // 🟦 Fondo gris claro
          filled: true,

          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle:
              const TextStyle(color: AppColors.placeholder), // 🟫 Placeholder
          hintStyle: const TextStyle(color: AppColors.placeholder),
          prefixIconColor: AppColors.placeholder,
        ),

        // 🧭 AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255), // Fondo claro
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1b1464)),
          titleTextStyle: TextStyle(
            color: Color(0xFF4C16A0),
            fontFamily: fontName,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          centerTitle: true,
          surfaceTintColor: Color(0xFF8D8AFF),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),

        // 🟪 Botón elevado (ElevatedButton)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1b1464), // 🌈 Botón morado
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDefaults.padding,
              vertical: 16,
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontFamily: fontName,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppDefaults.borderRadius,
            ),
          ),
        ),

        // 📦 Botón Outline
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1b1464), // Texto morado
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.all(AppDefaults.padding),
            shape: RoundedRectangleBorder(
              borderRadius: AppDefaults.borderRadius,
            ),
          ),
        ),

        // 📑 TabBar
        tabBarTheme: TabBarThemeData(
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              color: AppColors.primary, // Línea debajo del tab
              width: 2,
            ),
          ),
          dividerColor: AppColors.separator,
          labelPadding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
            vertical: AppDefaults.padding / 1.15,
          ),
          labelColor: const Color(0xFF1b1464), // Texto seleccionado
          unselectedLabelColor:
              AppColors.cardColorDark.withOpacityValue(0.5), // Texto gris
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontFamily: fontName,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontFamily: fontName),
        ),

        // 🔵 TextButton
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF1b1464),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // ☑ Checkbox
        checkboxTheme: CheckboxThemeData(
          side: const BorderSide(color: AppColors.placeholder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),

        // — Divider —
        dividerTheme: const DividerThemeData(
          color: Color.fromARGB(255, 255, 255, 255), // Morado del diseño
          thickness: 1,
        ),
      );

  /// ------------------------------
  ///        TEMA OSCURO
  /// ------------------------------
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEB5057),
          brightness: Brightness.dark,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: fontName,
              displayColor: const Color(0xFFEB5057), // Texto morado
              bodyColor: const Color(0xFFEB5057),
            ),
        cardColor: const Color(0xFF4C16A0),
        scaffoldBackgroundColor: const Color(0xFF4C16A0),
        canvasColor: AppColors.cardColorDark,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
            vertical: AppDefaults.padding,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDefaults.borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppDefaults.borderRadius,
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          fillColor: AppColors.cardColorDark,
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: const TextStyle(color: AppColors.placeholder),
          iconColor: AppColors.placeholder,
          hintStyle: const TextStyle(color: AppColors.placeholder),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
        listTileTheme: const ListTileThemeData(
          iconColor: AppColors.primary,
          textColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.scaffoldBackgrounDark,
          elevation: 0,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: fontName,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(AppDefaults.padding),
            shape: RoundedRectangleBorder(
              borderRadius: AppDefaults.borderRadius,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.all(AppDefaults.padding),
            shape: RoundedRectangleBorder(
              borderRadius: AppDefaults.borderRadius,
            ),
          ),
        ),
        tabBarTheme: TabBarThemeData(
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          labelPadding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
            vertical: AppDefaults.padding / 1.15,
          ),
          labelColor: AppColors.primary,
          unselectedLabelColor:
              AppColors.cardColor.withOpacityValue(0.5), // Texto apagado
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontFamily: fontName,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontFamily: fontName),
          dividerColor: AppColors.cardColorDark,
        ),
        checkboxTheme: const CheckboxThemeData(
          side: BorderSide(color: Colors.white70),
        ),
        dividerTheme: const DividerThemeData(color: Colors.white10),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: fontName,
            ),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: AppColors.cardColorDark),
      );
}
