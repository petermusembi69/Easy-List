import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../widgets/form_inputs/image.dart';
import '../widgets/ui_elements/indicator.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'imageurl': null
  };
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    // String googleMapsApiKey = 'AIzaSyBipM_xtzdZw5L_G5Rd4NWKUkGexMoxV-o';
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _getTitle(product),
              _getDescription(product),
              _getPrice(product),
              // Image.network('https://maps.googleapis.com/maps/api/staticmap?center=37.0902%2C-95.7192&zoom=4&size=600x400&AIzaSyBipM_xtzdZw5L_G5Rd4NWKUkGexMoxV-o'),
              SizedBox(
                height: 10.0,
              ),
              ImageInput(_setImage, product),
              SizedBox(
                height: 10.0,
              ),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent =
          _buildPageContent(context, model.selectedProduct);
      return model.selectedProductIndex == -1
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Edit product'),
              ),
              body: pageContent,
            );
    });
  }

  Widget _getTitle(Product product) {
    if (product == null && _titleController.text.trim() == '') {
      _titleController.text = '';
    } else if (product != null && _titleController.text.trim() == '') {
      _titleController.text = product.title;
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Product Title',
      ),
      // initialValue: product == null ? "" : product.title,
      controller: _titleController,
      validator: (String value) {
        return value.isEmpty ? 'Please fill field' : null;
      },
    );
  }

  Widget _getDescription(Product product) {
    if (product == null && _descriptionController.text.trim() == '') {
      _descriptionController.text = '';
    } else if (product != null && _descriptionController.text.trim() == '') {
      _descriptionController.text = product.description;
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Product Description',
      ),
      // initialValue: product == null ? "" : product.description,
      controller: _descriptionController,
      validator: (String value) {
        return value.isEmpty || value.length < 10
            ? 'Input a longer description'
            : null;
      },
      maxLines: 4,
    );
  }

  Widget _getPrice(Product product) {
    if (product == null && _priceController.text.trim() == '') {
      _priceController.text = '';
    } else if (product != null && _priceController.text.trim() == '') {
      _priceController.text = product.price.toString();
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Product Price',
      ),
      // initialValue: product == null ? "" : product.price.toString(),
      controller: _priceController,
      validator: (String value) {
        return !(RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) ||
                value.isEmpty
            ? 'Invalid Price'
            : null;
      },
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['price'] =
            double.parse(value.replaceFirst(RegExp(r','), '.'));
      },
    );
  }

  void _buildSubmitButton(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate() ||
        (_formData['imageurl'] == null && selectedProductIndex == -1)) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(
        _titleController.text,
        _descriptionController.text,
        _formData['imageurl'],
        double.parse(_priceController.text),
      ).then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Something went wrong'),
                content: Text('Please try again'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
        }
      });
    } else {
      updateProduct(
        _titleController.text,
        _descriptionController.text,
        _formData['imageurl'],
        double.parse(_priceController.text),
      ).then((_) {
        Navigator.pushReplacementNamed(context, '/products').then((_) {
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            model.fetchProducts();
            setSelectedProduct(null);
            return;
          });
        });
      });
    }
  }

  void _setImage(File image) {
    _formData['imageurl'] = image;
  }

  Widget _submitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(
                child: Indicator(),
              )
            : RaisedButton(
                child: Text('Save'),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                onPressed: () => _buildSubmitButton(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductIndex));
      },
    );
  }
}
