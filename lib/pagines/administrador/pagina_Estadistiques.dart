import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class paginaEstadistiquesAdministrador extends StatefulWidget {
  const paginaEstadistiquesAdministrador({Key? key}) : super(key: key);

  @override
  State<paginaEstadistiquesAdministrador> createState() =>
      _PaginaEstadisticasAdministradorState();
}

class _PaginaEstadisticasAdministradorState
    extends State<paginaEstadistiquesAdministrador> {
  late Stream<List<DocumentSnapshot>> _stream;
  late String _selectedYear;
  late String _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year.toString();
    _selectedMonth = DateTime.now().month.toString().padLeft(2, '0');
    _updateStream();
  }

  void _updateStream() {
    setState(() {
      _stream = FirebaseFirestore.instance
          .collection('estadisticas')
          .doc(_selectedYear)
          .collection('meses')
          .doc(_selectedMonth)
          .collection('platos')
          .snapshots()
          .map((snapshot) => snapshot.docs);
    });
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadistiques'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _selectedYear,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedYear = newValue;
                        _updateStream();
                      });
                    }
                  },
                  items: List.generate(5, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem(
                      value: year.toString(),
                      child: Text(year.toString()),
                    );
                  }),
                ),
                SizedBox(width: 20),
                DropdownButton<String>(
                  value: _selectedMonth,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedMonth = newValue;
                        _updateStream();
                      });
                    }
                  },
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: (index + 1).toString().padLeft(2, '0'),
                      child: Text((index + 1).toString().padLeft(2, '0')),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final data = snapshot.data!;
                  List<FlSpot> spots = [];
                  for (var i = 0; i < data.length; i++) {
                    final recuento = data[i]['cantidad'] ?? 0;
                    spots.add(FlSpot(i.toDouble(), recuento.toDouble()));
                  }

                  return spots.isNotEmpty
                      ? ChartWithLegend(spots: spots, data: data)
                      : Text('No hay datos disponibles');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChartWithLegend extends StatelessWidget {
  final List<FlSpot> spots;
  final List<DocumentSnapshot> data;

  const ChartWithLegend({Key? key, required this.spots, required this.data})
      : super(key: key);

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
                  color: Colors
                      .primaries[spots.indexOf(spot) % Colors.primaries.length],
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
              final nom = data[index]['nom'];
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
                      'Plato $nom',
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
