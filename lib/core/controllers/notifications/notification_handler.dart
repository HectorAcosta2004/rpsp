import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:news_pro/core/repositories/posts/post_repository.dart';
import 'package:news_pro/core/routes/app_routes.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../config/wp_config.dart';
import '../../logger/app_logger.dart';
import '../../models/notification_model.dart';

class NotificationHandler {
  /// Inicializa OneSignal y configura listeners
  static Future<void> init(BuildContext context, Ref ref) async {
    OneSignal.initialize(WPConfig.oneSignalId);

    // Notificaciones en primer plano
    OneSignal.Notifications.addForegroundWillDisplayListener(
        (OSNotificationWillDisplayEvent event) async {
      final notification =
          NotificationModel.fromOSnotification(event.notification);

      if (!(await isNotificationSaved(notification.postId))) {
        await saveNotification(notification);
      }

      await handleNotificationClick(notification, context, ref);

      event.notification.display();
    });

    // Notificaciones al abrir la app desde una notificación
    OneSignal.Notifications.addClickListener(
        (OSNotificationClickEvent result) async {
      final data = result.notification.additionalData;
      if (data != null) {
        final notification =
            NotificationModel.fromOSnotification(result.notification);

        if (!(await isNotificationSaved(notification.postId))) {
          await saveNotification(notification);
        }

        await handleNotificationClick(notification, context, ref);
      }
    });
  }

  /// Maneja el click en una notificación
  static Future<void> handleNotificationClick(
    NotificationModel notification,
    BuildContext context,
    Ref ref) async {
    if (notification.postId != 0) {
      // Obtener el PostRepository usando Riverpod
      final postRepo = ref.read(postRepoProvider);
      final post = await postRepo.getPost(postID: notification.postId);

      if (post != null) {
        Navigator.pushNamed(context, AppRoutes.post, arguments: post);
      } else {
        Navigator.pushNamed(context, AppRoutes.notification);
      }
    } else {
      Navigator.pushNamed(context, AppRoutes.notification);
    }
  }

  /// Guardar notificación en Hive
  static Future<void> saveNotification(NotificationModel notification) async {
    final box = Hive.box<NotificationModel>('notifications');
    await box.add(notification);
    Log.info('Notification saved: ${notification.id}');
  }

  /// Verifica si la notificación ya existe en Hive
  static Future<bool> isNotificationSaved(int notificationId) async {
    final box = Hive.box<NotificationModel>('notifications');
    return box.values.any((n) => n.postId == notificationId);
  }

  /// Obtener todas las notificaciones
  static Future<List<NotificationModel>> getNotifications() async {
    final box = Hive.box<NotificationModel>('notifications');
    return box.values.toList();
  }

  /// Eliminar una notificación
  static Future<void> deleteNotification(int notificationId) async {
    final box = Hive.box<NotificationModel>('notifications');
    final notifications = box.values;
    final notificationToDelete = notifications.firstWhere(
      (n) => n.postId == notificationId,
      orElse: () => throw Exception('Notification not found'),
    );
    await notificationToDelete.delete();
    Log.info('Notification deleted: $notificationId');
  }

  /// Limpiar todas las notificaciones
  static Future<void> clearAllNotifications() async {
    final box = Hive.box<NotificationModel>('notifications');
    await box.clear();
    Log.info('All notifications cleared');
  }

  /// Deshabilitar notificaciones
  static Future<void> disableNotifications() async {
    OneSignal.User.pushSubscription.optOut();
  }

  /// Habilitar notificaciones
  static Future<void> enableNotifications() async {
    OneSignal.User.pushSubscription.optIn();
  }
}
