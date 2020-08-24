import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/history/add_history.dart';
import 'package:sakura_line/view_model/history_model.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HistoryViewModel>(
      create: (_) => HistoryViewModel()..fetchHistory(),
      child: Consumer<HistoryViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('ヒストリー'),
            ),
            body: Container(),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return AddHistory();
                    },
                  ),
                );
                model.fetchHistory();
              },
            ),
          );
        },
      ),
    );
  }
}
