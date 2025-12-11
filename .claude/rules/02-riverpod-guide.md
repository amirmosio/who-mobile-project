# Riverpod 3.0+ Complete Guide

## 🚨 CRITICAL RULES - ZERO TOLERANCE

### RULE 1: State Initialization

```dart
// ❌ NEVER initialize state in constructor
class MyNotifier extends _$MyNotifier {
  MyNotifier() { state = value; } // ❌ CRASH
}

// ✅ ALWAYS initialize in build method
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  StateType build() {
    return initialValue; // ✅ CORRECT
  }
}
```

### RULE 2: Ref Usage (MOST VIOLATIONS)

```dart
// ❌ NEVER: ref.read() in initState or build for state consumption
@override
void initState() {
  super.initState();
  final data = ref.read(provider); // ❌ STALE DATA
  ref.listen(provider, callback); // ❌ CRASH
}

Widget build(context, ref) {
  final data = ref.read(provider); // ❌ WON'T REBUILD
  return Text(data);
}

// ✅ ALWAYS: ref.watch() in build, ref.read() for actions only
Widget build(context, ref) {
  final data = ref.watch(provider); // ✅ REACTIVE

  ref.listen(provider, (prev, next) { // ✅ Side effects in build
    if (next is Success) showDialog();
  });

  return ElevatedButton(
    onPressed: () => ref.read(provider.notifier).action(), // ✅ Actions
    child: Text(data),
  );
}
```

### RULE 3: No Direct State Access

```dart
// ❌ NEVER access state directly
ref.read(provider.notifier).state = value;

// ✅ ALWAYS use methods
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++; // ✅ Method
}
```

---

## 📊 Pattern Selection (Decision Tree)

```
What do you need?
├─ Simple API call (85%) → BaseApiNotifier
├─ List CRUD + optimistic updates (10%) → AsyncNotifier
├─ Paginated list → BaseListNotifier
├─ Complex state machine (5%) → Custom Provider
└─ Computed value → @riverpod functional
```

---

## 🔵 BaseApiNotifier Pattern (85% of cases)

### When to Use
- Standard CRUD operations
- Simple API calls
- Automatic logging and retry needed
- Consistent error handling

### Implementation

```dart
@riverpod
class FeatureProvider extends BaseApiNotifier<BaseApiState> {
  late final FeatureRepository _repository;

  @override
  BaseApiState build() {
    _repository = ref.watch(featureRepositoryProvider);
    return const BaseApiInitial();
  }

  // For API calls returning data
  Future<Data?> loadData() async {
    return executeApiCallAndSetState<Data>(
      () => _repository.getData(),
      loadingMessage: 'Loading...',
      successMessage: 'Success!',
    );
  }

  // For operations (create/update/delete)
  Future<bool> deleteItem(String id) async {
    return executeOperationAndSetState(
      () => _repository.delete(id),
      successMessage: 'Deleted successfully',
      errorMessage: 'Failed to delete',
      onSuccess: () => loadData(), // Auto-refresh
    );
  }
}
```

### UI Usage

```dart
class FeatureWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureProvider);

    ref.listen(featureProvider, (prev, next) {
      if (next is BaseApiError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    return switch (state) {
      BaseApiInitial() => ElevatedButton(
        onPressed: () => ref.read(featureProvider.notifier).loadData(),
        child: Text('Load'),
      ),
      BaseApiLoading() => CircularProgressIndicator(),
      BaseApiSuccess<Data>(:final data) => DataWidget(data),
      BaseApiError(:final message) => ErrorWidget(message),
      _ => SizedBox.shrink(),
    };
  }
}
```

---

## 🟢 AsyncNotifier Pattern (10% of cases)

### When to Use
- Lists with CRUD operations
- Optimistic UI updates needed
- Show stale data while loading
- Fine-grained async state control

### Implementation

```dart
@riverpod
class ItemsController extends _$ItemsController {
  @override
  Future<List<Item>> build() async {
    return ref.watch(itemRepositoryProvider).fetchAll();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(itemRepositoryProvider).fetchAll(),
    );
  }

  Future<void> create(String title) async {
    final current = state.value ?? [];

    // Optimistic update
    final tempId = 'temp-${DateTime.now().microsecondsSinceEpoch}';
    state = AsyncData([...current, Item(id: tempId, title: title)]);

    try {
      final created = await ref.read(itemRepositoryProvider).create(title: title);
      if (!ref.mounted) return;

      final list = List<Item>.from(state.value ?? []);
      list.removeWhere((item) => item.id == tempId);
      list.add(created);
      state = AsyncData(list);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncData(current); // Rollback
      state = AsyncError(e, st);
    }
  }

  Future<void> delete(String id) async {
    final current = state.value ?? [];

    // Optimistic delete
    state = AsyncData(current.where((item) => item.id != id).toList());

    try {
      await ref.read(itemRepositoryProvider).delete(id);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncData(current); // Rollback
      state = AsyncError(e, st);
    }
  }
}
```

### UI Usage

```dart
class ItemsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(itemsControllerProvider);

    ref.listen(itemsControllerProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    return switch (asyncState) {
      AsyncLoading() => CircularProgressIndicator(),
      AsyncError(:final error) => ErrorWidget(error),
      AsyncData(:final value) when value.isEmpty => Text('No items'),
      AsyncData(:final value) => ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(value[index].title),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => ref
              .read(itemsControllerProvider.notifier)
              .delete(value[index].id),
          ),
        ),
      ),
    };
  }
}
```

---

## 📋 Pattern Comparison

