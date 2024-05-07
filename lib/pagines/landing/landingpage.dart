/// The `LandingPage` class in Dart represents a Flutter landing page with sections for product
/// explanation, features, contact information, and frequently asked questions.
import 'package:dish_dash/pagina_login_externa.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FAQItem {
  FAQItem(
      {required this.question, required this.answer, this.isExpanded = false});
  String question;
  String answer;
  bool isExpanded;
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey contactKey = GlobalKey();
  final List<FAQItem> _faqData = [
    FAQItem(
      question: "¿Que modalidades de pago hay?",
      answer:
          "El servicio se puede contratar en formato de facturación mensual,trimestral o anual",
      isExpanded: false,
    ),
    FAQItem(
      question: "¿Cuáles son los métodos de pago disponibles?",
      answer: "Puedes pagar mediante tarjeta de crédito,Bizum o PayPal.",
      isExpanded: false,
    ),
    FAQItem(
      question: "¿Como funciona el servicio de renting?",
      answer:
          "Nosotros ofrecemos un servicio de renting de los dispositivos asi como la instalación de los mismos.",
      isExpanded: false,
    ),
  ];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(context),
            _buildProductExplanationSection(),
            _buildFeaturesSection(),
            _buildContactSection(),
            _buildFAQSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductExplanationSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
      color: Color(0xFFF1F1F1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '¿Qué es Dish Dash?',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005086),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFeatureIcon(
                Icons.tablet,
                'Una solucion innovadora',
                'Desarrollamos soluciones a medida para tu restaurante. ',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String title, String description) {
    return Column(
      children: [
        Icon(icon, size: 64, color: Color(0xFF005086)),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF005086),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(fontSize: 16, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/header3_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: TextButton(
              onPressed: _handleLogin,
              child: const Text(
                '¿Ya eres cliente? Iniciar sesión',
                style: TextStyle(color: Color(0xFF005086)),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 650),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 250, 251, 252),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                  ),
                  onPressed: _scrollToContact,
                  child: const Text('Conócenos',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF005086),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToContact() {
    Scrollable.ensureVisible(
      contactKey.currentContext!,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          const Text(
            'Características Principales',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005086),
            ),
          ),
          const SizedBox(height: 20),
          GridView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            children: [
              _buildFeatureItem(
                Icons.euro,
                'Optimización de recursos',
                'Ofrecemos un ahorro de hasta el 90 % frente a un modelo tradicional',
              ),
              _buildFeatureItem(
                Icons.analytics,
                'Disponibilidad',
                'Nuestro servicio esta disponible todos los días a todas las horas del dia* ',
              ),
              _buildFeatureItem(
                Icons.lock,
                'Seguridad',
                'Contamos con diferentes capas y protocolos de seguridad avanzada para proteger tu información .',
              ),
              _buildFeatureItem(
                Icons.menu_book,
                'Optimización del menú',
                'Gracias a nuestros sistemas de recolección y análisis de datos puedes ver los platos mas pedidos en tu local',
              ),
              _buildFeatureItem(
                Icons.add,
                'Agregar y modificar los platos',
                'Proporcionamos interfaces para añadir y eliminar platos de la carta al instante.',
              ),
              _buildFeatureItem(
                Icons.history,
                'Visualización de datos',
                'Recopilamos información acerca de los pedidos para generar gráficos informativos sobre tu negocio. ',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF005086)),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005086),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      key: contactKey,
      padding: const EdgeInsets.all(30),
      color: const Color(0xFFF1F1F1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contáctanos',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005086),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Introduce tu email',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              suffixIcon: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: const Color(0xFF005086)),
                onPressed: _saveEmailToFirestore,
                child:
                    const Text('Enviar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preguntas Frecuentes',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005086),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: _faqData.map<Widget>((FAQItem item) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.question,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF005086),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.answer,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(color: Colors.grey),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _saveEmailToFirestore() async {
    String email = _emailController.text.trim();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, introduce un correo válido')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('informacionSolicitada')
          .add({'email': email});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo guardado con éxito')),
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
      context,
      MaterialPageRoute(builder: (context) => PaginaLoginExterna()),
    );
  }
}
