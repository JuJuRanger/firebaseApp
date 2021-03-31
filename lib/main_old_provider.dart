import 'package:firebaseApp/counterProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CounterProvider>(
        create: (_) => CounterProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _counter = Provider.of<CounterProvider>(context, listen: false);

    print("build...build");
    print("build...build1");
    print("build...build2");
    print("build...build3");
    print("build...build4");
    print("build...build5");
    print("build...build6");

    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Manage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Toy hame push the btn this many times'),
            Consumer<CounterProvider>(
              builder: (context, value, child) => Text(
                '${_counter.value}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _counter.increment(),
        child: Icon(Icons.add),
      ),
    );
  }
}
