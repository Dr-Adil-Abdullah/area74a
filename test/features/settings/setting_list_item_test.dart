import 'package:flutter_test/flutter_test.dart';
import 'package:pos_system/features/settings/setting_list_item.dart';

void main() {
  test('SettingListItem round-trips json', () {
    final item = SettingListItem(
      id: 'a1',
      name: 'JazzCash',
      sortOrder: 2,
      isActive: true,
      parentId: 'p',
      extra: const {'ml': '100'},
    );
    final copy = SettingListItem.fromJson(item.toJson());
    expect(copy.id, 'a1');
    expect(copy.name, 'JazzCash');
    expect(copy.sortOrder, 2);
    expect(copy.parentId, 'p');
    expect(copy.extra['ml'], '100');
  });

  test('disabled copy keeps id', () {
    final item = SettingListItem(id: 'x', name: 'Cash');
    final off = item.copyWith(isActive: false);
    expect(off.id, 'x');
    expect(off.isActive, isFalse);
    expect(off.name, 'Cash');
  });
}
