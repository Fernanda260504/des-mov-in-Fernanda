import 'package:flutter/material.dart';
import 'package:flutter_application_3/worker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController _txtNameCtrl = TextEditingController();
  TextEditingController _txtSurnameCtrl = TextEditingController();
  TextEditingController _txtAgeCtrl = TextEditingController();
  List<Worker> trabajadores = [];
  Set<int> ids = {}; 

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void addTrabajador() {
    final nombre = _txtNameCtrl.text.trim();
    final apellidos = _txtSurnameCtrl.text.trim();
    final edadStr = _txtAgeCtrl.text.trim();
    if (nombre.isEmpty || apellidos.isEmpty || edadStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    final edad = int.tryParse(edadStr);
    if (edad == null || edad < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Solo se pueden registrar mayores de edad")),
      );
      return;
    }

    final id = trabajadores.length + 1; 
    if (ids.contains(id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ID ya existe, por favor usa uno diferente")),
      );
      return;
    }

    setState(() {
      final trabajador = Worker(id: id, nombre: nombre, apellidos: apellidos, edad: edad);
      trabajadores.add(trabajador);
      ids.add(id); 
    });

    _txtNameCtrl.clear();
    _txtSurnameCtrl.clear();
    _txtAgeCtrl.clear();
  }

  void removeLastTrabajador() {
    if (trabajadores.isNotEmpty) {
      setState(() {
        ids.remove(trabajadores.last.id);
        trabajadores.removeLast();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay trabajadores para eliminar")),
      );
    }
  }

  Widget getTrabajadores() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14),
        Text("Lista de Trabajadores:"),
        SizedBox(height: 10),
        ...trabajadores.map((w) => Text("Nombre: ${w.nombre} , Apellidos: ${w.apellidos}, Edad: ${w.edad}")).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: TextField(
                controller: _txtNameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: TextField(
                controller: _txtSurnameCtrl,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: TextField(
                controller: _txtAgeCtrl,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            ElevatedButton(
              onPressed: addTrabajador,
              child: const Text('Agregar Trabajador'),
            ),
            ElevatedButton(
              onPressed: removeLastTrabajador,
              child: const Text('Eliminar Trabajador'),
            ),
            getTrabajadores(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
