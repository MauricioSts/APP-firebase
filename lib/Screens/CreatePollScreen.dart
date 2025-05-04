import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePollScreen extends StatefulWidget {
  final String currentUserId;
  const CreatePollScreen({super.key, required this.currentUserId});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final TextEditingController titleController = TextEditingController();
  final List<TextEditingController> optionNameController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final List<File?> optionImages = [null, null, null];
  final ImagePicker _imagePicker = ImagePicker();
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Poll"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTitleField(),
              for (int i = 0; i < 3; i++) _buildOptionField(i),
              const SizedBox(height: 15),
              loader
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  )
                  : ElevatedButton(
                    onPressed: () => submitPoll(widget.currentUserId, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      "Create Poll",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: _boxDecoration(),
      child: TextFormField(
        controller: titleController,
        decoration: const InputDecoration(
          labelText: "Poll title",
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildOptionField(int i) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: optionNameController[i],
              decoration: InputDecoration(
                labelText: "Option ${i + 1} Name",
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => pickImage(i),
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
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
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
    );
  }

  Future<void> pickImage(int index) async {
    await _requestPermissions();
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        optionImages[index] = File(pickedFile.path);
      });
      log("Imagem carregada com sucesso: ${pickedFile.path}");
    } else {
      log("Nenhuma imagem foi selecionada.");
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.camera.request();
  }

  bool validateForm(BuildContext context) {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Title is required")));
      return false;
    }

    for (int i = 0; i < optionNameController.length; i++) {
      if (optionNameController[i].text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Option ${i + 1} name is required")),
        );
        return false;
      }
    }

    return true;
  }

  Future<String?> uploadImage(File imageFile, String pollId, int index) async {
    try {
      log("Caminho do arquivo a ser enviado: ${imageFile.path}");

      // Verifique se o arquivo é válido (apenas JPG ou PNG)
      if (!imageFile.path.endsWith(".jpg") &&
          !imageFile.path.endsWith(".png")) {
        log("Erro: O arquivo não é uma imagem válida.");
        return null;
      }

      final ref = FirebaseStorage.instance.ref().child(
        'polls/$pollId-option-$index.jpg',
      );

      log("Referência do Firebase Storage: ${ref.fullPath}");

      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      log("Imagem enviada com sucesso para a opção $index: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      log("Erro ao enviar imagem: $e");
      return null;
    }
  }

  Future<void> submitPoll(String userId, BuildContext context) async {
    if (!validateForm(context)) return;

    setState(() {
      loader = true;
    });

    try {
      final pollDoc = FirebaseFirestore.instance.collection("polls").doc();
      final pollId = pollDoc.id;
      final List<Map<String, dynamic>> options = [];

      for (int i = 0; i < 3; i++) {
        String? imageUrl;

        // Só tenta fazer o upload da imagem se a imagem for selecionada
        if (optionImages[i] != null) {
          imageUrl = await uploadImage(optionImages[i]!, pollId, i);
          if (imageUrl == null) {
            throw Exception("Falha no upload da imagem da opção ${i + 1}");
          }
        }

        options.add({
          "name": optionNameController[i].text.trim(),
          "imageUrl":
              imageUrl ?? "", // Se não houver imagem, usa uma string vazia
          "votes": 0,
        });
      }

      // Apenas uma chamada ao Firebase após montar tudo corretamente
      await pollDoc.set({
        "pollId": pollId,
        "title": titleController.text.trim(),
        "options": options,
        "createdAt": FieldValue.serverTimestamp(),
        "creatorId": userId,
        "total_votes": 0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Poll created successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      log("Erro ao criar poll: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to create Poll")));
    } finally {
      setState(() {
        loader = false; // ← O loading agora é ocultado após a finalização
      });
    }
  }
}
