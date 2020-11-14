import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter_courses/models/trader.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import 'package:mime/mime.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http_parser/http_parser.dart';

import '../models/database.dart';
import '../models/profile.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';

class ConnectedProductsModel extends Model {
  User _authenticatedUser;
  List<User> _userInfo = [];
  List<Product> _products = [];
  String _selProductId;
  bool _isloading = false;
}

class ProductModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex => _products.indexWhere((Product product) {
        return product.id == _selProductId;
      });
  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-flutter-courses-5e8eb.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addProduct(
      String title, String description, File imageurl, double price) async {
    _isloading = true;
    notifyListeners();
    final uploadData = await uploadImage(imageurl);

    if (uploadData == null) {
      print('Upload failed');
      return false;
    }
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      // 'imageurl':
      //     'https://www.jamescandy.com/media/catalog/product/cache/1/image/650x/040ec09b1e35df139433887a97daa66f/f/r/fralingers-chocolate-covered-paddle-pops.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'imagePath': uploadData['imagePath'],
      'imageurl': uploadData['imageUrl']
    };
    try {
      final http.Response response = await http.post(
          'https://flutter-courses-5e8eb.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isloading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
        id: responseData['name'],
        title: title,
        description: description,
        imageurl: uploadData['imageUrl'],
        imagePath: uploadData['imagePath'],
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id,
        isFavorite: productData['wishListUsers'] == null
            ? false
            : (productData['wishListUsers'] as Map<String, dynamic>)
                .containsKey(_authenticatedUser.id),
      );
      _products.add(newProduct);
      _isloading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isloading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct() {
    _isloading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();

    return http
        .delete(
            'https://flutter-courses-5e8eb.firebaseio.com/products/${deletedProductId}.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isloading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isloading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> updateProduct(
      String title, String description, File image, double price) async {
    _isloading = true;
    notifyListeners();
    String imageurl = selectedProduct.imageurl;
    String imagePath = selectedProduct.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);
      if (uploadData == null) {
        print('Update failed');
        return false;
      }
      imageurl = uploadData['imageurl'];
      imagePath = uploadData['imagePath'];
    }

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'imageurl': imageurl,
      'imagePath': imagePath,
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId,
      'isFavorite': selectedProduct.isFavorite
    };
    try {
      await http
          .get(
              'https://flutter-courses-5e8eb.firebaseio.com/products/${selectedProduct.id}/wishListUsers.json?auth=${_authenticatedUser.token}')
          .then<bool>((http.Response response) async {
        final Map<String, dynamic> wishListData = json.decode(response.body);
        print(updateData);
        print(wishListData);
        await http
            .put(
                'https://flutter-courses-5e8eb.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
                body: json.encode(updateData))
            .then<Null>((http.Response response) async {
          if (wishListData == null) {
            notifyListeners();
            return;
          } else {
            await http.put(
                'https://flutter-courses-5e8eb.firebaseio.com/products/${selectedProduct.id}/wishListUsers.json?auth=${_authenticatedUser.token}',
                body: json.encode(wishListData));
          }
          ;
        });
        _isloading = false;
        notifyListeners();
        final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          imageurl: imageurl,
          imagePath: imagePath,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: selectedProduct.isFavorite,
        );
        _products[selectedProductIndex] = updatedProduct;
        notifyListeners();
        return true;
      });
      return true;
    } catch (e) {
      _isloading = false;
      notifyListeners();
      return false;
    }
  }

  void toggleProductFavouriteStatus() async {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        imageurl: selectedProduct.imageurl,
        imagePath: selectedProduct.imagePath,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://flutter-courses-5e8eb.firebaseio.com/products/${selectedProduct.id}/wishListUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://flutter-courses-5e8eb.firebaseio.com/products/${selectedProduct.id}/wishListUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          imageurl: selectedProduct.imageurl,
          imagePath: selectedProduct.imagePath,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: newFavoriteStatus);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
    _selProductId = null;
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchProducts(
      {onlyForUser = false, clearExisting = false}) {
    _isloading = true;
    if (clearExisting) {
      _products = [];
    }
    notifyListeners();
    return http
        .get(
            'https://flutter-courses-5e8eb.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>(
      (http.Response response) {
        final List<Product> fetchedProductList = [];
        final Map<String, dynamic> productListData = json.decode(response.body);
        if (productListData == null) {
          _isloading = false;
          notifyListeners();
          return;
        }
        productListData.forEach(
          (String productId, dynamic productData) {
            final Product product = Product(
                id: productId ?? '',
                description: productData['description'] ?? '',
                imageurl: productData['imageurl'] ?? '',
                imagePath: productData['imagePath'] ?? '',
                price: productData['price'],
                title: productData['title'] ?? '',
                userEmail: productData['userEmail'] ?? '',
                userId: productData['userId'],
                isFavorite: productData['wishListUsers'] == null
                    ? false
                    : (productData['wishListUsers'] as Map<String, dynamic>)
                        .containsKey(_authenticatedUser.id));
            fetchedProductList.add(product);
          },
        );
        _products = onlyForUser
            ? fetchedProductList.where((Product product) {
                return product.userId == _authenticatedUser.id;
              }).toList()
            : fetchedProductList;
        _isloading = false;
        notifyListeners();
        _selProductId = null;
      },
    ).catchError((error) {
      _isloading = false;
      notifyListeners();
      return;
    });
  }
}

class UserModel extends ConnectedProductsModel {
  Timer _authTimer;
  TraderMode _traderMode;

  PublishSubject<bool> _userSubject = PublishSubject();

  String get getTradeMode {
    if (_traderMode == TraderMode.Seller) {
      return "Seller";
    }
    return "Buyer";
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  User get user {
    return _authenticatedUser;
  }

  List<User> get userInfor {
    return List.from(_userInfo);
  }

  Future<String> get getuserEmail async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userEmail = prefs.getString('userEmail');
    return userEmail.toString();
  }

  void setTradeMode(TraderMode newTraderMode) {
    _traderMode = newTraderMode;
  }

  // Future<Profile> getProfile(String email) async {
  //   await ProfileDatabase().getUserUsingEmail(email).then((results) {
  //     print(results.email);
  //     return results;
  //   });
  // }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isloading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDLC8EziKqfHQZO5LrKulgUEHXgm1ASA34',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDLC8EziKqfHQZO5LrKulgUEHXgm1ASA34',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
        id: responseData['localId'],
        email: responseData['email'],
        token: responseData['idToken'],
      );
      _userInfo.add(_authenticatedUser);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final now = DateTime.now();
      final DateTime expiryTime = now.add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('UserEmail', responseData['email']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = "Email already exist";
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email is not found';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid';
    }
    _isloading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners;
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logOut() async {
    print("LogOut");
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    _selProductId = null;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
    pref.remove('userEmail');
    pref.remove('userId');
    pref.remove('phoneNumber');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), () {
      logOut();
    });
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isloading;
  }
}
