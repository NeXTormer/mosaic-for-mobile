import 'package:flutter/material.dart';

import 'search_result_widget.dart';

class SearchResultsList extends StatelessWidget {
  SearchResultsList(this.results, {super.key});

  SearchResultsList.demo()
      : results = [
          SearchResult(
              'Wikipedia: The Carsey-Werner Company',
              'The Carsey-Werner Company (also called Carsey-Werner Productions or Carsey-Werner Television) is an independent television company. It was founded in 1981 by former ABC writer and producer duo Marcy Carsey and Tom Werner.',
              [
                (Icons.language, 'eng'),
                (Icons.storage, 'demo-simplewiki'),
                (Icons.numbers, '69')
              ])
        ];

  final List<SearchResult> results;

  @override
  Widget build(BuildContext context) {
    return results.length == 0
        ? Center(
            child: Text(
            'enter a search query to get results',
            style: TextStyle(color: Colors.grey),
          ))
        : Padding(
            padding: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) =>
                      SearchResultWidget(results[index])),
            ),
          );
  }
}
