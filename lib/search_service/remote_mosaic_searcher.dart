import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mosaic_for_mobile/widgets/search_result_widget.dart';

class RemoteMosaicSearcher {
  static Future<List<SearchResult>> search(String query) async {
    final dio = Dio();
    final response =
        await dio.get('https://qnode.eu/ows/mosaic/service/search?q=' + query);

    return decodeJsonResponse(response.data);
  }

  static List<SearchResult> decodeJsonResponse(response) {
    List<SearchResult> results = [];

    for (final indexResults in response['results']) {
      indexResults.forEach((indexName, entries) {
        for (final entry in entries) {
          results.add(SearchResult.named(
            title: entry['title'],
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
