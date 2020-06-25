// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CookieModel _$CookieModelFromJson(Map<String, dynamic> json) {
  return CookieModel(
    id: json['id'] as int,
    title: json['title'] as String,
    image: json['image'] as String,
    content: json['content'] as String,
    isNewProduct: json['isNewProduct'] as bool,
    price: (json['price'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$CookieModelToJson(CookieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'content': instance.content,
      'isNewProduct': instance.isNewProduct,
      'price': instance.price,
    };
