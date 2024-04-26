import 'package:flutter/material.dart';
import 'package:dish_dash/pagina_login_externa.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void _handleLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => paginaLoginExterna()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          TextButton(
            onPressed: _handleLogin,
            child: Text(
              'Iniciar sesión',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/restaurant.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'DishDash',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'La solución definitiva para gestionar tu restaurante',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'DishDash te ofrece todo lo que necesitas para llevar tu restaurante al próximo nivel. Desde gestión de pedidos hasta análisis de ventas en tiempo real, facilitamos cada aspecto de tu negocio.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Image.asset("assets/software_demo.jpg", height: 200, fit: BoxFit.cover),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor, // background (button) color
                onPrimary: Colors.white, // foreground (text) color
              ),
              child: Text('Descubre más'),
            ),
          ],
        ),
      ),
    );
  }
}
