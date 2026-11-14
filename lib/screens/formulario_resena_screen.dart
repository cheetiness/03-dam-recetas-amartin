import 'package:flutter/material.dart';
import 'package:recetas_app/data/resenas_db.dart';
import 'package:recetas_app/models/receta.dart';
import 'package:recetas_app/models/resena.dart';

class FormularioResenaScreen extends StatefulWidget {
  final Receta receta;

  const FormularioResenaScreen({super.key, required this.receta});

  @override
  State<FormularioResenaScreen> createState() => _FormularioResenaScreenState();
}

class _FormularioResenaScreenState extends State<FormularioResenaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _comentarioCtrl = TextEditingController();
  int _calificacion = 0; 
  bool _mostrarErrorEstrellas = false;
  bool _guardando = false;

  @override
  void dispose() {
    _comentarioCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final formularioValido = _formKey.currentState!.validate();
    if (_calificacion == 0) {
      setState(() => _mostrarErrorEstrellas = true);
    }
    if (!formularioValido || _calificacion == 0) return;

    setState(() => _guardando = true);
    final resena = Resena(
      recetaId: widget.receta.id,
      calificacion: _calificacion,
      comentario: _comentarioCtrl.text.trim(),
      fecha: DateTime.now(),
    );
    await ResenasDb.instancia.insertar(resena);
    if (!mounted) return;
    Navigator.pop(context, true); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escribir reseña')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              widget.receta.nombre,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Tu calificación'),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (i) {
                final estrella = i + 1;
                return IconButton(
                  onPressed: () => setState(() {
                    _calificacion = estrella;
                    _mostrarErrorEstrellas = false;
                  }),
                  iconSize: 38,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    estrella <= _calificacion
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            if (_mostrarErrorEstrellas)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Selecciona de 1 a 5 estrellas',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _comentarioCtrl,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Comentario',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().length < 5)
                  ? 'Escribe al menos 5 caracteres'
                  : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: const Icon(Icons.send),
              label: const Text('Publicar reseña'),
            ),
          ],
        ),
      ),
    );
  }
}
