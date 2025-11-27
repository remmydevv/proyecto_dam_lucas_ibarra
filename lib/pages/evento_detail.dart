import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_dam_lucas_ibarra/constants.dart';
import 'package:proyecto_dam_lucas_ibarra/services/evento_service.dart';

class EventoDetail extends StatelessWidget {
  final String idEvento;
  const EventoDetail({super.key, required this.idEvento});

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(secondColor),
      appBar: AppBar(
        backgroundColor: Color(thirdColor),
        title: Text(
          "Detalle del Evento",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: EventoService().evento(idEvento),
        builder: (context, snap) {
          if (!snap.hasData ||
              snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(thirdColor)),
            );
          }

          var evento = snap.data!;

          final Map<String, String> categoriaFotos = {
            'Charla': 'charla.jpg',
            'Workshop': 'workshop.jpg',
            'Coloquio': 'coloquio.jpg',
          };

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/categorias/${categoriaFotos[evento['categoria']]}',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evento['titulo'],
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(thirdColor),
                          ),
                        ),

                        SizedBox(height: 20),

                        _detailItem(
                          icon: Icons.category_rounded,
                          title: evento['categoria'],
                        ),

                        const SizedBox(height: 12),

                        _detailItem(
                          icon: Icons.location_on_rounded,
                          title: evento['lugar'],
                        ),

                        SizedBox(height: 12),

                        _detailItem(
                          icon: Icons.calendar_month_rounded,
                          title: formatDate(evento['fechaHora'].toDate()),
                        ),

                        SizedBox(height: 25),
                        Divider(color: Color(thirdColor)),
                        SizedBox(height: 20),

                        Text(
                          "Publicado por",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(thirdColor),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          evento['autor'],
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(thirdColor),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _detailItem({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(firstColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Color(thirdColor)),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Color(thirdColor),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
