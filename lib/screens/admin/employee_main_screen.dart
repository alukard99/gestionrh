import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'employ_edit_screen.dart';
class EmployeeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EmployeeSearch("dni"), // Aquí se proporciona "dni" como campo de búsqueda
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('empleados').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['dni']),
                subtitle: Text('${data['puesto']} - ${data['departamento']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeEditScreen(document.id), // Navega a la pantalla de edición con el id del empleado.
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class EmployeeSearch extends SearchDelegate<String> {
  final String searchField;

  EmployeeSearch(this.searchField);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults(context);
  }

  Widget _buildResults(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('empleados').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        final results = snapshot.data!.docs.where((DocumentSnapshot document) {
          final data = document.data() as Map<String, dynamic>;
          final fieldValue = data[searchField]?.toString().toLowerCase() ?? '';
          return fieldValue.contains(query.toLowerCase());
        });

        return ListView(
          children: results.map((document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['dni']),
              subtitle: Text('${data['puesto']} - ${data['departamento']}'),
              onTap: () {
                close(context, "");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeEditScreen(document.id), // Navega a la pantalla de edición con el id del empleado.
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}