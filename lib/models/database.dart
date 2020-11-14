import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'dart:async';
import './profile.dart';

class ProfileDatabase {
  Database _db;

// import 'package:path/path.dart';
// import '../model/user.dart';

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await _open();
    return _open();
  }

  Future<Database> _open() async {
    //get a path int the phone directory system
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //opendatabase is a function that creates database then passes it to variable
    // theDb for it to be returned
    var theDb = await openDatabase(
      join(documentsDirectory.path, 'user_datbase143.db'),
      onCreate: (db, version) {
        return db.execute(
          """
      CREATE TABLE UserProfile
      (
        id INTEGER PRIMARY KEY,
        username TEXT,
        fullname TEXT,
        dateofbirth INTEGER,
        phonenumber INTEGER,
        email TEXT,
        status TEXT
      )
        """,
        );
      },
      version: 1,
    );
    return theDb;
  }

  // funtion insertUser used to insert data in the database
  Future<void> insertUser(Profile userProfile) async {
    final Database db = await database;

    await db.insert(
      'userProfile',
      userProfile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // function getUserInfo used to retrieve data from the database
  Future<List<Profile>> getUserInfo() async {
    final Database db = await database;

    List<Map<String, dynamic>> maps = await db.query('userProfile');

    return List.generate(maps.length, (i) {
      return Profile(
        id: maps[i]['id'],
        username: maps[i]['username'],
        fullname: maps[i]['fullName'],
        dateofbirth: maps[i]['dateofbirth'],
        phonenumber: maps[i]['phonenumber'],
        email: maps[i]['email'],
        status: maps[i]['status'],
      );
    });
  }

  void updateRecord(Profile profile) async {
    final Database db = await database;

    await db.rawUpdate(
        'UPDATE userProfile SET username = ?, fullName = ?,phoneNumber = ? WHERE email = ?',
        [
          profile.username,
          profile.fullname,
          profile.phonenumber,
          profile.email
        ]);
  }

  // Future<Profile> getUserUsingEmail(String Email) async {
  //   final Database db = await database;

  //   List<Map<String, dynamic>> maps = await db.query('userProfile',
  //       columns: null, where: 'email = ?', whereArgs: [Email]);
  //   if (maps.length > 0) {
  //     for (int i in maps.first.values) {
  //       print(maps);
  //       return Profile(
  //         // id: maps[i].values.,
  //         // username: maps[i]['username'],
  //         // fullname: maps[i]['fullName'],
  //         // dateofbirth: maps[i]['dateofbirth'],
  //         // phonenumber: maps[i]['phonenumber'],
  //         // email: maps[i]['email'],
  //         // status: maps[i]['status'],
  //       );
  //     }
  //   }
  //   return null;
  // }
}
