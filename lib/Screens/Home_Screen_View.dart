import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_app/services/AuthServices/auth_services.dart';
import 'package:page_transition/page_transition.dart';
import 'CreatePollScreen.dart'; // Altere o caminho se necessário

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
              onPressed: () async {
                await AuthServices.signOut(context);
              },
              icon: Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            tabs: [Tab(text: "All"), Tab(text: "Posted"), Tab(text: "Voted")],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text("All polls")),
            Center(child: Text("Posted polls")),
            Center(child: Text("Voted polls")),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                child: CreatePollScreen(currentUserId: _currentUserId,),
                type: PageTransitionType.fade,
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
