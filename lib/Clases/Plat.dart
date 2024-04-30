import 'package:cloud_firestore/cloud_firestore.dart';

class Plat {
  String idPlat;
  String imageUrl;
  String nombrePlato;
  String descripcion;
  List<String> ingredientes;
  double precio;
  int cantidad;
  Map<String, bool> caracteristicas;

  Plat({
    required this.idPlat,
    required this.imageUrl,
    required this.nombrePlato,
    required this.descripcion,
    required this.ingredientes,
    required this.precio,
    this.cantidad = 1,
    required this.caracteristicas,
  });

  // Método de fábrica adaptable basado en el tipo de plato
  factory Plat.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String tipoPlato = data['TipoPlato'];  // Asume que cada documento tiene un campo 'TipoPlato'

    // Definiendo mapas de características para cada tipo de plato
    Map<String, Map<String, bool>> characteristicsForType = {
      'PrimersPlats': {
        'Carn': data['Carn'] ?? false,
        'Celiacs': data['Celiacs'] ?? false,
        'Pasta': data['Pasta'] ?? false,
        'Peix': data['Peix'] ?? false,
        'Pizza': data['Pizza'] ?? false,
        'Vega': data['Vega'] ?? false,
      },
      'Postre': {
        'Calents': data['Calents'] ?? false,
        'Freds': data['Freds'] ?? false,
        'Fruita': data['Fruita'] ?? false,
        'Gelats': data['Gelats'] ?? false,
        'SemiFreds': data['SemiFreds'] ?? false,
      },
      'Entrants': {
        'Amanides': data['Amanides'] ?? false,
        'Fregits': data['Fregits'] ?? false,
      }
    };

    // Asegurándonos de obtener el mapa correcto de características según el tipo de plato o un mapa vacío si no se encuentra
    Map<String, bool> selectedCharacteristics = characteristicsForType[tipoPlato] ?? {};

    return Plat(
      idPlat: doc.id,
      imageUrl: data['ImageUrl'] ?? '',
      nombrePlato: data['NombrePlato'] ?? '',
      descripcion: data['Descripcion'] ?? '',
      ingredientes: List<String>.from(data['Ingredientes'] ?? []),
      precio: (data['Precio'] ?? 0.0).toDouble(),
      cantidad: data['Cantidad'] ?? 1,
      caracteristicas: selectedCharacteristics,
    );
  }
}
