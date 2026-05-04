import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          error: AppColors.error,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: AppTextStyles.headingMedium,
        ),

        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputFill,
          hintStyle: AppTextStyles.hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.inputHorizontalPad,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppDimens.inputBorderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppDimens.inputBorderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppDimens.inputBorderRadius),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppDimens.inputBorderRadius),
            borderSide:
                const BorderSide(color: AppColors.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppDimens.inputBorderRadius),
            borderSide:
                const BorderSide(color: AppColors.error, width: 1.5),
          ),
          errorStyle: AppTextStyles.errorText,
        ),

        // Elevated button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textOnAccent,
            minimumSize: const Size(
                AppDimens.buttonMinWidth, AppDimens.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppDimens.buttonBorderRadius),
            ),
            elevation: 0,
            textStyle: AppTextStyles.buttonText,
          ),
        ),
      );
}