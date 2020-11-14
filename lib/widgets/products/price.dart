import 'package:flutter/material.dart';

class Price extends StatelessWidget {
final String price;

Price({this.price});
  @override
  Widget build(BuildContext context, ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 2.5,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        '\Ksh12$price',
        style: TextStyle(fontSize: 15.0, color: Colors.white),
      ),
    );
  }
}
