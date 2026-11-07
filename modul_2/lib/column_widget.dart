
import 'package:flutter/material.dart';

class ColumnWidget extends StatelessWidget {
  const ColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Column'),
      ),
      body: Column(
        children: const [
          Text('Belajar Flutter'),
          Text('Mengenal Widget Column'),
          Text('Membuat Tampilan Vertikal'),
        ],
      ),
    );
  }
}
