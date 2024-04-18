import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/Components/menuCard.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


class PaginaMenuClient extends StatelessWidget {
  const PaginaMenuClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Plat> platos = [
      Plat(
        idPlat: 'm1',
        imageUrl: 'images/menuinfantil.png',
        nombrePlato: 'Menú Infantil ',
        descripcion: 'Pizza Margarita',
        ingredientes: ['Tomate', 'Queso', 'Piña'],
        precio: 10,
      ),
      Plat(
        idPlat: 'm2',
        imageUrl: 'images/menuinfantil.png',
        nombrePlato: 'Menú adult ',
        descripcion: ' ',
        ingredientes: [
          'Inclou:\n1 Beguda(Begudes amb alcohol no incloses)\n1Entrant(Secció entrants)\n1Primer Plat(Secció Primers plats)\n1 Segon Plat'
        ],
        precio: 10,
      ),
      Plat(
        idPlat: 'm3',
        imageUrl: 'images/menuinfantil.png',
        nombrePlato: 'Menú de nit ',
        descripcion: 'Menú de nit',
        ingredientes: ['Tomate', 'Queso', 'Piña'],
        precio: 10,
      ),
      Plat(
        idPlat: 'm4',
        imageUrl: 'images/menuinfantil.png',
        nombrePlato: 'Menú degustació',
        descripcion: 'Menú degustació',
        ingredientes: ['Tomate', 'Queso', 'Piña'],
        precio: 10,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menús'),
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
          return MenuCard(
            plato: plato,
            onAdd: () {
              Provider.of<ModelDades>(context, listen: false)
                  .agregarAlCarrito(plato);
               final snackBar = SnackBar(
                backgroundColor: Color.fromARGB(100,92, 174, 99),
                elevation: 10,
                behavior: SnackBarBehavior.fixed,
                content: AwesomeSnackbarContent(
                  color: Color.fromARGB(1000,92, 174, 99),
                  title: '¡Éxito!',
                  message: '${plato.nombrePlato} añadido al carrito',
                  contentType: ContentType.success,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            },
          );
        },
      ),
    );
  }
}
