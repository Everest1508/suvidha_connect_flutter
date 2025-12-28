import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/theme/app_colors.dart';

class ConnectionTestWidget extends StatefulWidget {
  const ConnectionTestWidget({super.key});

  @override
  State<ConnectionTestWidget> createState() => _ConnectionTestWidgetState();
}

class _ConnectionTestWidgetState extends State<ConnectionTestWidget> {
  bool _isTesting = false;
  String _status = 'Not tested';
  String _details = '';

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _status = 'Testing...';
      _details = '';
    });

    try {
      final isConnected = await ApiService.testConnection();
      setState(() {
        _isTesting = false;
        if (isConnected) {
          _status = '✅ Connected';
          _details = 'Backend is reachable at ${ApiService.baseUrl}';
        } else {
          _status = '❌ Not Connected';
          _details = 'Cannot reach backend at ${ApiService.baseUrl}\n\nCheck:\n1. Backend server is running\n2. Correct IP address\n3. Firewall settings';
        }
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
        _status = '❌ Error';
        _details = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Backend Connection Test',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  _status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _status.contains('✅')
                        ? AppColors.success
                        : _status.contains('❌')
                            ? AppColors.error
                            : AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'URL: ${ApiService.baseUrl}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.mutedForeground,
              ),
            ),
            if (_details.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _details,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.foreground,
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isTesting ? null : _testConnection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isTesting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Test Connection'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

