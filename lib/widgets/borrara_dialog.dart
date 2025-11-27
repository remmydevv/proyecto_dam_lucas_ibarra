import 'package:flutter/material.dart';

class BorraraDialog {
  static Future<bool> confirmar(
    BuildContext context, {
    String title = 'Eliminar evento',
    String msj = '¿Esta seguro de querer eliminar este evento?',
  }) async {
    final resultado = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msj),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    return resultado ?? false;
  }
}
