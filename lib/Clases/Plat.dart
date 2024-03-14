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

String get getnombre => nombrePlato;
double get getpreu => precio;

//seters
set setnombre(String nombre){nombrePlato = nombre;}
set setpreu(double precioPlato){precio = precioPlato;}
}
