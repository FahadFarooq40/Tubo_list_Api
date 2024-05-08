import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  final Tab? tubo;

  const MyHomePage({Key? key, this.tubo}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _userData = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _deleteTubo(int id) async {
    final response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete tubo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 195, 242),
      appBar: AppBar(
        title: const Text(
          "Tubo Application",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        leading: GestureDetector(
          onTap: () {},
          child: const Icon(Icons.menu),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(10),
        child: _userData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _userData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            tileColor: Colors.amberAccent,
                            title: Text(
                              "Name:  ${_userData[index]['name']}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Email:  ${_userData[index]['email']}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                _deleteTubo(_userData[index]['id']);
                                setState(() {
                                  _userData.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.delete_outline_rounded),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
