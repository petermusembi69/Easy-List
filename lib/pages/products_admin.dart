import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'product_edit.dart';
import 'product_list.dart';
import '../widgets/ui_elements/logout_list_tile.dart';
import '../scoped-models/main.dart';

class ProductsAdminPage extends StatefulWidget {
  final MainModel model;

  ProductsAdminPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductsAdminPageState();
  }
}

class _ProductsAdminPageState extends State<ProductsAdminPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
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
                            border: Border.all(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        // Text('${widget.model.userInfor[0].email}'),
                        OutlineButton(
                          borderSide:
                              BorderSide(width: 2.0, color: Theme.of(context).primaryColor),
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
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  leading: Icon(Icons.shop),
                  title: Text('All products'),
                ),
                Divider(),
                LogOutListTile(),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('Product Management'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.create),
                  text: 'Create Product',
                ),
                Tab(
                  icon: Icon(Icons.list),
                  text: 'My Product',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ProductEditPage(),
              ProductListPage(model),
            ],
          ),
        ),
      );
    });
  }
}
