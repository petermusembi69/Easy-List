import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/product.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Product product;

  ImageInput(this.setImage, this.product);

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;
  Future _getImage(BuildContext context, ImageSource source) async{
    var image =  await ImagePicker.pickImage(source: source, maxWidth: 400.0, maxHeight: 300.0);
      setState(() {
          _imageFile = image;
          if (image == null) {
         
          }
      });

      widget.setImage(image);
      Navigator.pop(context);
      return true;
  }

  void _openImagePicker(BuildContext context) {
    // final buttonColor2 = Theme.of(context).accentColor;
    final buttonColor = Theme.of(context).primaryColor;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: buttonColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    (_getImage(context, ImageSource.camera));
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                FlatButton(
                  textColor: buttonColor,
                  child: Text('Use Gallary'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).primaryColor;
    Widget previewImage = Text('Please select an image');
    if (_imageFile != null) {
      previewImage = Image.file(
        _imageFile,
        fit: BoxFit.cover,
        height: 300.0,
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
      );
    } else if (widget.product != null) {
      previewImage = Image.network(
        widget.product.imageurl,
        fit: BoxFit.cover,
        height:300.0,
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
      );
    }

    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(width: 2.0, color: buttonColor),
          onPressed: () => _openImagePicker(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                color: buttonColor,
              ),
              SizedBox(width: 5.0),
              Text(
                'Add Image',
                style: TextStyle(color: buttonColor),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        previewImage,
      ],
    );
  }
}
