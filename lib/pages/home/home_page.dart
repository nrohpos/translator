import 'package:flutter/material.dart';
import 'package:translator/pages/Home/home_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                HomeView(),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }
}
