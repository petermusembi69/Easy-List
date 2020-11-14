import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageurl;
  final String imagePath;
  final bool isFavorite;
  final String userEmail;
  final String userId;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageurl,
    @required this.imagePath,
    @required this.userEmail,
    @required this.userId,
    this.isFavorite = false,
  });


}
