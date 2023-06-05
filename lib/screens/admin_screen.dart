import 'package:flutter/material.dart';
import 'package:gestionrh/screens/admin/hours_screen.dart';
import 'admin/department_screen.dart';
import 'admin/employee_main_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.options),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildButton(context, AppLocalizations.of(context)!.department, Icons.business, 0),
          _buildButton(context, AppLocalizations.of(context)!.employees, Icons.people, 1),
          _buildButton(context, AppLocalizations.of(context)!.hours, Icons.access_time, 2),
          _buildButton(context, 'Placeholder', Icons.help, 3),
          _buildButton(context, 'Placeholder', Icons.help, 4),
          _buildButton(context, 'Placeholder', Icons.help, 5),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData iconData, int index) {
    return InkWell(
      onTap: () {
        // Acción al pulsar cada botón.
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DepartmentsScreen()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmployeeScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HoursScreen()),
            );
            break;
        // Agregar más casos para otros botones si es necesario
        // case 'Empleados':
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => EmployeesScreen()),
        //   );
        //   break;
        // ...
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 60, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}