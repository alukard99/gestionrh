import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HoursScreen extends StatefulWidget {
  @override
  _HoursScreenState createState() => _HoursScreenState();
}

class _HoursScreenState extends State<HoursScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final _searchController = TextEditingController();
  String _searchType = 'hours';
  List<DocumentSnapshot> _fullData = []; // Esta es la lista completa de datos
  List<DocumentSnapshot> _data = []; // Esta es la lista de datos filtrados

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final snapshot = await _firestore
        .collection('horas')
        .where('userId', isEqualTo: _user?.uid)
        .orderBy('insertDate', descending: true)
        .get();

    setState(() {
      _fullData = snapshot.docs; // Almacenamos todos los datos en _fullData
      _data = _fullData; // Y también los copiamos a _data
    });
  }

  void _search() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        _data = _fullData.where((doc) { // La búsqueda se realiza sobre _fullData
          final data = doc.data() as Map<String, dynamic>;
          final searchField = data[_searchType];
          if (searchField is int) {
            final queryInt = int.tryParse(query);
            if (queryInt != null) {
              return searchField == queryInt;
            }
          } else if (searchField is String) {
            return searchField.contains(query);
          }
          return false;
        }).toList();
      });
    } else {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.hours),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _searchType,
                  items: <String>[
                    'hours',
                    'date_day',
                    'date_month',
                    'date_year'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _searchType = newValue!;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.search,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _search,
                      ),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _data.isEmpty
                ? Center(child: Text(AppLocalizations.of(context)!.noData))
                : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final doc = _data[index];
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(
                    '${data['date_day']}/${data['date_month']}/${data['date_year']}',
                  ),
                  subtitle: Text('${AppLocalizations.of(context)!.hours}: ${data['hours']}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditHoursScreen(docId: doc.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EditHoursScreen extends StatefulWidget {
  final String docId;

  EditHoursScreen({required this.docId});

  @override
  _EditHoursScreenState createState() => _EditHoursScreenState();
}

class _EditHoursScreenState extends State<EditHoursScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  void dispose() {
    _hoursController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _deleteData() async {
    await _firestore.collection('horas').doc(widget.docId).delete();

    // Muestra un SnackBar para informar al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.hourDeleted)),
    );

    // Regresa a la pantalla anterior
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editHours),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('horas').doc(widget.docId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;
          _hoursController.text = data['hours'].toString();
          _dayController.text = data['date_day'].toString();
          _monthController.text = data['date_month'].toString();
          _yearController.text = data['date_year'].toString();
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _hoursController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.hours),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.plsaddhours;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dayController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.day),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.plsaddday;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _monthController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.month),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.plsaddmonth;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _yearController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.year),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.plsaddyear;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.editHours),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Si el formulario es válido, actualizamos el documento en Firestore
                        _firestore
                            .collection('horas')
                            .doc(widget.docId)
                            .update({
                          'hours': int.parse(_hoursController.text),
                          'date_day': int.parse(_dayController.text),
                          'date_month': int.parse(_monthController.text),
                          'date_year': int.parse(_yearController.text),
                        }).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppLocalizations.of(context)!.saved)),
                          );
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.red, // Color del texto
                    ),
                    onPressed: _deleteData,
                    child: Text(AppLocalizations.of(context)!.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}