import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/providers/notification_provider.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<NotificationProvider>()..loadNotifications(),
      child: const _NotificationContent(),
    );
  }
}

class _NotificationContent extends StatelessWidget {
  const _NotificationContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: GoogleFonts.cabin(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: AppTheme.primary.withValues(alpha: 0.6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.notifications.isEmpty
          ? _buildEmptyState(context)
          : RefreshIndicator(
              onRefresh: provider.loadNotifications,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: provider.notifications.length,
                separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
                itemBuilder: (context, index) {
                  final note = provider.notifications[index];
                  final bool isRead = note['is_read'] ?? false;
                  final DateTime date = DateTime.parse(note['created_at']);

                  return ListTile(
                    onTap: () => provider.markRead(index,context),
                    leading: CircleAvatar(
                      backgroundColor: isRead
                          ? Colors.grey[200]
                          : AppTheme.primary.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.notifications_active_outlined,
                        color: isRead ? Colors.grey : AppTheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      note['title'] ?? 'Update',
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          note['message'] ?? '',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM d, h:mm a').format(date),
                          style: TextStyle(color: Colors.grey[400], fontSize: 11),
                        ),
                      ],
                    ),
                    trailing: !isRead
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "All caught up!",
            style: GoogleFonts.cabin(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You don't have any notifications right now.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
