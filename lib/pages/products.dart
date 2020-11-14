import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products.dart';
import '../widgets/ui_elements/logout_list_tile.dart';
import '../scoped-models/main.dart';
import '../pages/profile.dart';

class ProductsPage extends StatefulWidget {
  final MainModel modell;

  ProductsPage(this.modell);
  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    widget.modell.fetchProducts();
    super.initState();
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        drawer: Drawer(
            child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Column(children: <Widget>[
                    Container(
                      height: 80.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/food.jpg'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(40),
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    // Text('${widget.model.userInfor[0].email}'),
                    OutlineButton(
                      borderSide: BorderSide(
                          width: 2.0, color: Theme.of(context).primaryColor),
                      child: Text('Profile'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ]),
                ),
              ]),
            ),
            (model.getTradeMode == "Seller")
                ? ListTile(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/admin')
                          .then((_) => model.selectProduct(null));
                    },
                    leading: Icon(Icons.toll),
                    title: Text('Manage products'),
                  )
                : Divider(),
            LogOutListTile(),
          ],
        )),
        appBar: AppBar(
          elevation: 0.0,
          title: Text('EasyList'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () {
                model.toggleDisplayMode();
                model.displayProducts;
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          child: Products(),
          onRefresh: () async {
            await model.fetchProducts();
          },
        ),
      );
    });
  }
}
