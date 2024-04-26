import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class PaginaEstadisticasAdministrador extends StatefulWidget {
  const PaginaEstadisticasAdministrador({Key? key}) : super(key: key);

  @override
  State<PaginaEstadisticasAdministrador> createState() =>
      _PaginaEstadisticasAdministradorState();
}

class _PaginaEstadisticasAdministradorState
    extends State<PaginaEstadisticasAdministrador> {
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
        title: Text('Estadísticas del Restaurante'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.orange.shade100,
              Colors.orange.shade200,
              Colors.orange.shade300,
            ],
          ),
        ),
        child: Column(
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
                  } else if (snapshot.data!.isEmpty) {
                    return Center(child: Text('No hay datos disponibles'));
                  } else {
                    final data = snapshot.data!;
                    return ChartWithLegend(data: data);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartWithLegend extends StatelessWidget {
  final List<DocumentSnapshot> data;

  ChartWithLegend({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = data.map((doc) {
      final count = doc['cantidad'] as int;
      final index = data.indexOf(doc);
      return PieChartSectionData(
        color: Colors.primaries[index % Colors.primaries.length],
        value: count.toDouble(),
        title: '$count',
        radius: 250,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 0,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];
              return ListTile(
                leading: Icon(Icons.circle, color: Colors.primaries[index % Colors.primaries.length]),
                title: Text(doc['nom']),
                subtitle: Text('Cantidad vendida: ${doc['cantidad']}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
