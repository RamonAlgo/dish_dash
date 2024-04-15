import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class paginaEstadistiquesAdministrador extends StatefulWidget {
  const paginaEstadistiquesAdministrador({Key? key}) : super(key: key);

  @override
  State<paginaEstadistiquesAdministrador> createState() => _PaginaEstadisticasAdministradorState();
}

class _PaginaEstadisticasAdministradorState extends State<paginaEstadistiquesAdministrador> {
  late Stream<List<DocumentSnapshot>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('estadisticas').snapshots().map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas'),
      ),
      body: Center(
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data!;
              List<FlSpot> spots = [];
              for (var i = 0; i < data.length; i++) {
                final recuento = data[i]['cantidad'] ?? 0;
                spots.add(FlSpot(i.toDouble(), recuento.toDouble()));
              }

              return spots.isNotEmpty ? ChartWithLegend(spots: spots, data: data) : Text('No hay datos disponibles');
            }
          },
        ),
      ),
    );
  }
}

class ChartWithLegend extends StatelessWidget {
  final List<FlSpot> spots;
  final List<DocumentSnapshot> data;

  const ChartWithLegend({Key? key, required this.spots, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sections: spots.map((spot) {
                return PieChartSectionData(
                  color: Colors.primaries[spots.indexOf(spot) % Colors.primaries.length],
                  value: spot.y,
                  title: '${spot.y}',
                  radius: 100,
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: spots.map((spot) {
              final index = spots.indexOf(spot);
              final id = data[index].id; 
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: Colors.primaries[index % Colors.primaries.length],
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Plato $id',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
