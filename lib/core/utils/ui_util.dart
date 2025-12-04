import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/app_defaults.dart';

class UiUtil {
  /// OPENS BOTTOM SHEET WITH THE GIVEN WIDGET
  static Future openBottomSheet({
    required BuildContext context,
    required Widget widget,
  }) async {
    return await showModalBottomSheet(
      context: context,
      builder: (ctx) => widget,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.bottomSheetRadius,
      ),
    );
  }

  /// Opens dialog with background blur enabled
  static Future<T?> openDialog<T>({
    required BuildContext context,
    required Widget widget,
    bool isDismissable = true,
    String? barrierLabel, // NUEVO: opcional
  }) async {
    final safeBarrierLabel =
        isDismissable ? (barrierLabel ?? 'close_dialog'.tr()) : null;

    return await showGeneralDialog<T?>(
      barrierDismissible: isDismissable,
      barrierLabel: safeBarrierLabel,
      context: context,
      pageBuilder: (ctx, anim1, anim2) => widget,
      transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
        scale: anim1,
        child: child,
      ),
    );
  }
}
