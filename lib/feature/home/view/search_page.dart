import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/feature/home/view/job_post_card.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(color: AppColor.gray, height: 97),
              const SingleChildScrollView(
                child: Column(children: [JobPostCard()]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
