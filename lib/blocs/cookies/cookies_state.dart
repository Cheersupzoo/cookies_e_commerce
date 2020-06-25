part of 'cookies_bloc.dart';

@immutable
abstract class CookiesState extends Equatable {
  CookiesState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class CookiesLoading extends CookiesState {
  @override
  String toString() => 'CookieLoading';
}

class CookiesLoaded extends CookiesState {
  final CookieList cookies;

  CookiesLoaded(this.cookies);


  @override
  String toString() => 'CookiesLoaded';
}

class CookiesNotLoaded extends CookiesState {
  final String errorMessage;

  CookiesNotLoaded(this.errorMessage);

  @override
  String toString() => 'CookiesNotLoaded';
}