import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: Text('Calendario'),
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
              stream: _firestore
                  .collection('horas')
                  .where('userId', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                // Filtrar los documentos por la fecha seleccionada
                final List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
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
                    String category = hourData['category'];

                    return ListTile(
                      title: Text('${date.day}/${date.month}/${date.year}'),
                      subtitle: Text('Horas: $hours, Categoría: $category'), // Muestra la categoría
                    );
                  },
                );
              },
            )
                : Center(
              child: Text('Selecciona una fecha en el calendario'),
            ),
          ),
        ],
      ),
    );
  }
}