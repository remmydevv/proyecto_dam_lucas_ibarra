import 'package:flutter/material.dart';
import 'package:proyecto_dam_lucas_ibarra/constants.dart';
import 'package:proyecto_dam_lucas_ibarra/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(firstColor), Color(secondColor)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.event_available,
                size: 65,
                color: Color(thirdColor),
              ),
            ),

            SizedBox(height: 40),

            Text(
              "Global Eventos",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(thirdColor),
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Organiza, descubre y publica eventos",
              style: TextStyle(
                fontSize: 16,
                color: Color(thirdColor).withValues(alpha: 0.8),
              ),
            ),

            SizedBox(height: 60),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: GestureDetector(
                onTap: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);

                        bool resultado = await FirebaseServicess().signIn();

                        if (!mounted) return;
                        setState(() => _isLoading = false);

                        if (!resultado) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Inicio de sesion cancelado o fallido",
                              ),
                            ),
                          );
                        }
                      },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset("assets/google.png", height: 24),
                      ),
                      */
                      Image.asset("assets/google.png", height: 24),
                      SizedBox(width: 12),
                      Text(
                        _isLoading ? "Cargando..." : "Continuar con Google",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(thirdColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
