import 'package:uuid/uuid.dart';

/// One row in a Settings dictionary (payment method, unit, price tier, …).
class SettingListItem {
  SettingListItem({
    required this.id,
    required this.name,
    this.sortOrder = 0,
    this.isActive = true,
    this.parentId,
    this.extra = const {},
  });

  final String id;
  final String name;
  final int sortOrder;
  final bool isActive;
  final String? parentId;
  final Map<String, String> extra;

  SettingListItem copyWith({
    String? name,
    int? sortOrder,
    bool? isActive,
    String? parentId,
    bool clearParent = false,
    Map<String, String>? extra,
  }) {
    return SettingListItem(
      id: id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      parentId: clearParent ? null : (parentId ?? this.parentId),
      extra: extra ?? this.extra,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sort_order': sortOrder,
        'is_active': isActive,
        if (parentId != null) 'parent_id': parentId,
        if (extra.isNotEmpty) 'extra': extra,
      };

  factory SettingListItem.fromJson(Map<String, dynamic> j) {
    final extraRaw = j['extra'];
    final extra = <String, String>{};
    if (extraRaw is Map) {
      extraRaw.forEach((k, v) {
        extra['$k'] = '$v';
      });
    }
    return SettingListItem(
      id: j['id'] as String? ?? const Uuid().v4(),
      name: j['name'] as String? ?? '',
      sortOrder: (j['sort_order'] as num?)?.toInt() ?? 0,
      isActive: j['is_active'] as bool? ?? true,
      parentId: j['parent_id'] as String?,
      extra: extra,
    );
  }
}
