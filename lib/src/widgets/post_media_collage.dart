import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/post_media_image.dart';

class PostMediaCollage extends StatelessWidget {
  const PostMediaCollage({super.key, required this.postMedia});

  final BuiltList<MediaUrlV2> postMedia;

  @override
  Widget build(BuildContext context) {
    return PostMediaImage(postMedia: postMedia.first);
  }
}
