import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mosaic_for_mobile/widgets/search_result_widget.dart';

class LocalMosaicSearcher {
  static const platform = MethodChannel('eu.ows.mosaic');

  static Future<List<SearchResult>> search(String query) async {
    String response = "failed to get response";
    try {
      final result =
          await platform.invokeMethod<String>('search', {'query': query});
      response = "$result";
    } on PlatformException catch (e) {
      response = "'${e.message}'.";
    }

    return _decodeJsonResponse(response);
  }

  static List<SearchResult> _decodeJsonResponse(response) {
    List<SearchResult> results = [];
    final jsonObject = jsonDecode(response);

    for (final indexResults in jsonObject['results']) {
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
