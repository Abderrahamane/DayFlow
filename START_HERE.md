# DayFlow - Course Features Implementation

## For Lina and Mohammed

**Welcome!** This branch contains all the code and instructions you need to complete your assigned tasks for the course project.

---

## Start Here

### 1. Read the Documentation

Choose based on your learning style:

**Detailed Learner?** 
→ Read **[TEAM_INSTRUCTIONS.md](./TEAM_INSTRUCTIONS.md)** first (complete guide with examples)

**Quick Learner?**
→ Read **[QUICK_REFERENCE.md](./QUICK_REFERENCE.md)** first (cheat sheet)

**Want to understand architecture?**
→ Read **[IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md)** (for deeper understanding)

### 2. Set Up Your Branch

```bash
# Make sure you're on the right branch
git checkout copilot/implement-course-features
git pull origin copilot/implement-course-features

# Create your personal branch
# Lina:
git checkout -b feature/lina-state-management

# Mohammed:
git checkout -b feature/mohammed-backend-analytics
```

### 3. Start Working on Your Tasks

See the "Who Does What" section below.

---

## Who Does What?

### Lina's Responsibilities

**Issue 3 - Mixpanel Analytics (Partial)**
- [ ] Add login tracking in login page
- [ ] Add habit creation tracking

**Issue 5 - State Management (Full)**
- [ ] Update To-Do page to use TasksProvider
- [ ] Update Habits page to use HabitsProvider
- [ ] Update login page to use AuthProvider
- [ ] Update logout to use AuthProvider

**Your Documentation:**
- Primary: [TEAM_INSTRUCTIONS.md](./TEAM_INSTRUCTIONS.md) → See "Issue 5" section
- Quick ref: [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) → See "Issue 5" section

### Mohammed's Responsibilities

**Issue 3 - Mixpanel Analytics (Partial)**
- [ ] Get Mixpanel token
- [ ] Add token to main.dart
- [ ] Add task completion tracking

**Issue 4 - Node.js Backend (Full)**
- [ ] Install dependencies
- [ ] Set up MongoDB
- [ ] Configure environment
- [ ] Start server
- [ ] Test API endpoint

