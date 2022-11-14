import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';

class PostMediaWidget extends StatelessWidget {
  const PostMediaWidget({super.key, required this.postMedia});

  final MediaUrlV2 postMedia;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Image.network(
        postMedia.processed ? postMedia.processedUrl! : postMedia.originalUrl,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          if (!postMedia.processed) {
            return const Icon(Icons.image);
          } else {
            return Container(
                width: postMedia.width!.toDouble(),
                height: postMedia.height!.toDouble(),
                color: HexColor.fromHex(postMedia.dominantColorHex!));
          }
        },
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image),
      ),
    );
  }
}
