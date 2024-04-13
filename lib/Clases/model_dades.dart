import 'package:flutter/material.dart';
import 'package:dish_dash/Clases/Plat.dart';

class ModelDades extends ChangeNotifier {
  List<Plat> _carritoGlobal = [];

  List<Plat> get carritoGlobal => _carritoGlobal;

  void agregarAlCarrito(Plat plato) {
    int index = _carritoGlobal.indexWhere((item) => item.nombrePlato == plato.nombrePlato);
    if (index != -1) {
      _carritoGlobal[index].cantidad++;
    } else {
      _carritoGlobal.add(plato);
    }
    notifyListeners();
  }

  void aumentarCantidad(Plat plato) {
    int index = _carritoGlobal.indexWhere((item) => item.nombrePlato == plato.nombrePlato);
    if (index != -1) {
      _carritoGlobal[index].cantidad++;
      notifyListeners();
    }
  }

  void reducirCantidad(Plat plato) {
    int index = _carritoGlobal.indexWhere((item) => item.nombrePlato == plato.nombrePlato);
    if (index != -1 && _carritoGlobal[index].cantidad > 1) {
      _carritoGlobal[index].cantidad--;
    } else {
      _carritoGlobal.removeAt(index);
    }
    notifyListeners();
  }

  void removerDelCarrito(Plat plato) {
    _carritoGlobal.removeWhere((item) => item.nombrePlato == plato.nombrePlato);
    notifyListeners();
  }

  void vaciarCarrito() {
    _carritoGlobal.clear();
    notifyListeners();
  }
}
