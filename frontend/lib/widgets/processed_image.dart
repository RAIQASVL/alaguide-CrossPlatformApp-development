import 'package:flutter/material.dart';

class ProcessedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double opacity;
  final bool isNetwork;
  final BoxFit fit;
  final bool isCircular;

  const ProcessedImage({
    Key? key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.opacity = 1.0,
    this.isNetwork = true,
    this.fit = BoxFit.cover,
    this.isCircular = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (isNetwork) {
      image = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return CircularProgressIndicator();
          }
        },
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      );
    } else {
      image = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
      );
    }

    if (isCircular) {
      image = ClipOval(child: image);
    } else {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: image,
      );
    }

    return Opacity(
      opacity: opacity,
      child: image,
    );
  }
}
