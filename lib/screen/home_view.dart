// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<dynamic>> getUser() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/Users');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      throw Exception('Failed to load data');
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
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        leading: GestureDetector(
          onTap: () {},
          child: const Icon(Icons.menu),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: getUser(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
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
                                    ("Name:  " +
                                        snapshot.data![index]['name']
                                            .toString()),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    ("email:  " +
                                        snapshot.data![index]['email']
                                            .toString()),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.cancel)),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
