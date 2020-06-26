import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:cookies_e_commerce/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final CookieModel cookie;

  const DetailPage({Key key, this.cookie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                Container(
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CachedNetworkImageExtend(
                        url: cookie.image,
                        height: 220,
                      ),
                    )),
                SizedBox(height: 50),
                Text(
                  cookie.title,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8),
                Text(
                  cookie.price.toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Colors.redAccent[700]),
                ),
                SizedBox(height: 8),
                Text(
                  cookie.content,
                  style: TextStyle(fontSize: 16,height: 1.4),
                ),
                SizedBox(height: 16),
              ]),
        ),
      ),
    );
  }
}
