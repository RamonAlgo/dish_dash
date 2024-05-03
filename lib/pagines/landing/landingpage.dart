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

  int _currentPage = 0;
  final List<String> _images = [
    "images/restaurant1.jpg",
    "images/restaurant2.jpg",
    "images/restaurant3.jpg",
  ];
  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => paginaLoginExterna()));
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



  void _scrollToSection() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
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
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            Container(
              height: 900,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(_images[index]),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Restaurafacil',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),  
                          Text(
                            'La solución definitiva para gestionar tu restaurante',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                            child: Text(
                              'Restaurafacil te ofrece todo lo que necesitas para llevar tu restaurante al próximo nivel. Desde gestión de pedidos hasta análisis de ventas en tiempo real, facilitamos cada aspecto de tu negocio.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _scrollToSection,
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor, 
                              onPrimary: Colors.white, 
                            ),
                            child: Text('Descubre más', style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
                        _buildAportamosSection(context), ],
        ),
      ),
    );
  }

  Widget _buildAportamosSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Qué aportamos?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureIcon(context, Icons.restaurant_menu, "Gestión de Menús"),
              _buildFeatureIcon(context, Icons.analytics, "Análisis de Datos"),
              _buildFeatureIcon(context, Icons.schedule, "Optimización de Tiempo"),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Restaurafacil ofrece una plataforma integrada que ayuda a los restaurantes a maximizar su eficiencia, mejorar la gestión del tiempo y optimizar los recursos. Nuestras herramientas analíticas avanzadas permiten a los gerentes tomar decisiones basadas en datos precisos, mejorando así el servicio y la satisfacción del cliente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Image.asset("assets/feature_graphic.png", fit: BoxFit.cover),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 30,
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
