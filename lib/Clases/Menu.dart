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
    required this.nombreMenu,
    required this.precio,
  })   : tipoPlato = "Menu",
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/dishdash-25346.appspot.com/o/menuinfantil.png?alt=media&token=672f7c01-ebfe-4fa9-a56c-ee57bea5bdc3';

  Map<String, dynamic> toJson() {
    return {
      'descripcion': descripcion,
      'idsPlatos': idsPlatos,
      'imageUrl': imageUrl,
      'nombreMenu': nombreMenu,
      'precio': precio,
      'tipoPlato': tipoPlato,
    };
  }

  @override
  String toString() {
    return 'Menu(nombreMenu: $nombreMenu, descripcion: $descripcion, idsPlatos: $idsPlatos, imageUrl: $imageUrl, precio: $precio, tipoPlato: $tipoPlato)';
  }
}
