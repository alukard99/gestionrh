import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'calendar_screen.dart';
import 'add_hours_screen.dart';
import 'stats_screen.dart';
import 'admin_screen.dart';
import 'options/options_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Agregar el índice de la página actual
  int _currentIndex = 2;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkIfAdmin();
  }
  //Comprueba si el usuario es administrador
  void _checkIfAdmin() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user != null ? user.uid : '';

    final QuerySnapshot adminUsers = await FirebaseFirestore.instance
        .collection('adminUsers') //El userId de los admin se encuentra en la colección "adminUsers"
        .where('userId', isEqualTo: userId)
        .get();

    if (adminUsers.docs.isNotEmpty) {
      setState(() {
        _isAdmin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionate'),
      ),
      body: _getBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey, // Cambiar el color de los ítems no seleccionados
        selectedItemColor: Colors.blue, // Cambiar el color del ítem seleccionado
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: AppLocalizations.of(context)!.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle_outline),
            label: AppLocalizations.of(context)!.addHours,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.hourglass_empty),
            label: AppLocalizations.of(context)!.admin,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.options,
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 3 && !_isAdmin) {
      // Si el usuario no es administrador y toca la opción de administrador, muestra un mensaje y no cambia la screen.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No tienes permiso para acceder a esta página.')));
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  // Método que devuelve el widget correspondiente al índice
  Widget _getBody(int index) {
    switch (index) {
      case 0:
        final User? user = FirebaseAuth.instance.currentUser;
        final String userId = user != null ? user.uid : '';
        return CalendarScreen(userId: userId); // Retorna el widget correspondiente a Calendario.
      case 1:
        return AddHoursScreen(); // Retorna el widget correspondiente a Agregar horas
      case 2:
        return StatsScreen(); // Retorna el widget correspondiente a Inicio
      case 3:
        return AdminScreen(); // Retorna el widget correspondiente a Admin
      case 4:
        return OptionsScreen(); // Retorna el widget correspondiente a Opciones
      default:
        return Container(); // Por si acaso
    }
  }
}