import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:cookies_e_commerce/screens/screens.dart';
import 'package:cookies_e_commerce/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:google_fonts/google_fonts.dart';

class OpenCookieContainer extends StatelessWidget {
  final CookieModel cookie;
  const OpenCookieContainer({Key key, this.cookie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionDuration: const Duration(milliseconds: 400),
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return DetailScreen(cookie: cookie);
      },
      tappable: false,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return CookieCard(openContainer: openContainer, cookie: cookie);
      },
    );
  }
}

class _CookieCardWrapper extends StatelessWidget {
  final CookieModel cookie;
  final VoidCallback openContainer;
  const _CookieCardWrapper({Key key, @required this.cookie, this.openContainer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CookieCard(
      cookie: cookie,
    );
  }
}

class CookieCard extends StatelessWidget {
  final CookieModel cookie;
  final VoidCallback openContainer;

  const CookieCard({Key key, @required this.cookie, this.openContainer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardHeight = 250.0;
    final cardWidth = 172.0;
    return Stack(children: <Widget>[
      InkWell(
        onTap: openContainer,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(
                  flex: 2,
                ),
                _buildCookieImage(),
                Spacer(
                  flex: 2,
                ),
                _buildCookieDetail(),
                Spacer(
                  flex: 1,
                ),
              ]),
        ),
      )
    ]);
  }

  Card _buildCardBackground(double cardWidth, double cardHeight) {
    return Card(
        elevation: 0.5,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
        ));
  }

  Padding _buildCookieDetail() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitleText(),
          const SizedBox(height: 8),
          _buildPriceText(),
        ],
      ),
    );
  }

  Text _buildPriceText() {
    return Text(
      '\$ ${cookie.price.toStringAsFixed(2)}',
      style: GoogleFonts.workSans(
          fontSize: 19, color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  Text _buildTitleText() {
    return Text(
      cookie.title,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    );
  }

  Container _buildCookieImage() {
    return Container(
      color: Colors.white,
      height: 138,
      child: Stack(children: <Widget>[
        Center(
          child: CachedNetworkImageExtend(
              url: cookie.image, height: 120, id: cookie.id),
        ),
        cookie.isNewProduct
            ? Positioned(
                top: 5,
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
    );
  }
}

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
                painter: CircularShadow(height),
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

class CircularShadow extends CustomPainter {
  final double height;

  CircularShadow(this.height);
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
  bool shouldRepaint(CircularShadow oldDelegate) {
    return false;
  }
}
