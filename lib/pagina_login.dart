/// The `PaginaLogin` class in Dart represents a login page that allows users to authenticate based on
/// their email domain and redirects them to different pages based on their email type.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/auth/servei_auth.dart';
import 'package:dish_dash/pagines/administrador/adminDashboard.dart';
import 'package:dish_dash/pagines/cuina/pagina_cuina.dart';
import 'package:dish_dash/tpv/paginatpv.dart';
import 'package:dish_dash/pagines/pagina_inicial_client.dart';

class PaginaLogin extends StatefulWidget {
  final String domain;

  const PaginaLogin({Key? key, required this.domain}) : super(key: key);

  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  String? logoUrl;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ServeiAuth serveiAuth = ServeiAuth();

  @override
  void initState() {
    super.initState();
    _loadLogo();
  }

  void _loadLogo() async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('logos/${widget.domain}.png');
      logoUrl = await storageRef.getDownloadURL();
      setState(() {});
    } catch (e) {
      print('Error loading logo: $e');
    }
  }

  void _login() async {
    String email = _usernameController.text.trim() + '@'+widget.domain;
    print(email);
    String password = _passwordController.text.trim();

    try {
      UserCredential? userCredential = await serveiAuth.loginAmbEmailIPassword(email, password);
      if (userCredential != null) {
        final userEmail = userCredential.user?.email;
        if (userEmail != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => _getPageBasedOnEmail(userEmail)),
          );
        }
      } else {
        _mostrarDialogoError("No se pudo obtener la información del usuario.");
      }
    } catch (e) {
      _mostrarDialogoError(e.toString());
    }
  }

  Widget _getPageBasedOnEmail(String email) {
    if (email.contains("administrador")) {
      return AdminDashboardPage(domain:widget.domain);
    } else if (email.contains("cocina")) {
      return PaginaCuina(domain:widget.domain);
    } else if (email.contains("tpv")) {
      return paginaTPV(domain:widget.domain);
    } else { 
      return PaginaInicialClient(domain:widget.domain);
    }
  }

  void _mostrarDialogoError(String mensaje) {
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
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (logoUrl != null)
                Image.network(logoUrl!)
              else
                Text('Logo no disponible para el dominio: ${widget.domain}'),
                
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text("Iniciar sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
