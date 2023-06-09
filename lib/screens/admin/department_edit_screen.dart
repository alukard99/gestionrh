import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentEditScreen extends StatefulWidget {
  final String departmentId;

  DepartmentEditScreen(this.departmentId);

  @override
  _DepartmentEditScreenState createState() => _DepartmentEditScreenState();
}

class _DepartmentEditScreenState extends State<DepartmentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _nombre;
  String? _descripcion;
  String? _gerenteAsignado;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('departamentos').doc(widget.departmentId).get().then((snapshot) {
      setState(() {
        final data = snapshot.data() as Map<String, dynamic>;
        _nombre = data['nombre'];
        _descripcion = data['description'];
        _gerenteAsignado = data['gerenteAsignado'];
      });
    });
  }

  void _saveDepartment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FirebaseFirestore.instance.collection('departamentos').doc(widget.departmentId).update({
        'nombre': _nombre,
        'description': _descripcion,
        'gerenteAsignado': _gerenteAsignado,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Department'),
      ),
      body: _nombre == null || _descripcion == null || _gerenteAsignado == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),  // Ajusta el valor según tus necesidades
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _nombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nombre = value;
                },
              ),
              TextFormField(
                initialValue: _descripcion,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _descripcion = value;
                },
              ),
              TextFormField(
                initialValue: _gerenteAsignado,
                decoration: InputDecoration(labelText: 'Gerente Asignado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter assigned manager';
                  }
                  return null;
                },
                onSaved: (value) {
                  _gerenteAsignado = value;
                },
              ),
              ElevatedButton(
                onPressed: _saveDepartment,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}