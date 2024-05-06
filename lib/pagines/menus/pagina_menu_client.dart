import 'package:flutter/material.dart';

class PaginaMenuClient extends StatelessWidget {
  final String domain;
  const PaginaMenuClient({Key? key,required this.domain}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menús'),
      ),
    );
  }
}
