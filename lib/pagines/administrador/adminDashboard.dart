import 'package:flutter/material.dart';
import 'package:dish_dash/pagines/administrador/pagina_Estadistiques.dart';
import 'package:dish_dash/pagines/administrador/pagina_administrador.dart';

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaginaAdministrador()),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                child: Center(
                  child: Text(
                    'Añadir platos',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaginaEstadisticasAdministrador()),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                child: Center(
                  child: Text(
                    'Estadisticas',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
