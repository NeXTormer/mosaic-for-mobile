// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mosaic_for_mobile/search_service/remote_mosaic_searcher.dart';
import 'package:mosaic_for_mobile/widgets/mosaic_search_bar.dart';
import 'package:mosaic_for_mobile/widgets/search_result_widget.dart';
import 'package:mosaic_for_mobile/widgets/search_results_list.dart';

class MosaicApp extends StatefulWidget {
  MosaicApp({super.key});

  @override
  State<MosaicApp> createState() => _MosaicAppState();
}

class _MosaicAppState extends State<MosaicApp> {
  List<SearchResult> results = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Mosaic4Mobile'), actions: [
          IconButton(
              onPressed: () {},
              icon: Row(
                children: [
                  Text("Change Index"),
                  const SizedBox(width: 8),
                  Icon(Icons.change_circle_outlined),
                ],
              ))
        ]),
        body: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
              MosaicSearchBar((query) async {
                setState(() {
                  results = [];
                  loading = true;
                });

                final response = await RemoteMosaicSearcher.search(query);

                setState(() {
                  results = response;
                  loading = false;
                });
              }),
              const SizedBox(height: 16),
              Expanded(child: SearchResultsList(results))
            ],
          ),
        ));
  }
}
