import 'package:concurso_admin/src/features/admin/data/concurso_model.dart';
import 'package:concurso_admin/src/features/admin/domain/concurso_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddConcursoScreen extends StatefulWidget {
  const AddConcursoScreen({super.key});

  @override
  _AddConcursoScreenState createState() => _AddConcursoScreenState();
}

class _AddConcursoScreenState extends State<AddConcursoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedEstado = 'abierto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Concurso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text('Fecha: ${_selectedDate.toLocal()} '.split(' ')[0]),
                  ),
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: const Text('Seleccionar fecha'),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _selectedEstado,
                items: ['abierto', 'cerrado', 'evaluando'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedEstado = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final nuevoConcurso = ConcursoModel(
                      id: const Uuid().v4(),
                      nombre: _nombreController.text,
                      descripcion: _descripcionController.text,
                      fecha: _selectedDate,
                      estado: _selectedEstado,
                    );
                    ConcursoService().addConcurso(nuevoConcurso);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}