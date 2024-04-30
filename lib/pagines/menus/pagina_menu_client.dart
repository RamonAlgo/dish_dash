import 'package:dish_dash/Clases/Plat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class PaginaMenuClient extends StatelessWidget {
  const PaginaMenuClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menús'),
      ),
    );
  }
}
