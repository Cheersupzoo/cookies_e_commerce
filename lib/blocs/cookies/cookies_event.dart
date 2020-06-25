part of 'cookies_bloc.dart';

@immutable
abstract class CookiesEvent extends Equatable {
  CookiesEvent([List props = const []]) : super();
}

class FetchCookies extends CookiesEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'FetchCookies';
}