# 🎨 theme/ Folder Documentation

## Overview

The `theme/` folder contains the **visual styling** configuration for the DayFlow app. This includes colors, typography, spacing, and all visual design elements.

**Think of theme as the interior designer**: Just like an interior designer chooses colors, furniture, and decorations for a house, the theme defines how your app looks and feels.

---

## What is Theming?

Theming is the process of defining consistent visual styles across your app:
- 🎨 Colors (primary, secondary, background, etc.)
- ✍️ Typography (fonts, sizes, weights)
- 📐 Spacing (padding, margins)
- 🎭 Shapes (rounded corners, borders)
- 🌓 Dark/Light modes

### Why Use Themes?

✅ **Consistency**: Same look and feel everywhere
✅ **Maintainability**: Change color once, updates everywhere
✅ **Professional**: Cohesive, polished appearance
✅ **Accessibility**: Better for users with visual preferences
✅ **Branding**: Reflects your app's identity

---

## Files in theme/

```
theme/
└── app_theme.dart    # Complete theme configuration
```

---

## 🎨 app_theme.dart

**Purpose**: Defines the complete visual theme for light and dark modes.

### Theme Components

The file contains:
1. **ThemeProvider** - Manages theme state
2. **Color Definitions** - App color palette
3. **Light Theme** - Light mode styling
4. **Dark Theme** - Dark mode styling

---

## 🔄 ThemeProvider

**Purpose**: Manages which theme (light/dark/system) is currently active.

### Properties

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;  // Default to system
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // Follow system setting
      return WidgetsBinding.instance.platformDispatcher.platformBrightness 
             == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
```

### Methods

#### Set Theme Mode
```dart
void setThemeMode(ThemeMode mode) {
  _themeMode = mode;
  notifyListeners();  // Updates entire app
}
```

#### Toggle Theme
```dart
void toggleTheme() {
  _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  notifyListeners();
}
```

### Using ThemeProvider

```dart
// In main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    // ... other providers
  ],
  child: MyApp(),
)

// In MaterialApp
return Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,      // Light mode config
      darkTheme: AppTheme.darkTheme,   // Dark mode config
      // ...
    );
  },
);

