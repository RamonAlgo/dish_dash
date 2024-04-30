import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/Components/platoCard.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Refrescs extends StatelessWidget {
  const Refrescs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Refrescs'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('No hay refrescos disponibles en este momento.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
