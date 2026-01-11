# Application States Documentation
**WHO Mobile Project - IDTM Guide**

**Last Updated:** January 11, 2026

---

## Overview

Your WHO Mobile Project uses a sophisticated state management architecture combining **Riverpod** providers with a custom **BaseApiState** system. This document catalogs all states, their purposes, and relationships.

---

## State Management Architecture

### Primary State Management Tools:
1. **Riverpod** - Modern reactive state management
2. **BaseApiState System** - Custom sealed class hierarchy for API operations
3. **SharedPreferences** - Local data persistence
4. **Firebase/Firestore** - Cloud data persistence
5. **Get_it** - Dependency injection

---

## 1. Core API States (BaseApiState System)

### Location: `lib/providers/base/base_api_state.dart`

**Base Sealed Class Hierarchy:**

```dart
sealed class BaseApiState extends Equatable
```

### 1.1 **BaseApiInitial**
- **Purpose:** Initial state before any operation
- **When Used:** Default state when provider first initializes
- **Data:** None
- **Example:**
  ```dart
  const BaseApiInitial()
  ```

### 1.2 **BaseApiLoading**
- **Purpose:** Loading state during API operations
- **When Used:** During network requests, data fetching
- **Data:** None (optional loading message)
- **UI Impact:** Show loading indicators (CircularProgressIndicator)
- **Example:**
  ```dart
  const BaseApiLoading()
  ```

### 1.3 **BaseApiSuccess<T>**
- **Purpose:** Successful operation with data
- **When Used:** After successful API call, data load
- **Data:** Generic type T (any data type)
- **Example:**
  ```dart
  const BaseApiSuccess<ProgressTracker>(progressData)
  ```

### 1.4 **BaseApiError**
- **Purpose:** Error state with exception details
- **When Used:** API failures, network errors, validation errors
- **Data:** `RepositoryException` with error type and message
- **UI Impact:** Show error messages, retry buttons
- **Example:**
  ```dart
  const BaseApiError(RepositoryException(
    error: ErrorType.network,
    message: "Connection failed"
  ))
  ```

### 1.5 **BaseApiOperationSuccess**
- **Purpose:** Boolean operation results (create, update, delete)
- **When Used:** After successful CRUD operations
- **Data:**
  - `bool success`
  - `String? message` (optional success message)
- **Example:**
  ```dart
  const BaseApiOperationSuccess(true, "Installation created successfully")
  ```

### 1.6 **BaseApiListSuccess<T>**
- **Purpose:** List operations with pagination support
- **When Used:** Fetching lists of items (installations, alerts, etc.)
- **Data:**
  - `List<T> items` - The list of items
  - `int totalCount` - Total items available
  - `bool hasMore` - More pages available?
  - `int currentPage` - Current page number
- **Example:**
  ```dart
  const BaseApiListSuccess<Installation>(
    items: installations,
    totalCount: 50,
    hasMore: true,
    currentPage: 1,
  )
  ```

### State Pattern Matching Extension:

```dart
state.when(
  initial: () => Text("Start"),
  loading: (message) => CircularProgressIndicator(),
  success: (data) => DisplayData(data),
  error: (message, exception) => ErrorWidget(message),
)
```

---

## 2. Repository States (Legacy)

### Location: `lib/repository/repo_state.dart`

### 2.1 **SuccessState<T, M>**
- **Data:**
  - `T? data` - Main data
  - `M? metaData` - Additional metadata
- **Usage:** Repository-level success responses

### 2.2 **ErrorState**
- **Data:** `RepositoryException`
- **Error Types:**
  - `ErrorType.unauthorized` → Auto-logout and redirect
  - `ErrorType.network` → Network connection error
  - `ErrorType.validation` → Input validation error
  - `ErrorType.notFound` → Resource not found

### 2.3 **LoadingState**
- **Purpose:** Repository-level loading indicator

---

## 3. Installation/Facility Lifecycle States

### Location: `lib/general/models/idtm/installation_phase.dart`

### **FacilityInstallationPhase Enum**

The IDTM facility progresses through 5 distinct phases:

