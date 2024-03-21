import 'package:dish_dash/pagina_login.dart';
import 'package:dish_dash/pagines/pagina_inicial_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PortalAuth extends StatelessWidget {
  const PortalAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            return  PaginaInicialClient();
          }else{
            return  PaginaLogin();
          }
        },
      ),
    );
    
  }
}