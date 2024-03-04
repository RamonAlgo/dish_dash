import 'package:dish_dash/pagines/pagina_menu_client.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/pagines/pagina_inicial_client.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DishDash',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white, 
        appBarTheme: AppBarTheme(
          color: Colors.green, 
          foregroundColor: Colors.white, 
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.green, 
            onPrimary: Colors.white, 
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: PaginaMenuClient(), 
    );
  }
}