#### 3.1 **initial**
- **Display Name:** "Not Started"
- **Description:** Facility installation not yet begun
- **Can Edit:** ✅ Yes
- **Next Phase:** → installing
- **Previous Phase:** None
- **UI State:** Shows "Start Installation" button

#### 3.2 **installing**
- **Display Name:** "Installing"
- **Description:** Installation in progress
- **Can Edit:** ✅ Yes
- **Next Phase:** → maintenance
- **Previous Phase:** ← initial
- **UI State:** Shows installation steps, progress tracking
- **Sub-states:**
  - Installation steps (each can be completed/incomplete)
  - Overall installation progress (X/Y steps completed)

#### 3.3 **maintenance**
- **Display Name:** "Maintenance"
- **Description:** Facility in use, routine maintenance mode
- **Can Edit:** ✅ Yes
- **Next Phase:** → dismantling
- **Previous Phase:** ← installing
- **UI State:** Shows maintenance tasks, scheduled alerts
- **Auto-Actions:** Automatically schedules maintenance alerts when entered
- **Sub-states:**
  - Active maintenance tasks
  - Scheduled alerts
  - Completed maintenance logs

#### 3.4 **dismantling**
- **Display Name:** "Dismantling"
- **Description:** Facility being dismantled/repacked
- **Can Edit:** ✅ Yes
- **Next Phase:** → completed
- **Previous Phase:** ← maintenance
- **UI State:** Shows dismantling steps, repacking checklist
- **Sub-states:**
  - Dismantling steps completion
  - Packing list verification

#### 3.5 **completed**
- **Display Name:** "Completed"
- **Description:** Facility fully dismantled, lifecycle complete
- **Can Edit:** ❌ No (read-only)
- **Next Phase:** None (terminal state)
- **Previous Phase:** ← dismantling
- **UI State:** Shows summary, no edit actions available

### Phase Transition Logic:

```dart
// Transition to next phase
initial → installing → maintenance → dismantling → completed

// Check if can edit
if (phase.canEdit) {
  // Allow modifications
} else {
  // Read-only mode
}

// Get next phase
final next = currentPhase.nextPhase; // Returns null if completed
```

---

## 4. Authentication States

### Location: `lib/providers/auth/`

### 4.1 **User Authentication State**

**Provider:** `CurrentUserProvider`

