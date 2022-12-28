import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';

class MediaWidget extends StatelessWidget {
  const MediaWidget({super.key, required this.media, required this.fit});

  final MediaUrlV2 media;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
        media.processed ? media.processedUrl! : media.originalUrl,
        fit: fit, loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      } else {
        return Container(
          color: media.processed
              ? Colors.grey
              : HexColor.fromHex(media.dominantColorHex!),
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      }
    }, errorBuilder: (context, error, stackTrace) {
      return const Center(
        child: Icon(Icons.broken_image),
      );
    });
  }
}
