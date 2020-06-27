// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:cookies_e_commerce/blocs/blocs.dart';
import 'package:cookies_e_commerce/keys.dart';
import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:cookies_e_commerce/providers/networks.dart';
import 'package:cookies_e_commerce/screens/DetailScreen.dart';
import 'package:cookies_e_commerce/screens/screens.dart';
import 'package:cookies_e_commerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cookies_e_commerce/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:bloc_test/bloc_test.dart';

class MockCookiesBloc extends MockBloc<CookiesEvent, CookiesState>
    implements CookiesBloc {}

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  group('basicWidget', () {
    testWidgets('HomeScreen with no network', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(CookieShopApp());

      expect(find.text('Products'), findsOneWidget);

      await tester.pumpAndSettle();
      // get 404 network
      expect(find.text("Something Went Wrong.\nPlease try to refresh again."),
          findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

    });

    testWidgets('DetailScreen with Dummy isNewProduct: true',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      final dummyCookie = CookieModel(
          id: 1,
          title: 'test Cookie',
          image: '',
          content: 'lorem',
          isNewProduct: true,
          price: 20.214);
      await tester.pumpWidget(Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: Color(0xFFE30909),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: GoogleFonts.montserratTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: DetailScreen(
              cookie: dummyCookie,
            ),
          );
        },
      ));

      // Verify that our counter starts at 0.
      expect(find.text(dummyCookie.title), findsOneWidget);
      expect(find.text(dummyCookie.content), findsOneWidget);
      expect(find.text('\$ ${dummyCookie.price.toStringAsFixed(2)}'),
          findsOneWidget);
      expect(find.text('NEW'), findsOneWidget);
    });

    testWidgets('DetailScreen with Dummy isNewProduct: false',
        (WidgetTester tester) async {
      final dummyCookie = CookieModel(
          id: 1,
          title: 'test Cookie',
          image: '',
          content: 'lorem',
          isNewProduct: false,
          price: 20.214);
      await tester.pumpWidget(MaterialApp(
        home: DetailScreen(
          cookie: dummyCookie,
        ),
      ));

      // Verify that our counter starts at 0.
      expect(find.text(dummyCookie.title), findsOneWidget);
      expect(find.text(dummyCookie.content), findsOneWidget);
      expect(find.text('\$ ${dummyCookie.price.toStringAsFixed(2)}'),
          findsOneWidget);
      expect(find.text('NEW'), findsNothing);
    });
  });

  group('CookieBloc', () {
    CookiesBloc cookiesBloc;

    setUp(() {
      cookiesBloc = MockCookiesBloc();
    });
    testWidgets('should show Error when state is CookiesNotLoaded',
        (WidgetTester tester) async {
      when(cookiesBloc.state).thenAnswer(
        (_) => CookiesNotLoaded(
            "Something Went Wrong.\nPlease try to refresh again."),
      );
      // Build our app and trigger a frame.
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<CookiesBloc>.value(value: cookiesBloc),
        ],
        child: MaterialApp(
          title: 'Cookie E-commerce',
          home: HomeScreen(title: 'Cookie E-commerce'),
        ),
      ));

      // Show AppBar
      expect(find.text('Products'), findsOneWidget);

      await tester.pumpAndSettle();
      // get error message
      expect(find.text("Something Went Wrong.\nPlease try to refresh again."),
          findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should show Loading indicator when state is CookiesLoading',
        (WidgetTester tester) async {
      when(cookiesBloc.state).thenAnswer(
        (_) => CookiesLoading(),
      );
      // Build our app and trigger a frame.
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<CookiesBloc>.value(value: cookiesBloc),
        ],
        child: MaterialApp(
          title: 'Cookie E-commerce',
          home: HomeScreen(title: 'Cookie E-commerce'),
        ),
      ));

      // Show AppBar
      expect(find.text('Products'), findsOneWidget);

      // Check loading indicator
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(ArchKeys.loading), findsOneWidget);
    });

    testWidgets('should show Cookie Card when state is CookiesLoaded',
        (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(1080, 2160));
      var parseCookies = CookieList.fromJson(await jsonDecode(mockCookies));
      when(cookiesBloc.state).thenAnswer(
        (_) => CookiesLoaded(parseCookies),
      );
      // Build our app and trigger a frame.
      await tester.pumpWidget(Builder(
        builder: (BuildContext context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<CookiesBloc>.value(value: cookiesBloc),
            ],
            child: MaterialApp(
              theme: ThemeData(
                primaryColor: Color(0xFFE30909),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                textTheme: GoogleFonts.montserratTextTheme(
                  Theme.of(context).textTheme,
                ),
              ),
              title: 'Cookie E-commerce',
              home: HomeScreen(title: 'Cookie E-commerce'),
            ),
          );
        },
      ));

      // Show AppBar
      expect(find.text('Products'), findsOneWidget);

      // Check Cookie List
      await tester.pump(Duration(seconds: 1));
      expect(find.text(parseCookies.cookies[0].title), findsWidgets);
      expect(find.text("NEW"), findsWidgets);
    });

    testWidgets('should show Blank Cookie List when state is CookiesLoadedWithEmptyList',
        (WidgetTester tester) async {
      when(cookiesBloc.state).thenAnswer(
        (_) => CookiesLoadedWithEmptyList(),
      );
      // Build our app and trigger a frame.
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<CookiesBloc>.value(value: cookiesBloc),
        ],
        child: MaterialApp(
          title: 'Cookie E-commerce',
          home: HomeScreen(title: 'Cookie E-commerce'),
        ),
      ));

      // Show AppBar
      expect(find.text('Products'), findsOneWidget);

      // Check Error message
      await tester.pump(Duration(seconds: 1));
      expect(find.text("No cookies to show."), findsOneWidget);
    });
  });
}

