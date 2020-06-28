import 'package:cookies_e_commerce/keys.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:16.0),
      child: Center(
        child: LoadingJumpingLine.square(
          key: ArchKeys.loading,
          borderColor: Colors.brown[700],
          backgroundColor: Colors.brown[700],
          size: 35.0,
        ),
      ),
    );
  }
}

class ImageLoadingIndicator extends StatelessWidget {
  ImageLoadingIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingFilling.square(
        key: ArchKeys.loading,
        borderColor: Colors.brown[600],
        fillingColor: Colors.brown[300],
        size: 30.0,
        borderSize: 3.0,
      ),
    );
  }
}
