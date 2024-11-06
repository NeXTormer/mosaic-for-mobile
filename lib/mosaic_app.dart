// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosaic_for_mobile/search_service/local_mosaic_searcher.dart';
import 'package:mosaic_for_mobile/search_service/remote_mosaic_searcher.dart';
import 'package:mosaic_for_mobile/widgets/index_info_widget.dart';
import 'package:mosaic_for_mobile/widgets/mosaic_search_bar.dart';
import 'package:mosaic_for_mobile/widgets/search_result_widget.dart';
import 'package:mosaic_for_mobile/widgets/search_results_list.dart';

class MosaicApp extends StatefulWidget {
  MosaicApp({super.key});

  @override
  State<MosaicApp> createState() => _MosaicAppState();
}

class _MosaicAppState extends State<MosaicApp> {
  static const platform = MethodChannel('eu.ows.mosaic');

  List<SearchResult> results = [];
  bool loading = false;

  bool mosaic_started = false;
  @override
  void initState() {
    super.initState();

    Future(() async {
      final result = await platform.invokeMethod<String>('start');
      print(result);

      setState(() {
        mosaic_started = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Image.asset('mosaic-logo.png', height: 40), actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  mosaic_started = false;
                });
                final result = await platform.invokeMethod<String>('reset');

                setState(() {
                  mosaic_started = true;
                });
              },
              icon: Row(
                children: [
                  Text("Restart Mosaic"),
                  const SizedBox(width: 8),
                  Icon(Icons.change_circle_outlined),
                ],
              )),
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

                final response = await LocalMosaicSearcher.search(query);

                setState(() {
                  results = response;
                  loading = false;
                });
              }),
              const SizedBox(height: 16),
              if (!mosaic_started)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                              const SizedBox(width: 16),
                              Text('Please wait while mosaic is starting...'),
                            ],
                          ),
                        )),
                  ),
                ),
              if (!loading) Expanded(child: SearchResultsList(results)),
              if (loading)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (results.isEmpty) IndexInfoWidget(),
            ],
          ),
        ));
  }
}
