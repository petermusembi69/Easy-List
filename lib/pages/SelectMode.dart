import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/trader.dart';
import '../scoped-models/main.dart';

class SelectModePage extends StatefulWidget {
  @override
  _SelectModePageState createState() => _SelectModePageState();
}

class _SelectModePageState extends State<SelectModePage> {
  TraderMode _traderMode = TraderMode.Buyer;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        body: Container(
          color: Colors.black87,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                  ),
                ),
                padding: EdgeInsets.only(left: 45, right: 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _traderMode = TraderMode.Buyer;
                          model.setTradeMode(_traderMode);
                        });
                        print('buyer');
                        // TraderMode.Buyer;
                        Navigator.pushReplacementNamed(context, '/profile');
                      },
                      child: Container(
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 5.0,
                          ),
                        ),
                        child: Image.asset('assets/buy.png'),
                        padding: EdgeInsets.all(15.0),
                      ),
                    ),
                    SizedBox(height: 9),
                    Text(
                      'Become A Buyer',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _traderMode = TraderMode.Seller;
                          model.setTradeMode(_traderMode);
                        });
                        print('seller');
                        // TraderMode.Seller;
                        Navigator.pushReplacementNamed(context, '/profile');
                      },
                      child: Container(
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            style: BorderStyle.solid,
                            width: 5.0,
                          ),
                        ),
                        child: Image.asset('assets/seller.png'),
                        padding: EdgeInsets.all(15.0),
                      ),
                    ),
                    SizedBox(height: 9),
                    Text(
                      'Become A Seller',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
