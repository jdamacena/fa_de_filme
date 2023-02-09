import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PosterImage extends StatelessWidget {
  final Function()? onTap;

  final String imageUrl;

  const PosterImage({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double imgHeight = 208.0;

    return GestureDetector(
      onTap: onTap,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: imgHeight,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.image),
            height: imgHeight,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
