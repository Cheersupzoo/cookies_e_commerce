import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cookies_e_commerce/blocs/cookies/cookies.dart';
import 'package:cookies_e_commerce/screens/HomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(CookieShopApp());
}

class CookieShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CookiesBloc>(
          create: (context) {
            return CookiesBloc()..add(FetchCookies());
          },
        ),
      ],
      child: MaterialApp(
        title: 'Cookie E-commerce',
        theme: ThemeData(
          primaryColor: Color(0xFFE30909),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: HomeScreen(title: 'Cookie E-commerce'),
      ),
    );
  }
}
