import 'package:dish_dash/pagines/landing/landingpage.dart';
import 'package:flutter/material.dart';



class EliminarPlatMenu extends StatelessWidget {
  final String titulo;

  const EliminarPlatMenu({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar: $titulo'),  // Muestra el título
        backgroundColor: Colors.deepOrangeAccent,        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LandingPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: const Center(),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.deepOrangeAccent,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Support: support@restaurafacil.com | Phone: ',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}