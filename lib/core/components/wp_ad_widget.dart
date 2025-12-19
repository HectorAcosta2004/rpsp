import 'package:flutter/material.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({
    super.key,
    this.isLarge = false,
  });

  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

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
    return const SizedBox.shrink();
  }
}
