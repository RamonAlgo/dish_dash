import 'package:cloud_firestore/cloud_firestore.dart';

class Plat {
  String idPlat;
  String imageUrl;
  String nombrePlato;
  String descripcion;
  List<String> ingredientes;
  double precio;
  int cantidad;
  bool carn;
  bool celiacs;
  bool pasta;
  bool peix;
  bool pizza;
  bool vega;

  Plat({
    required this.idPlat,
    required this.imageUrl,
    required this.nombrePlato,
    required this.descripcion,
    required this.ingredientes,
    required this.precio,
    this.cantidad = 1,
    this.carn = false,
    this.celiacs = false,
    this.pasta = false,
    this.peix = false,
    this.pizza = false,
    this.vega = false,
  }) {
    assert(precio >= 0, 'El precio debe ser un valor positivo.');
  }

  // Getters
  String get getImageUrl => imageUrl;
  String get getNombre => nombrePlato;
  String get getDescripcion => descripcion;
  List<String> get getIngredientes => ingredientes;
  double get getPrecio => precio;
  int get getCantidad => cantidad;
  bool get getCarn => carn;
  bool get getCeliacs => celiacs;
  bool get getPasta => pasta;
  bool get getPeix => peix;
  bool get getPizza => pizza;
  bool get getVega => vega;

  // Setters
  set setImageUrl(String imageUrl) => this.imageUrl = imageUrl;
  set setNombre(String nombre) => nombrePlato = nombre;
  set setDescripcion(String descripcion) => this.descripcion = descripcion;
  set setIngredientes(List<String> ingredientes) => this.ingredientes = ingredientes;
  set setPrecio(double precio) => this.precio = precio;
  set setCantidad(int nuevaCantidad) {
    if (nuevaCantidad >= 0) {
      cantidad = nuevaCantidad;
    }
  }
  set setCarn(bool carn) => this.carn = carn;
  set setCeliacs(bool celiacs) => this.celiacs = celiacs;
  set setPasta(bool pasta) => this.pasta = pasta;
  set setPeix(bool peix) => this.peix = peix;
  set setPizza(bool pizza) => this.pizza = pizza;
  set setVega(bool vega) => this.vega = vega;

  factory Plat.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Plat(
      idPlat: doc.id,
      imageUrl: data['ImageUrl'] ?? '',
      nombrePlato: data['NombrePlato'] ?? '',
      descripcion: data['Descripcion'] ?? '',
      ingredientes: List<String>.from(data['Ingredientes'] ?? []),
      precio: (data['Precio'] ?? 0.0).toDouble(),
      cantidad: 1,
      carn: data['Carn'] ?? false,
      celiacs: data['Celiacs'] ?? false,
      pasta: data['Pasta'] ?? false,
      peix: data['Peix'] ?? false,
      pizza: data['Pizza'] ?? false,
      vega: data['Vega'] ?? false,
    );
  }
}