// In settings page to toggle
final themeProvider = Provider.of<ThemeProvider>(context);
SwitchListTile(
  title: Text('Dark Mode'),
  value: themeProvider.isDarkMode,
  onChanged: (value) {
    themeProvider.toggleTheme();
  },
);
```

---

## 🎨 Color Palette

### Light Mode Colors

```dart
static const Color primaryLight = Color(0xFF6366F1);      // Indigo
static const Color primaryDark = Color(0xFF818CF8);       // Lighter Indigo
static const Color secondaryLight = Color(0xFF8B5CF6);    // Purple
static const Color secondaryDark = Color(0xFFA78BFA);     // Lighter Purple
static const Color backgroundLight = Color(0xFFF8FAFC);   // Very light gray
static const Color backgroundDark = Color(0xFF0F172A);    // Very dark blue
static const Color surfaceLight = Color(0xFFFFFFFF);      // White
static const Color surfaceDark = Color(0xFF1E293B);       // Dark blue-gray
static const Color errorColor = Color(0xFFEF4444);        // Red
static const Color successColor = Color(0xFF10B981);      // Green
```

### Color Usage

- **Primary**: Main brand color (buttons, links, active items)
- **Secondary**: Accent color (highlights, special elements)
- **Background**: App background color
- **Surface**: Card/container background
- **Error**: Error messages, destructive actions
- **Success**: Success messages, completed items

### Visual Representation

**Light Mode**:
```
┌────────────────────────────────────────┐
│ Primary: Indigo (#6366F1)              │  🟦
│ Secondary: Purple (#8B5CF6)            │  🟪
│ Background: Light Gray (#F8FAFC)       │  ⬜
│ Surface: White (#FFFFFF)               │  ⬜
│ Error: Red (#EF4444)                   │  🟥
│ Success: Green (#10B981)               │  🟩
└────────────────────────────────────────┘
```

**Dark Mode**:
```
┌────────────────────────────────────────┐
│ Primary: Light Indigo (#818CF8)        │  🟦
│ Secondary: Light Purple (#A78BFA)      │  🟪
│ Background: Dark Blue (#0F172A)        │  ⬛
│ Surface: Dark Blue-Gray (#1E293B)      │  ⬛
│ Error: Red (#EF4444)                   │  🟥
│ Success: Green (#10B981)               │  🟩
└────────────────────────────────────────┘
```

---

## ☀️ Light Theme Configuration

```dart
static ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  
  // Color scheme
  colorScheme: const ColorScheme.light(
    primary: primaryLight,
    secondary: secondaryLight,
    surface: surfaceLight,
    error: errorColor,
  ),
  
  // Scaffold (page background)
  scaffoldBackgroundColor: backgroundLight,
  
  // App Bar
  appBarTheme: const AppBarTheme(
    elevation: 0,                         // Flat design
    centerTitle: false,                   // Title on left
    backgroundColor: surfaceLight,
    foregroundColor: Colors.black87,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  
  // Bottom Navigation Bar
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: surfaceLight,
    selectedItemColor: primaryLight,
    unselectedItemColor: Colors.black54,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
  ),
  
  // Drawer (side menu)
  drawerTheme: const DrawerThemeData(
    backgroundColor: surfaceLight,
    elevation: 8,
  ),
  
  // Cards
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: surfaceLight,
  ),
  
  // Floating Action Button
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryLight,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  
  // Input Fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryLight, width: 2),
    ),
  ),
  
  // Elevated Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  
  // Text Buttons
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryLight,
    ),
  ),
  
  // Chips
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey[200]!,
    selectedColor: primaryLight,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
);
```

---

## 🌙 Dark Theme Configuration

Similar structure to light theme but with dark colors:

```dart
static ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  
  // Color scheme
  colorScheme: const ColorScheme.dark(
    primary: primaryDark,
    secondary: secondaryDark,
    surface: surfaceDark,
    error: errorColor,
  ),
  
  // Scaffold
  scaffoldBackgroundColor: backgroundDark,
  
  // App Bar
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: surfaceDark,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  
  // ... similar structure as light theme with dark colors
);
```

---

## Using Themes in Widgets

### Access Theme Colors

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  
  return Container(
    color: theme.colorScheme.primary,     // Primary color
    child: Text(
      'Hello',
      style: theme.textTheme.headlineMedium,  // Text style
    ),
  );
}
```

### Common Theme Properties

```dart
// Colors
theme.colorScheme.primary          // Primary color
theme.colorScheme.secondary        // Secondary color
theme.colorScheme.surface          // Surface color
theme.colorScheme.error            // Error color
theme.scaffoldBackgroundColor      // Page background

// Text Styles
theme.textTheme.displayLarge       // Large heading
theme.textTheme.displayMedium      // Medium heading
theme.textTheme.displaySmall       // Small heading
theme.textTheme.headlineMedium     // Headline
theme.textTheme.bodyLarge          // Large body text
theme.textTheme.bodyMedium         // Medium body text
theme.textTheme.bodySmall          // Small body text
theme.textTheme.labelLarge         // Button text

// Other
theme.cardColor                    // Card background
theme.dividerColor                 // Divider color
theme.shadowColor                  // Shadow color
```

### Responsive to Theme Changes

```dart
// Automatically updates when theme changes
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).cardColor,  // Updates with theme
    borderRadius: BorderRadius.circular(12),
  ),
)
```

---

## Theme Customization

### Custom Colors for Specific Use Cases

```dart
class TaskPriorityColors {
  static Color getColor(TaskPriority priority, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    switch (priority) {
      case TaskPriority.high:
        return isDark ? Colors.red[300]! : Colors.red[700]!;
      case TaskPriority.medium:
        return isDark ? Colors.orange[300]! : Colors.orange[700]!;
      case TaskPriority.low:
        return isDark ? Colors.blue[300]! : Colors.blue[700]!;
      case TaskPriority.none:
        return isDark ? Colors.grey[400]! : Colors.grey[600]!;
    }
  }
}

// Usage
Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: TaskPriorityColors.getColor(task.priority, context),
    ),
  ),
)
```

### Custom Text Styles

```dart
class AppTextStyles {
  static TextStyle taskTitle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.w600,
    );
  }
  
  static TextStyle taskDescription(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
    );
  }
  
  static TextStyle dueDate(BuildContext context, {bool isOverdue = false}) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      color: isOverdue 
          ? Theme.of(context).colorScheme.error 
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
    );
  }
}

// Usage
Text(
  task.title,
  style: AppTextStyles.taskTitle(context),
)
```

---

## Material 3 vs Material 2

DayFlow uses **Material 3** (latest design system):

### Material 3 Features

✅ **Better color system**: More flexible color roles
✅ **Improved components**: Updated button, card designs
✅ **Elevation system**: Better shadow/elevation handling
✅ **Dynamic colors**: Can adapt to user's device theme
✅ **Better accessibility**: Improved contrast ratios

### Enable Material 3

```dart
ThemeData(
  useMaterial3: true,  // Enable Material 3
  // ...
)
```

---

## Theme Best Practices

### ✅ DO:

1. **Use theme colors**
   ```dart
   // Good: Uses theme
   color: Theme.of(context).colorScheme.primary
   
   // Bad: Hardcoded
   color: Colors.blue
   ```

2. **Use theme text styles**
   ```dart
   // Good: Uses theme
   style: Theme.of(context).textTheme.bodyMedium
   
   // Bad: Hardcoded
   style: TextStyle(fontSize: 14)
   ```

3. **Support both themes**
   ```dart
   // Good: Works in both light and dark
   final color = Theme.of(context).colorScheme.primary;
   ```

4. **Test both themes**
   - Always test your UI in both light and dark modes
   - Ensure good contrast in both

### ❌ DON'T:

1. **Don't hardcode colors**
   ```dart
   // Bad: Won't adapt to theme
   Container(color: Color(0xFF6366F1))
   ```

2. **Don't use Colors.white/black directly**
   ```dart
   // Bad: Might be invisible in dark mode
   Text('Hello', style: TextStyle(color: Colors.black))
   
   // Good: Uses theme
   Text('Hello', style: TextStyle(
     color: Theme.of(context).colorScheme.onSurface
   ))
   ```

3. **Don't forget dark mode**
   - Always consider how your UI looks in dark mode
   - Test with dark theme enabled

---

## Theme Testing

### Test Light Mode

```dart
// In device/emulator
Settings → Display → Light Mode
```

### Test Dark Mode

```dart
// In device/emulator
Settings → Display → Dark Mode
```

### Test in Code

```dart
// Force light theme for testing
MaterialApp(
  themeMode: ThemeMode.light,
  theme: AppTheme.lightTheme,
  // ...
)

// Force dark theme for testing
MaterialApp(
  themeMode: ThemeMode.dark,
  darkTheme: AppTheme.darkTheme,
  // ...
)
```

---

## Accessibility Considerations

### Color Contrast

Ensure sufficient contrast between:
- Text and background
- Icons and background
- Borders and background

**WCAG Guidelines**:
- Normal text: 4.5:1 contrast ratio
- Large text: 3:1 contrast ratio

### Color Blindness

Don't rely solely on color to convey information:
```dart
// Good: Uses both color and icon
Row(
  children: [
    Icon(Icons.error, color: Colors.red),
    Text('Error', style: TextStyle(color: Colors.red)),
  ],
)

// Bad: Color only
Container(color: Colors.red)  // No indication what red means
```

---

## For Beginners: Theme Concepts

**Q: What's the difference between theme and styling?**
A:
- **Theme**: Global styles applied to entire app
- **Styling**: Individual widget styles

**Q: Why use Theme.of(context) instead of hardcoding?**
A: 
- Automatically adapts to light/dark mode
- Updates when theme changes
- Maintains consistency

**Q: How do I change the app's primary color?**
A: Change `primaryLight` and `primaryDark` in `app_theme.dart`

**Q: Can I have more than light/dark themes?**
A: Yes! You can create custom themes (e.g., "Blue", "Green", "Purple")

---

## Quick Reference

| Element | Light Mode | Dark Mode |
|---------|------------|-----------|
| **Primary** | Indigo (#6366F1) | Light Indigo (#818CF8) |
| **Secondary** | Purple (#8B5CF6) | Light Purple (#A78BFA) |
| **Background** | Light Gray (#F8FAFC) | Dark Blue (#0F172A) |
| **Surface** | White (#FFFFFF) | Dark Blue-Gray (#1E293B) |
| **Error** | Red (#EF4444) | Red (#EF4444) |
| **Success** | Green (#10B981) | Green (#10B981) |

---

## Next Steps

Now that you understand theming, check out:
- 🏗️ [Architecture](./architecture.md) - See how theme fits in
- 🧩 [Widgets](./widgets.md) - See how widgets use theme
- 📱 [Pages](./pages.md) - See themed pages

---

**Themes make your app beautiful! 🎨**
