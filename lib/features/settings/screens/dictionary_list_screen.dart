import 'package:flutter/material.dart';

import '../pharmacy_settings_store.dart';
import '../setting_list_item.dart';

class DictionaryListScreen extends StatefulWidget {
  const DictionaryListScreen({
    super.key,
    required this.store,
    required this.listKey,
    required this.title,
    this.hierarchical = false,
  });

  final PharmacySettingsStore store;
  final String listKey;
  final String title;
  final bool hierarchical;

  @override
  State<DictionaryListScreen> createState() => _DictionaryListScreenState();
}

class _DictionaryListScreenState extends State<DictionaryListScreen> {
  List<SettingListItem> _items = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final items = await widget.store.list(widget.listKey);
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _persist(List<SettingListItem> next) async {
    for (var i = 0; i < next.length; i++) {
      next[i] = next[i].copyWith(sortOrder: i);
    }
    await widget.store.saveList(widget.listKey, next);
    await _reload();
  }

  Future<void> _add({SettingListItem? parent}) async {
    final name = await _promptName(title: parent == null ? 'Add' : 'Add sub-item');
    if (name == null || name.isEmpty) return;
    final next = [..._items, PharmacySettingsStore.newItem(name, _items.length, parentId: parent?.id)];
    await _persist(next);
  }

  Future<void> _edit(SettingListItem item) async {
    final name = await _promptName(title: 'Rename', initial: item.name);
    if (name == null || name.isEmpty) return;
    final next = [for (final i in _items) i.id == item.id ? i.copyWith(name: name) : i];
    await _persist(next);
  }

  Future<void> _toggle(SettingListItem item) async {
    final next = [
      for (final i in _items) i.id == item.id ? i.copyWith(isActive: !i.isActive) : i
    ];
    await _persist(next);
  }

  Future<void> _move(SettingListItem item, int delta) async {
    final idx = _items.indexWhere((e) => e.id == item.id);
    final dest = idx + delta;
    if (idx < 0 || dest < 0 || dest >= _items.length) return;
    final next = [..._items];
    final tmp = next[idx];
    next[idx] = next[dest];
    next[dest] = tmp;
    await _persist(next);
  }

  Future<String?> _promptName({required String title, String? initial}) {
    final c = TextEditingController(text: initial ?? '');
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, c.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _items
        : _items
            .where((e) => e.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('Nothing here yet. Tap +'))
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final item = filtered[i];
                          final String? parentName = () {
                            final pid = item.parentId;
                            if (pid == null) return null;
                            for (final e in _items) {
                              if (e.id == pid) return e.name;
                            }
                            return null;
                          }();
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text([
                              item.isActive ? 'Active' : 'Disabled',
                              if (parentName != null) 'under $parentName',
                            ].join(' · ')),
                            leading: Icon(
                              item.isActive
                                  ? Icons.check_circle_outline
                                  : Icons.block,
                            ),
                            trailing: Wrap(spacing: 0, children: [
                              IconButton(
                                tooltip: 'Up',
                                onPressed: () => _move(item, -1),
                                icon: const Icon(Icons.keyboard_arrow_up),
                              ),
                              IconButton(
                                tooltip: 'Down',
                                onPressed: () => _move(item, 1),
                                icon: const Icon(Icons.keyboard_arrow_down),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (v) {
                                  switch (v) {
                                    case 'edit':
                                      _edit(item);
                                    case 'toggle':
                                      _toggle(item);
                                    case 'child':
                                      _add(parent: item);
                                  }
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Rename')),
                                  PopupMenuItem(
                                    value: 'toggle',
                                    child: Text(item.isActive ? 'Disable' : 'Enable'),
                                  ),
                                  if (widget.hierarchical)
                                    const PopupMenuItem(
                                      value: 'child',
                                      child: Text('Add sub-item'),
                                    ),
                                ],
                              ),
                            ]),
                          );
                        },
                      ),
              ),
            ]),
    );
  }
}
