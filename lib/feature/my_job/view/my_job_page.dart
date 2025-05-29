import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyJobPage extends StatelessWidget {
  const MyJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.push("/create-posting");
              },
              child: const Text("공고 작성"),
            ),
          ],
        ),
      ),
    );
  }
}
