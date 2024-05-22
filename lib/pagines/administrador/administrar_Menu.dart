import 'package:dish_dash/pagines/administrador/administrar_Menu/agregar.dart';
import 'package:dish_dash/pagines/administrador/administrar_Menu/eliminar.dart';
import 'package:dish_dash/pagines/landing/landingpage.dart';
import 'package:flutter/material.dart';



class AdministrarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador de menu'),
        backgroundColor: Color(0xFF005086),
        actions: [
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DashboardButtonMenu(
                  title: 'Menús',
                  icon: Icons.restaurant_menu,
                ),
                SizedBox(width: 20),
                DashboardButtonMenu(
                  title: 'Begudes',
                  icon: Icons.restaurant_menu,
                ),
                SizedBox(width: 20),
                DashboardButtonMenu(
                  title: 'Entrants',
                  icon: Icons.restaurant_menu,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DashboardButtonMenu(
                  title: 'Primers Plats',
                  icon: Icons.restaurant_menu,
                ),
                SizedBox(width: 20),
                DashboardButtonMenu(
                  title: 'Postres',
                  icon: Icons.restaurant_menu,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFF005086),
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


void MostrarBotones(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white.withOpacity(0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 300),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Algo",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class DashboardButtonMenu extends StatelessWidget {
  final String title;
  final IconData icon;

  const DashboardButtonMenu({
    required this.title,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => mostrarBotones(context, title),
        child: Container(
          width: 200,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

void mostrarBotones(BuildContext context, String titulo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white.withOpacity(0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,  
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF005086)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SmallDashboardButton(
                      title: 'Agregar',
                      icon: Icons.add,
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgregarPlatMenu(titulo: titulo),
                          ),
                        );
                      },
                    ),
                    SmallDashboardButton(
                      title: 'Eliminar',
                      icon: Icons.remove,
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EliminarPlatMenu(titulo: titulo),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}

class SmallDashboardButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const SmallDashboardButton({
    required this.title,
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30),
              const SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}