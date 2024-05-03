import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class PaginaAdministrador extends StatefulWidget {
  const PaginaAdministrador({Key? key}) : super(key: key);

  @override
  State<PaginaAdministrador> createState() => _PaginaAdministradorState();
}

class _PaginaAdministradorState extends State<PaginaAdministrador> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();

  bool _isCarn = false;
  bool _isCeliacs = false;
  bool _isPasta = false;
  bool _isPeix = false;
  bool _isPizza = false;
  bool _isVega = false;
  XFile? selectedImage;

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        selectedImage = image;
      });
    }
  }
  
  String cleanFileName(String input) {
    return input.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');
  }
  
  Future<void> uploadPlat(Uint8List imageData) async {
  try {
    String fileName = cleanFileName(_nombreController.text) + '.png';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(fileName); 
    UploadTask uploadTask = ref.putData(imageData);
    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      final String imageUrl = await snapshot.ref.getDownloadURL();
      final String idPlat = await getNextPlatId();
      Map<String, bool> caracteristicas = {
        'Carn': _isCarn,
        'Celiacs': _isCeliacs,
        'Pasta': _isPasta,
        'Peix': _isPeix,
        'Pizza': _isPizza,
        'Vega': _isVega
      };
      Plat platoPorGuardar = Plat(
        idPlat: idPlat,
        imageUrl: imageUrl,
        nombrePlato: _nombreController.text,
        descripcion: _descripcionController.text,
        ingredientes: _ingredientesController.text.split(',').map((i) => i.trim()).toList(),
        precio: double.parse(_precioController.text),
        tipoPlato: "PrimersPlats", 
        caracteristicas: caracteristicas,
      );
      try {
        await FirebaseFirestore.instance.collection('primersPlats').doc(idPlat).set({
          'ImageUrl': platoPorGuardar.imageUrl,
          'NombrePlato': platoPorGuardar.nombrePlato,
          'Descripcion': platoPorGuardar.descripcion,
          'Ingredientes': platoPorGuardar.ingredientes,
          'Precio': platoPorGuardar.precio,
          'TipoPlato': platoPorGuardar.tipoPlato,
          'Caracteristicas': platoPorGuardar.caracteristicas,
        });
        print('Plato guardado en Firestore: ${platoPorGuardar.nombrePlato}');
      } catch (e) {
        print('Error al guardar el plato en Firestore: $e');
      }
    } else {
      print('Error al subir la imagen');
    }
  } catch (e) {
    print('Error al subir la imagen: $e');
  }
}

Future<String> getNextPlatId() async {
  final DocumentReference platCounterRef = FirebaseFirestore.instance.collection('primersPlats').doc('counter');
  
  try {
    final DocumentSnapshot counterSnapshot = await platCounterRef.get();
        if (counterSnapshot.exists) {
      final Map<String, dynamic>? data = counterSnapshot.data() as Map<String, dynamic>?;
      if (data != null && data['NumeroPlatos'] != null) {
        int nextNumber = data['NumeroPlatos'] + 1;
        await platCounterRef.set({'NumeroPlatos': nextNumber});
        return 'Pp$nextNumber';
      } else {
        print('Los datos del contador no están en el formato esperado.');
        return 'Pp100';
      }
    } else {
      print('El documento del contador no existe.');
      return 'Pp100';
    }
  } catch (e) {
    print('Error al obtener el próximo ID del plato: $e');
    return 'Pp100';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Plato'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Plato',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(
                  labelText: 'Precio (€)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ingredientesController,
                decoration: const InputDecoration(
                  labelText: 'Ingredientes',
                  hintText: 'Ingrediente1, Ingrediente2, ...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              buildCheckbox("Carn", _isCarn, (bool value) { setState(() { _isCarn = value; }); }),
              buildCheckbox("Celiacs", _isCeliacs, (bool value) { setState(() { _isCeliacs = value; }); }),
              buildCheckbox("Pasta", _isPasta, (bool value) { setState(() { _isPasta = value; }); }),
              buildCheckbox("Peix", _isPeix, (bool value) { setState(() { _isPeix = value; }); }),
              buildCheckbox("Pizza", _isPizza, (bool value) { setState(() { _isPizza = value; }); }),
              buildCheckbox("Vega", _isVega, (bool value) { setState(() { _isVega = value; }); }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        Uint8List imageBytes = await image.readAsBytes();
                        setState(() {
                          selectedImage = image;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Imagen seleccionada con éxito.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text('Subir imagen'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_nombreController.text.isEmpty ||
                          _precioController.text.isEmpty ||
                          _ingredientesController.text.isEmpty ||
                          selectedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor completa todos los campos y selecciona una imagen.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (!(_isCarn || _isCeliacs || _isPasta || _isPeix || _isPizza || _isVega)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor selecciona al menos una categoría.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        try {
                          Uint8List imageBytes = await selectedImage!.readAsBytes();
                          await uploadPlat(imageBytes);
                        } catch (e) {
                          print(e); 
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error al guardar el plato.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Guardar plato'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckbox(String title, bool boolValue, Function onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: boolValue,
      onChanged: (bool? newValue) {
        onChanged(newValue ?? false);
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
