import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../widgets/ui_components.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uidController = TextEditingController();
  bool _showRegisteredCards = false;

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = _uidController.text.trim();
    final success = await ref
        .read(authProvider.notifier)
        .authenticateVoter(uid);

    if (!mounted) return;

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Authentication successful! Proceeding to voting...'),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      // TODO: Navigate to voting screen in next step
      // For now, just show a message
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voting screen coming in Step 5!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    // Error is already displayed via the authState.errorMessage in the UI
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Voter Authentication',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Icon
              Icon(
                Icons.credit_card,
                size: 80,
                color: theme.colorScheme.primary,
              ).animate().fadeIn(duration: 600.ms).scale(),

              const SizedBox(height: 24),

              // Title
              Text(
                'Scan Your RFID Card',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 12),

              // Description
              Text(
                'Enter your voter registration card UID to continue',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 40),

              // Error Message Card - THIS IS KEY!
              if (authState.errorMessage != null)
                AlertCard.error(
                  title: 'Authentication Failed',
                  message: authState.errorMessage!,
                ).animate().shake(duration: 400.ms).then().fadeIn(),

              if (authState.errorMessage != null) const SizedBox(height: 20),

              // Card UID Input
              InputField(
                controller: _uidController,
                label: 'RFID Card UID',
                hint: 'Enter card UID (e.g., CARD001)',
                prefixIcon: Icons.credit_card,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a card UID';
                  }
                  return null;
                },
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // Authenticate Button
              PrimaryButton(
                text: 'Authenticate',
                icon: Icons.verified_user,
                onPressed: authState.isLoading ? () {} : _authenticate,
                isLoading: authState.isLoading,
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 16),

              // Test Cards Toggle
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showRegisteredCards = !_showRegisteredCards;
                  });
                },
                icon: Icon(
                  _showRegisteredCards
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                label: Text(
                  _showRegisteredCards ? 'Hide Test Cards' : 'Show Test Cards',
                ),
              ).animate().fadeIn(delay: 1000.ms),

              // Registered Cards List
              if (_showRegisteredCards) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Test Card UIDs',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Use any of these UIDs for testing:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...ApiService.getRegisteredVoters().map(
                          (uid) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: InkWell(
                              onTap: () {
                                _uidController.text = uid;
                                setState(() {
                                  _showRegisteredCards = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.credit_card,
                                      size: 16,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      uid,
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              ],

              const SizedBox(height: 40),

              // Info Cards
              Row(
                children: [
                  Expanded(
                    child: _InfoBox(
                      icon: Icons.security,
                      title: 'Secure',
                      description: 'Encrypted authentication',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoBox(
                      icon: Icons.verified,
                      title: 'Verified',
                      description: 'Blockchain validated',
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// Info Box Widget
class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoBox({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
