import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorageService {
  static const String _tasksKey = 'tasks';

  static Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);
      
      if (tasksJson == null || tasksJson.isEmpty) {
        debugPrint('No saved tasks found');
        return [];
      }

      final List<dynamic> decoded = jsonDecode(tasksJson);
      final tasks = decoded.map((json) => Task.fromJson(json)).toList();
      
      debugPrint('Loaded ${tasks.length} tasks');
      return tasks;
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      return [];
    }
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
      await prefs.setString(_tasksKey, tasksJson);
      debugPrint('Saved ${tasks.length} tasks');
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }

  static Future<void> clearTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tasksKey);
      debugPrint('Cleared all tasks');
    } catch (e) {
      debugPrint('Error clearing tasks: $e');
    }
  }
}
