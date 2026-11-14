import 'package:flutter/material.dart';

class Estrellas extends StatelessWidget {
  final double valor;
  final double tamano;

  const Estrellas({super.key, required this.valor, this.tamano = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final posicion = i + 1;
        IconData icono;
        if (valor >= posicion) {
          icono = Icons.star;
        } else if (valor >= posicion - 0.5) {
          icono = Icons.star_half;
        } else {
          icono = Icons.star_border;
        }
        return Icon(icono, color: Colors.amber, size: tamano);
      }),
    );
  }
}
