import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:cookies_e_commerce/screens/screens.dart';
import 'package:cookies_e_commerce/widgets/widgets.dart';
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
