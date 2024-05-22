class Menu {
  String descripcion;
  List<String> idsPlatos;
  String imageUrl;
  String nombreMenu;
  double precio;
  String tipoPlato;
  int cantidad;
  String id;
  
  Menu({
    required this.descripcion,
    required this.idsPlatos,
    required this.nombreMenu,
    required this.precio,
    required this.id,
  })   : tipoPlato = "Menu",
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/dishdash-25346.appspot.com/o/menuinfantil.png?alt=media&token=672f7c01-ebfe-4fa9-a56c-ee57bea5bdc3',
        cantidad = 1;

  Map<String, dynamic> toJson() {
    return {
      'Descripcion': descripcion,
      'IDsPlatos': idsPlatos,
      'ImageUrl': imageUrl,
      'NombreMenu': nombreMenu,
      'Precio': precio,
      'TipoPlato': tipoPlato,
      'Cantidad': cantidad,
      'ID': id
    };
  }

  @override
  String toString() {
    return 'Menu(nombreMenu: $nombreMenu, descripcion: $descripcion, idsPlatos: $idsPlatos, imageUrl: $imageUrl, precio: $precio, tipoPlato: $tipoPlato, cantidad: $cantidad)';
  }
}
