import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/date_utils.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/edit_task_sheet.dart';
import '../widgets/empty_state.dart';
import '../widgets/progress_header.dart';
import '../theme/app_theme.dart' as theme;
import '../services/task_storage_service.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];
  Task? _lastDeletedTask;
  int? _lastDeletedIndex;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await TaskStorageService.loadTasks();
    if (!mounted) return;
    setState(() {
      _tasks.clear();
      _tasks.addAll(loadedTasks);
    });
  }

  List<Task> get _incompleteTasks {
    final tasks = _tasks.where((task) => !task.isCompleted).toList();
    tasks.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) {
        return a.createdAt.compareTo(b.createdAt);
      }
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return tasks;
  }

  List<Task> get _completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();


  Future<void> _addTask(String title, {String? description, DateTime? dueDate, String? dueTime}) async {
    setState(() {
      _tasks.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
        dueDate: dueDate,
        dueTime: dueTime,
      ));
    });
    await TaskStorageService.saveTasks(_tasks);
  }

  Future<void> _toggleTaskCompletion(int index) async {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    await TaskStorageService.saveTasks(_tasks);
  }

  Future<void> _deleteTask(int index) async {
    setState(() {
      _lastDeletedTask = _tasks[index];
      _lastDeletedIndex = index;
      _tasks.removeAt(index);
    });
    await TaskStorageService.saveTasks(_tasks);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            setState(() {
              if (_lastDeletedTask != null && _lastDeletedIndex != null) {
                _tasks.insert(_lastDeletedIndex!, _lastDeletedTask!);
              }
              _lastDeletedTask = null;
              _lastDeletedIndex = null;
            });
            await TaskStorageService.saveTasks(_tasks);
          },
        ),
      ),
    );
  }

  Future<void> _deleteAllTasks() async {
    if (_tasks.isEmpty) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Tasks'),
        content: const Text('Are you sure you want to delete all tasks? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: theme.AppTheme.errorColor,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _tasks.clear();
      });
      await TaskStorageService.saveTasks(_tasks);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All tasks deleted')),
      );
    }
  }

  Future<void> _editTask(int index) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditTaskSheet(
        task: _tasks[index],
        onEditTask: (title, {description, dueDate, dueTime}) async {
          setState(() {
            _tasks[index] = _tasks[index].copyWith(
              title: title,
              description: description,
              dueDate: dueDate,
              dueTime: dueTime,
            );
          });
          await TaskStorageService.saveTasks(_tasks);
        },
      ),
    );
  }
  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskSheet(onAddTask: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: null,
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 60,
        actions: [
          if (_tasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark 
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.06),
                    width: 0.5,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _deleteAllTasks,
                    borderRadius: BorderRadius.circular(14),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.delete_sweep_rounded,
                        size: 22,
                        color: theme.AppTheme.errorColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark 
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark 
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.06),
                  width: 0.5,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.settings_rounded,
                      size: 22,
                      color: theme.AppTheme.secondaryTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppDateUtils.getFormattedDate(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: theme.AppTheme.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppDateUtils.getGreeting(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                  ),
                ],
              ),
            ),
          ),
          if (_tasks.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ProgressHeader(
                  totalTasks: _tasks.length,
                  completedTasks: _completedTasks.length,
                ),
              ),
            ),
          if (_incompleteTasks.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                child: Text(
                  'Tasks',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          if (_incompleteTasks.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final taskIndex = _tasks.indexOf(_incompleteTasks[index]);
                  return TaskTile(
                    task: _tasks[taskIndex],
                    onCheckboxChanged: (value) =>
                        _toggleTaskCompletion(taskIndex),
                    onDelete: () => _deleteTask(taskIndex),
                    onEdit: () => _editTask(taskIndex),
                  );
                },
                childCount: _incompleteTasks.length,
              ),
            ),
          if (_incompleteTasks.isNotEmpty && _completedTasks.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                child: Text(
                  'Completed (${_completedTasks.length})',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: theme.AppTheme.secondaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          if (_completedTasks.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final taskIndex = _tasks.indexOf(_completedTasks[index]);
                  return TaskTile(
                    task: _tasks[taskIndex],
                    onCheckboxChanged: (value) =>
                        _toggleTaskCompletion(taskIndex),
                    onDelete: () => _deleteTask(taskIndex),
                    onEdit: () => _editTask(taskIndex),
                  );
                },
                childCount: _completedTasks.length,
              ),
            ),
          if (_tasks.isEmpty)
            SliverFillRemaining(
              child: const EmptyState(),
            ),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _showAddTaskSheet,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.AppTheme.accentColor,
                    theme.AppTheme.accentColor.withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: theme.AppTheme.accentColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: theme.AppTheme.accentColor.withValues(alpha: 0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
