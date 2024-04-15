import 'package:dish_dash/auth/servei_auth.dart';
import 'package:dish_dash/pagines/administrador/adminDashboard.dart';
import 'package:dish_dash/pagines/administrador/pagina_administrador.dart';
import 'package:dish_dash/pagines/cuina/pagina_cuina.dart';
import 'package:dish_dash/pagines/pagina_inicial_client.dart';
import 'package:dish_dash/tpv/paginatpv.dart';
import 'package:flutter/material.dart';

class PaginaLogin extends StatefulWidget {
  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final serveiAuth = ServeiAuth();

  void _login(BuildContext context) async {
    String username = _usernameController.text + '@mesa.com';

    try {
      await serveiAuth.loginAmbEmailIPassword(
        username,
        _passwordController.text,
      );
      final user = serveiAuth.getUsuarisActual();
      if (user != null) {
        final email = user.email;
        if (email!.contains("administrador")) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AdminDashboardPage()));
          });
        } else if (email.contains("cocina")) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PaginaCuina()));
          });
        } else if (email.contains("tpv")) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => paginaTPV()));
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PaginaInicialClient()));
          });
        }
      } else {
        _mostrarDialogoError(
            context, "No se pudo obtener la información del usuario.");
      }
    } catch (e) {
      _mostrarDialogoError(context, e.toString());
    }
  }

  void _mostrarDialogoError(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/login.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: "Usuari"),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Contrasenya"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _login(context),
                    child: Text("Iniciar sessió"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
