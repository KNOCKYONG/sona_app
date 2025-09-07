import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:app_settings/app_settings.dart';

class NoNetworkDialog extends StatefulWidget {
  final VoidCallback onRetry;

  const NoNetworkDialog({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  @override
  State<NoNetworkDialog> createState() => _NoNetworkDialogState();
}

class _NoNetworkDialogState extends State<NoNetworkDialog> {
  bool _isRetrying = false;

  Future<void> _handleRetry() async {
    setState(() {
      _isRetrying = true;
    });

    // Add a small delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
    
    widget.onRetry();
    
    // The parent will handle closing the dialog if connection succeeds
    setState(() {
      _isRetrying = false;
    });
  }

  Future<void> _openNetworkSettings() async {
    try {
      // Use app_settings package for cross-platform support
      // openAppSettings() opens the main app settings page
      // Users can navigate to WiFi settings from there
      await AppSettings.openAppSettings();
    } catch (e) {
      debugPrint('Error opening app settings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 40,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              Text(
                localizations.noInternetConnection,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Message
              Text(
                localizations.internetRequiredMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Retry Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isRetrying ? null : _handleRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isRetrying
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(localizations.checkingConnection),
                          ],
                        )
                      : Text(
                          localizations.retryConnection,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Settings Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _openNetworkSettings,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.primaryColor,
                    side: BorderSide(
                      color: theme.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.settings, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        localizations.openNetworkSettings,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}