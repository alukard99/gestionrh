import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DepartmentsScreen extends StatefulWidget {
  @override
  _DepartmentsScreenState createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _description = '';
  String _managerAssigned = '';
  String _name = '';

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear departamento'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.plsaddname;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.description),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.manager),
                onChanged: (value) {
                  setState(() {
                    _managerAssigned = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(AppLocalizations.of(context)!.addDepartment),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Guardar los datos en Firestore
      _firestore.collection('departamentos').add({
        'nombre': _name,
        'description': _description,
        'gerenteAsignado': _managerAssigned,
      });

      // Mostrar un mensaje de éxito y cerrar la pantalla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.succesfulDepartment)),
      );
      Navigator.pop(context);
    }
  }
}