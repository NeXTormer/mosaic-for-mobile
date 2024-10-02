import 'package:flutter/material.dart';
import 'package:mosaic_for_mobile/search_service/remote_mosaic_searcher.dart';

class MosaicSearchBar extends StatefulWidget {
  const MosaicSearchBar(this.onQuery, {super.key});
  final Function(String) onQuery;

  @override
  State<MosaicSearchBar> createState() => _MosaicSearchBarState();
}

class _MosaicSearchBarState extends State<MosaicSearchBar> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: textEditingController,
      onSubmitted: (query) {
        if (query.length > 0) {
          widget.onQuery(query);
        }
      },
      leading: Padding(
          padding: const EdgeInsets.only(left: 4), child: Icon(Icons.search)),
      trailing: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: InkWell(
            child: Icon(Icons.highlight_remove),
            onTap: () => textEditingController.text = '',
          ),
        )
      ],
    );
  }
}
