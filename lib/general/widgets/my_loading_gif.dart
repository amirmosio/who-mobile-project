import 'package:flutter/material.dart';

class MyLoadingGifWidget extends StatefulWidget {
  const MyLoadingGifWidget({super.key});

  @override
  State<MyLoadingGifWidget> createState() => _MyLoadingGifWidgetState();
}

class _MyLoadingGifWidgetState extends State<MyLoadingGifWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/gifs/loading_animation.gif",
      width: 200,
      height: 100,
    );
  }
}
