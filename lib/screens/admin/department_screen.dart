import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'department_edit_screen.dart';

class DepartmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('departamentos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              final String nombre = data['nombre'] ?? ''; // Si es null, se asignará una cadena vacía.
              final String descripcion = data['description'] ?? ''; // Si es null, se asignará una cadena vacía.
              final String gerenteAsignado = data['gerenteAsignado'] ?? ''; // Si es null, se asignará una cadena vacía.

              return ListTile(
                title: Text(nombre),
                subtitle: Text(descripcion),
                trailing: Text(gerenteAsignado),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DepartmentEditScreen(document.id)));
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}