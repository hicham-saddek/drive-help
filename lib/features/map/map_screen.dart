import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../core/models/poi.dart';
import '../../core/providers/providers.dart';
import '../../core/repositories/settings_repository.dart';
import '../poi/poi_list_screen.dart';
import 'poi_bottom_sheet.dart';
import 'poi_markers.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  MaplibreMapController? _controller;
  String? _offlinePath;

  @override
  void initState() {
    super.initState();
    _loadTilesPath();
  }

  Future<void> _loadTilesPath() async {
    final repo = ref.read(settingsRepositoryProvider);
    final path = await repo.getOfflineTilesPath();
    setState(() => _offlinePath = path);
  }

  Future<void> _pickMbtiles() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      await ref.read(settingsRepositoryProvider).setOfflineTilesPath(path);
      setState(() => _offlinePath = path);
    }
  }

  void _onSymbolTapped(Symbol symbol) async {
    final pois = ref.read(visiblePoisProvider);
    final pos = symbol.options.geometry!;
    final poi = pois.firstWhere(
      (p) => p.lat == pos.latitude && p.lon == pos.longitude,
      orElse: () => pois.first,
    );
    final changed = await showModalBottomSheet<bool>(
      context: context,
      builder: (_) => PoiBottomSheet(
        poi: poi,
        lat: poi.lat,
        lon: poi.lon,
      ),
    );
    if (changed == true) {
      ref.invalidate(poiListProvider);
      if (_controller != null) {
        final updated = ref.read(visiblePoisProvider);
        await renderPoiMarkers(_controller!, updated);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pois = ref.watch(visiblePoisProvider);
    return Stack(
      children: [
        MapLibreMap(
          styleString: 'asset://assets/style/offline_fallback_style.json',
          initialCameraPosition: const CameraPosition(
            target: LatLng(31.6, -8.0),
            zoom: 4.5,
          ),
          onMapCreated: (c) async {
            _controller = c;
            c.onSymbolTapped.add(_onSymbolTapped);
            await renderPoiMarkers(c, pois);
          },
          onMapLongClick: (point, latLng) async {
            final changed = await showModalBottomSheet<bool>(
              context: context,
              builder: (_) => PoiBottomSheet(
                lat: latLng.latitude,
                lon: latLng.longitude,
              ),
            );
            if (changed == true) {
              ref.invalidate(poiListProvider);
              if (_controller != null) {
                final updated = ref.read(visiblePoisProvider);
                await renderPoiMarkers(_controller!, updated);
              }
            }
          },
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in PoiCategory.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(c.name),
                      selected: ref.watch(poiFiltersProvider).contains(c),
                      onSelected: (v) async {
                        final filters = ref.read(poiFiltersProvider.notifier);
                        final set = {...filters.state};
                        if (v) {
                          set.add(c);
                        } else {
                          set.remove(c);
                        }
                        filters.state = set;
                        if (_controller != null) {
                          await renderPoiMarkers(
                              _controller!, ref.read(visiblePoisProvider));
                        }
                      },
                    ),
                  ),
                TextButton(
                  onPressed: _pickMbtiles,
                  child: const Text('Pick MBTiles'),
                ),
              ],
            ),
          ),
        ),
        if (_offlinePath == null || !File(_offlinePath!).existsSync())
          Positioned(
            top: 72,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.redAccent,
              child: const Text('Offline tiles not configured'),
            ),
          ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () async {
              final poi = await Navigator.push<Poi>(
                context,
                MaterialPageRoute(
                  builder: (_) => const PoiListScreen(),
                ),
              );
              if (poi != null && _controller != null) {
                await _controller!.animateCamera(
                  CameraUpdate.newLatLng(LatLng(poi.lat, poi.lon)),
                );
              }
            },
            child: const Icon(Icons.list),
          ),
        ),
      ],
    );
  }
}
