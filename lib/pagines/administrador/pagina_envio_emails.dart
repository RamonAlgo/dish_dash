import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';


class PaginaEnvioEmails extends StatelessWidget {
  const PaginaEnvioEmails({Key? key}) : super(key: key);

 void enviarEmail(String email) async {
  final subject = Uri.encodeComponent('Información sobre RestauraFacil');
  final body = Uri.encodeComponent('TextoPrueba.');

  final mailtoLink = 'mailto:$email?subject=$subject&body=$body';

  if (await canLaunch(mailtoLink)) {
    await launch(mailtoLink);
  } else {
    print('No se pudo abrir el enlace');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Correos'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('informacionSolicitada').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final emails = snapshot.data?.docs ?? [];

            return ListView.builder(
              itemCount: emails.length,
              itemBuilder: (context, index) {
                final email = emails[index]['email'];
                return ListTile(
                  title: Text(email),
                  trailing: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => enviarEmail(email),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
