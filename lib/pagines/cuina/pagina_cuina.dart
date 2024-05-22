import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginaCuina extends StatefulWidget {
  const PaginaCuina({Key? key});

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
                  children: [
                    ..._buildPlatosList(mesaData),
                    ..._buildMenusList(mesaData),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildPlatosList(QueryDocumentSnapshot mesaData) {
    return (mesaData['platos'] as List<dynamic>).map<Widget>((plat) {
      return ListTile(
        title: Text(plat['nom']),
        subtitle: Text('Cantidad: ${plat['cantitat']}'),
        trailing: IconButton(
          icon: Icon(Icons.check_circle_outline),
          color: plat['entregado'] ? Colors.green : null,
          onPressed: () {
            _marcarComoEntregado(mesaData.id, plat);
          },
        ),
      );
    }).toList();
  }

  List<Widget> _buildMenusList(QueryDocumentSnapshot mesaData) {
    return (mesaData['menus'] as List<dynamic>).map<Widget>((menu) {
      return ListTile(
        title: Text(menu['NombreMenu']),
        subtitle: Text('Cantidad: ${menu['Cantidad']}'),
        trailing: IconButton(
          icon: Icon(Icons.check_circle_outline),
          color: menu['Entregado'] ? Colors.green : null,
          onPressed: () {
            _marcarComoEntregadoMenu(mesaData.id, menu);
          },
        ),
      );
    }).toList();
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

  void _marcarComoEntregadoMenu(String mesaId, dynamic menu) {
    var updatedMenu = Map<String, dynamic>.from(menu);
    updatedMenu['Entregado'] = true;

    _firestore.collection('mesas').doc(mesaId).update({
      'menus': FieldValue.arrayRemove([menu])
    }).then((_) {
      _firestore.collection('mesas').doc(mesaId).update({
        'menus': FieldValue.arrayUnion([updatedMenu])
      }).then((_) => _verificarYEliminarSiNecesario(mesaId));
    });
  }

  void _verificarYEliminarSiNecesario(String mesaId) {
    _firestore.collection('mesas').doc(mesaId).get().then((mesa) {
      var platos = mesa.data()!['platos'] as List<dynamic>;
      var menus = mesa.data()!['menus'] as List<dynamic>;

      bool todosPlatosEntregados = platos.every((plat) => plat['entregado'] == true);
      bool todosMenusEntregados = menus.every((menu) => menu['Entregado'] == true);

      if (todosPlatosEntregados && todosMenusEntregados) {
        double totalPlatos = platos.fold(0, (sum, plat) => sum + (plat['preu'] * plat['cantitat']));
        double totalMenus = menus.fold(0, (sum, menu) => sum + (menu['Precio'] * menu['Cantidad']));
        double total = totalPlatos + totalMenus;

        var platosDetallados = platos.map((plat) {
          return {
            'idPlat': plat['idPlat'],
            'nom': plat['nom'],
            'cantitat': plat['cantitat'],
            'preu': plat['preu'],
            'preuTotalPlato': plat['preu'] * plat['cantitat'],
          };
        }).toList();

        var menusDetallados = menus.map((menu) {
          return {
            'menuId': menu['menuId'],
            'NombreMenu': menu['NombreMenu'],
            'Descripcion': menu['Descripcion'],
            'Precio': menu['Precio'],
            'Cantidad': menu['Cantidad'],
            'preuTotalMenu': menu['Precio'] * menu['Cantidad'],
          };
        }).toList();

        _firestore.collection('tpv').doc(mesaId).set({
          'mesaId': mesaId,
          'platos': platosDetallados,
          'menus': menusDetallados,
          'totalPlatos': totalPlatos,
          'totalMenus': totalMenus,
          'total': total,
          'fecha': DateTime.now(),
        }).then((_) {
          _firestore.collection('mesas').doc(mesaId).delete();
        }).catchError((error) {
          print('Error al mover los datos a TPV: $error');
        });
      }
    });
  }
}
