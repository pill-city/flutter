import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';

ImageProvider<Object>? getMediaUrlV2Image(MediaUrlV2? media) {
  if (media == null) {
    return const AssetImage("assets/image.webp");
  }
  if (!media.processed) {
    return NetworkImage(media.originalUrl);
  }
  return NetworkImage(media.processedUrl!);
}
