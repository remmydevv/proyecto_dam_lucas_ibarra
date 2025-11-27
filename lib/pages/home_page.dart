import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto_dam_lucas_ibarra/constants.dart';
import 'package:proyecto_dam_lucas_ibarra/pages/evento_detail.dart';
import 'package:proyecto_dam_lucas_ibarra/pages/eventos_agregar.dart';
import 'package:proyecto_dam_lucas_ibarra/services/auth_service.dart';
import 'package:proyecto_dam_lucas_ibarra/services/evento_service.dart';
import 'package:proyecto_dam_lucas_ibarra/widgets/borrara_dialog.dart';
import 'package:proyecto_dam_lucas_ibarra/widgets/logout_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  Future<void> _logout() async {
    try {
      await FirebaseServicess().cerrarSesion();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cerrar sesión: $e')));
      }
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final views = [
      buildEventos(EventoService().eventos()),
      buildEventos(EventoService().eventoByAutor()),
    ];

    return Scaffold(
      backgroundColor: Color(secondColor),
      appBar: AppBar(
        title: Text(
          'Global Eventos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(thirdColor), Color(secondColor)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => LogoutDialog.show(context, _logout),
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),

      body: views[_index],

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Color(firstColor),
          indicatorColor: Color(thirdColor).withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(icon: Icon(Icons.public), label: 'Todos'),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Mis eventos',
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(thirdColor),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Color(thirdColor),
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EventosAgregar()),
            );
          },
        ),
      ),
    );
  }

  Widget buildEventos(Stream<QuerySnapshot> stream) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData ||
              snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(firstColor)),
            );
          }

          return ListView.builder(
            itemCount: snap.data!.docs.length,
            itemBuilder: (context, index) {
              var evento = snap.data!.docs[index];

              final Map<String, String> categoriaFotos = {
                'Charla': 'charla.jpg',
                'Workshop': 'workshop.jpg',
                'Coloquio': 'coloquio.jpg',
              };

              final userId = FirebaseAuth.instance.currentUser!.uid;
              final bool miEvento = evento['autorId'] == userId;

              final card = _buildEventoCard(evento, categoriaFotos);

              if (!miEvento) return card;

              return Slidable(
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Color(thirdColor),
                      label: 'Eliminar',
                      icon: MdiIcons.trashCanOutline,
                      foregroundColor: Colors.white,
                      onPressed: (context) async {
                        final confirmar = await BorraraDialog.confirmar(
                          context,
                        );
                        if (confirmar) {
                          await EventoService().eliminarEvento(evento.id);
                        }
                      },
                    ),
                  ],
                ),
                child: card,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEventoCard(
    QueryDocumentSnapshot evento,
    Map<String, String> categoriaFotos,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EventoDetail(idEvento: evento.id)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(5),
                  right: Radius.circular(5),
                ),
                child: Image.asset(
                  'assets/categorias/${categoriaFotos[evento['categoria']]}',
                  width: 100,
                  height: 100,
                ),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento['titulo'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(thirdColor),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${evento['lugar']}',
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    Text(
                      '📅 ${formatDate(evento['fechaHora'].toDate())}',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(firstColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        evento['categoria'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(thirdColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
