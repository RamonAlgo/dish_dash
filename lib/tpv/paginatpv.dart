import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class paginaTPV extends StatefulWidget {
  const paginaTPV({Key? key}) : super(key: key);

  @override
  State<paginaTPV> createState() => _PaginaTPVState();
}

class _PaginaTPVState extends State<paginaTPV> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TPV '),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('tpv')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No hay pedidos pendientes."));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var pedido = snapshot.data!.docs[index];
              var platos = pedido['platos'] as List<dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(
                      'Mesa ${pedido['mesaId']} - Total: ${pedido['total']}€'),
                  subtitle: Text(
                      'Fecha: ${DateTime.fromMillisecondsSinceEpoch(pedido['fecha'].millisecondsSinceEpoch).toString()}'),
                  children: [
                    ...platos.map<Widget>((plat) {
                      return ListTile(
                        title: Text(plat['nom']),
                        subtitle: Text(
                            'Cantidad: ${plat['cantitat']} - Precio por unidad: ${plat['preu']}€'),
                        trailing: Text('Total: ${plat['preuTotalPlato']}€'),
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => marcarComoPagado(pedido),
                        child: Text('Marcar como pagado'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void marcarComoPagado(QueryDocumentSnapshot pedido) {
    var platos = pedido['platos'] as List<dynamic>;
    DateTime fechaActual = DateTime.now();
    String anio = '${fechaActual.year}';
    String mes = fechaActual.month.toString().padLeft(2, '0');

    WriteBatch batch = _firestore.batch();
    double totalPedido = 0;

    for (var plat in platos) {
      var platId = plat['idPlat'];
      var nomPlat = plat['nom'];

      var cantidad = plat['cantitat'] as int;
      var precioTotalPlato = plat['preuTotalPlato'] as double;
      totalPedido += precioTotalPlato;

      DocumentReference platRef = _firestore
          .collection('estadisticas')
          .doc(anio)
          .collection('meses')
          .doc(mes)
          .collection('platos')
          .doc(platId);

      batch.set(
          platRef,
          {
            'cantidad': FieldValue.increment(cantidad),
            'nom': nomPlat
          },
          SetOptions(merge: true));
    }

    DocumentReference facturacionRef = _firestore
        .collection('estadisticas')
        .doc(anio)
        .collection('meses')
        .doc(mes)
        .collection('facturacion')
        .doc('total');
    batch.set(facturacionRef, {'total': FieldValue.increment(totalPedido)},
        SetOptions(merge: true));
    batch.delete(_firestore.collection('tpv').doc(pedido.id));

    batch.commit().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Pedido marcado como pagado y estadísticas actualizadas. Pedido eliminado de la lista.'),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al actualizar estadísticas: $error'),
          backgroundColor: Colors.red));
    });
  }
}
