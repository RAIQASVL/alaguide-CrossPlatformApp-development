import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomMarker extends StatelessWidget {
  final String svgAsset;
  final VoidCallback onTap;

  const CustomMarker({
    Key? key,
    required this.svgAsset,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        svgAsset,
        width: 70,
        height: 100,
      ),
    );
  }
}
