import 'package:dish_dash/pagines/landing/landingpage.dart';
import 'package:flutter/material.dart';

class AgregarPlatMenu extends StatelessWidget {
  final String titulo;
  final List<Map<String, bool>> caracteristicas = [];

  AgregarPlatMenu({Key? key, required this.titulo}) : super(key: key) {
    _populateCaracteristicas();
  }

  void _populateCaracteristicas() {
    switch (titulo) {
      case 'Begudes':
        caracteristicas.addAll([
          {'Cocktails': false},
          {'Refrescs': false},
        ]);
        break;
      case 'Entrants':
        caracteristicas.addAll([
          {'Amanides': false},
          {'Fregits': false},
        ]);
        break;
      case 'Primers Plats':
        caracteristicas.addAll([
          {'Carn': false},
          {'Celiacs': false},
          {'Pasta': false},
          {'Peix': false},
          {'Pizza': false},
          {'Vega': false},
        ]);
        break;
      case 'Postres':
        caracteristicas.addAll([
          {'Calents': false},
          {'Freds': false},
          {'Fruita': false},
          {'Gelats': false},
          {'SemiFreds': false},
        ]);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar: $titulo'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Agregar $titulo',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextFormField('Campo 1', Icons.fastfood),
                        const SizedBox(height: 10),
                        _buildTextFormField('Campo 2', Icons.fastfood),
                        const SizedBox(height: 10),
                        _buildTextFormField('Campo 3', Icons.fastfood),
                        const SizedBox(height: 10),
                        _buildTextFormField('Campo 4', Icons.fastfood),
                        const SizedBox(height: 20),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          endIndent: 20,
                        ),
                        Expanded(
                          child: _buildFeatureGrid(),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    color: Colors.grey,
                    thickness: 1,
                    width: 40,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Lógica para modificar texto
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Modificar texto',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Cuadro Extra',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  Widget _buildTextFormField(String label, IconData icon) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: caracteristicas.map((feature) {
        String key = feature.keys.first;
        bool value = feature[key]!;
        return CheckboxListTile(
          title: Text(key),
          value: value,
          onChanged: (bool? newValue) {
            // Since this is a StatelessWidget, you might need a callback to 
            // handle state change in the parent widget.
            // Implement the callback logic here if needed.
          },
        );
      }).toList(),
    );
  }
}
