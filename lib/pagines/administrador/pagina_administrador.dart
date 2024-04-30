import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  // Estados de los CheckBoxes
  bool _isCarn = false;
  bool _isCeliacs = false;
  bool _isPasta = false;
  bool _isPeix = false;
  bool _isPizza = false;
  bool _isVega = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Plato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Plato',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _precioController,
                decoration: InputDecoration(
                  labelText: 'Precio (€)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _ingredientesController,
                decoration: InputDecoration(
                  labelText: 'Ingredientes',
                  hintText: 'Ingrediente1, Ingrediente2, ...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              buildCheckbox("Carn", _isCarn, (bool value) {
                setState(() { _isCarn = value; });
              }),
              buildCheckbox("Celiacs", _isCeliacs, (bool value) {
                setState(() { _isCeliacs = value; });
              }),
              buildCheckbox("Pasta", _isPasta, (bool value) {
                setState(() { _isPasta = value; });
              }),
              buildCheckbox("Peix", _isPeix, (bool value) {
                setState(() { _isPeix = value; });
              }),
              buildCheckbox("Pizza", _isPizza, (bool value) {
                setState(() { _isPizza = value; });
              }),
              buildCheckbox("Vega", _isVega, (bool value) {
                setState(() { _isVega = value; });
              }),
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
      controlAffinity: ListTileControlAffinity.leading,  // Pone el checkbox al inicio del ListTile
    );
  }
}
