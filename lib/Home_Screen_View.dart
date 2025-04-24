import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'CreatePollScreen.dart'; // Altere o caminho se necessário

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
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
                child: const Createpollscreen(),
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
