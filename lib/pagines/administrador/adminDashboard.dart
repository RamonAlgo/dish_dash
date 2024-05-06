import 'package:dish_dash/auth/servei_auth.dart';
import 'package:dish_dash/pagina_login.dart';
import 'package:dish_dash/pagines/administrador/administrar_Menu.dart';
import 'package:dish_dash/pagines/administrador/pagina_envio_emails.dart';
import 'package:dish_dash/pagines/landing/landingpage.dart';
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardButton(
              title: 'Administrar Menu',
              icon: Icons.restaurant_menu,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdministrarMenu()),
                );
              },
            ),
            SizedBox(width: 20),
            DashboardButton(
              title: 'Estadisticas',
              icon: Icons.bar_chart,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PaginaEstadisticasAdministrador()),
                );
              },
            ),
            SizedBox(width: 20),
            DashboardButton(
              title: 'PaginaEnvioEmails',
              icon: Icons.info_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaginaEnvioEmails()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepOrangeAccent,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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

class DashboardButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const DashboardButton({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 200,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}