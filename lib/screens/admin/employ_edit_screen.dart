import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class EmployeeEditScreen extends StatefulWidget {
  final String employeeId;

  EmployeeEditScreen(this.employeeId);

  @override
  _EmployeeEditScreenState createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _dni;
  String? _puesto;
  String? _departamento;

  @override
  void initState() {
    super.initState();

    // Carga el registro del empleado de Firestore
    FirebaseFirestore.instance.collection('empleados').doc(widget.employeeId).get().then((snapshot) {
      setState(() {
        final data = snapshot.data() as Map<String, dynamic>;
        _dni = data['dni'];
        _puesto = data['puesto'];
        _departamento = data['departamento'];
      });
    });
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      // Si el formulario es correcto, se sube a Firestore
      _formKey.currentState!.save();
      FirebaseFirestore.instance.collection('empleados').doc(widget.employeeId).update({
        'dni': _dni,
        'puesto': _puesto,
        'departamento': _departamento,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si los datos aún no se han cargado, muestra un spinner.
    if (_dni == null || _puesto == null || _departamento == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Una vez que los datos estén disponibles, muestra los campos de formulario.
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editEmployee),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Campos para editar al empleado
            TextFormField( //Campo DNI
              initialValue: _dni,
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
            TextFormField( //Campo puesto
              initialValue: _puesto,
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
            TextFormField( //Campo departamento
              initialValue: _departamento,
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
            ElevatedButton(
              onPressed: _saveEmployee,
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }
}