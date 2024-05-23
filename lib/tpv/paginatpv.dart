import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class paginaTPV extends StatefulWidget {
  const paginaTPV({Key? key}) : super(key: key);

  @override
  State<paginaTPV> createState() => _PaginaTPVState();
}

class _PaginaTPVState extends State<paginaTPV> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TPV'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('tpv')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No hay pedidos pendientes."));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var pedido = snapshot.data!.docs[index];
              var platos = pedido['platos'] as List<dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(
                      'Mesa ${pedido['mesaId']} - Total: ${pedido['total']}€'),
                  subtitle: Text(
                      'Fecha: ${DateTime.fromMillisecondsSinceEpoch(pedido['fecha'].millisecondsSinceEpoch).toString()}'),
                  children: [
                    ...platos.map<Widget>((plat) {
                      return ListTile(
                        title: Text(plat['nom']),
                        subtitle: Text(
                            'Cantidad: ${plat['cantitat']} - Precio por unidad: ${plat['preu']}€'),
                        trailing: Text('Total: ${plat['preuTotalPlato']}€'),
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => marcarComoPagado(pedido),
                        child: Text('Marcar como pagado'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => generarTicket(pedido),
                        child: Text('Generar Ticket'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void marcarComoPagado(QueryDocumentSnapshot pedido) {
    var platos = pedido['platos'] as List<dynamic>;
    DateTime fechaActual = DateTime.now();
    String anio = '${fechaActual.year}';
    String mes = fechaActual.month.toString().padLeft(2, '0');

    WriteBatch batch = _firestore.batch();
    double totalPedido = 0;

    for (var plat in platos) {
      var platId = plat['idPlat'];
      var nomPlat = plat['nom'];

      var cantidad = plat['cantitat'] as int;
      var precioTotalPlato = plat['preuTotalPlato'] as double;
      totalPedido += precioTotalPlato;

      DocumentReference platRef = _firestore
          .collection('estadisticas')
          .doc(anio)
          .collection('meses')
          .doc(mes)
          .collection('platos')
          .doc(platId);

      batch.set(
          platRef,
          {'cantidad': FieldValue.increment(cantidad), 'nom': nomPlat},
          SetOptions(merge: true));
    }

    DocumentReference facturacionRef = _firestore
        .collection('estadisticas')
        .doc(anio)
        .collection('meses')
        .doc(mes)
        .collection('facturacion')
        .doc('total');
    batch.set(facturacionRef, {'total': FieldValue.increment(totalPedido)},
        SetOptions(merge: true));
    batch.delete(_firestore.collection('tpv').doc(pedido.id));

    batch.commit().then((_) {
      showAwesomeSnackbar(
          context,
          'Pedido marcado como pagado y estadísticas actualizadas. Pedido eliminado de la lista.',
          ContentType.success);
    }).catchError((error) {
      showAwesomeSnackbar(context, 'Error al actualizar estadísticas: $error',
          ContentType.failure);
    });
  }

  Future<Map<String, dynamic>?> _fetchRestaurantData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('dadesrestaurant')
          .doc('dades')
          .get();

      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>?;
      } else {
        print("El documento no existe");
        return null;
      }
    } catch (e) {
      throw Exception('Error al obtener datos: $e');
    }
  }

  Future<pw.Font> loadCustomFont() async {
    try {
      final fontData = await rootBundle.load('fonts/OpenSans.ttf');
      return pw.Font.ttf(fontData);
    } catch (e) {
      print("Failed to load font: $e");
      throw e;
    }
  }

  void generarTicket(QueryDocumentSnapshot pedido) async {
    final restaurantData = await _fetchRestaurantData();

    if (restaurantData == null) {
      showAwesomeSnackbar(
          context, 'Error al obtener los datos del restaurante.', ContentType.failure);
      return;
    }

    final pdf = pw.Document();
    final customFont = await loadCustomFont();

    var platos = pedido['platos'] as List<dynamic>;
    double total = double.parse(pedido['total'].toString());
    double baseImponible = total / 1.10;
    double iva = total - baseImponible;
    final mesaId = pedido['mesaId']?.replaceAll(RegExp(r'[^0-9]'), '');
    DateTime fechaPedido = DateTime.fromMillisecondsSinceEpoch(
        pedido['fecha'].millisecondsSinceEpoch);
    String hora = fechaPedido.hour.toString().padLeft(2, '0');
    String minuto = fechaPedido.minute.toString().padLeft(2, '0');
    String fechaFormateada = '$hora:$minuto';

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw
          .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text('Restaurante ${restaurantData['name']}',
            style:
                pw.TextStyle(font: customFont, fontWeight: pw.FontWeight.bold)),
        pw.Text('Fecha: $fechaFormateada',
            style: pw.TextStyle(font: customFont)),
        pw.Text('Ubicación: ${restaurantData['location']}'),
        pw.Text('N.I.F.: ${restaurantData['nif']} - Tel: ${restaurantData['phone']}'),
        pw.Text('Barcelona'),
        pw.Text('E-Mail: ${restaurantData['email']}'),
        pw.Text('Mesa: $mesaId',
            style: pw.TextStyle(
                font: customFont,
                fontSize: 14,
                fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
                flex: 4,
                child: pw.Text('Descripción',
                    style: pw.TextStyle(font: customFont))),
            pw.Expanded(
                flex: 2,
                child:
                    pw.Text('Unidades', style: pw.TextStyle(font: customFont))),
            pw.Expanded(
                flex: 2,
                child:
                    pw.Text('Precio', style: pw.TextStyle(font: customFont))),
            pw.Expanded(
                flex: 2,
                child: pw.Text('Total', style: pw.TextStyle(font: customFont))),
          ],
        ),
        pw.Divider(),
        ...platos.map<pw.Widget>((plat) {
          return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  flex: 4,
                  child: pw.Text(plat['nom'],
                      style: pw.TextStyle(font: customFont)),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('${plat['cantitat']}',
                      style: pw.TextStyle(font: customFont)),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('${plat['preu']}€',
                      style: pw.TextStyle(font: customFont)),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('${plat['preuTotalPlato']}€',
                      style: pw.TextStyle(font: customFont)),
                ),
              ]);
        }),
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text('Base Imponible: ${baseImponible.toStringAsFixed(2)}€',
                style: pw.TextStyle(font: customFont)),
            pw.SizedBox(width: 16),
            pw.Text('IVA (10%): ${iva.toStringAsFixed(2)}€',
                style: pw.TextStyle(font: customFont)),
          ],
        ),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text('Total: ${total.toStringAsFixed(2)}€',
              style: pw.TextStyle(
                  font: customFont,
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold)),
        ),
      ]);
    }));

    Uint8List pdfData = await pdf.save();
    await Printing.sharePdf(
        bytes: pdfData,
        filename:
            'Factura-${pedido['mesaId']}-${pedido['fecha'].millisecondsSinceEpoch}.pdf');
  }

  void showAwesomeSnackbar(
      BuildContext context, String message, ContentType contentType) {
    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: AwesomeSnackbarContent(
        title: contentType == ContentType.success ? 'Éxito' : 'Error',
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
