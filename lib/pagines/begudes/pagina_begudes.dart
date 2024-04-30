import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/pagines/begudes/cocktails.dart';
import 'package:dish_dash/pagines/begudes/pagina_refrescs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class PaginaBegudes extends StatelessWidget {
  const PaginaBegudes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Refrescs()));
                },
                child: Text('Refrescs ', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cocktails()));
                },
                child: Text('Cocktails ', style: TextStyle(color: Colors.white)),
              ),
            ),
            // añadir mas aquí si es necesario
          ],
        ),
      ),
      body: Center(
        child: Text('Seleccione una categoría de bebidas desde el menú superior.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
