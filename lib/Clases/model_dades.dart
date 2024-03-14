import 'package:flutter/material.dart';
import 'package:dish_dash/Clases/Plat.dart';

class ModelDades extends ChangeNotifier {
  List<Plat> _carritoGlobal = [];

  List<Plat> get carritoGlobal => _carritoGlobal;

  void agregarAlCarrito(Plat plato) {
    _carritoGlobal.add(plato);
    notifyListeners();
  }

  void removerDelCarrito(Plat plato) {
    _carritoGlobal.remove(plato);
    notifyListeners();
  }

  void vaciarCarrito() {}

}
