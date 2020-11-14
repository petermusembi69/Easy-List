import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:map_view/map_view.dart';
import 'scoped-models/main.dart';
import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './models/product.dart';
import './shared/adaptive_themedata.dart';
import './widgets/helpers/custom_route.dart';
import './pages/profileedit.dart';
import './pages/SelectMode.dart';
import './pages/profile.dart';

void main() {
  // debugPaintBaselinesEnabled = true;
  // debugPaintSizeEnabled = true;
  // debugPaintPointersEnabled = true;
  // MapView.setApiKey("AIzaSyBipM_xtzdZw5L_G5Rd4NWKUkGexMoxV-o");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    print('autologout');
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EasyList',
        //debugShowMaterialGrid: true,
        theme: getAdaptiveThemeData(context),
        //home: AuthPage(),
        routes: {
          '/profilepage': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProfilePage(),
          '/profile': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProfileEditPage(),
          '/admin': (BuildContext context) => ProductsAdminPage(_model),
          '/selectmode': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : SelectModePage(),
          '/': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          // '/verification': (BuildContext context) => !_isAuthenticated ? AuthPage() : Verification(),
          // '/profile':  (BuildContext context) => !_isAuthenticated ? AuthPage() : Profile(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          print(pathElements);
 
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return CustomRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductPage(product),
            );
          }
          return MaterialPageRoute(builder: (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsPage(_model));
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          );
        },
      ),
    );
  }
}
