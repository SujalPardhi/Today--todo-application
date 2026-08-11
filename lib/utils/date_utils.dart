class AppDateUtils {
  static String getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  static String getTaskDate(DateTime dateTime) {
    final now = DateTime.now();
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == tomorrow) {
      return 'Tomorrow';
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]}';
    }
  }

  static String getTaskDateTime(DateTime? dueDate, String? dueTime) {
    if (dueDate == null && dueTime == null) {
      return '';
    }
    
    final parts = <String>[];
    
    if (dueDate != null) {
      parts.add(getTaskDate(dueDate));
    }
    
    if (dueTime != null) {
      parts.add(dueTime);
    }
    
    return parts.join(' · ');
  }

  static bool isOverdue(DateTime? dueDate, bool isCompleted) {
    if (dueDate == null || isCompleted) {
      return false;
    }
    
    final now = DateTime.now();
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final today = DateTime(now.year, now.month, now.day);
    
    return taskDate.isBefore(today);
  }

  static String getOverdueText(DateTime? dueDate) {
    if (dueDate == null) {
      return '';
    }
    
    final now = DateTime.now();
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    
    if (taskDate == yesterday) {
      return 'Overdue · Yesterday';
    } else {
      return 'Overdue · ${getTaskDate(dueDate)}';
    }
  }
}
