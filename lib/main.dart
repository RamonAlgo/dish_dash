import 'package:dish_dash/pagina_login.dart';
import 'package:dish_dash/pagines/carrito/rebut_client.dart';
import 'package:flutter/material.dart';

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
        
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: PaginaLogin(),
    );
  }
}
