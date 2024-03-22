import 'package:date_input_formatter/date_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Example(),
    );
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Example",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                enableInteractiveSelection: false,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/-]')),
                  DateInputFormatter(),
                ],
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
