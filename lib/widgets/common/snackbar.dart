import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'media_query_helper.dart';

class AppSnackbar {
  static void show(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: context.screenWidth * 0.035,
          ),
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }
}

class AppDialog {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
  }) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: GoogleFonts.lato(
            fontSize: context.screenWidth * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.lato(
            fontSize: context.screenWidth * 0.035,
          ),
        ),
        actions: [
          if (secondaryButtonText != null)
            CupertinoDialogAction(
              onPressed: onSecondaryPressed ?? () => Navigator.pop(context),
              child: Text(secondaryButtonText),
            ),
          CupertinoDialogAction(
            onPressed: onPrimaryPressed ?? () => Navigator.pop(context),
            isDefaultAction: true,
            child: Text(primaryButtonText ?? 'OK'),
          ),
        ],
      ),
    );
  }
}