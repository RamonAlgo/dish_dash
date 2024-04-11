class Plat {
   String idPlat;
   String imageUrl;
   String nombrePlato;
   String descripcion;
   List<String> ingredientes;
   double precio;
   int cantidad;

  Plat({
    required this.idPlat,
    required this.imageUrl,
    required this.nombrePlato,
    required this.descripcion,
    required this.ingredientes,
    required this.precio,
    this.cantidad = 1, 
  });

//getters
String get getImageUrl => imageUrl;
  String get getNombre => nombrePlato;
  String get getDescripcion => descripcion;
  List<String> get getIngredientes => ingredientes;
  double get getPrecio => precio;
  int get getCantidad => cantidad; // Getter para la cantidad


//seters
set setimageurl(String imageURL){imageUrl = imageURL;}
set setnombre(String nombre){nombrePlato = nombre;}
set setdescripcion(String descripcionPlato){descripcion = descripcionPlato;}
set setingredientes (List<String> ingredientesPlato){ingredientesPlato=ingredientes;}
set setpreu(double precioPlato){precio = precioPlato;}

  set setCantidad(int nuevaCantidad) {
    if (nuevaCantidad >= 0) { // Asegurar que la cantidad no sea negativa
      cantidad = nuevaCantidad;
    }
  }

}
