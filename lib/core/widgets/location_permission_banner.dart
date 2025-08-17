import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionBanner extends StatefulWidget {
  const LocationPermissionBanner({super.key});

  @override
  State<LocationPermissionBanner> createState() =>
      _LocationPermissionBannerState();
}

class _LocationPermissionBannerState extends State<LocationPermissionBanner> {
  LocationPermission? _status;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final s = await Geolocator.checkPermission();
    if (!mounted) return;
    setState(() => _status = s);
  }

  @override
  Widget build(BuildContext context) {
    if (_status == LocationPermission.denied ||
        _status == LocationPermission.deniedForever) {
      return MaterialBanner(
        content: const Text('Enable location'),
        actions: [
          TextButton(
            onPressed: () async {
              final s = await Geolocator.requestPermission();
              if (!mounted) return;
              setState(() => _status = s);
            },
            child: const Text('Enable'),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

