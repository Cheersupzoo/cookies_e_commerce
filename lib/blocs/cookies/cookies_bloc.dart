import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:cookies_e_commerce/providers/networks.dart';

part 'cookies_event.dart';
part 'cookies_state.dart';

class CookiesBloc extends Bloc<CookiesEvent, CookiesState> {
  @override
  CookiesState get initialState => CookiesLoading();

  @override
  Stream<CookiesState> mapEventToState(
    CookiesEvent event,
  ) async* {
    if (event is FetchCookies) {
      yield* _mapFetchCookiesToState();
    }
  }

  Stream<CookiesState> _mapFetchCookiesToState() async* {
    try {
      yield CookiesLoading();
      final cookies = await CookieNetworkHandle().fetchCookie();
      yield CookiesLoaded(cookies);
    } catch (error) {
      print(error);
      if(error == 404)
        yield CookiesNotLoaded("Network Error: Status $error");
      else yield CookiesNotLoaded("Something Went Wrong.\nPlease try to refresh again.");
    }
  }
}
