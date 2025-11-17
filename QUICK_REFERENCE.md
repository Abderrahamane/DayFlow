# DayFlow Course Features - Quick Reference

## 🚀 Getting Started

### For Everyone

1. **Pull latest changes**:
```bash
git checkout copilot/implement-course-features
git pull origin copilot/implement-course-features
```

2. **Read the full instructions**: Open `TEAM_INSTRUCTIONS.md`

3. **Create your branch**:
```bash
# Lina:
git checkout -b feature/lina-state-management

# Mohammed:
git checkout -b feature/mohammed-backend-analytics
```

---

## 📊 Issue 3: Mixpanel Analytics (Lina + Mohammed)

### Mohammed's Quick Setup

```bash
# 1. Get Mixpanel token
# Go to https://mixpanel.com → Sign up → Create project "DayFlow"
# Copy your project token

# 2. Add token to app
# Edit lib/main.dart line 34
# Replace: 'YOUR_MIXPANEL_TOKEN_HERE'
# With: 'your-actual-token-abc123'

# 3. Install dependencies
flutter pub get
```

### Where to Add Tracking

**Lina - Login tracking** (`lib/pages/auth/login_page.dart`):
```dart
final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
analytics.trackLogin(userId: user.uid, email: user.email ?? '', loginProvider: 'email');
```

**Mohammed - Task completion** (`lib/pages/todo_page.dart`):
```dart
final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
analytics.trackTaskCompleted(taskId: task.id, taskTitle: task.title, priority: 'high');
```

**Lina - Habit creation** (`lib/pages/habits_page.dart`):
```dart
final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
analytics.trackHabitCreated(habitId: habit.id, habitName: habit.name, frequency: 'daily');
```

---

## 🖥️ Issue 4: Node.js Backend (Mohammed)

### Quick Setup

```bash
# 1. Go to backend folder
cd backend

# 2. Install dependencies
npm install

# 3. Set up MongoDB Atlas (cloud option)
# Go to https://mongodb.com/cloud/atlas
# Sign up → Create cluster → Get connection string

# 4. Create .env file
cp .env.example .env

# Edit .env and add:
# MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/dayflow

# 5. Start server
npm run dev

# 6. Test it works
# Visit: http://localhost:5000/api/status
# Should return: { "ok": true, ... }
```

---

## 🎨 Issue 5: State Management (Lina)

### Provider Pattern

**Pattern 1: Load data on page open**
```dart
@override
void initState() {
  super.initState();
  Future.microtask(() {
    Provider.of<TasksProvider>(context, listen: false).loadTasks();
  });
}
```

**Pattern 2: Display data with Consumer**
```dart
@override
Widget build(BuildContext context) {
  return Consumer<TasksProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading) return CircularProgressIndicator();
      
      return ListView.builder(
        itemCount: provider.tasks.length,
        itemBuilder: (context, index) {
          final task = provider.tasks[index];
          return TaskTile(task: task);
        },
      );
    },
  );
}
```

**Pattern 3: Call provider methods**
```dart
final provider = Provider.of<TasksProvider>(context, listen: false);
await provider.addTask(newTask);
await provider.toggleTaskCompletion(taskId);
await provider.deleteTask(taskId);
```

### Files to Update

- `lib/pages/todo_page.dart` → Use TasksProvider
- `lib/pages/habits_page.dart` → Use HabitsProvider
- `lib/pages/auth/login_page.dart` → Use AuthProvider
- `lib/pages/settings_page.dart` → Use AuthProvider for logout

---

## 🧪 Testing Checklist

### Lina

- [ ] Login works and tracks to Mixpanel
- [ ] Tasks load using TasksProvider
- [ ] Can create/complete/delete tasks
- [ ] Habits load using HabitsProvider
- [ ] Can create habits and tracks to Mixpanel
- [ ] Logout works with AuthProvider

### Mohammed

- [ ] Mixpanel token added to main.dart
- [ ] Task completion tracks to Mixpanel
- [ ] Events visible in Mixpanel dashboard
- [ ] Backend server starts successfully
- [ ] MongoDB connects (see "connected" in terminal)
- [ ] GET /api/status returns correct JSON

---

## 📝 Commit and PR

```bash
# 1. Check what changed
git status

# 2. Add changes
git add .

# 3. Commit with message
git commit -m "Implement Mixpanel tracking for login and habits"

# 4. Push
git push origin feature/your-branch-name

# 5. Create PR on GitHub
# Go to repository → Pull Requests → New Pull Request
```

---

## 🆘 Common Issues

### "Provider not found"
**Solution**: Make sure you're using `Provider.of<TasksProvider>` with the correct type.

### "MixpanelService not initialized"
**Solution**: Check that Mixpanel token is added in main.dart and app has been restarted.

### "Port 5000 already in use"
**Solution**: Change `PORT=3000` in backend/.env

### "MongoDB connection failed"
**Solution**: 
- Check MongoDB service is running (local)
- Verify connection string in .env (cloud)
- Add `0.0.0.0/0` to IP whitelist in Atlas

---

## 📚 Documentation Files

- **TEAM_INSTRUCTIONS.md** - Full detailed instructions
- **backend/README.md** - Backend setup guide
- **QUICK_REFERENCE.md** - This file (quick lookup)

---

## 🎯 Division of Work

### Lina (State Management + Analytics)
1. Track login with Mixpanel
2. Track habit creation with Mixpanel
3. Update To-Do page to use TasksProvider
4. Update Habits page to use HabitsProvider
5. Update Auth pages to use AuthProvider

### Mohammed (Backend + Analytics)
1. Get Mixpanel token and add to main.dart
2. Track task completion with Mixpanel
3. Set up Node.js backend
4. Configure MongoDB
5. Test backend API

---

## 💡 Tips

- **Test frequently** - Don't wait until the end
- **Read error messages** - They usually tell you what's wrong
- **Ask for help** - Your teammate or team lead
- **Take screenshots** - Include them in your PR
- **Document issues** - If something doesn't work, write it down

---

## 🏁 Done?

When you finish:
1. ✅ Test everything works
2. ✅ Take screenshots
3. ✅ Commit and push
4. ✅ Create Pull Request
5. ✅ Request review from Abderrahmane
6. ✅ Review your teammate's PR

Good luck! 🚀
