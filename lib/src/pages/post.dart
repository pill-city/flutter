import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(postId),
        ),
        body: Text("post"),
      ),
    );
  }
}