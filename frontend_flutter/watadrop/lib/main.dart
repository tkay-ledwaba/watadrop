import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:watadrop/splash_screen.dart';
import 'common/style.dart';
import 'database/local_database_helper.dart';

void main() async {
  var devices = ["3ECB68428182FB9CD5CF1CBBBA6077E2", "9D3D19CEC5EAA5F0A7E088D30AD26520",
    "78C00043BDB6E1AEB9A4D1F26EEE852B", "20E7CB371CB24450A9CF874D4613E6EB"];
  WidgetsFlutterBinding.ensureInitialized();

  initDatabase();

  await MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: devices
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(const MyApp());
}

Future<void> initDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), db_name),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return  db.execute('CREATE TABLE '
          '$dbTable'
          '($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$colName TEXT, '
          '$colImage TEXT, '
          '$colQuantity INTEGER, '
          '$colPrice TEXT)'
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: db_version,
  );

  database.then((value) => print(value));


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorAccent,
      ),
      home: SplashScreen(),
    );
  }
}
