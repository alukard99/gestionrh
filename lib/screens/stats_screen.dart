import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_extension.dart';
class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();

}

class _StatsScreenState extends State<StatsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<PieChartSectionData> _sections = []; //Secciones del gráfico vacio.
  DateTime _selectedMonth = DateTime.now(); //El mes por defecto es el actual.

  // Mapa de colores por categoría
  final Map<int, Color> _categoryColors = {
    0: const Color(0xFF006400),
    1: const Color(0xFF8B0000),
    2: const Color(0xFF00008B),
    3: const Color(0xFF8B008B),
    4: const Color(0xFF008B8B),
  };

  final List<int> _years = List<int>.generate(101, (i) => 2000 + i);
  String _userId = '';


  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() { //Comprueba que se hayan cargado las dependencias antes de cargar los datos.
    super.didChangeDependencies();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.stats),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _sections.isNotEmpty
                  ? Container(
                height: 400, // define el alto del contenedor
                child: PieChart(
                  PieChartData(
                    sections: _sections,
                  ),
                ),
              )
                  : Expanded(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.noData,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: _selectedMonth.month.toString(),
                    items: List.generate(12, (index) {
                      return DropdownMenuItem<String>(
                        value: (index + 1).toString(),
                        child: Text(
                            AppLocalizations.of(context)!.getMonth(index + 1)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth =
                            DateTime(_selectedMonth.year, int.parse(value!));
                        _fetchData();
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedMonth.year.toString(),
                    items: _years.map((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth =
                            DateTime(int.parse(value!), _selectedMonth.month);
                        _fetchData();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'User ID: $_userId',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user != null ? user.uid : '';

    // Inicializa los totales de horas a 0 para cada categoría
    Map<int, double> hourTotals = {
      1: 0.0, // Horas normales
      2: 0.0, // Horas extra
      3: 0.0, // Horas vacaciones
      4: 0.0, // Horas baja médica
      5: 0.0, // Horas festivas
    };

    // Mapa para convertir números de categorías a nombres de categoría
    Map<int, String> categoryNames = {
      1: AppLocalizations.of(context)!.normalHours,
      2: AppLocalizations.of(context)!.extraHours,
      3: AppLocalizations.of(context)!.vacationHours,
      4: AppLocalizations.of(context)!.medicalLeaveHours,
      5: AppLocalizations.of(context)!.festiveHours,
    };

    //Consulta para recibir registros
    QuerySnapshot snapshot = await _firestore
        .collection('horas')
        .where('userId', isEqualTo: userId)
        .where('date_year', isEqualTo: _selectedMonth.year)
        .where('date_month', isEqualTo: _selectedMonth.month)
        .get();

    // Suma las horas de cada documento a los totales de horas correspondientes
    for (var doc in snapshot.docs) {
      final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      final categoryNum = data?['category'];
      final hours = data?['hours'];

      hourTotals[categoryNum] = (hourTotals[categoryNum] ?? 0) + hours;
    }

    // Crea las secciones de la gráfica a partir de los totales de horas
    List<PieChartSectionData> sections = [];
    hourTotals.forEach((categoryNum, hours) {
      if (hours > 0) {
        final categoryName = categoryNames[categoryNum] ?? 'Desconocido';
        final hourStr = (hours % 1 == 0) ? hours.toInt().toString() : hours.toStringAsFixed(1);
        sections.add(
          PieChartSectionData(
            color: _categoryColors[categoryNum],
            value: hours,
            title: '$categoryName: ${hourStr}h', //Formato de las horas mostradas en el gráfico
            radius: 150,
            titleStyle: const TextStyle(fontSize: 15, color: Colors.white),
            titlePositionPercentageOffset: 0.55,
          ),
        );
      }
    });

    // Actualiza el estado con las nuevas secciones
    setState(() {
      _sections = sections;
      setState(() {  // Actualizamos el userId en el estado
        _userId = userId;
      });
    });
  }
}