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


  int _currentPage = 0;
  final List<String> _images = [
    "images/restaurant1.jpg",
    "images/restaurant2.jpg",
    "images/restaurant3.jpg",
  ];

  final double promotionalSectionHeight = 400; 

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
        if (_currentPage < _images.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
          );
        }
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.lightGreen.shade600,
              Colors.green.shade500,
              Colors.green.shade400,
              Colors.lightGreen.shade300
            ],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              promotionalSection(),
              const SizedBox(height: 50), 
              Image.asset("images/añadirimagen.png",
                  fit: BoxFit.cover), 
              _buildAportamosSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget promotionalSection() {
    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("images/logorestaurafacil.png", width: 120),
          const Text('Bienvenido a Restaurafacil',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 16),
          const Text('Optimiza tu restaurante desde 10€ al mes',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 8),
          const Text(
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
                          color: _isHovering ? Colors.black : Colors.transparent)),
                  suffixIcon: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      onPressed: () {},
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
          const Text('Qué aportamos?',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureIcon(context, Icons.analytics, "Data Mining"),
              _buildFeatureIcon(
                  context, Icons.schedule, "Optimización de tiempo"),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
              'Empleamos tecnicas de Data Mining para optimizar la oferta de platos disponible ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureIcon(
                  context, Icons.restaurant_menu, "Gestión de platos"),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Modificación de la oferta de platos en cuestión de segundos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white)),
          const SizedBox(height: 20),
          Image.asset("images/añadirimagengrafico.png", fit: BoxFit.cover),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 50, 
          height: 50, 
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(10), 
          ),
          child: Icon(
            icon,
            size: 30,
            color: Colors.lightGreen,
          ),
          alignment: Alignment.center, 
        ),
        SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  void _handleLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => paginaLoginExterna()));
  }
}
