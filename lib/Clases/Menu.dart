class Menu {
  String descripcion;
  List<String> idsPlatos;
  String imageUrl;
  String nombreMenu;
  double precio;
  String tipoPlato;

  Menu({
    required this.descripcion,
    required this.idsPlatos,
    required this.imageUrl,
    required this.nombreMenu,
    required this.precio,
  }) : tipoPlato = "Menu";


  @override
  String toString() {
    return 'Menu(nombreMenu: $nombreMenu, descripcion: $descripcion, idsPlatos: $idsPlatos, imageUrl: $imageUrl, precio: $precio, tipoPlato: $tipoPlato)';
  }
}