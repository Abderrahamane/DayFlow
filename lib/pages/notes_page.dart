import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/app_localizations.dart';
import '../blocs/note/note_bloc.dart';
import '../models/note_model.dart';
import '../services/biometric_service.dart';
import '../theme/app_theme.dart';
import 'note_editor_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(LoadNotes());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openNoteEditor({Note? note}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<NoteBloc>(),
          child: NoteEditorPage(note: note),
        ),
      ),
    );
  }

  void _showCreateOptions() {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.createNew,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            _CreateOptionTile(
              icon: Icons.note_add,
              title: l10n.textNote,
              subtitle: l10n.simpleTextNote,
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.pop(ctx);
                _openNoteEditor(
                  note: Note(
                    id: '',
                    title: '',
                    content: '',
                    createdAt: DateTime.now(),
                    type: NoteType.text,
                  ),
                );
              },
            ),
            _CreateOptionTile(
              icon: Icons.checklist,
              title: l10n.checklist,
              subtitle: l10n.taskListWithCheckboxes,
              color: AppTheme.successColor,
              onTap: () {
                Navigator.pop(ctx);
                _openNoteEditor(
                  note: Note(
                    id: '',
                    title: '',
                    content: '',
                    createdAt: DateTime.now(),
                    type: NoteType.checklist,
                    checklistItems: [],
                  ),
                );
              },
            ),
            _CreateOptionTile(
              icon: Icons.text_fields,
              title: l10n.richTextNote,
              subtitle: l10n.withFormattingOptions,
              color: Colors.purple,
              onTap: () {
                Navigator.pop(ctx);
                _openNoteEditor(
                  note: Note(
                    id: '',
                    title: '',
                    content: '',
                    createdAt: DateTime.now(),
                    type: NoteType.richText,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<NoteBloc>(),
        child: const _FilterSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: l10n.openMenu,
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.searchNotesHint,
                  border: InputBorder.none,
                ),
                onChanged: (query) =>
                    context.read<NoteBloc>().add(SearchNotesEvent(query)),
              )
            : Text(l10n.notesTitle),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() => _isSearching = !_isSearching);
              if (!_isSearching) {
                _searchController.clear();
                context.read<NoteBloc>().add(ClearSearchEvent());
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state.status == NoteStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == NoteStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text(l10n.failedToLoadNotes,
                      style: theme.textTheme.titleLarge),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.read<NoteBloc>().add(LoadNotes()),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state.filteredNotes.isEmpty) {
            return _EmptyState(
              hasFilter: state.hasActiveFilter || state.searchQuery.isNotEmpty,
              onCreate: _showCreateOptions,
            );
          }

          return Column(
            children: [
              // Filter chips
              if (state.hasActiveFilter)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      if (state.selectedCategory != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            label: Text(
                                '${state.selectedCategory!.icon} ${state.selectedCategory!.displayName}'),
                            onDeleted: () => context
                                .read<NoteBloc>()
                                .add(const FilterByCategoryEvent(null)),
                          ),
                        ),
                      if (state.selectedTag != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            label: Text('#${state.selectedTag}'),
                            onDeleted: () => context
                                .read<NoteBloc>()
                                .add(const FilterByTagEvent(null)),
                          ),
                        ),
                      if (state.selectedType != null)
                        Chip(
                          label: Text(state.selectedType!.displayName),
                          onDeleted: () => context
                              .read<NoteBloc>()
                              .add(const FilterByTypeEvent(null)),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            context.read<NoteBloc>().add(ClearFiltersEvent()),
                        child: Text(l10n.clearAll),
                      ),
                    ],
                  ),
                ),
              // Notes grid
              Expanded(
                child: _NotesGrid(
                  pinnedNotes: state.pinnedNotes,
                  unpinnedNotes: state.unpinnedNotes,
                  onNoteTap: (note) => _handleNoteTap(context, note),
                  onNoteOptions: (note) => _showNoteOptions(context, note),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateOptions,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _handleNoteTap(BuildContext context, Note note) async {
    if (note.isLocked) {
      final authenticated = await _authenticateNote(context, note);
      if (!authenticated) return;
    }
    _openNoteEditor(note: note);
  }

  Future<bool> _authenticateNote(BuildContext context, Note note) async {
    final l10n = AppLocalizations.of(context);

    if (note.useBiometric) {
      final success = await BiometricService.authenticate(
        reason: l10n.authenticateToViewNote,
      );
      if (success) return true;
    }

    if (note.lockPin != null) {
      return await _showPinDialog(context, note.lockPin!);
    }

    return false;
  }

  Future<bool> _showPinDialog(BuildContext context, String correctPin) async {
    final l10n = AppLocalizations.of(context);

    final pinController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.enterPin),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          decoration: InputDecoration(
            hintText: l10n.enter4DigitPin,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx, pinController.text == correctPin);
            },
            child: Text(l10n.unlock),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showNoteOptions(BuildContext context, Note note) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                  note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(note.isPinned ? l10n.unpin : l10n.pinToTop),
              onTap: () {
                Navigator.pop(ctx);
                context.read<NoteBloc>().add(ToggleNotePinEvent(note.id));
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: Text(l10n.changeColor),
              onTap: () {
                Navigator.pop(ctx);
                _showColorPicker(context, note);
              },
            ),
            ListTile(
              leading: Icon(note.isLocked ? Icons.lock_open : Icons.lock),
              title: Text(note.isLocked ? l10n.removeLock : l10n.lockNote),
              onTap: () {
                Navigator.pop(ctx);
                if (note.isLocked) {
                  context.read<NoteBloc>().add(UnlockNoteEvent(note.id));
                } else {
                  _showLockOptions(context, note);
                }
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.delete_outline, color: theme.colorScheme.error),
              title: Text(l10n.delete,
                  style: TextStyle(color: theme.colorScheme.error)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, note);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, Note note) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.chooseColor,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: NoteColors.colors.length,
              itemBuilder: (context, index) {
                final color = NoteColors.colors[index];
                final isSelected = note.color == color ||
                    (note.color == null && color == const Color(0xFFFFFFFF));
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    context.read<NoteBloc>().add(ChangeNoteColorEvent(
                          note.id,
                          color == const Color(0xFFFFFFFF) ? null : color,
                        ));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withAlpha(128),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 24,
                            color: NoteColors.getContrastText(color),
                          )
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLockOptions(BuildContext context, Note note) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // Lock icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.secureYourNote,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chooseHowToProtectNote,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            // Biometric option
            _LockOptionCard(
              icon: Icons.fingerprint,
              title: l10n.biometrics,
              subtitle: l10n.useFingerprintOrFace,
              color: Colors.green,
              onTap: () async {
                final canAuth = await BiometricService.canAuthenticate();
                if (canAuth) {
                  Navigator.pop(ctx);
                  context.read<NoteBloc>().add(
                        LockNoteEvent(note.id, useBiometric: true),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.noteLockedWithBiometrics),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.biometricsNotAvailable),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            // PIN option
            _LockOptionCard(
              icon: Icons.pin,
              title: l10n.pinCode,
              subtitle: l10n.set4DigitSecurityCode,
              color: Colors.blue,
              onTap: () {
                Navigator.pop(ctx);
                _showSetPinDialog(context, note);
              },
            ),
            const SizedBox(height: 12),
            // Both option
            _LockOptionCard(
              icon: Icons.security,
              title: l10n.both,
              subtitle: l10n.useBiometricsWithPinBackup,
              color: Colors.purple,
              onTap: () async {
                final canAuth = await BiometricService.canAuthenticate();
                if (canAuth) {
                  Navigator.pop(ctx);
                  _showSetPinDialogWithBiometric(context, note);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.biometricsNotAvailableUsingPin),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(ctx);
                  _showSetPinDialog(context, note);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSetPinDialogWithBiometric(BuildContext context, Note note) {
    final l10n = AppLocalizations.of(context);

    final pinController = TextEditingController();
    final confirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.security, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(l10n.setBackupPin),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.setPinBackupForBiometrics,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                hintText: '••••',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                hintText: l10n.confirmPin,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (pinController.text.length == 4 &&
                  pinController.text == confirmController.text) {
                Navigator.pop(ctx);
                context.read<NoteBloc>().add(
                      LockNoteEvent(note.id,
                          pin: pinController.text, useBiometric: true),
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.noteLockedWithBiometrics),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (pinController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.pinsDoNotMatch),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(l10n.lockNote),
          ),
        ],
      ),
    );
  }

  void _showSetPinDialog(BuildContext context, Note note) {
    final l10n = AppLocalizations.of(context);

    final pinController = TextEditingController();
    final confirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.pin, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(l10n.pinCode),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.set4DigitSecurityCode,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                hintText: '••••',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                hintText: l10n.confirmPin,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (pinController.text.length == 4 &&
                  pinController.text == confirmController.text) {
                Navigator.pop(ctx);
                context.read<NoteBloc>().add(
                      LockNoteEvent(note.id, pin: pinController.text),
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🔒 ${l10n.lockNote}'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (pinController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.pinsDoNotMatch),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(l10n.lockNote),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Note note) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteNote),
        content: Text(l10n.deleteNoteConfirmMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<NoteBloc>().add(DeleteNoteEvent(note.id));
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _CreateOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CreateOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasFilter;
  final VoidCallback onCreate;

  const _EmptyState({
    required this.hasFilter,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilter ? Icons.filter_alt_off : Icons.note_add,
              size: 80,
              color: theme.colorScheme.primary.withAlpha(128),
            ),
            const SizedBox(height: 24),
            Text(
              hasFilter ? l10n.noNotesMatchingFilters : l10n.noNotesYet,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hasFilter
                  ? l10n.tryAdjustingYourFilters
                  : l10n.startCreatingNotes,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withAlpha(179),
              ),
            ),
            if (!hasFilter) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: Text(l10n.createFirstNote),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotesGrid extends StatelessWidget {
  final List<Note> pinnedNotes;
  final List<Note> unpinnedNotes;
  final Function(Note) onNoteTap;
  final Function(Note) onNoteOptions;

  const _NotesGrid({
    required this.pinnedNotes,
    required this.unpinnedNotes,
    required this.onNoteTap,
    required this.onNoteOptions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pinnedNotes.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.push_pin, size: 16),
                const SizedBox(width: 4),
                Text(
                  l10n.pinned,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildGrid(pinnedNotes),
          const SizedBox(height: 24),
        ],
        if (unpinnedNotes.isNotEmpty && pinnedNotes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              l10n.others,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        _buildGrid(unpinnedNotes),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildGrid(List<Note> notes) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return _NoteCard(
          note: note,
          onTap: () => onNoteTap(note),
          onLongPress: () => onNoteOptions(note),
        );
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final bgColor = note.color ?? theme.colorScheme.surface;
    final textColor = NoteColors.getContrastText(bgColor);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icons
            Row(
              children: [
                if (note.isLocked)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.lock, size: 14, color: textColor.withAlpha(179)),
                  ),
                if (note.isPinned)
                  Icon(Icons.push_pin, size: 14, color: textColor.withAlpha(179)),
                const Spacer(),
                if (note.category != null)
                  Text(
                    note.category!.icon,
                    style: const TextStyle(fontSize: 14),
                  ),
                if (note.hasAttachments)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(Icons.attach_file, size: 14, color: textColor.withAlpha(179)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              note.title.isEmpty ? l10n.untitled : note.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Content preview or checklist preview
            Expanded(
              child: note.isChecklist
                  ? _ChecklistPreview(
                      items: note.checklistItems ?? [],
                      textColor: textColor,
                    )
                  : Text(
                      note.isLocked ? '••••••••' : note.contentPreview,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor.withAlpha(179),
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            const SizedBox(height: 8),
            // Footer
            Row(
              children: [
                Text(
                  note.formattedDate,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textColor.withAlpha(128),
                  ),
                ),
                const Spacer(),
                if (note.type != NoteType.text)
                  Icon(
                    note.type.icon,
                    size: 14,
                    color: textColor.withAlpha(128),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistPreview extends StatelessWidget {
  final List<ChecklistItem> items;
  final Color textColor;

  const _ChecklistPreview({
    required this.items,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = items.take(4).toList();
    final remaining = items.length - 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displayItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Icon(
                    item.isChecked
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    size: 14,
                    color: textColor.withAlpha(179),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.text,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withAlpha(179),
                        decoration:
                            item.isChecked ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
        if (remaining > 0)
          Text(
            '+$remaining more',
            style: TextStyle(
              fontSize: 11,
              color: textColor.withAlpha(128),
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.filterNotes,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text('By Type',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: NoteType.values.map((type) {
                  return FilterChip(
                    label: Text(type.displayName),
                    avatar: Icon(type.icon, size: 18),
                    selected: state.selectedType == type,
                    onSelected: (_) {
                      context.read<NoteBloc>().add(FilterByTypeEvent(
                            state.selectedType == type ? null : type,
                          ));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('By Category',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: NoteCategory.values.map((category) {
                  return FilterChip(
                    label: Text('${category.icon} ${category.displayName}'),
                    selected: state.selectedCategory == category,
                    onSelected: (_) {
                      context.read<NoteBloc>().add(FilterByCategoryEvent(
                            state.selectedCategory == category ? null : category,
                          ));
                    },
                  );
                }).toList(),
              ),
              if (state.allTags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('By Tag',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: state.allTags.map((tag) {
                    return FilterChip(
                      label: Text('#$tag'),
                      selected: state.selectedTag == tag,
                      onSelected: (_) {
                        context.read<NoteBloc>().add(FilterByTagEvent(
                              state.selectedTag == tag ? null : tag,
                            ));
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<NoteBloc>().add(ClearFiltersEvent());
                    Navigator.pop(context);
                  },
                  child: Text(l10n.clearAll),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LockOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _LockOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

