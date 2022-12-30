import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Referrence our box
  final _myBox = Hive.box('mybox');

  // Write data
  void writeData() {
    _myBox.put(1, 'sou');
  }

  // Read data
  void readData() {
    print(_myBox.get(1));
  }

  // Delete data
  void deleteData() {
    _myBox.delete(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: writeData,
              child: Text('Write'),
              color: Colors.green.shade200,
            ),
            MaterialButton(
              onPressed: readData,
              child: Text('Read'),
              color: Colors.blue.shade200,
            ),
            MaterialButton(
              onPressed: deleteData,
              child: Text('Delete'),
              color: Colors.red.shade200,
            )
          ],
        ),
      ),
    );
  }
}
