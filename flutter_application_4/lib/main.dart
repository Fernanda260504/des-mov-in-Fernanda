import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: 'Historial de números'),
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
  List<int> _historial = [];       
  bool _mostrarHistorial = false; 

  void _incrementCounter() {
    setState(() {
      _counter++;
      _historial.add(_counter); 
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
      _historial.add(_counter); 
    });
  }

  Widget _buildHistorial() {
  if (_historial.isEmpty) {
    return const Text("No hay historial todavía.");
  } else {
    return Expanded(   
      child: ListView.builder(
        itemCount: _historial.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text("Valor ${index + 1}: ${_historial[index]}"),
          );
        },
      ),
    );
  }
}

  void _limpiarHistorial() {
    setState(() {
      _historial.clear();
    });
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
            const Text('Valor actual del contador:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _mostrarHistorial = !_mostrarHistorial;
                });
              },
              child: Text(_mostrarHistorial ? "Ocultar historial" : "Mostrar historial"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _limpiarHistorial,
              child: const Text("Limpiar historial"),
            ),
            const SizedBox(height: 20),
            if (_mostrarHistorial) _buildHistorial(),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
