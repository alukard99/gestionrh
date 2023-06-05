import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddHoursScreen extends StatefulWidget {
  @override
  _AddHoursScreenState createState() => _AddHoursScreenState();
}

class _AddHoursScreenState extends State<AddHoursScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hoursController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();
  int _selectedCategory = 1;

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Map<int, String> _categories = {
      0: AppLocalizations.of(context)!.normalHours,
      1: AppLocalizations.of(context)!.extraHours,
      2: AppLocalizations.of(context)!.vacationHours,
      3: AppLocalizations.of(context)!.medicalLeaveHours,
      4: AppLocalizations.of(context)!.festiveHours,
    };

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addHours),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              // Campo de texto para ingresar las horas
              TextFormField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.addHours,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.plsaddhours;
                  }
                  if (int.tryParse(value) == null) {
                    return AppLocalizations.of(context)!.plsaddint;
                  }
                  return null;
                },
              ),
              // Selector de fecha
              Row(
                children: [
                  Text(
                      '${DateFormat('dd/MM/yyyy').format(_selectedDate.toLocal())}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              // Selector de categoría
              DropdownButtonFormField<int>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.category,
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: _categories.keys.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(_categories[value]!),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(AppLocalizations.of(context)!.addHours),
              ),
            ]),
          ),
        ));
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      //Obtiene los datos del formulario
      final User? user = FirebaseAuth.instance.currentUser;
      final String userId = user != null ? user.uid : '';
      final int hours = int.parse(_hoursController.text);
      final int day = Timestamp.fromDate(_selectedDate).toDate().day;
      final int month = Timestamp.fromDate(_selectedDate).toDate().month;
      final int year = Timestamp.fromDate(_selectedDate).toDate().year;

      if (userId != '') {
        // Agrega las horas a Firestore
        await _firestore.collection('horas').add({
          'userId': userId,
          'date_day': day,
          'date_month': month,
          'date_year': year,
          'insertDate': Timestamp.fromDate(DateTime.now()),
          'hours': hours,
          'category': _selectedCategory,
        });

        // Limpia el formulario
        _formKey.currentState!.reset();
      }
    }
  }
}
