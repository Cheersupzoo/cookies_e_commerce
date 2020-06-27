import 'package:cookies_e_commerce/models/cookie.dart';
import 'package:cookies_e_commerce/providers/networks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;


// Create a MockClient using the Mock class provided by the Mockito package.
class MockClient extends Mock implements http.Client {}


main() {
  group('fetchCookieList', () {
    test('returns a CookieList if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get('https://ecommerce-product-app.herokuapp.com/products'))
          .thenAnswer((_) async => http.Response(mockCookies, 200));

      expect(await CookieNetworkHandle(client: client).fetchCookie(), isA<CookieList>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get('https://ecommerce-product-app.herokuapp.com/products'))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(CookieNetworkHandle(client: client).fetchCookie(), throwsException);
    });

  });
}

// Mock data
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
