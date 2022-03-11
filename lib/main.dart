// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:note_app_database/database/database_helper.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    TextEditingController titleControl = TextEditingController();
    TextEditingController textControl = TextEditingController();
    TextEditingController idControl = TextEditingController();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: idControl,
                decoration: const InputDecoration(
                  hintText: "ID",
                ),
              ),
              TextField(
                controller: titleControl,
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
              ),
              TextField(
                controller: textControl,
                decoration: const InputDecoration(
                  hintText: "Text",
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    DatabaseHelper.instance
                        .insertData(titleControl.text, textControl.text);
                  },
                  child: const Text("Insert Data")),
              ElevatedButton(
                  onPressed: () async {
                    if (idControl.text != "") {
                      await DatabaseHelper.instance.updateData(
                          int.parse(idControl.text),
                          textControl.text,
                          titleControl.text);
                    } else {
                      print("ID number can't be null!");
                    }
                  },
                  child: const Text("Update Data")),
              ElevatedButton(
                onPressed: () async {
                  var litstOfValues =
                      await DatabaseHelper.instance.readAllData();
                  print("All values in Database are $litstOfValues");
                },
                child: const Text("Show All Data"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await DatabaseHelper.instance.deleteAllData();
                  print("All data has been deleted!");
                },
                child: const Text("Delete All Data"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String lastId = await DatabaseHelper.instance.lastId();
                  print("Last Id: $lastId");
                },
                child: const Text("Last ID"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    String lastId = await DatabaseHelper.instance.lastId();
                    for (var i = 1; i < int.parse(lastId) + 1; i++) {
                      //ID number starts with 1
                      String title = await DatabaseHelper.instance.rawQuery(i);
                      setState(() {
                        cards.add(kContainer(title));
                      });
                    }
                  },
                  child: const Text("Add Widgets from the List")),
              Wrap(runSpacing: 20, spacing: 20, children: cards),
            ],
          ),
        ),
      ),
    );
  }
}

Widget kContainer(String title) {
  return Container(
    width: 50,
    height: 50,
    color: Colors.amber,
    child: Center(child: Text(title)),
  );
}

List<Widget> cards = [];
