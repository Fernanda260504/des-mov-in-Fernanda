import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
  TextEditingController nombreCrtl = TextEditingController();
  TextEditingController matriculaCrtl = TextEditingController();
  List<String> alumnos = [];
  //int _counter = 0;

  /*void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }*/

  void _validacionInput() {
    setState(() {
      String nombre = nombreCrtl.text.trim();
      String matricula = matriculaCrtl.text.trim();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Campos vacios,no valido")));
      if (nombre.isNotEmpty && matricula.isNotEmpty) {
        alumnos.add("${nombreCrtl.text} -${matriculaCrtl.text}");

        nombreCrtl.clear();
        matriculaCrtl.clear();
      }
    });
  }

  Widget listaAlumnos() {
    return Column(
      children: [
        Text("Lista de Alumnos"),
        SizedBox(height: 16),
        ...alumnos.map((e) => Row(children: [Text(e)])),
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
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nombreCrtl,
              decoration: InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: matriculaCrtl,
              decoration: InputDecoration(
                labelText: "Matricula",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            listaAlumnos(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _validacionInput,
        child: Text("Añadir estudiante"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
