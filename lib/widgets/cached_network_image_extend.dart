import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookies_e_commerce/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageExtend extends StatelessWidget {
  final String url;
  final double height;
  final int id;
  const CachedNetworkImageExtend(
      {Key key, this.url, this.height = 120, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fitHeight,
      width: double.infinity,
      height: height,
      fadeInDuration: Duration(milliseconds: 800),
      fadeOutDuration: Duration(milliseconds: 400),
      imageBuilder:
          (BuildContext context, ImageProvider<dynamic> imageProvider) {
        return Stack(children: <Widget>[
          Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                painter: _CircularShadow(height),
              )),
          Align(
            alignment: Alignment.center,
            child: Image(
              height: height,
              fit: BoxFit.fitHeight,
              image: imageProvider,
            ),
          )
        ]);
      },
      placeholder: (context, url) => LoadingIndicator(),
      errorWidget: (context, url, error) {
        return Image(
            fit: BoxFit.contain,
            image: AssetImage('assets/image-not-found.png'),
            width: 30);
      },
    );
  }
}

class _CircularShadow extends CustomPainter {
  final double height;

  _CircularShadow(this.height);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(
        size.width / 2, size.height / 2 - 25 * (height - 120) / 100);
    Offset center = Offset(0.0, 0.0);
    Path oval = Path()
      ..addOval(Rect.fromCenter(
          center: center, width: 110 * height / 120, height: 5 * height / 120));
    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(oval, shadowPaint);
  }

  @override
  bool shouldRepaint(_CircularShadow oldDelegate) {
    return false;
  }
}
