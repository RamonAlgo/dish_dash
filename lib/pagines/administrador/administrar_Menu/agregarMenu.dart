import 'package:dish_dash/Clases/Menu.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:dish_dash/pagines/landing/landingpage.dart';

class AgregarMenu extends StatefulWidget {
  final String titulo;

  AgregarMenu({Key? key, required this.titulo}) : super(key: key);

  @override
  _AgregarMenuState createState() => _AgregarMenuState();
}

class _AgregarMenuState extends State<AgregarMenu> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  List<Map<String, dynamic>> _platosEnCarta = [];
  List<Map<String, dynamic>> _platosAgregados = [];
  List<Map<String, dynamic>> _allPlatos = [];

  String _selectedFilter = 'Entrants';

  final Map<String, String> _filterMap = {
    'Entrants': 'Entrants',
    'Primers Plats': 'PrimersPlats',
    'Postres': 'Postre'
  };

  @override
  void initState() {
    super.initState();
    _fetchPlatosEnCarta();
  }

  Future<void> _fetchPlatosEnCarta() async {
    List<Map<String, dynamic>> platos = [];

    await _fetchFromCollection('entrants', platos);
    await _fetchFromCollection('postres', platos);
    await _fetchFromCollection('primersPlats', platos);

    setState(() {
      _allPlatos = platos;
      _platosEnCarta = _filteredPlatos(platos, _filterMap[_selectedFilter]!);
    });
  }

  Future<void> _fetchFromCollection(String collectionName, List<Map<String, dynamic>> platos) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collectionName).get();
  snapshot.docs.where((doc) => doc.id != 'counter').forEach((doc) {
    Map<String, dynamic> platoData = doc.data() as Map<String, dynamic>;
    platoData['id'] = doc.id;
    platos.add(platoData);
  });
}


void _onSave() async {
  if (_nombreController.text.isEmpty || _precioController.text.isEmpty) {
    _showSnackbar('Nombre Menu y Precio son obligatorios');
    return;
  }

  if (_platosAgregados.length < 3 ||
      !_platosAgregados.any((plato) => plato['TipoPlato'] == 'Entrants') ||
      !_platosAgregados.any((plato) => plato['TipoPlato'] == 'PrimersPlats') ||
      !_platosAgregados.any((plato) => plato['TipoPlato'] == 'Postre')) {
    _showSnackbar('Debes agregar al menos un plato de cada tipo');
    return;
  }

  List<String> idsPlatos = _platosAgregados.map((plato) => plato['id'].toString()).toList();

  Menu nuevoMenu = Menu(
    descripcion: _descripcionController.text,
    idsPlatos: idsPlatos,
    nombreMenu: _nombreController.text,
    precio: double.parse(_precioController.text),
  );

  DocumentSnapshot counterSnapshot = await FirebaseFirestore.instance.collection('menus').doc('counter').get();
  int numeroConsulta = counterSnapshot.get('NumeroPlatos') + 1;

  await FirebaseFirestore.instance.collection('menus').doc('counter').update({'NumeroPlatos': numeroConsulta});

  await FirebaseFirestore.instance.collection('menus').doc('Me$numeroConsulta').set(nuevoMenu.toJson());

  _showSnackbar('El menú se ha guardado correctamente.');
}

  void _agregarPlato(Map<String, dynamic> plato) {
  String platoId = plato['id'].toString();

  setState(() {
    _platosEnCarta.removeWhere((p) => p['TipoPlato'] == plato['TipoPlato']);
    _platosAgregados.add({...plato, 'id': platoId});
  });
}


  void _eliminarPlato(Map<String, dynamic> plato) {
    setState(() {
      _platosAgregados.remove(plato);
      _platosEnCarta.addAll(_allPlatos.where((p) => p['TipoPlato'] == plato['TipoPlato']));
      _platosEnCarta = _filteredPlatos(_platosEnCarta, _filterMap[_selectedFilter]!);
    });
  }

  List<Map<String, dynamic>> _filteredPlatos(List<Map<String, dynamic>> platos, String filter) {
    return platos.where((plato) => plato['TipoPlato'] == filter).toList();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar: ${widget.titulo}'),
        backgroundColor: const Color(0xFF005086),
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
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      backgroundColor: const Color(0xFF005086),
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
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              _buildTextFormField(
                                'Nombre Menu',
                                Icons.fastfood,
                                controller: _nombreController,
                              ),
                              const SizedBox(height: 10),
                              _buildTextFormField(
                                'Descripcion Menu',
                                Icons.description,
                                controller: _descripcionController,
                              ),
                              const SizedBox(height: 10),
                              _buildNumberFormField(
                                'Precio',
                                Icons.attach_money,
                                controller: _precioController,
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Platos agregados',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF005086),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: _platosAgregados.isEmpty
                                              ? const Center(
                                                  child: Text(
                                                    'Vacio',
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  itemCount: _platosAgregados.length,
                                                  itemBuilder: (context, index) {
                                                    final plato = _platosAgregados[index];
                                                    return Container(
                                                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                                                      padding: const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 223, 223, 223),
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Image.network(
                                                            plato['ImageUrl'] ?? '',
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  plato['NombrePlato'] ?? 'Sin nombre',
                                                                  style: const TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  plato['Descripcion'] ?? 'Sin descripción',
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.white70,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () => _eliminarPlato(plato),
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.red,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              'Eliminar',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Platos en menú',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF005086),
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      const Text(
                                        'Filtro:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF005086),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      DropdownButton<String>(
                                        value: _selectedFilter,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedFilter = newValue!;
                                            _platosEnCarta = _filteredPlatos(_allPlatos, _filterMap[_selectedFilter]!);
                                          });
                                        },
                                        items: _filterMap.keys.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              Expanded(
                                child: _platosEnCarta.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Vacio',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: _platosEnCarta.length,
                                        itemBuilder: (context, index) {
                                          final plato = _platosEnCarta[index];
                                          return Container(
                                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 223, 223, 223),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Row(
                                              children: [
                                                Image.network(
                                                  plato['ImageUrl'] ?? '',
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        plato['NombrePlato'] ?? 'Sin nombre',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF005086),
                                                        ),
                                                      ),
                                                      Text(
                                                        plato['Descripcion'] ?? 'Sin descripción',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Color(0xFF005086),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => _agregarPlato(plato),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFF005086),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Agregar',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
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

  Widget _buildTextFormField(String label, IconData icon,
      {String? hintText, required TextEditingController controller}) {
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

  Widget _buildNumberFormField(String label, IconData icon,
      {required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
      ],
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
