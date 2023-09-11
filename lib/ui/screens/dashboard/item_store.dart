import 'package:bindworks_test_app/entities/item.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';

part 'item_store.g.dart';

class ItemStore = _ItemStore with _$ItemStore;

abstract class _ItemStore with Store {
  @observable
  ObservableList<Item> items = ObservableList<Item>();

  @action
  Future<void> addItem(Item item) async {
    items.add(item);
    await saveItems();
  }

  @action
  Future<void> editItem(int index, Item item) async {
    items[index] = item;
    await saveItems();
  }

  @action
  Future<void> deleteItem(int index) async {
    items.removeAt(index);
    await saveItems();
  }

  Future<void> saveItems() async {
    final box = await Hive.openBox<Item>(
      'items', /*encryptionCipher: HiveAesCipher(encryptionKeyUint8List)*/
    );
    await box.clear();
    await box.addAll(items);
  }

  Future<void> loadItems() async {
    final box = await Hive.openBox<Item>(
      'items', /*encryptionCipher: HiveAesCipher(encryptionKeyUint8List)*/
    );
    items = ObservableList.of(box.values.toList());
  }
}
