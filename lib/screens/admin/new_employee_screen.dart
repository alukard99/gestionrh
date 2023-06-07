import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewEmployeeScreen extends StatefulWidget {
  @override
  _NewEmployeeScreenState createState() => _NewEmployeeScreenState();
}

class _NewEmployeeScreenState extends State<NewEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _dni;
  String? _name;
  String? _puesto;
  String? _departamento;
  double? _salario;

  void _createEmployee() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FirebaseFirestore.instance.collection('empleados').add({
        'dni': _dni,
        'name': _name,
        'puesto': _puesto,
        'departamento': _departamento,
        'salario': _salario,
      }).then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createEmployee),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.dni),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.plsadddni;
                }
                return null;
              },
              onSaved: (value) {
                _dni = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.plsaddname;
                }
                return null;
              },
              onSaved: (value) {
                _name = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.position),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.plsaddposition;
                }
                return null;
              },
              onSaved: (value) {
                _puesto = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.department),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.plsadddepartment;
                }
                return null;
              },
              onSaved: (value) {
                _departamento = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.salary),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.plsaddsalary;
                }
                return null;
              },
              onSaved: (value) {
                _salario = double.tryParse(value!);
              },
            ),
            ElevatedButton(
              onPressed: _createEmployee,
              child: Text(AppLocalizations.of(context)!.create),
            ),
          ],
        ),
      ),
    );
  }
}