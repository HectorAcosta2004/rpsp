import 'package:flutter/material.dart';

/// Un widget que no muestra nada. Reemplaza la funcionalidad del banner de anuncios.
class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({
    super.key,
    this.isLarge = false,
  });

  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    // Devuelve un widget vacío que no ocupa espacio.
    return const SizedBox.shrink();
  }
}

/// Un widget que no muestra nada. Reemplaza la funcionalidad del anuncio nativo.
class NativeAdWidget extends StatelessWidget {
  final bool isSmallSize;
  final bool hasBorderAndLabel;

  const NativeAdWidget({
    super.key,
    this.isSmallSize = false,
    this.hasBorderAndLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    // Devuelve un widget vacío que no ocupa espacio.
    return const SizedBox.shrink();
  }
}