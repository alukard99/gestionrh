import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Agrega un empleado
  Future<void> addEmpleado({
    required String dni,
    required String nombre,
    required String puesto,
    required int salario,
    required String departamento,
  }) async {
    await _firestore.collection('empleados').doc(dni).set({
      'puesto': puesto,
      'salario': salario,
      'departamento': departamento,
    });
  }

  // Agrega un departamento
  Future<void> addDepartamento({
    required String nombre,
    required String descripcion,
    required String gerenteAsignado,
  }) async {
    await _firestore.collection('departamentos').doc(nombre).set({
      'descripcion': descripcion,
      'gerente_asignado': gerenteAsignado,
    });
  }

  // Agrega un registro de horas
  Future<void> addHours({
    required String employeeDni,
    required DateTime fechaEntrada,
    required DateTime fechaSalida,
    required int pausas,
    required int horasExtra,
  }) async {
    await _firestore
        .collection('empleados')
        .doc(employeeDni)
        .collection('registro_de_horas')
        .add({
      'fecha_entrada': fechaEntrada,
      'fecha_salida': fechaSalida,
      'pausas': pausas,
      'horas_extra': horasExtra,
    });
  }

  // Agrega una solicitud de vacaciones
  Future<void> addVacation({
    required String dni,
    required DateTime fecha,
    required String motivo,
    required bool estadoDeAprobacion,
  }) async {
    await _firestore
        .collection('empleados')
        .doc(dni)
        .collection('solicitudes_de_vacaciones')
        .add({
      'fecha': fecha,
      'motivo': motivo,
      'estado_de_aprobacion': estadoDeAprobacion,
    });
  }

  // Obtener todos los empleados
  Future<QuerySnapshot> getEmployees() async {
    return await _firestore.collection('empleados').get();
  }

  // Obtener un empleado específico por DNI
  Future<DocumentSnapshot> getEmployeeByDni(String dni) async {
    return await _firestore.collection('empleados').doc(dni).get();
  }

  // Obtener todos los departamentos
  Future<QuerySnapshot> getDepartments() async {
    return await _firestore.collection('departamentos').get();
  }

  // Obtener un departamento específico por nombre
  Future<DocumentSnapshot> getDepartmentByName(String nombre) async {
    return await _firestore.collection('departamentos').doc(nombre).get();
  }

  // Obtener todos los registros de horas de un empleado
  Future<QuerySnapshot> getEmployeeHours(String employeeDni) async {
    return await _firestore
        .collection('empleados')
        .doc(employeeDni)
        .collection('registro_de_horas')
        .get();
  }

  // Obtener todas las solicitudes de vacaciones de un empleado
  Future<QuerySnapshot> getEmployeeVacations(String employeeDni) async {
    return await _firestore
        .collection('empleados')
        .doc(employeeDni)
        .collection('solicitudes_de_vacaciones')
        .get();
  }
}