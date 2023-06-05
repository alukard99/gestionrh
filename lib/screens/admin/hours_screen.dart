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
  late Stream<QuerySnapshot> _stream;
  final _searchController = TextEditingController();
  String _searchType = 'hours';

  @override
  void initState() {
    super.initState();
    _stream = _firestore
        .collection('horas')
        .where('userId', isEqualTo: _user?.uid)
        .orderBy('insertDate', descending: true)
        .snapshots();
  }

  void _search() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      _stream = _firestore
          .collection('horas')
          .where('userId', isEqualTo: _user?.uid)
          .orderBy(_searchType)
          .startAt([int.parse(query)]).endAt([
        int.parse(query) + 1
      ]) // incremento de 1 para incluir el número buscado
          .snapshots();
    } else {
      _stream = _firestore
          .collection('horas')
          .where('userId', isEqualTo: _user?.uid)
          .orderBy('insertDate', descending: true)
          .snapshots();
    }
    setState(() {});
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        'Category: ${data['category']}, Hours: ${data['hours']}',
                      ),
                      subtitle: Text('Date: ${data['insertDate'].toDate()}'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditHoursScreen(docId: doc.id),
                        ),
                      ),
                    );
                  },
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
                  SizedBox(height: 20),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
