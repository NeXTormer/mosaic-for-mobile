import "package:flutter/material.dart";
import "package:mosaic_for_mobile/search_service/local_mosaic_searcher.dart";

class IndexInfoWidget extends StatefulWidget {
  const IndexInfoWidget({super.key});

  @override
  State<IndexInfoWidget> createState() => _IndexInfoWidgetState();
}

class _IndexInfoWidgetState extends State<IndexInfoWidget> {
  List<dynamic> indexInfoResult = [];

  @override
  void initState() {
    Future(() async {
      final result = await LocalMosaicSearcher.indexInfo();

      setState(() {
        indexInfoResult = result;
      });
      print(result);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text(
              "Index info",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                  itemCount: indexInfoResult.length,
                  itemBuilder: (context, i) {
                    final index = indexInfoResult[i];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(index.keys.toList().first),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(width: 16),
                            Flexible(
                              child: Text(
                                  "Languages: ${index[index.keys.toList().first]['languages'].join(', ')}"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(width: 16),
                            Flexible(
                              child: Text(
                                  "Document count: ${index[index.keys.toList().first]['documentCount']}"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16)
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
