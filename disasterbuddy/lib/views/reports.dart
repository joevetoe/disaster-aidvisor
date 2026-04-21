import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/copyright_footer.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('reports').snapshots(),
              builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                var items = snapshot.data?.docs ?? [];
                return GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  itemBuilder: (itemBuilder, index) {
                    dynamic data = jsonDecode(items[index]['image']);
                    Uint8List imageBytes =
                        Uint8List.fromList(List<int>.from(data));

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: Colors.black,
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              items[index]['issue'],
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Image.memory(
                              imageBytes,
                              height:
                                  MediaQuery.of(context).size.height * 0.2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: items.length,
                );
              },
            ),
          ),
          const SafeArea(top: false, child: CopyrightFooter()),
        ],
      ),
    );
  }
}
