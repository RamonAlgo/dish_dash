import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginaMenjarDemanat extends StatelessWidget {
  final String mesaId; 

  PaginaMenjarDemanat({required this.mesaId});

  Future<DocumentSnapshot> obtenerPedidoMesa() {
    return FirebaseFirestore.instance
        .collection('mesas')
        .doc(mesaId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Confirmado de Mesa $mesaId"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: obtenerPedidoMesa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.data == null || !snapshot.data!.exists) {
            return Center(child: Text("No hay pedido confirmado para esta mesa."));
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['platos'] == null) {
            return Text("No hay platos en el pedido.");
          }
          
          List<dynamic> platos = data['platos'];
          return ListView(
            children: [
              ListTile(
                title: Text('Pedido Confirmado: ${data['timestamp'].toDate().toString()}'),
                subtitle: Text('Total de platos: ${platos.length}'),
              ),
              ...platos.map<Widget>((plat) {
                return ListTile(
                  title: Text(plat['nom']),
                  subtitle: Text('Cantidad: ${plat['cantitat']}'),
                  trailing: Text('Precio total: ${plat['preu'] * plat['cantitat']}€'),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
