import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionCheckerWidget extends StatefulWidget {
  const PermissionCheckerWidget({Key? key}) : super(key: key);

  @override
  State<PermissionCheckerWidget> createState() => _PermissionCheckerWidgetState();
}

class _PermissionCheckerWidgetState extends State<PermissionCheckerWidget> {
  bool _hasPermission = true;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    if (!Platform.isAndroid) {
      setState(() => _hasPermission = true);
      return;
    }

    setState(() => _isChecking = true);
    
    try {
      final status = await Permission.scheduleExactAlarm.status;
      setState(() {
        _hasPermission = status.isGranted;
        _isChecking = false;
      });
    } catch (e) {
      setState(() => _isChecking = false);
    }
  }

  Future<void> _requestPermission() async {
    setState(() => _isChecking = true);
    
    try {
      final status = await Permission.scheduleExactAlarm.request();
      
      if (status.isPermanentlyDenied) {
        // Show dialog to open settings
        if (mounted) {
          _showSettingsDialog();
        }
      }
      
      await _checkPermission();
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      setState(() => _isChecking = false);
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Exact alarm permission is required to schedule reminders. '
          'Please enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const SizedBox.shrink();
    }

    if (_hasPermission) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Permission Needed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Allow exact alarms to schedule reminders',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _requestPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }
}