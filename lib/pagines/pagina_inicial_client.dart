import 'package:flutter/material.dart';
import 'package:dish_dash/Components/platoCard.dart';

class PaginaInicialClient extends StatelessWidget {
  const PaginaInicialClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(    
      appBar: AppBar(
        title: Text('PANTALLA "PRINCIPAL"'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 6, // numplats
        itemBuilder: (context, index) {
          String imageName = 'plato${index + 1}.png'; 
          return PlatoCard(
            imageUrl: 'assets/images/$imageName',
            nombrePlato: 'Nombre del plato $index',
            descripcion: 'Descripción del plato $index',
          );
        },
      ),
    );
  }
}
