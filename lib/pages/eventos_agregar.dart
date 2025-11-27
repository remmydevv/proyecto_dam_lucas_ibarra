import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_dam_lucas_ibarra/constants.dart';
import 'package:proyecto_dam_lucas_ibarra/services/categoria_service.dart';
import 'package:proyecto_dam_lucas_ibarra/services/evento_service.dart';

class EventosAgregar extends StatefulWidget {
  const EventosAgregar({super.key});

  @override
  State<EventosAgregar> createState() => _EventosAgregarState();
}

class _EventosAgregarState extends State<EventosAgregar> {
  final formKey = GlobalKey<FormState>();
  TextEditingController tituloCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();

  String? categoriaSelected;
  DateTime fechaHora = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo Evento!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(thirdColor),
        leading: Icon(Icons.event, color: Color(firstColor)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Crear nuevo evento",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(thirdColor),
                    ),
                  ),
                  SizedBox(height: 25),

                  TextFormField(
                    controller: tituloCtrl,
                    decoration: InputDecoration(
                      labelText: 'Título del Evento',
                      filled: true,
                      fillColor: Color(secondColor).withValues(alpha: 0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese un título';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: lugarCtrl,
                    decoration: InputDecoration(
                      labelText: 'Lugar del Evento',
                      filled: true,
                      fillColor: Color(secondColor).withValues(alpha: 0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Ingrese un lugar';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  FutureBuilder(
                    future: CategoriaService().categorias(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                      if (!snap.hasData ||
                          snap.connectionState == ConnectionState.waiting) {
                        return Text('Cargando...');
                      }
                      var cats = snap.data!.docs;

                      return DropdownButtonFormField(
                        initialValue: categoriaSelected,
                        validator: (cat) {
                          if (cat == null) {
                            return 'Seleccione una categoría';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Categoría',
                          filled: true,
                          fillColor: Color(secondColor).withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        items: cats.map((cat) {
                          return DropdownMenuItem(
                            value: cat['nombre'].toString(),
                            child: Text(cat['nombre']),
                          );
                        }).toList(),
                        onChanged: (valor) {
                          setState(() {
                            categoriaSelected = valor;
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: 25),

                  Text(
                    "Fecha del evento",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(thirdColor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: seleccionarFechaHora,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Color(secondColor).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Color(thirdColor)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${fechaHora.day}/${fechaHora.month}/${fechaHora.year}  "
                              "${fechaHora.hour.toString()}:"
                              "${fechaHora.minute.toString()}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(thirdColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  Divider(color: Color(thirdColor), thickness: 1),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(thirdColor)),
                            foregroundColor: Color(thirdColor),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text("Volver"),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (fechaHora.isBefore(DateTime.now())) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'La fecha y hora no pueden ser anteriores',
                                    ),
                                  ),
                                );
                                return;
                              }

                              await EventoService().agregarEvento(
                                tituloCtrl.text.trim(),
                                fechaHora,
                                lugarCtrl.text.trim(),
                                categoriaSelected!,
                              );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(thirdColor),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text("Guardar Evento"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> seleccionarFechaHora() async {
    DateTime? fechaSelected = await showDatePicker(
      context: context,
      initialDate: fechaHora,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (fechaSelected == null) {
      return;
    }

    TimeOfDay? horaSelected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(fechaHora),
    );
    if (horaSelected == null) {
      return;
    }
    DateTime fechaHoraFinal = DateTime(
      fechaSelected.year,
      fechaSelected.month,
      fechaSelected.day,
      horaSelected.hour,
      horaSelected.minute,
    );
    setState(() {
      fechaHora = fechaHoraFinal;
    });
  }
}
