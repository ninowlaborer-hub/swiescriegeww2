import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/calendar_source.dart';
import 'calendar_providers.dart';
import 'widgets/calendar_permission_widget.dart';

/// Calendar selection screen
///
/// Allows users to select which device calendars to sync with.
/// Shows all available calendars with account information.
class CalendarSelectionScreen extends ConsumerStatefulWidget {
  const CalendarSelectionScreen({super.key});

  @override
  ConsumerState<CalendarSelectionScreen> createState() =>
      _CalendarSelectionScreenState();
}

class _CalendarSelectionScreenState
    extends ConsumerState<CalendarSelectionScreen> {
  Set<String> _selectedIds = {};
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    final permissionsAsync = ref.watch(calendarPermissionsProvider);
    final sourcesAsync = ref.watch(calendarSourcesProvider);
    final syncLoading = ref.watch(calendarSyncLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Selection'),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: syncLoading == true ? null : _saveSelection,
              child: const Text('SAVE'),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: syncLoading == true ? null : _syncCalendars,
            tooltip: 'Sync calendars',
          ),
        ],
      ),
      body: permissionsAsync.when(
        data: (hasPermissions) {
          if (!hasPermissions) {
            return const CalendarPermissionWidget();
          }

          return sourcesAsync.when(
            data: (sources) => _buildCalendarList(sources, syncLoading == true),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(error),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildCalendarList(List<CalendarSource> sources, bool syncLoading) {
    if (sources.isEmpty) {
      return _buildEmptyState();
    }

    // Initialize selected IDs from sources
    if (_selectedIds.isEmpty && !_hasChanges) {
      _selectedIds = sources
          .where((s) => s.isSelected)
          .map((s) => s.id)
          .toSet();
    }

    // Group calendars by account
    final groupedSources = <String, List<CalendarSource>>{};
    for (final source in sources) {
      final accountKey = source.accountName ?? 'Local';
      groupedSources.putIfAbsent(accountKey, () => []).add(source);
    }

    return Column(
      children: [
        // Info banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Select calendars to include in your daily routines',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue.shade700,
                      ),
                ),
              ),
            ],
          ),
        ),

        // Calendar list
        Expanded(
          child: syncLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupedSources.length,
                  itemBuilder: (context, index) {
                    final accountName = groupedSources.keys.elementAt(index);
                    final accountSources = groupedSources[accountName]!;

                    return _buildAccountSection(
                      accountName,
                      accountSources,
                    );
                  },
                ),
        ),

        // Summary footer
        if (_selectedIds.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  '${_selectedIds.length} calendar${_selectedIds.length == 1 ? '' : 's'} selected',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAccountSection(
    String accountName,
    List<CalendarSource> sources,
  ) =>
      Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    sources.first.sourceIcon,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accountName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          sources.first.sourceTypeDisplay,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Calendars in this account
            ...sources.map(_buildCalendarTile),
          ],
        ),
      );

  Widget _buildCalendarTile(CalendarSource source) {
    final isSelected = _selectedIds.contains(source.id);

    return CheckboxListTile(
      value: isSelected,
      onChanged: source.isReadOnly
          ? null
          : (value) => setState(() {
                if (value == true) {
                  _selectedIds.add(source.id);
                } else {
                  _selectedIds.remove(source.id);
                }
                _hasChanges = true;
              }),
      title: Text(source.name),
      subtitle: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Color(source.color),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade400),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            source.isReadOnly ? 'Read-only' : 'Read & Write',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (source.isPrimary) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'PRIMARY',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No Calendars Found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Add calendars to your device to get started',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _syncCalendars,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );

  Widget _buildErrorState(Object error) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to Load Calendars',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(calendarSourcesProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );

  Future<void> _syncCalendars() async {
    try {
      await syncCalendarSourcesAction(ref);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Calendars synced successfully')),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sync: $e')),
        );
      }
    }
  }

  Future<void> _saveSelection() async {
    try {
      await selectCalendarsAction(ref, _selectedIds.toList());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Calendar selection saved')),
        );
        setState(() {
          _hasChanges = false;
        });

        // Optionally go back
        context.pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }
}