var mockCookies = """[
  {
    "id": 1,
    "title": "Signature Chocolate Chip Lactation Cookies",
    "image": "https://firebasestorage.googleapis.com/v0/b/test-4c60c.appspot.com/o/cookie1%402x.png?alt=media&token=dadc7377-1b3b-439a-9948-8237ec944d07",
    "content": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    "isNewProduct": true,
    "price": 18.569
  },
  {
    "id": 2,
    "title": "Signature Chocolate Chip Lactation Cookies",
    "image": "https://firebasestorage.googleapis.com/v0/b/test-4c60c.appspot.com/o/cookie1%402x.png?alt=media&token=dadc7377-1b3b-439a-9948-8237ec944d07",
    "content": "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
    "isNewProduct": true,
    "price": 18.563
  },
  {
    "id": 3,
    "title": "Signature Chocolate Chip Lactation Cookies",
    "image": "https://firebasestorage.googleapis.com/v0/b/test-4c60c.appspot.com/o/cookie2%402x.png?alt=media&token=f8a2a013-8a6e-44b6-b66d-feb20bfc6a51",
    "content": "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of.",
    "isNewProduct": true,
    "price": 17.563
  },
  {
    "id": 4,
    "title": "Signature Chocolate Chip Lactation Cookies",
    "image": "https://firebasestorage.googleapis.com",
    "content": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    "isNewProduct": true,
    "price": 18.563
  },
  {
    "id": 5,
    "title": "Signature Chocolate Chip Lactation Cookies",
    "image": "https://firebasestorage.googleapis.com",
    "content": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    "isNewProduct": false,
    "price": 18.563
  },
  {
    "id": 6,
    "title": "Signature Chocolate Chip Lactation Cookies",
    "image": "https://firebasestorage.googleapis.com/v0/b/test-4c60c.appspot.com/o/cookie2%402x.png?alt=media&token=f8a2a013-8a6e-44b6-b66d-feb20bfc6a51",
    "content": "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
    "isNewProduct": false,
    "price": 18.563
  }
]""";
