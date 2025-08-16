import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/poi.dart';
import '../../core/providers/providers.dart';

class PoiBottomSheet extends ConsumerStatefulWidget {
  const PoiBottomSheet(
      {super.key, this.poi, required this.lat, required this.lon});

  final Poi? poi;
  final double lat;
  final double lon;

  @override
  ConsumerState<PoiBottomSheet> createState() => _PoiBottomSheetState();
}

class _PoiBottomSheetState extends ConsumerState<PoiBottomSheet> {
  late PoiCategory _category;
  late TextEditingController _name;
  late TextEditingController _cost;
  late TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    final poi = widget.poi;
    _category = poi?.category ?? PoiCategory.custom;
    _name = TextEditingController(text: poi?.name ?? '');
    _cost = TextEditingController(text: poi?.costHint ?? '');
    _notes = TextEditingController(text: poi?.notes ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<PoiCategory>(
            value: _category,
            onChanged: (c) => setState(() => _category = c!),
            items: PoiCategory.values
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.name),
                    ))
                .toList(),
          ),
          TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name')),
          TextField(
              controller: _cost,
              decoration: const InputDecoration(labelText: 'Cost Hint')),
          TextField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.poi != null)
                TextButton(
                  onPressed: () async {
                    final repo = ref.read(poiRepositoryProvider);
                      await repo.delete(widget.poi!.id);
                      if (mounted) Navigator.pop(context, true); // ignore: use_build_context_synchronously
                  },
                  child: const Text('Delete'),
                ),
              ElevatedButton(
                onPressed: () async {
                  final repo = ref.read(poiRepositoryProvider);
                  final poi = (widget.poi ??
                          Poi(
                            category: _category,
                            name: _name.text,
                            lat: widget.lat,
                            lon: widget.lon,
                          ))
                      .copyWith(
                    category: _category,
                    name: _name.text,
                    costHint: _cost.text.isEmpty ? null : _cost.text,
                    notes: _notes.text.isEmpty ? null : _notes.text,
                  );
                    if (widget.poi == null) {
                      await repo.insert(poi);
                    } else {
                      await repo.update(poi);
                    }
                    if (mounted) Navigator.pop(context, true); // ignore: use_build_context_synchronously
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
