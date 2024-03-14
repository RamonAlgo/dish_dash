class Plat {
   String imageUrl;
   String nombrePlato;
   String descripcion;
   List<String> ingredientes;
   double precio;

  Plat({
    required this.imageUrl,
    required this.nombrePlato,
    required this.descripcion,
    required this.ingredientes,
     required this.precio,
  });

//getters
 String get getImageUrl => imageUrl;
  String get getNombre => nombrePlato;
  String get getDescripcion => descripcion;
  List<String> get getIngredientes => ingredientes;
  double get getPrecio => precio;


//seters
set setimageurl(String imageURL){imageUrl = imageURL;}
set setnombre(String nombre){nombrePlato = nombre;}
set setdescripcion(String descripcionPlato){descripcion = descripcionPlato;}
set setingredientes (List<String> ingredientesPlato){ingredientesPlato=ingredientes;}
set setpreu(double precioPlato){precio = precioPlato;}


}
