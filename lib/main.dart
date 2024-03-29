import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/pagina_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {


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
