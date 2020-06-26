import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:cookies_e_commerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  final CookieModel cookie;
  /* final AnimationController fade */

  const DetailPage({Key key, this.cookie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: Stack(children: <Widget>[
        _buildCardBackground(context),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildCookieImage(context),
                  _buildTitleText(),
                  SizedBox(height: 8),
                  _buildPriceText(),
                  SizedBox(height: 8),
                  _buildContentText(),
                  SizedBox(height: 16),
                ]),
          ),
        ),
      ]),
    );
  }

  Hero _buildCardBackground(BuildContext context) {
    return Hero(
        tag: 'card${cookie.id}',
        child: Card(
            elevation: 0.5,
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            )),
      );
  }

  Container _buildCookieImage(BuildContext context) {
    return Container(
                  height: 320,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: 320,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CachedNetworkImageExtend(
                                url: cookie.image,
                                height: 220,
                                id: cookie.id),
                          )),
                      cookie.isNewProduct
                          ? Positioned(
                              top: 35,
                              right: 30,
                              child: _buildNEWText())
                          : SizedBox()
                    ],
                  ),
                );
  }

  Text _buildNEWText() {
    return Text(
                                "NEW",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.redAccent[700]),
                              );
  }

  Text _buildContentText() {
    return Text(
                  cookie.content,
                  style: TextStyle(fontSize: 16, height: 1.4),
                );
  }

  Text _buildPriceText() {
    return Text(
                  '\$ ${cookie.price.toStringAsFixed(2)}',
                  style: GoogleFonts.workSans(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent[700]),
                );
  }

  Text _buildTitleText() {
    return Text(
                  cookie.title,
                  style: TextStyle(fontSize: 24),
                );
  }
}
