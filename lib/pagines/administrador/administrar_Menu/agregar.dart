import 'package:dish_dash/Clases/Plat.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/pagines/landing/landingpage.dart';
import 'package:path/path.dart' as path;

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

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

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

  bool _validateInputs() {
    if (_nombreController.text.isEmpty ||
        _ingredientesController.text.isEmpty ||
        _precioController.text.isEmpty ||
        selectedImage == null) {
      return false;
    }

    bool isAnyChecked = caracteristicas.any((feature) => feature.values.first);
    if (!isAnyChecked) {
      return false;
    }

    return true;
  }

  Future<String> _uploadImage(String nombre) async {
    if (selectedImage != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref();
        final imageRef = storageRef.child('${path.basename(selectedImage!.path)}');
        await imageRef.putData(imageBytes!);

        String imageUrl = await imageRef.getDownloadURL();
        return imageUrl;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir la imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
        return '';
      }
    }
    return '';
  }

  Future<int> _fetchAndUpdateNumeroPlatos() async {
    try {
      String collection = determineCollection(widget.titulo);
      DocumentReference counterRef = FirebaseFirestore.instance.collection(collection).doc('counter');
      DocumentSnapshot counterSnapshot = await counterRef.get();
      int numeroPlatos = counterSnapshot.get('NumeroPlatos');
      int newNumeroPlatos = numeroPlatos + 1;
      await counterRef.update({'NumeroPlatos': newNumeroPlatos});

      return newNumeroPlatos;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener o actualizar NumeroPlatos: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return -1;
    }
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  String getIdPrefix(String tipoPlato) {
    switch (tipoPlato) {
      case 'Begudes':
        return 'Be';
      case 'Entrants':
        return 'En';
      case 'Primers Plats':
        return 'Pp';
      case 'Postres':
        return 'Po';
      default:
        return 'Un';
    }
  }

  void _onSave() async {
    if (_validateInputs()) {
      String nombre = _nombreController.text.trim();
      String imageUrl = await _uploadImage(nombre);

      if (imageUrl.isNotEmpty) {
        List<String> ingredientes = _ingredientesController.text
            .split(',')
            .map((ingrediente) => ingrediente.trim())
            .toList();

        String collection = determineCollection(widget.titulo);

        int numeroPlatos = await _fetchAndUpdateNumeroPlatos();

        if (numeroPlatos != -1) {
          String prefix = getIdPrefix(widget.titulo);
          String idPlat = '$prefix$numeroPlatos';
          String tipoPlato = capitalize(widget.titulo); 

          Map<String, bool> featuresMap = {};
          for (var feature in caracteristicas) {
            featuresMap.addAll(feature);
          }

          Plat nuevoPlat = Plat(
            idPlat: idPlat,
            tipoPlato: tipoPlato,
            nombrePlato: nombre,
            descripcion: _descripcionController.text.trim(),
            ingredientes: ingredientes,
            precio: double.tryParse(_precioController.text.trim()) ?? 0.0,
            imageUrl: imageUrl,
            caracteristicas: featuresMap,
          );

          await savePlatToFirestore(nuevoPlat, collection);

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al obtener o actualizar el ID del plato.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir la imagen.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos requeridos, seleccione una imagen y al menos una característica.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> savePlatToFirestore(Plat plat, String collection) async {
    try {
      await FirebaseFirestore.instance.collection(collection).doc(plat.idPlat).set({
        'IdPlat': plat.idPlat,
        'TipoPlato': plat.tipoPlato,
        'NombrePlato': plat.nombrePlato,
        'Descripcion': plat.descripcion,
        'Ingredientes': plat.ingredientes,
        'Precio': plat.precio,
        'ImageUrl': plat.imageUrl,
        'Caracteristicas': plat.caracteristicas,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Platillo guardado con éxito en Firestore.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar el platillo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String determineCollection(String tipoPlato) {
    switch (tipoPlato) {
      case 'Begudes':
        return 'bebidas';
      case 'Entrants':
        return 'entrants';
      case 'Primers Plats':
        return 'primersPlats';
      case 'Postres':
        return 'postres';
      default:
        return 'unknown';
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
                              onPressed: _onSave,
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
                        _buildTextFormField(
                          'Nombre',
                          Icons.fastfood,
                          controller: _nombreController
                        ),
                        const SizedBox(height: 10),
                        _buildTextFormField(
                          'Descripcion',
                          Icons.description,
                          controller: _descripcionController
                        ),
                        const SizedBox(height: 10),
                        _buildTextFormField(
                          'Ingredientes',
                          Icons.list,
                          hintText: 'Ingrediente1, Ingrediente2, Ingrediente3',
                          controller: _ingredientesController
                        ),
                        const SizedBox(height: 10),
                        _buildNumberFormField(
                          'Precio',
                          Icons.attach_money,
                          controller: _precioController
                        ),
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

  Widget _buildTextFormField(String label, IconData icon, {String? hintText, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildNumberFormField(String label, IconData icon, {required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
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