**Your Documentation:**
- Primary: [TEAM_INSTRUCTIONS.md](./TEAM_INSTRUCTIONS.md) → See "Issue 3" and "Issue 4" sections
- Backend guide: [backend/README.md](./backend/README.md)
- Quick ref: [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        DayFlow Application                       │
└─────────────────────────────────────────────────────────────────┘

                         USER INTERFACE
                              ↓ ↑
┌──────────────┬──────────────┬──────────────┬──────────────────┐
│   To-Do      │   Habits     │   Login      │    Settings      │
│   Page       │   Page       │   Page       │    Page          │
└──────┬───────┴──────┬───────┴──────┬───────┴──────┬───────────┘
       │              │              │              │
       ↓              ↓              ↓              ↓
┌──────────────┬──────────────┬──────────────┬──────────────────┐
│  Tasks       │  Habits      │  Auth        │  Analytics       │
│  Provider    │  Provider    │  Provider    │  Provider        │
└──────┬───────┴──────┬───────┴──────┬───────┴──────┬───────────┘
       │              │              │              │
       ↓              ↓              ↓              ↓
┌──────────────┬──────────────┬──────────────┬──────────────────┐
│  Firestore   │  Firestore   │  Firebase    │  Mixpanel        │
│  (Tasks)     │  (Habits)    │  Auth        │  Service         │
└──────────────┴──────────────┴──────────────┴──────────────────┘


                    BACKEND (Separate)
┌─────────────────────────────────────────────────────────────────┐
│  Node.js + Express.js Server                                    │
│  ├── Routes    (API endpoints)                                  │
│  ├── Controllers (Business logic)                               │
│  ├── Models    (Data schemas)                                   │
│  └── Config    (Database connection)                            │
│                     ↓ ↑                                          │
│                  MongoDB                                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## What's New?

### New Flutter Files

**Providers** (State Management):
- `lib/providers/analytics_provider.dart` - Analytics state
- `lib/providers/auth_provider.dart` - Authentication state
- `lib/providers/tasks_provider.dart` - Tasks with Firestore
- `lib/providers/habits_provider.dart` - Habits with Firestore

**Services**:
- `lib/services/mixpanel_service.dart` - Mixpanel integration

**Updated Models**:
- `lib/models/task_model.dart` - Added Firestore methods
- `lib/models/habit_model.dart` - Added Firestore methods

**Updated Main**:
- `lib/main.dart` - Registered all new providers

### New Backend Files

```
backend/
├── config/database.js         ← MongoDB connection
├── controllers/statusController.js  ← Status logic
├── models/User.js             ← Example user model
├── routes/status.js           ← Status route
├── .env.example               ← Environment template
├── .gitignore                 ← Git ignore
├── package.json               ← Dependencies
├── README.md                  ← Setup guide
└── server.js                  ← Main server
```

### Documentation Files

- `TEAM_INSTRUCTIONS.md` - Complete guide (READ THIS!)
- `QUICK_REFERENCE.md` - Quick lookup
- `IMPLEMENTATION_SUMMARY.md` - Architecture details
- `backend/README.md` - Backend setup guide

---

## What's Already Done

You don't need to create these - they're ready to use:

- Mixpanel service with all tracking methods
- Analytics provider for state management  
- Tasks provider with Firestore integration
- Habits provider with Firestore integration
- Auth provider with Firebase
- Backend server structure
- MongoDB connection setup
- API status endpoint
- All providers registered in main.dart

**You just need to:**
1. Configure tokens/databases
2. Integrate providers in your assigned pages
3. Test everything works

---

## Quick Start

### For Lina

```bash
# 1. Install dependencies
flutter pub get

# 2. Read your sections in TEAM_INSTRUCTIONS.md
#    - Issue 3: Mixpanel Analytics (your parts)
#    - Issue 5: State Management (full)

# 3. Start with Issue 5 (State Management)
#    Update these files:
#    - lib/pages/todo_page.dart
#    - lib/pages/habits_page.dart
#    - lib/pages/auth/login_page.dart
#    - lib/pages/settings_page.dart

# 4. Then do Issue 3 (Analytics)
#    Add tracking to login and habit creation

# 5. Test everything works
flutter run
```

### For Mohammed

```bash
# 1. Set up Mixpanel (Issue 3)
#    - Create account at mixpanel.com
#    - Get project token
#    - Add to lib/main.dart line 34

# 2. Set up Backend (Issue 4)
cd backend
npm install
cp .env.example .env
# Edit .env and add MongoDB URI
npm run dev

# 3. Test backend
# Visit: http://localhost:5000/api/status

# 4. Add task completion tracking (Issue 3)
#    Edit lib/pages/todo_page.dart
#    Add analytics tracking when task completed

# 5. Test everything works
```

---

## Testing Checklist

### Lina Tests

- [ ] Tasks load from Firestore using TasksProvider
- [ ] Can create/update/delete tasks via provider
- [ ] Task completion works
- [ ] Habits load from Firestore using HabitsProvider
- [ ] Can create/update/delete habits via provider
- [ ] Login works with AuthProvider
- [ ] Logout works with AuthProvider
- [ ] Login event tracked in Mixpanel
- [ ] Habit creation tracked in Mixpanel

### Mohammed Tests

- [ ] Mixpanel token added and app runs
- [ ] Backend server starts without errors
- [ ] MongoDB connection successful
- [ ] GET /api/status returns correct JSON
- [ ] Task completion tracked in Mixpanel
- [ ] All events visible in Mixpanel dashboard

---

## Need Help?

### Step 1: Check Documentation
- **Detailed help**: TEAM_INSTRUCTIONS.md
- **Quick lookup**: QUICK_REFERENCE.md
- **Backend help**: backend/README.md

### Step 2: Check Error Message
- Read the error carefully
- Copy error and Google it

### Step 3: Ask for Help
- Ask your teammate (Lina ↔ Mohammed)
- Ask Abderrahmane (team lead)

### Common Issues

**"Provider not found"**
→ Check you're using correct type: `Provider.of<TasksProvider>`

**"Mixpanel not initialized"**
→ Check token is added in main.dart and app restarted

**"Port 5000 already in use"**
→ Change PORT in backend/.env to 3000

**"MongoDB connection failed"**
→ Check .env has correct URI, check MongoDB is running

---

## Progress Tracking

### Issue 3: Mixpanel Analytics
- [ ] Mohammed: Get token and add to main.dart
- [ ] Mohammed: Track task completion
- [ ] Lina: Track login
- [ ] Lina: Track habit creation
- [ ] Both: Verify events in Mixpanel dashboard

### Issue 4: Backend (Mohammed only)
- [ ] Install dependencies
- [ ] Set up MongoDB
- [ ] Configure .env
- [ ] Start server successfully
- [ ] Test API endpoint

### Issue 5: State Management (Lina only)
- [ ] Update To-Do page
- [ ] Update Habits page
- [ ] Update Login page
- [ ] Update Logout in Settings
- [ ] Test all CRUD operations

---

## Deliverables

When you're done, create a Pull Request with:

1. ✅ Your code changes
2. ✅ Screenshots showing:
   - Features working
   - Mixpanel dashboard (if applicable)
   - Backend running (Mohammed)
3. ✅ Description of what you did
4. ✅ Any issues you encountered

---

## Tips for Success

1. **Read first, code second** - Understand before implementing
2. **Test frequently** - Don't wait until the end
3. **One task at a time** - Don't try to do everything at once
4. **Use the examples** - Copy patterns from documentation
5. **Ask questions early** - Don't struggle alone
6. **Help each other** - You're a team!

---

## You've Got This!

Everything is set up for you. The infrastructure is ready, the documentation is comprehensive, and your teammates are here to help.

**Just follow the instructions in TEAM_INSTRUCTIONS.md and you'll do great!** 🚀

---

## Contact

**Team Lead**: Abderrahmane  
**Team Members**: Lina & Mohammed

**Repository**: https://github.com/Abderrahamane/DayFlow

---

**Good luck! Happy coding! 🎊**
