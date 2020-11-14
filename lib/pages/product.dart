import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/products/productFab.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(product.title),
        // ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 256,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title),
                background: Hero(
                  tag: product.id,
                  child: FadeInImage(
                    image: NetworkImage(product.imageurl),
                    fit: BoxFit.cover,
                    height: 300.0,
                    placeholder: AssetImage('assets/food.jpg'),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      product.title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(product.description),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Price ${product.price.toString()}'),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      product.userEmail,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        floatingActionButton: ProductFab(product),
      ),
    );
  }
}
