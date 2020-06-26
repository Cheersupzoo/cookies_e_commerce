import 'dart:async';

import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:cookies_e_commerce/screens/screens.dart';
import 'package:cookies_e_commerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cookies_e_commerce/blocs/cookies/cookies.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Products",
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
      )),
      body: HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  HomeScreenBody({Key key}) : super(key: key);

  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    final cookiesBloc = BlocProvider.of<CookiesBloc>(context);

    return BlocBuilder(
        bloc: cookiesBloc,
        builder: (BuildContext context, CookiesState cookiesState) {
          if (cookiesState is CookiesLoading) {
            return LoadingIndicator(key: Key('__CookiesLoading'));
          } else if (cookiesState is CookiesLoaded) {
            List<CookieModel> cookies = cookiesState.cookies.cookies;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildHeaderText(),
                  _buildCookieCardWarpList(context, cookies),
                ],
              ),
            );
          } else if (cookiesState is CookiesNotLoaded) {
            return Center(child: Text(cookiesState.errorMessage));
          }
        });
  }

  Container _buildCookieCardWarpList(BuildContext context, List<CookieModel> cookies) {
    return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceEvenly,
                      children: cookies
                          .map((cookie) => CookieCard(cookie: cookie))
                          .toList()),
                );
  }

  Padding _buildHeaderText() {
    return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    'Start picking your treats',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87),
                  ),
                );
  }
}
