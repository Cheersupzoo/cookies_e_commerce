import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'cookie.g.dart';


@immutable
@JsonSerializable()

class CookieModel extends Equatable {
  final int id;
  final String title;
  final String image;
  final String content;
  final bool isNewProduct;
  final double price;

  CookieModel(
      {this.id,
      this.title,
      this.image,
      this.content,
      this.isNewProduct,
      this.price});

  CookieModel copyWith({
    int id,
    String title,
    String image,
    String content,
    bool isNewProduct,
    double price,
  }) {
    return CookieModel(
        id: id ?? this.id,
        title: title ?? this.title,
        image: image ?? this.image,
        content: content ?? this.content,
        isNewProduct: isNewProduct ?? this.isNewProduct,
        price: price ?? this.price);
  }

  @override
  String toString() {
    return 'Cookie { id: $id, title: $title, image: $image, content: $id, isNewProduct: $id, price: $id }';
  }

  @override
  List<Object> get props => [id, title, image, content, isNewProduct, price];

  factory CookieModel.fromJson(Map<String, dynamic> json) =>
      _$CookieModelFromJson(json);

  Map<String, dynamic> toJson() => _$CookieModelToJson(this);
}

@JsonSerializable()
class CookieList extends Equatable {
  final List<CookieModel> cookies;

  CookieList(this.cookies);

  @override
  List<Object> get props => [cookies];

  factory CookieList.fromJson(Map<String, dynamic> json) =>
      _$CookieListFromJson(json);

  Map<String, dynamic> toJson() => _$CookieListToJson(this);
}