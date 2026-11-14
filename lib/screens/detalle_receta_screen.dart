import 'package:flutter/material.dart';
import 'package:recetas_app/data/resenas_db.dart';
import 'package:recetas_app/models/receta.dart';
import 'package:recetas_app/models/resena.dart';
import 'package:recetas_app/screens/formulario_resena_screen.dart';
import 'package:recetas_app/widgets/estrellas.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;

  const DetalleRecetaScreen({super.key, required this.receta});

  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  List<Resena> _resenas = [];
  double _promedio = 0;
  int _total = 0;
  bool _cargandoResenas = true;

  @override
  void initState() {
    super.initState();
    _cargarResenas();
  }

  Future<void> _cargarResenas() async {
    try {
      final id = widget.receta.id;
      final resenas = await ResenasDb.instancia.obtenerPorReceta(id);
      final resumen = await ResenasDb.instancia.obtenerResumen(id);
      if (!mounted) return;
      setState(() {
        _resenas = resenas;
        _promedio = resumen.promedio;
        _total = resumen.total;
        _cargandoResenas = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _cargandoResenas = false);
    }
  }

  Future<void> _escribirResena() async {
    final guardada = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioResenaScreen(receta: widget.receta),
      ),
    );
    if (guardada == true) _cargarResenas(); 
  }

  String _formatearFecha(DateTime f) {
    final dia = f.day.toString().padLeft(2, '0');
    final mes = f.month.toString().padLeft(2, '0');
    return '$dia/$mes/${f.year}';
  }

  @override
  Widget build(BuildContext context) {
    final receta = widget.receta;
    return Scaffold(
      appBar: AppBar(title: Text("Detalle de la receta")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(14),
            child: Image.network(
              receta.imagenUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Image.asset(
                "assets/images/default.jpg",
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              Chip(label: Text('${receta.tiempoTotal} min')),
              Chip(label: Text(receta.dificultad)),
              Chip(label: Text(receta.cocina)),
              Chip(label: Text('${receta.calorias} kcal')),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Ingredientes: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.ingredientes.map(
            (ingrediente) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.orange),
                  const SizedBox(height: 8),
                  Expanded(child: Text(ingrediente)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Preparación: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...receta.instrucciones.asMap().entries.map(
            (entrada) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      '${entrada.key + 1}',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(entrada.value)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Reseñas: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Estrellas(valor: _promedio),
              const SizedBox(width: 8),
              Text(
                _total == 0
                    ? 'Aún no hay reseñas'
                    : '${_promedio.toStringAsFixed(1)} ($_total ${_total == 1 ? 'reseña' : 'reseñas'})',
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _escribirResena,
            icon: const Icon(Icons.rate_review),
            label: const Text('Escribir reseña'),
          ),
          const SizedBox(height: 12),
          if (_cargandoResenas)
            const Center(child: CircularProgressIndicator())
          else
            ..._resenas.map(
              (resena) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Estrellas(
                            valor: resena.calificacion.toDouble(),
                            tamano: 18,
                          ),
                          Text(
                            _formatearFecha(resena.fecha),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(resena.comentario),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
