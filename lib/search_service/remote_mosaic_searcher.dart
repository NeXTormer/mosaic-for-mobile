import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mosaic_for_mobile/widgets/search_result_widget.dart';

class RemoteMosaicSearcher {
  static Future<List<SearchResult>> search(String query) async {
    final dio = Dio();
    final response = await dio.get('http://10.0.0.14:8008/search?q=' + query);
    // await dio.get('https://qnode.eu/ows/mosaic/service/search?q=' + query);

    return _decodeJsonResponse(response.data);
  }

  static List<SearchResult> _decodeJsonResponse(response) {
    List<SearchResult> results = [];

    for (final indexResults in response['results']) {
      indexResults.forEach((indexName, entries) {
        for (final entry in entries) {
          results.add(SearchResult.named(
            title: entry['title'],
            url: entry['url'],
            snippet: entry['textSnippet'],
            wordCount: entry['wordCount'],
            language: entry['language'],
            indexName: indexName,
          ));
        }
      });
    }
    return results;
  }
}
