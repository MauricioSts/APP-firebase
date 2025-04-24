import 'package:flutter/material.dart';

class Createpollscreen extends StatefulWidget {
  const Createpollscreen({super.key});

  @override
  State<Createpollscreen> createState() => _CreatepollscreenState();
}

class _CreatepollscreenState extends State<Createpollscreen> {
  TextEditingController titleController = TextEditingController();
  final List<TextEditingController> optionNameController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create poll"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Poll title"),
              ),
            ),
            for (int i = 0; i < 3; i++)
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: optionNameController[i],
                        decoration: InputDecoration(
                          labelText: "Option ${i + 1} Name",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
