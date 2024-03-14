import 'package:dish_dash/pagines/begudes/cocktails.dart';
import 'package:dish_dash/pagines/begudes/pagina_refrescs.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Components/platoCard.dart';

class PaginaBegudes extends StatelessWidget {
  const PaginaBegudes({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Plat> platos = [
      Plat(
        imageUrl: 'images/cocktail.png',
        nombrePlato: 'Cocktail ',
        descripcion: 'Conte Sucre i Alcohol',
        ingredientes: ['Alcohol', 'Refresc', 'Sucre'],
        precio: 10,
      ),
      Plat(
        imageUrl: 'images/depsi.png',
        nombrePlato: 'Depsi Chino',
        descripcion: '',
        ingredientes: ['Sucres'],
        precio: 10,
      ),
      Plat(
        imageUrl: 'images/cocacola.png',
        nombrePlato: 'CocaCola ',
        descripcion: '',
        ingredientes: ['Sucres'],
        precio: 10,
      ),
      Plat(
        imageUrl: 'images/nestea.png',
        nombrePlato: 'Nestea ',
        descripcion: '',
        ingredientes: ['Sucres'],
        precio: 10,
      ),
      Plat(
        imageUrl: 'images/cocktail5.png',
        nombrePlato: 'Tropical',
        descripcion: 'Conte Sucre i Alcohol',
        ingredientes: ['Alcohol', 'Refresc', 'Sucre'],
        precio: 10,
      ),
      Plat(
        imageUrl: 'images/nestea.png',
        nombrePlato: 'Nestea ',
        descripcion: '',
        ingredientes: ['Sucres'],
        precio: 10,
      ),
      Plat(
        imageUrl: 'images/cocktail2.png',
        nombrePlato: 'Tropical Elegance ',
        descripcion: 'Conte Sucre i Alcohol',
        ingredientes: ['Alcohol', 'Refresc', 'Sucre'],
        precio: 10,
      ),
      Plat(
        imageUrl: 'images/depsi.png',
        nombrePlato: 'Depsi Chino',
        descripcion: '',
        ingredientes: ['Sucres'],
        precio: 10,
      ),
      Plat(
        imageUrl: 'images/cocktail4.png',
        nombrePlato: 'Fruit Explosion ',
        descripcion: 'Conte Sucre i Alcohol',
        ingredientes: ['Alcohol', 'Refresc', 'Sucre'],
        precio: 10,
      ),
      Plat(
        imageUrl: 'images/cocacola.png',
        nombrePlato: 'CocaCola ',
        descripcion: '',
        ingredientes: ['Sucres'],
        precio: 10,
      ),
      Plat(
        imageUrl: 'images/cocktail3.png',
        nombrePlato: 'Somni Vermell',
        descripcion: 'Conte Sucre i Alcohol',
        ingredientes: ['Alcohol', 'Refresc', 'Sucre'],
        precio: 10,
      )
    ];

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
                child:
                    Text('Cocktails ', style: TextStyle(color: Colors.white)),
              ),
            ),
            // añadir mas aqui
          ],
        ),
        actions: <Widget>[],
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: platos.length,
          itemBuilder: (context, index) {
            final plato = platos[index];
            return PlatoCard(
              imageUrl: plato.imageUrl,
              nombrePlato: plato.nombrePlato,
              descripcion: plato.descripcion,
              ingredientes: plato.ingredientes,
              precio: plato.precio,
            );
          }),
    );
  }
}
