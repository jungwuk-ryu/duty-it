import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_filter_view_controller.dart';

class SearchFilterView extends GetView<SearchFilterViewController> {
  const SearchFilterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SearchFilterView'), centerTitle: true),
      body: const Center(
        child: Text(
          'SearchFilterView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
