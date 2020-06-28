import 'package:cookies_e_commerce/keys.dart';
import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:cookies_e_commerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cookies_e_commerce/blocs/cookies/cookies.dart';
import 'package:frefresh/frefresh.dart';

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
        /* style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22), */
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
  FRefreshController _frefreshcontroller;

  @override
  void initState() {
    super.initState();
    _frefreshcontroller = FRefreshController();
  }

  @override
  void dispose() {
    super.dispose();
    _frefreshcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cookiesBloc = BlocProvider.of<CookiesBloc>(context);
    Widget widgetToShow;

    return BlocBuilder(
        bloc: cookiesBloc,
        builder: (BuildContext context, CookiesState cookiesState) {
          if (!(cookiesState is CookiesLoading))
            _frefreshcontroller.finishRefresh();
            
          if (cookiesState is CookiesLoading) {
            widgetToShow = widgetToShow ??
                _buildCookieLoading(context);
          } else if (cookiesState is CookiesLoaded) {
            final cookies = cookiesState.cookies.cookies;
            widgetToShow = _buildCookiesLoaded(context, cookies);
          } else if (cookiesState is CookiesLoadedWithEmptyList) {
            widgetToShow = _buildCookiesLoadedWithEmptyList(
                cookiesBloc, _frefreshcontroller);
          } else if (cookiesState is CookiesNotLoaded) {
            widgetToShow = _buildCookiesNotLoaded(cookiesState.errorMessage,
                cookiesBloc, context, _frefreshcontroller);
          }

          return _pullToRefresh(cookiesBloc, widgetToShow);
        });
  }

  FRefresh _pullToRefresh(CookiesBloc cookiesBloc, Widget widgetToShow) {
    return FRefresh(
          header: LoadingIndicator(
            key: ArchKeys.loading,
          ),
          controller: _frefreshcontroller,
          headerHeight: 60.0,
          headerTrigger: 120,
          onRefresh: () => cookiesBloc.add(FetchCookies()),
          child: widgetToShow,
        );
  }

  SizedBox _buildCookieLoading(BuildContext context) {
    return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: LoadingIndicator(
                  key: ArchKeys.loading,
                ),
              );
  }

  Widget _buildCookiesLoaded(BuildContext context, List<CookieModel> cookies) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeaderText(),
          _buildCookieCardWarpList(context, cookies),
        ],
      ),
    );
  }

  Widget _buildCookiesLoadedWithEmptyList(
      CookiesBloc cookiesBloc, FRefreshController refreshController) {
    return GestureDetector(
      onTap: () {
        cookiesBloc.add(FetchCookies());
        refreshController.refresh();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withAlpha(0),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.sentiment_dissatisfied,
              size: 48,
              color: Colors.grey[850],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "No cookies to show.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Tap screen to refresh.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildCookiesNotLoaded(String errorMessage, CookiesBloc cookiesBloc,
      BuildContext context, FRefreshController refreshController) {
    return GestureDetector(
      onTap: () {
        cookiesBloc.add(FetchCookies());
        refreshController.refresh();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withAlpha(0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.grey[850],
              ),
              Text(errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, height: 2)),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCookieCardWarpList(
      BuildContext context, List<CookieModel> cookies) {
    double width = MediaQuery.of(context).size.width;
    var widgetPerRow = (width ~/ 172);
    var countBlankSizedBox = widgetPerRow - cookies.length % widgetPerRow;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 8.0),
      child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceEvenly,
          runSpacing: 16.0,
          children: <Widget>[
            ...cookies
                .map((cookie) => OpenCookieContainer(cookie: cookie))
                .toList(),
            ...List<Widget>.generate(
                countBlankSizedBox,
                (index) => SizedBox(
                      width: 172,
                    ))
          ]),
    );
  }

  Padding _buildHeaderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Text(
        'Start picking your treats',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
      ),
    );
  }
}
