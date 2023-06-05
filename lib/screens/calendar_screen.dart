import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarScreen extends StatefulWidget {
  final String userId;

  CalendarScreen({required this.userId});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.calendar),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: _selectedDay != null
                ? StreamBuilder<QuerySnapshot>(
              // Comprueba si el usuario no es nulo (Ha cerrado sesión)
              stream: widget.userId != null
                  ? _firestore
                  .collection('horas')
                  .where('userId', isEqualTo: widget.userId)
                  .snapshots()
                  : Stream.empty(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      // Filtrar los documentos por la fecha seleccionada
                      final List<DocumentSnapshot> filteredDocs =
                          snapshot.data!.docs.where((doc) {
                        return doc['date_year'] == _selectedDay!.year &&
                            doc['date_month'] == _selectedDay!.month &&
                            doc['date_day'] == _selectedDay!.day;
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot hourData = filteredDocs[index];

                          // Construye el objeto DateTime a partir de los campos de la fecha
                          DateTime date = DateTime(
                            hourData['date_year'],
                            hourData['date_month'],
                            hourData['date_day'],
                          );

                          String hours = hourData['hours'].toString();
                          Map<int, String> categoryMap = {
                            0: AppLocalizations.of(context)!.addHours,
                            1: AppLocalizations.of(context)!.extraHours,
                            2: AppLocalizations.of(context)!.vacationHours,
                            3: AppLocalizations.of(context)!.medicalLeaveHours,
                            4: AppLocalizations.of(context)!.festiveHours,
                          };
                          int category = hourData['category'];
                          String sCategory = categoryMap[category] ?? AppLocalizations.of(context)!.unknowCategory;

                          // Formato de las horas mostradas
                          String formattedHours = "${hours}h";

                          return ListTile(
                            title: Text('${date.day}/${date.month}/${date.year}'),
                            subtitle: Text('$formattedHours, $sCategory'),
                          );
                        },
                      );
                    },
                  )
                : Center(
                    child: Text(AppLocalizations.of(context)!.plschoosedate),
                  ),
          ),
          FutureBuilder<QuerySnapshot>(
            future: _firestore
                .collection('horas')
                .where('userId', isEqualTo: widget.userId)
                .where('date_year', isEqualTo: _focusedDay.year)
                .where('date_month', isEqualTo: _focusedDay.month)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final int totalDays =
                  DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
              final int daysWithData = snapshot.data!.docs.length;
              final int daysWithoutData = totalDays - daysWithData;

              return Text('${AppLocalizations.of(context)!.dayswithoutdata}: $daysWithoutData');
            },
          ),
        ],
      ),
    );
  }
}
