import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/firebase_options.dart';
import 'package:dish_dash/pagina_login.dart';
import 'package:dish_dash/pagines/administrador/adminDashboard.dart';
import 'package:dish_dash/pagines/administrador/administrar_Menu.dart';
import 'package:dish_dash/pagines/administrador/pagina_administrador.dart';
import 'package:dish_dash/pagines/landing/landingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> main() async {

WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(

    ChangeNotifierProvider(
      create: (context) => ModelDades(),
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurafacil',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.green,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: (AdminDashboardPage()),
    );
  }
}