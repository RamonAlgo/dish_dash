import 'package:dish_dash/pagines/landing/landingpage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class AgregarPlatMenu extends StatefulWidget {
  final String titulo;

  AgregarPlatMenu({Key? key, required this.titulo}) : super(key: key);

  @override
  _AgregarPlatMenuState createState() => _AgregarPlatMenuState();
}

class _AgregarPlatMenuState extends State<AgregarPlatMenu> {
  final List<Map<String, bool>> caracteristicas = [];
  XFile? selectedImage;
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _populateCaracteristicas();
  }

  void _populateCaracteristicas() {
    switch (widget.titulo) {
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

  void pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageBytes = await image.readAsBytes();
      setState(() {
        selectedImage = image;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imagen seleccionada con éxito.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se seleccionó ninguna imagen.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Agregar: ${widget.titulo}'),
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
                      Row(
                        children: [
                          Text(
                            'Agregar ${widget.titulo}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF005086),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF005086),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Guardar',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
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
                          pickImage(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF005086),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Seleccionar imagen',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedImage == null
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedImage == null
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: selectedImage == null
                                  ? const Text(
                                      'Esperando imagen',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    )
                                  : Image.memory(
                                      imageBytes!,
                                      fit: BoxFit.cover,
                                    ),
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
      childAspectRatio: 7,
      children: caracteristicas.map((feature) {
        String key = feature.keys.first;
        bool value = feature[key]!;
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: (bool? newValue) {
                  setState(() {
                    feature[key] = newValue!;
                  });
                },
              ),
              Expanded(
                child: Text(
                  key,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
