import 'package:flutter/material.dart';
import 'package:flutter_courses/pages/product.dart';
import 'package:scoped_model/scoped_model.dart';

import './price.dart';
import '../ui_elements/title_default.dart';
import '../../scoped-models/main.dart';
import '../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product products;

  ProductCard({this.products});

  Widget buildCard() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
          child: (model.displayProducts.length == 0)
              ? Container(child: Center(child: Text("No products available")))
              : (model.displayProducts.length == 0)
                  ? Container(
                      child: Center(child: Text("No products available")))
                  : GridTile(
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10),
                        child: Container(
                          // padding: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 3,
                              )
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 160,
                                child: Hero(
                                  tag: products.id,
                                  child: FadeInImage(
                                    image: NetworkImage(products.imageurl),
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage('assets/food.jpg'),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TitleDefault(products.title),
                                    SizedBox(width: 8.0),
                                    Price(price: products.price.toString()),
                                  ],
                                ),
                              ),
                              Text(products.userEmail),
                              Divider(
                                thickness: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.info),
                                    iconSize: 30.0,
                                    color: Theme.of(context).accentColor,
                                    onPressed: () {
                                      model.selectProduct(products.id);
                                    
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ProductPage(products),
                                          ));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      products.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    ),
                                    iconSize: 30.0,
                                    color: Colors.red,
                                    onPressed: () {
                                      model.selectProduct(products.id);
                                      model.toggleProductFavouriteStatus();
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
    });
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return buildCard();
    });
  }
}
