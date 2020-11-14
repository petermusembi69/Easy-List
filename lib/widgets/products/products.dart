import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import './product_card.dart';
import '../../scoped-models/main.dart';
import '../../models/product.dart';

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductList(context, model.displayProducts);
      },
    );
  }

  Widget _buildProductList(context, List<Product> products) {
    Widget productItem;
    if (products.length > 0) {
      productItem = GridView.builder(
        
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.1),
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products: products[index]),
      );
    } else {
      productItem = Container();
    }
    return productItem;
  }
}
