import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuWidget extends StatelessWidget {
  final String imageUrl;
  final String nombreMenu;
  final List<String> idsPlatos;
  final double precio;
  final VoidCallback onAdd;

  MenuWidget({
    required this.imageUrl,
    required this.nombreMenu,
    required this.idsPlatos,
    required this.precio,
    required this.onAdd,
  });

  Future<Map<String, dynamic>> _fetchPlatoDetails(String idPlato) async {
    String collectionName;
    if (idPlato.startsWith('En')) {
      collectionName = 'entrants';
    } else if (idPlato.startsWith('Po')) {
      collectionName = 'postres';
    } else if (idPlato.startsWith('Pp')) {
      collectionName = 'primersPlats';
    } else {
      throw 'ID del plato desconocido';
    }

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(collectionName).doc(idPlato).get();
      return snapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error al obtener el documento: $e');
      return {};
    }
  }

  void _showPlatoInfo(BuildContext context) async {
    List<Map<String, dynamic>> platosInfo = [];

    for (String idPlato in idsPlatos) {
      var details = await _fetchPlatoDetails(idPlato);
      if (details.isNotEmpty) {
        platosInfo.add(details);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0.85),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nombreMenu,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                SizedBox(height: 10),
                const Text(
                  "Contingut",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: platosInfo.map((plato) {
                    String imageUrl = plato['ImageUrl'] ?? '';
                    String nombrePlato = plato['NombrePlato'] ?? '';

                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Stack(
                        children: [
                          if (imageUrl.isNotEmpty)
                            Positioned.fill(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                              child: Text(
                                nombrePlato,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nombreMenu,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _showPlatoInfo(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text('Info', style: TextStyle(color: Colors.white)),
              ),
              Text(
                '${precio.toStringAsFixed(2)}€',
                style: TextStyle(fontSize: 16.0),
              ),
              ElevatedButton(
                onPressed: () {
                  onAdd();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                ),
                child: Text('Demanar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
