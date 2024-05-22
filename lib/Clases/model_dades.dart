import 'package:flutter/material.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/Menu.dart';

class ModelDades extends ChangeNotifier {
  List<Plat> _carritoGlobal = [];
  List<Menu> _menusGlobal = [];

  List<Plat> get carritoGlobal => _carritoGlobal;
  List<Menu> get menusGlobal => _menusGlobal;

  void agregarAlCarrito(Plat plato) {
    int index = _carritoGlobal.indexWhere((item) => item.nombrePlato == plato.nombrePlato);
    if (index != -1) {
      _carritoGlobal[index].cantidad++;
    } else {
      _carritoGlobal.add(plato);
    }
    notifyListeners();
  }

  void agregarMenuAlCarrito(Menu menu) {
    int index = _menusGlobal.indexWhere((item) => item.nombreMenu == menu.nombreMenu);
    if (index != -1) {
      _carritoGlobal[index].cantidad++;
    } else {
      _menusGlobal.add(menu);
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

  void aumentarCantidadMenu(Menu menu) {
    int index = _menusGlobal.indexWhere((item) => item.nombreMenu == menu.nombreMenu);
    if (index != -1) {
      _menusGlobal[index].cantidad++;
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

  void reducirCantidadMenu(Menu menu) {
    int index = _menusGlobal.indexWhere((item) => item.nombreMenu == menu.nombreMenu);
    if (index != -1 && _menusGlobal[index].cantidad > 1) {
      _menusGlobal[index].cantidad--;
    } else {
      _menusGlobal.removeAt(index);
    }
    notifyListeners();
  }

  void removerDelCarrito(Plat plato) {
    _carritoGlobal.removeWhere((item) => item.nombrePlato == plato.nombrePlato);
    notifyListeners();
  }

  void removerMenuDelCarrito(Menu menu) {
    _menusGlobal.removeWhere((item) => item.nombreMenu == menu.nombreMenu);
    notifyListeners();
  }

  void vaciarCarrito() {
    _carritoGlobal.clear();
    _menusGlobal.clear();
    notifyListeners();
  }
}
