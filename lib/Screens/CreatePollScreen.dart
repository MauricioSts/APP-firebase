import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  TextEditingController titleController = TextEditingController();
  final List<TextEditingController> optionNameController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final List<File?> optionImages = [null, null, null];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Poll"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Título do poll
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Poll title",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            // Opções do poll
            for (int i = 0; i < 3; i++)
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Campo de nome da opção
                    Expanded(
                      child: TextFormField(
                        controller: optionNameController[i],
                        decoration: InputDecoration(
                          labelText: "Option ${i + 1} Name",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Ícone ou imagem da opção
                    GestureDetector(
                      onTap: () {
                        pickImage(i);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            optionImages[i] != null
                                ? Image.file(
                                  optionImages[i]!,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
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

  Future<void> pickImage(int index) async {
    // Verificar e solicitar permissões
    await _requestPermissions();

    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        optionImages[index] = File(pickedFile.path);
      });
    }
  }

  // Função para solicitar permissões em tempo de execução
  Future<void> _requestPermissions() async {
    var statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }

    var statusCamera = await Permission.camera.status;
    if (!statusCamera.isGranted) {
      await Permission.camera.request();
    }
  }
}
