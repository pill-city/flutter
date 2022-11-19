import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';

class MediaWidget extends StatelessWidget {
  const MediaWidget({super.key, required this.media});

  final MediaUrlV2 media;

  @override
  Widget build(BuildContext context) {
    return Image.network(
        media.processed ? media.processedUrl! : media.originalUrl,
        loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }
      if (!media.processed) {
        return const Icon(Icons.image);
      }
      return AspectRatio(
        aspectRatio: media.width!.toDouble() / media.height!.toDouble(),
        child: Container(
          color: HexColor.fromHex(
            media.dominantColorHex!,
          ),
        ),
      );
    }, errorBuilder: (context, error, stackTrace) {
      if (!media.processed) {
        return const Icon(Icons.broken_image);
      }
      return AspectRatio(
        aspectRatio: media.width!.toDouble() / media.height!.toDouble(),
        child: const Icon(Icons.broken_image),
      );
    });
  }
}
