import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/default_network_image_fetch_strategy.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';

class MediaWidget extends StatelessWidget {
  const MediaWidget({super.key, required this.media});

  final MediaUrlV2 media;

  @override
  Widget build(BuildContext context) {
    return Image(
        image: NetworkImageWithRetry(
          media.processed ? media.processedUrl! : media.originalUrl,
          fetchStrategy: defaultNetworkImageFetchStrategy,
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          if (!media.processed) {
            return const Center(
              child: Icon(Icons.image),
            );
          }
          return Container(
            color: HexColor.fromHex(
              media.dominantColorHex!,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image),
          );
        });
  }
}