| Feature | BaseApiNotifier | AsyncNotifier |
|---------|----------------|---------------|
| **Use Case** | Simple API calls | Lists + CRUD |
| **Optimistic Updates** | Manual | Built-in |
| **Error Handling** | `executeApiCallAndSetState()` | `AsyncValue.guard()` |
| **Logging** | ✅ Automatic | Manual |
| **Retry** | ✅ Automatic | Manual |
| **Complexity** | Low | Medium |
| **When to use** | 85% of cases | 10% of cases |

---

## 🎯 Real Examples from Codebase

### GuideBookingProvider (BaseApiNotifier)

```dart
@Riverpod(keepAlive: true)
class GuideBookingProvider extends BaseApiNotifier<BaseApiState> {
  late GuideBookingRepository _repository;

  @override
  BaseApiState build() {
    _repository = ref.read(guideBookingRepositoryProvider);
    return const BaseApiInitial();
  }

  Future<void> fetchGuideBookings() async {
    await executeApiCallAndSetState<GuideBookingsResponse>(
      () => _repository.getMyGuideBookings(),
      loadingMessage: 'Loading bookings...',
      successMessage: 'Bookings loaded',
    );
  }

  Future<bool> cancelGuideBooking(String bookingId) async {
    return executeOperationAndSetState(
      () => _repository.cancelGuideBooking(bookingId),
      successMessage: 'Booking cancelled',
      onSuccess: () => fetchGuideBookings(),
    );
  }
}
```

---

## 🔧 Development Workflow

### Required Dependencies

```yaml
dependencies:
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^3.0.0

dev_dependencies:
  riverpod_generator: ^3.0.0
  build_runner: ^2.4.15
```

### Code Generation

```bash
# After ANY provider changes
dart run build_runner build --delete-conflicting-outputs

# During development (watch mode)
dart run build_runner watch --delete-conflicting-outputs
```

### App Setup

```dart
void main() {
  runApp(ProviderScope(child: MyApp()));
}
```

---

## 📁 Directory Structure

```
lib/providers/
├── base/
│   ├── base_api_state.dart
│   └── base_api_notifier.dart
├── feature_name/
│   └── feature_provider.dart
```

---

## ✅ Best Practices

### DO
- ✅ Use `ref.watch()` in build for reactive state
- ✅ Use `ref.read()` for actions/events only
- ✅ Use `ref.listen()` in build for side effects
- ✅ Check `if (!ref.mounted) return;` after async ops (AsyncNotifier)
- ✅ Use exhaustive switch expressions
- ✅ Run build_runner after provider changes

### DON'T
- ❌ Never read provider state in `initState()`
- ❌ Never use `ref.read()` in build for state consumption
- ❌ Never use `ref.listen()` in `initState()`
- ❌ Never access `state` directly from outside
- ❌ Never forget code generation

---

## 🧪 Testing

```dart
testWidgets('provider test', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(MockRepository()),
      ],
      child: MyApp(),
    ),
  );

  expect(find.text('expected'), findsOneWidget);
});
```

---

## 🚀 Quick Start Templates

### For Simple API Calls (BaseApiNotifier)

```dart
@riverpod
class MyProvider extends BaseApiNotifier<BaseApiState> {
  late final MyRepository _repository;

  @override
  BaseApiState build() {
    _repository = ref.watch(myRepositoryProvider);
    return const BaseApiInitial();
  }

  Future<Data?> loadData() async {
    return executeApiCallAndSetState<Data>(
      () => _repository.getData(),
      loadingMessage: 'Loading...',
      successMessage: 'Loaded!',
    );
  }
}
```

### For Lists with Optimistic Updates (AsyncNotifier)

```dart
@riverpod
class MyController extends _$MyController {
  @override
  Future<List<Data>> build() async {
    return ref.watch(myRepositoryProvider).fetchAll();
  }

  Future<void> create(Data data) async {
    final current = state.value ?? [];
    state = AsyncData([...current, data]); // Optimistic

    try {
      final created = await ref.read(myRepositoryProvider).create(data);
      if (!ref.mounted) return;
      state = AsyncData([...current, created]);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncData(current); // Rollback
      state = AsyncError(e, st);
    }
  }
}
```

---

## 🔍 Code Review Checklist

### Critical (Check First)
- [ ] No `ref.read()` in `initState()` for state consumption
- [ ] No `ref.read()` in `build()` for state consumption
- [ ] No `ref.listen()` in `initState()`
- [ ] All `ref.watch()` calls in build method only

### Provider Design
- [ ] All providers use `@riverpod` annotation
- [ ] Exhaustive switch expressions (no default case)
- [ ] No public properties in notifiers
- [ ] Build runner executed after changes

### Search Commands for Violations

```bash
# Find initState violations
grep -r "initState" lib --include="*.dart" -A 10 | grep "ref\."

# Find ref.read in build methods
grep -r "ref\.read" lib --include="*.dart" -B 3 -A 1 | grep -B 5 "Widget build"
```

---

## 📞 Quick Reference

**Pattern Selection:**
- Simple API call → BaseApiNotifier
- List CRUD + optimistic → AsyncNotifier
- Paginated list → BaseListNotifier
- Complex logic → Custom Provider

**Widget Types:**
- No lifecycle → `ConsumerWidget`
- With lifecycle → `ConsumerStatefulWidget`

**Ref Methods:**
- Reactive state → `ref.watch()`
- Actions/events → `ref.read()`
- Side effects → `ref.listen()`

**Key Methods:**
- BaseApiNotifier → `executeApiCallAndSetState()`, `executeOperationAndSetState()`
- AsyncNotifier → `AsyncValue.guard()`, check `!ref.mounted`

---

**REMEMBER**: These rules are STRICT and NON-NEGOTIABLE. Violations cause runtime errors, performance issues, or maintainability problems.
