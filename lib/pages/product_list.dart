import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    widget.model.fetchProducts(onlyForUser: true,clearExisting: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemCount: model.allProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(model.allProducts[index].title),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart ||
                  direction == DismissDirection.startToEnd) {
                model.selectProduct(model.allProducts[index].id);
                model.deleteProduct();
              }
              model.selectProduct(null);
            },
            movementDuration: Duration(seconds: 19),
            background: Container(
              color: Colors.red,
              child: ListTile(
                  trailing: Text('DELETING'),
                  leading: Text('DELETING'),
                  onTap: () {}
                  // color: Colors.red,
                  ),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(model.allProducts[index].imageurl),
                  ),
                  title: Text(model.allProducts[index].title),
                  subtitle: Text('${model.allProducts[index].price}'),
                  trailing: _iconButtons(context, index, model),
                ),
                Divider(),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _iconButtons(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.allProducts[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage();
            },
          ),
        ).then((_) {
          model.selectProduct(null);
        });
      },
    );
  }
}
