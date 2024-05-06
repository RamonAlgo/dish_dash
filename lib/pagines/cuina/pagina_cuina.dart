import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginaCuina extends StatefulWidget {
  final String domain;

  const PaginaCuina({Key? key, required this.domain}) : super(key: key);

  @override
  State<PaginaCuina> createState() => _PaginaCuinaState();
}

class _PaginaCuinaState extends State<PaginaCuina> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos de Cocina'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('mesas').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var documentos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documentos.length,
            itemBuilder: (context, index) {
              var mesaData = documentos[index];
              return Card(
                child: ExpansionTile(
                  title: Text(mesaData.id),
                  children: List<Widget>.from(
                    (mesaData['platos'] as List<dynamic>).map(
                      (plat) => ListTile(
                        title: Text(plat['nom']),
                        subtitle: Text('Cantidad: ${plat['cantitat']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.check_circle_outline),
                          color: plat['entregado'] ? Colors.green : null,
                          onPressed: () {
                            _marcarComoEntregado(mesaData.id, plat);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

void _marcarComoEntregado(String mesaId, dynamic plat) {
  var updatedPlat = Map<String, dynamic>.from(plat);
  updatedPlat['entregado'] = true; 

  _firestore.collection('mesas').doc(mesaId).update({
    'platos': FieldValue.arrayRemove([plat])
  }).then((_) {
    _firestore.collection('mesas').doc(mesaId).update({
      'platos': FieldValue.arrayUnion([updatedPlat])
    }).then((_) => _verificarYEliminarSiNecesario(mesaId));
  });
}

void _verificarYEliminarSiNecesario(String mesaId) {
  _firestore.collection('mesas').doc(mesaId).get().then((mesa) {
    var platos = mesa.data()!['platos'] as List<dynamic>;
    if (platos.every((plat) => plat['entregado'] == true)) {
      double total = platos.fold(0, (sum, plat) => sum + (plat['preu'] * plat['cantitat']));

      var platosDetallados = platos.map((plat) {
        return {
            'idPlat': plat['idPlat'],
            'nom': plat['nom'],
            'cantitat': plat['cantitat'],
            'preu': plat['preu'],
            'preuTotalPlato': plat['preu'] * plat['cantitat'], 
        };
      }).toList();

      _firestore.collection('tpv').doc(mesaId).set({
        'mesaId': mesaId,
        'platos': platosDetallados,
        'total': total, 
        'fecha': DateTime.now() 
      }).then((_) {
        _firestore.collection('mesas').doc(mesaId).delete();
      }).catchError((error) {
        print('Error al mover los datos a TPV: $error');
      });
    }
  });
}

}

