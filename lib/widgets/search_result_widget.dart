// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget(this.data, {super.key});

  final SearchResult data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
          height: 220,
          child: Card(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Divider(
                  height: 0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.snippet,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(),
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                ),
                SizedBox(
                  height: 56,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.tags.length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Chip(
                              avatar: Icon(data.tags[index].$1),
                              label: Text(data.tags[index].$2),
                              elevation: 100,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                            ),
                          )),
                )
              ],
            ),
          )),
    );
  }
}

class SearchResult {
  String title;
  String snippet;
  List<(IconData, String)> tags;

  SearchResult(this.title, this.snippet, this.tags);

  SearchResult.named(
      {required this.title,
      required this.snippet,
      String? indexName,
      String? language,
      int? wordCount})
      : tags = [] {
    if (language != null) tags.add((Icons.language, language));
    if (indexName != null) tags.add((Icons.storage, indexName));
    if (wordCount != null) tags.add((Icons.numbers, '$wordCount'));
  }
}
