import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pagination_flutter/network/NetworkApi.dart';

import 'model/News.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const _pageSize = 6;
  final PagingController<int, Articles> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _fetchData(int pageKey) async {
    try {
      final newItems = await NetworkApi().getNews(pageKey);
      final isLastPage = newItems!.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
        print("isLast");
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
        print("isNotLastPage");
      }
    } catch (e) {
      _pagingController.error = e;
    }

  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagination"),
      ),
      body: PagedListView<int, Articles>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Articles>(
            itemBuilder: (context, item, index) {
          return Container(
            margin: EdgeInsets.all(10),
            color: Colors.green[100],
            alignment: Alignment.center,
            width: double.infinity,
            height: 60,
            child: Text(item.title.toString()),
          );
        }),
      ),
    );
  }
}
