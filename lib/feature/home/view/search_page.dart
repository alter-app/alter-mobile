import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/feature/home/view/posting_card.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                color: AppColor.white,
                height: 97,
                child: Center(
                  child: TextFormField(
                    onTap: () {},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.gray[10],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1.0,
                          color: AppColor.gray[20]!,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        size: 24,
                        color: AppColor.gray[20],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 66,
                alignment: Alignment.centerLeft,
                child: Text(
                  "서울 구로구 경인로 445",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(height: 1.42),
                ),
              ),
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [JobPostCard(), JobPostCard(), JobPostCard()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
