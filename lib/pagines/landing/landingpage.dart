import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/pagina_login_externa.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _emailController = TextEditingController();
  bool _isHovering = false;

  final List<String> _images = [
    "images/restaurant1.jpg",
    "images/restaurant2.jpg",
    "images/restaurant3.jpg",
  ];

  final double promotionalSectionHeight = 600;

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.doWhile(() async {
        await Future.delayed(Duration(seconds: 3));
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightGreen.shade600,
              Colors.green.shade500,
              Colors.green.shade400,
              Colors.white
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextButton(
                    onPressed: _handleLogin,
                    child: Text(
                      "Ya eres cliente? Iniciar sesión",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              promotionalSection(),
              SizedBox(height: 50),
              Image.asset("images/add_image_here.png", fit: BoxFit.cover),
              _buildAportamosSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget promotionalSection() {
    return Container(
      height: promotionalSectionHeight,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logorestaurafacil.png", width: 120),
              SizedBox(width: 20),
              Flexible(
                child: Text('Restaurafacil',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('Optimiza tu restaurante desde 10€ al mes',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 8),
          Text(
              'Un servicio completo para mejorar la gestión y la experiencia del cliente.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70)),
          SizedBox(height: 20),
          MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Introduce tu email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color:
                              _isHovering ? Colors.black : Colors.transparent)),
                  suffixIcon: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      onPressed: _saveEmailToFirestore,
                      child: const Text(
                        "Solicitar Información",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAportamosSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureIcon(
                  context, Icons.schedule, "Optimización de tiempo", "Gracias a las estadísticas podrías ahorrar hasta un 50% del tiempo en creación de nuevos platos"),
              _buildFeatureIcon(context, Icons.analytics,
                  "Disponibilidad", "Empleamos distintas técnicas de Análisis de datos para determinar que platos en la carta son los que estan siendo mas vendidos"),
            ],
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureIcon(
                  context, Icons.lock, "Seguridad", "Contamos con diferentes capas y protocolos de seguridad avanzada"),
              _buildFeatureIcon(context, Icons.event_available,
                  "Disponibilidad", "Accesible 24 * 7 ,solo necesitas una conexión  a Internet"),
            ],
          ),
          Image.asset("images/admindashboard.png", fit: BoxFit.cover),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(BuildContext context, IconData icon, String label,
      String additionalText) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 30,
            color: Color.fromARGB(255, 49, 49, 49),
          ),
          alignment: Alignment.center,
        ),
        SizedBox(height: 8),
        Container(
          width: 120, 
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          width: 120, 
          child: Text(
            additionalText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
void _saveEmailToFirestore() async {
  String email = _emailController.text.trim();

  if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor, introduce un correo válido')),
    );
    return;
  }

  try {
    await FirebaseFirestore.instance.collection('informacionSolicitada').add({'email': email});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Correo guardado con éxito')),
    );
    _emailController.clear(); 
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al guardar el correo: $e')),
    );
  }
}
  void _handleLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PaginaLoginExterna()));
  }
}
