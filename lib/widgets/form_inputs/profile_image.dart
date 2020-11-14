import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import '../../models/product.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;

  final imageKey; 
  ImageInput(this.setImage, this.imageKey);

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;
  final imageKey = GlobalKey<_ImageInputState>();
  Future _getImage(BuildContext context, ImageSource source) async {
    var image = await ImagePicker.pickImage(
        source: source, maxWidth: 400.0, maxHeight: 300.0);
    setState(() {
      _imageFile = image;
      if (image == null) {}
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
    Widget previewImage = Container(
      
      decoration: BoxDecoration(
        color: (_imageFile != null) ? null : Colors.grey,
        shape: BoxShape.rectangle,
        // borderRadius: BorderRadius.circular(30),
      ),
      child: GestureDetector(

        onTap: () {
          _openImagePicker(context);
        },
        child: (_imageFile != null)
            ? Image.file(
                _imageFile,
                key: imageKey,
                height: 150.0,
                width: 150,
              )
            : Icon(Icons.add_a_photo),
      ),
      padding: EdgeInsets.all(15),
      height: 150.0,
      
      width: 150,
    );
    // if (_imageFile != null) {
    //   previewImage = Container(
    //       decoration: BoxDecoration(
    //         shape: BoxShape.circle,
    //       ),
    //       height: 150.0,
    //       width: 150,
    //       child: Image.file(
    //         _imageFile,
    //         height: 150.0,
    //         width: 150,
    //       ));
    // }

    return Column(
      children: <Widget>[
        previewImage,
      ],
    );
  }
}