**Async States (Riverpod's AsyncValue):**

#### **AsyncLoading**
- **When:** Fetching user from Firebase
- **UI:** Loading spinner on auth screens

#### **AsyncData<AppUser>**
- **When:** User loaded successfully
- **Data:** `AppUser` object
- **Sub-states:**
  - `user.isAuthenticated = true` - Logged in
  - `user.isAuthenticated = false` - Guest mode

#### **AsyncError**
- **When:** Firebase auth error
- **Data:** Error object with stack trace

### 4.2 **User Roles State**

**Enum:** `UserRole`
- **admin** - Administrator with full access
- **user** - Standard authenticated user
- **guest** - Unauthenticated/guest access

### 4.3 **User Cache States**

**Cached in Memory:**
- `_cachedUser` - In-memory cache (5 min validity)
- `_lastFetch` - Timestamp of last fetch

**Cached in SharedPreferences:**
- User data (profile info)
- User role

**Cache Validity:**
- Valid if < 5 minutes old
- Invalidated on logout, manual refresh

---

## 5. Installation Progress States

### Location: `lib/providers/idtm/installation_state_provider.dart`

**Provider:** `InstallationStateProvider`

### States Managed:

#### 5.1 **Installation Creation**
- **Initial:** `BaseApiInitial()`
- **Creating:** `BaseApiLoading()`
- **Created:** `BaseApiSuccess<String>(installationId)`
- **Error:** `BaseApiError(exception)`

#### 5.2 **Progress Loading**
- **Loading:** `BaseApiLoading()` with "Loading progress..." message
- **Loaded:** `BaseApiSuccess<ProgressTracker>(progress)`
- **Not Found:** `BaseApiError("Installation not found")`

#### 5.3 **Step Completion States**

**Per Step:**
- `completed: true` - Step finished
- `completed: false` - Step pending/incomplete

**Progress Tracker State:**
```dart
{
  currentPhase: FacilityInstallationPhase,
  completedSteps: List<String>,
  totalSteps: int,
  percentageComplete: double,
  lastUpdated: DateTime,
}
```

#### 5.4 **Phase Transition States**
- **Transitioning:** `BaseApiLoading()`
- **Success:** `BaseApiOperationSuccess(true, "Transitioned to next phase")`
- **Auto-Actions:** When entering `maintenance` phase:
  - Automatically schedules maintenance alerts
  - Triggers `ScheduledAlertsProvider`

---

## 6. Maintenance States

### Location: `lib/providers/maintenance_guide/maintenance_provider.dart`

### 6.1 **Maintenance Task States**

**Per Task:**
- `completed: boolean` - Task finished
- `lastCompleted: DateTime?` - When last completed
- `nextDue: DateTime?` - Next scheduled time

### 6.2 **Scheduled Alert States**

**Provider:** `ScheduledAlertsProvider`

**Alert States:**
```dart
{
  id: String,
  status: AlertStatus,  // scheduled, triggered, dismissed, completed
  scheduledTime: DateTime,
  notificationSent: boolean,
}
```

**Alert Status Enum:**
- **scheduled** - Future alert, not yet triggered
- **triggered** - Alert time reached, notification sent
- **dismissed** - User dismissed without completing
- **completed** - Task completed via alert

---

## 7. Packing List States

### Location: `lib/ui/idtm/packing_list_page.dart`

### 7.1 **Checkbox States (Per Item)**

**Stored in SharedPreferences:**
```dart
Map<String, bool> _checkedItems = {
  'pack-001': true,   // Main item checked
  'pack-001-a': true, // Sub-item checked
  'pack-002': false,  // Unchecked
}
```

### 7.2 **Expansion States (Per Item)**

**Stored in SharedPreferences:**
```dart
Map<String, bool> _expandedItems = {
  'pack-001': true,   // Expanded to show sub-items
  'pack-002': false,  // Collapsed
}
```

### 7.3 **Page State**
- `_isLoading: true` - Loading saved state from SharedPreferences
- `_isLoading: false` - Data loaded, displaying list
- `_isScanning: true` - Visual recognition in progress
- `_isScanning: false` - Ready for scanning

### 7.4 **Progress State**
- `_checkedCount` - Number of checked main items
- `_totalItems` - Total main items
- Progress value: `_checkedCount / _totalItems`

---

## 8. Navigation States

### 8.1 **Route History**

**Provider:** `GoRouterTracker`

```dart
{
  _currentRoute: GoRouteInfo?,
  _routeHistory: List<GoRouteInfo>,  // Max 20 items
}
```

**GoRouteInfo:**
```dart
{
  location: String,    // Full path with params
  path: String,        // Route template
  timestamp: DateTime,
  params: Map<String, String>?,
}
```

### 8.2 **Navigation Stack States**
- **After Login:** Stack cleared via `navigation.reset()`
- **After Logout:** Stack cleared, navigate to Login
- **Deep Links:** History preserved

---

## 9. UI Component States

### 9.1 **Dashboard Card States**

**IDTM Status Card:**
```dart
// Auto-refreshes when:
- App resumed from background
- User pulls to refresh
- Returns from detail screens
```

### 9.2 **Form States**
- **Idle** - No interaction
- **Dirty** - User modified input
- **Validating** - Client-side validation
- **Submitting** - Sending to backend
- **Success** - Submitted successfully
- **Error** - Validation or submission error

### 9.3 **Dialog States**
- **Closed** - Dialog not shown
- **Open** - Dialog visible
- **Processing** - Action in progress (e.g., confirming reset)

---

## 10. Data Persistence States

### 10.1 **SharedPreferences Storage**

**Stored States:**
```dart
// Packing list
'checked_<itemId>': bool
'expanded_<itemId>': bool

// User preferences
'user_data': JSON string
'user_role': String

// Installation
'base_url_local': String
'base_websocket_url_local': String
```

### 10.2 **Firebase/Firestore Sync States**

**Sync Status:**
- **Online + Synced** - Data up-to-date
- **Online + Syncing** - Upload in progress
- **Offline + Cached** - Using local data
- **Offline + Queued** - Changes queued for sync

**Firestore Settings:**
```dart
persistenceEnabled: true,
cacheSizeBytes: CACHE_SIZE_UNLIMITED,
```

---

## 11. Permission States

### Location: Various UI pages

### 11.1 **Camera Permission**
- **Not Requested** - Initial state
- **Requesting** - Permission dialog shown
- **Granted** - Camera accessible
- **Denied** - Permission rejected, show error

### 11.2 **Notification Permission**
- **Not Determined** - Not asked yet
- **Granted** - Can send notifications
- **Denied** - Cannot send notifications
- **Provisional** (iOS) - Silent notifications only

### 11.3 **Location Permission**
- **Not Requested**
- **When In Use** - Granted for foreground
- **Always** - Granted for background
- **Denied** - Show error message

---

## 12. Visual Recognition States

### Location: `lib/ui/idtm/packing_list_page.dart`

### Workflow States:

#### 12.1 **Item Selection**
- State: Dialog open
- Data: List of items to choose from

#### 12.2 **Image Source Selection**
- State: Dialog open
- Options: Camera or Gallery

#### 12.3 **Image Capture/Selection**
- State: Camera/Gallery picker open
- Result: `XFile?` with image path

#### 12.4 **Image Processing**
- State: Dialog "Analyzing image..."
- Progress: `CircularProgressIndicator`
- Backend: Mock API call (2 second delay)

#### 12.5 **Verification Result**
- **Verified (true):**
  - Show success dialog
  - Offer "Check Item" button
  - Auto-check item when confirmed
- **Not Verified (false):**
  - Show error dialog
  - Suggest manual verification

---

## 13. App Lifecycle States

### States Tracked:

#### **AppLifecycleState.resumed**
- **Action:** Refresh dashboard cards
- **Reason:** Data may have changed while app was backgrounded

#### **AppLifecycleState.paused**
- **Action:** None currently
- **Potential:** Save current state

#### **AppLifecycleState.inactive**
- **Action:** None

#### **AppLifecycleState.detached**
- **Action:** None

---

## 14. Error States

### 14.1 **ErrorType Enum**

**Location:** `lib/general/constants/api_error_types.dart`

- **unauthorized (401)** - Auto-logout, redirect to login
- **network** - Connection failure
- **validation** - Input validation error
- **notFound (404)** - Resource doesn't exist
- **serverError (500)** - Backend error
- **timeout** - Request timeout
- **unknown** - Unexpected error

### 14.2 **Error Handling Behavior**

**Unauthorized:**
```dart
if (error == ErrorType.unauthorized) {
  // Clear user data
  GetIt.instance<StorageManager>().removeUserRelatedInfo();

  // Wait 5 seconds
  Future.delayed(Duration(seconds: 5), () {
    // Restart app (go to login)
    RestartWidget.restartApp();
  });
}
```

---

## 15. State Transition Diagrams

### 15.1 Installation Lifecycle

```
┌─────────┐
│ initial │
└────┬────┘
     │ Start Installation
     ▼
┌────────────┐
│ installing │──────┐
└─────┬──────┘      │ Mark steps
      │             │ complete/incomplete
      │ All steps   │
      │ complete    │
      ▼             │
┌────────────┐◄─────┘
│maintenance │
└─────┬──────┘
      │ Auto: Schedule alerts
      │
      │ Begin Dismantling
      ▼
┌──────────────┐
│ dismantling  │
└──────┬───────┘
       │ All steps complete
       ▼
┌───────────┐
│ completed │ (Terminal state)
└───────────┘
```

### 15.2 API Request Lifecycle

```
┌─────────┐
│ Initial │
└────┬────┘
     │ API call initiated
     ▼
┌─────────┐
│ Loading │
└────┬────┘
     │
     ├─────────► Success ──► Display data
     │
     └─────────► Error ────► Show error, retry option
```

### 15.3 User Authentication Flow

```
┌────────┐
│ Guest  │
└───┬────┘
    │ Login
    ▼
┌────────────┐
│ Loading... │
└──────┬─────┘
       │
       ├──► Success ──► Authenticated User ──┐
       │                                     │
       └──► Error ────► Show error ──────────┤
                                             │
                                             │ Logout
                                             ▼
                                        ┌────────┐
                                        │ Guest  │
                                        └────────┘
```

---

## 16. State Dependencies

### High-Level State Graph:

```
CurrentUser (Auth)
    │
    ├──► InstallationState
    │       ├──► Phase (initial, installing, maintenance, dismantling, completed)
    │       └──► ProgressTracker (steps completion)
    │               └──► MaintenanceAlerts (auto-scheduled on phase transition)
    │
    ├──► PackingListState (SharedPreferences)
    │       ├──► CheckedItems
    │       └──► ExpandedItems
    │
    └──► NavigationState (GoRouter)
            └──► RouteHistory
```

---

## 17. State Testing Checklist

### States to Test:

- ✅ **BaseApiInitial** - Initial state rendering
- ✅ **BaseApiLoading** - Loading indicator display
- ✅ **BaseApiSuccess** - Success data display
- ✅ **BaseApiError** - Error message display
- ✅ **FacilityPhases** - All 5 phases transitions
- ✅ **PackingList** - Checkbox/expansion persistence
- ✅ **Authentication** - Login/logout state changes
- ⚠️ **ProgressTracker** - Step completion state
- ⚠️ **Notifications** - Alert scheduling state
- ⚠️ **Offline** - Firestore offline persistence

---

## 18. State Management Best Practices Used

### ✅ Implemented:

1. **Immutability** - States use const constructors
2. **Sealed Classes** - Exhaustive pattern matching
3. **Equatable** - Efficient state comparison
4. **Caching** - Multi-layer cache (memory, SharedPreferences, Firestore)
5. **Reactive** - Riverpod auto-rebuilds UI on state change
6. **Type Safety** - Generics for typed data
7. **Error Handling** - Dedicated error states with details

### Patterns:

```dart
// 1. Pattern Matching
state.when(
  initial: () => ...,
  loading: (msg) => ...,
  success: (data) => ...,
  error: (msg, ex) => ...,
);

// 2. Type-safe Data Access
if (state is BaseApiSuccess<ProgressTracker>) {
  final progress = state.data;
  // Use progress safely
}

// 3. State Transitions
state = const BaseApiLoading();
// ... perform operation
state = BaseApiSuccess(result);
```

---

## 19. Quick Reference: State Locations

| State Category | File Location | Provider/Class |
|----------------|---------------|----------------|
| **API Base States** | `providers/base/base_api_state.dart` | `BaseApiState` hierarchy |
| **Installation Phase** | `models/idtm/installation_phase.dart` | `FacilityInstallationPhase` enum |
| **Installation Progress** | `providers/idtm/installation_state_provider.dart` | `InstallationStateProvider` |
| **Current User** | `providers/auth/current_user_provider.dart` | `CurrentUserProvider` |
| **Maintenance** | `providers/maintenance_guide/maintenance_provider.dart` | `MaintenanceProvider` |
| **Packing List** | `ui/idtm/packing_list_page.dart` | Widget state |
| **Navigation** | `services/navigation_tracker.dart` | `GoRouterTracker` |
| **Repository** | `repository/repo_state.dart` | `RepositoryState` classes |
| **Error Types** | `general/constants/api_error_types.dart` | `ErrorType` enum |

---

## 20. Summary

Your WHO Mobile Project has **184+ distinct application states** across multiple dimensions:

### State Categories:
1. **API States** (6 base types)
2. **Lifecycle Phases** (5 phases)
3. **Authentication States** (3 user states)
4. **Progress States** (per installation, per step)
5. **UI Component States** (dozens of widget-level states)
6. **Persistence States** (SharedPreferences, Firestore)
7. **Permission States** (3 permission types × 3 states each)
8. **Error States** (8+ error types)
9. **Navigation States** (route history, navigation stack)

### State Management Quality: ⭐⭐⭐⭐⭐

**Strengths:**
- Well-architected sealed class hierarchy
- Type-safe with generics
- Reactive with Riverpod
- Multi-layer caching
- Comprehensive error handling
- Clear state transitions

**Recommendations:**
- ✅ Already following best practices
- Consider adding state machine library for complex flows
- Document phase transition business rules
- Add state validation tests

---

**END OF DOCUMENT**
