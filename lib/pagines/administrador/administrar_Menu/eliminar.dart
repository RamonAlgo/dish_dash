import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/pagines/landing/landingpage.dart';
import 'package:flutter/material.dart';

class EliminarPlatMenu extends StatefulWidget {
  final String titulo;

  const EliminarPlatMenu({Key? key, required this.titulo}) : super(key: key);

  @override
  _EliminarPlatMenuState createState() => _EliminarPlatMenuState();
}

class _EliminarPlatMenuState extends State<EliminarPlatMenu> {
  List<Map<String, dynamic>> _dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String? collection = _getCollectionName();
    if (collection != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .get();
      setState(() {
        _dataList = querySnapshot.docs
            .where((doc) => doc.id != 'counter')
            .map((doc) => {
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                })
            .toList();
      });
    }
  }

  Future<void> _deleteDocument(String docId) async {
    String? collection = _getCollectionName();
    if (collection != null) {
      await FirebaseFirestore.instance.collection(collection).doc(docId).delete();
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar: ${widget.titulo}'),
        backgroundColor: Colors.deepOrangeAccent,
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
      body: _buildBody(),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.deepOrangeAccent,
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

  Widget _buildBody() {
    if (_dataList.isEmpty) {
      return const Center(
        child: Text('No data available.'),
      );
    } else {
      return ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          final item = _dataList[index];
          return ListTile(
            title: Text(item['NombrePlato'] ?? 'No Name'),
            subtitle: Text(item['Descripcion'] ?? 'No Description'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteDocument(item['id']);
              },
            ),
          );
        },
      );
    }
  }

  String? _getCollectionName() {
    switch (widget.titulo) {
      case 'Begudes':
        return 'bebidas';
      case 'Entrants':
        return 'entrants';
      case 'Primers Plats':
        return 'primersPlats';
      case 'Postres':
        return 'postres';
      default:
        return null; 
    }
  }
}
