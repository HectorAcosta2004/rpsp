import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:news_pro/core/components/components.dart';

/// Un widget wrapper que solía manejar los permisos de App Tracking Transparency de iOS.
/// Se ha modificado para que simplemente devuelva el widget hijo, ya que la aplicación
/// ya no utiliza servicios de publicidad que requieran este seguimiento.
class IOSTrackingPermissionWrapper extends StatefulWidget {
  /// El widget hijo a mostrar.
  final Widget child;

  /// Custom widget para explicar por qué se necesita el seguimiento (ahora no se usa).
  final Widget? explainerDialog;

  /// Si solicitar el permiso al mostrar (ahora siempre falso).
  final bool requestOnDisplay;

  /// Callback disparado después de la solicitud (ahora siempre retorna 'notSupported').
  final Function(TrackingStatus status)? onPermissionComplete;

  const IOSTrackingPermissionWrapper({
    super.key,
    required this.child,
    this.explainerDialog,
    this.requestOnDisplay = false, // Lo establecemos en falso por defecto
    this.onPermissionComplete,
  });

  @override
  IOSTrackingPermissionWrapperState createState() =>
      IOSTrackingPermissionWrapperState();
}

class IOSTrackingPermissionWrapperState
    extends State<IOSTrackingPermissionWrapper> {
  bool _permissionHandled = false;

  @override
  void initState() {
    super.initState();
    // Ya que no usamos ads, simplemente marcamos el permiso como manejado.
    if (widget.requestOnDisplay) {
      _handleTrackingPermission();
    } else {
      _permissionHandled = true;
    }
  }

  Future<void> _handleTrackingPermission() async {
    // Si no hay anuncios, simplemente marcamos el permiso como manejado
    // y llamamos al callback con 'no soportado' ya que la funcionalidad no es necesaria.
    setState(() => _permissionHandled = true);
    widget.onPermissionComplete?.call(TrackingStatus.notSupported);
  }

  /// Manually request tracking permission (simplificado)
  Future<TrackingStatus> requestTracking() async {
    widget.onPermissionComplete?.call(TrackingStatus.notSupported);
    return TrackingStatus.notSupported;
  }

  @override
  Widget build(BuildContext context) {
    // Ya que requestOnDisplay es falso, siempre mostrará el child directamente.
    // Si _permissionHandled es falso y requestOnDisplay es true (lo cual es poco probable
    // con la nueva lógica), se mantendrá la pantalla de carga.
    if (!_permissionHandled && widget.requestOnDisplay) {
      return Scaffold(
        body: Center(
          child: AppLoader(),
        ),
      );
    }

    // De lo contrario, muestra el widget hijo.
    return widget.child;
  }
}

// Eliminamos la clase 'DefaultTrackingExplainerDialog' ya que no hay anuncios
// que justificar y el código principal de la plantilla no la usa por defecto.
