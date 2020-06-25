import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:cookies_e_commerce/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class CookieCard extends StatelessWidget {
  final CookieModel cookie;

  const CookieCard({Key key, this.cookie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(cookie.image);
    return Card(
      elevation: 0.5,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: Container(
        width: 180,
        height: 250,
        child: Column(children: <Widget>[
          Container(
            color: Colors.white,
            height: 160,
            child: Stack(children: <Widget>[
              Center(
                child: CachedNetworkImageExtend(url: cookie.image),
              ),
              cookie.isNewProduct
                  ? Positioned(
                      top: 15,
                      right: 15,
                      child: Text(
                        "NEW",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.redAccent[700]),
                      ))
                  : SizedBox()
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cookie.title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cookie.price.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class CachedNetworkImageExtend extends StatelessWidget {
  final String url;
  const CachedNetworkImageExtend({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fitHeight,
      width: double.infinity,
      height: 120,
      fadeInDuration: Duration(milliseconds: 800),
      fadeOutDuration: Duration(milliseconds: 400),
      imageBuilder:
          (BuildContext context, ImageProvider<dynamic> imageProvider) {
        return Stack(children: <Widget>[
          Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                painter: CircularShadow(),
              )),
          Align(alignment: Alignment.center,
                      child: Image(
              height: 120,
              fit: BoxFit.fitHeight,
              image: imageProvider,
            ),
          )
        ]);
      },
      placeholder: (context, url) => LoadingIndicator(),
      errorWidget: (context, url, error) {
        print('errWid $error');
        return Image(
          image: AssetImage('assets/image-not-found.png'),
          width: 30,
        );
      },
    );
  }
}

class CircularShadow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    Offset center = Offset(0.0, 0.0);
    // draw shadow first
    Path oval = Path()
      ..addOval(Rect.fromCenter(center: center, width: 100, height: 5));
    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(oval, shadowPaint);
  }

  @override
  bool shouldRepaint(CircularShadow oldDelegate) {
    return false;
  }
}
