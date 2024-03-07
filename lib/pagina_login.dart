import 'package:dish_dash/pagines/administrador/pagina_administrador.dart';
import 'package:dish_dash/pagines/cuina/pagina_cuina.dart';
import 'package:dish_dash/pagines/pagina_inicial_client.dart';
import 'package:flutter/material.dart';

class PaginaLogin extends StatefulWidget {
  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(BuildContext context) {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'admin' && password == 'admin') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => PaginaAdministrador()));
    } else if (username == 'cocina' && password == 'cocina') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PaginaCuina()));
    } else if (username == 'mesa' && password == 'mesa') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => PaginaInicialClient()));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Usuario o contraseña incorrectos"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
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
                image: AssetImage("images/login.png"), //imatgefons
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
