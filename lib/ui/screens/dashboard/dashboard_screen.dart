import 'package:bindworks_test_app/theme/theme.dart';
import 'package:bindworks_test_app/ui/screens/dashboard/widgets/detail_dialog.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'item_store.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<DashboardScreen> {
  final itemStore = ItemStore();

  @override
  void initState() {
    super.initState();
    itemStore.loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.inversePrimary,
        title: const Text('Item List'),
      ),
      body: Observer(
        builder: (_) => ListView.builder(
          padding: const EdgeInsets.symmetric(
              vertical: padding20, horizontal: padding20),
          itemCount: itemStore.items.length,
          itemBuilder: (context, index) {
            final item = itemStore.items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: padding8),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(item.userName),
                leading: CircleAvatar(
                  child: Text(
                    '${index + 1}',
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    FluentIcons.delete_12_filled,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    itemStore.deleteItem(index);
                  },
                ),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.grey),
                  borderRadius: borderRadius20,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => DetailDialog(
                      title: 'Update item',
                      item: item,
                      callback: (item) {
                        itemStore.editItem(index, item);
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => DetailDialog(
              title: 'Add item',
              callback: (item) {
                itemStore.addItem(item);
              },
            ),
          );
        },
        child: const Icon(FluentIcons.add_12_regular),
      ),
    );
  }
}
