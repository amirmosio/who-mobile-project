# Adding New API Endpoints

This guide covers adding new API endpoints with Riverpod 3.0+ patterns.

**REFER TO**: [02-riverpod-guide.md](02-riverpod-guide.md) for complete Riverpod rules and patterns.

## Quick API Integration Steps

### 1. Define the Model

Create model with `toJson()` and `fromJson()` methods in `lib/general/models/[feature]/`:

```dart
class FeatureModel {
  final int id;
  final String name;

  FeatureModel({required this.id, required this.name});

  factory FeatureModel.fromJson(Map<String, dynamic> json) => FeatureModel(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
```

### 2. Add API Endpoint

Add endpoint in `lib/network/rest_client.dart`:

```dart
@GET('/api/v2/features')
Future<DataBasedResponse<List<FeatureModel>, BaseMetaData>> getFeatures();

@POST('/api/v2/features')
Future<DataBasedResponse<FeatureModel, BaseMetaData>> createFeature(
  @Body() CreateFeatureRequest request,
);
```

### 3. Create Repository

Create repository in `lib/repository/[feature]/`:

```dart
@injectable
class FeatureRepository extends BaseRepository {
  FeatureRepository(super.apiClient);

  Future<RepositoryState> getFeatures() async {
    return getRepositoryState(() => apiClient.getFeatures());
  }

  Future<RepositoryState> createFeature(CreateFeatureRequest request) async {
    return getRepositoryState(() => apiClient.createFeature(request));
  }
}
```

### 4. Define the Provider

Create provider in `lib/providers/[feature]/`:

```dart
@riverpod
FeatureRepository featureRepository(Ref ref) {
  return getIt<FeatureRepository>();
}

@Riverpod(keepAlive: true)
class FeatureProvider extends BaseApiNotifier<BaseApiState> {
  late final FeatureRepository _repository;

  @override
  BaseApiState build() {
    _repository = ref.read(featureRepositoryProvider);
    return const BaseApiInitial();
  }

  // Automatic retry built-in for failed operations
  Future<List<FeatureModel>?> loadFeatures() async {
    return executeApiCallAndSetState<List<FeatureModel>>(
      () => _repository.getFeatures(),
      loadingMessage: 'Loading features...',
      successMessage: 'Features loaded successfully',
    );
  }

  // Enhanced error handling with ProviderException
  Future<bool> createFeature(CreateFeatureRequest request) async {
    return executeOperationAndSetState(
      () => _repository.createFeature(request),
      successMessage: 'Feature created successfully',
      onSuccess: () => loadFeatures(), // Auto-refresh
    );
  }

  // Custom update filtering using == (new in 3.0)
  @override
  bool updateShouldNotify(BaseApiState previous, BaseApiState next) {
    return previous != next;
  }
}
```

### 5. UI Integration

Create UI widget with `ConsumerWidget`:

```dart
class FeatureWidget extends ConsumerWidget {
  const FeatureWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureProvider);

    // Enhanced error handling for ProviderException
    ref.listen(featureProvider, (previous, next) {
      if (next is BaseApiError) {
        // Handle ProviderException with access to original error
        final originalError = next.exception.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.message}')),
        );
      }
    });

    return switch (state) {
      BaseApiInitial() => ElevatedButton(
        onPressed: () => ref.read(featureProvider.notifier).loadFeatures(),
        child: Text('Load Features'),
      ),
      BaseApiLoading() => CircularProgressIndicator(),
      BaseApiSuccess<List<FeatureModel>>(:final data) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(data[index].name),
        ),
      ),
      BaseApiError(:final message, :final exception) => Column(
        children: [
          ErrorWidget(message: message),
          // Access to original error through exception.error
          if (exception.error != null)
            Text('Details: ${exception.error}'),
        ],
      ),
      _ => SizedBox.shrink(),
    };
  }
}
```

### 6. Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

This regenerates:
- Dependency injection code
- API client code
- Riverpod providers

## Key Riverpod 3.0+ Features

- **Automatic retry** for failed operations
- **Unified `Ref` interface** (no AutoDispose variants)
- **Enhanced error handling** with `ProviderException`
- **Consistent update filtering** using `==`

## Key Differences from BLoC

- Use `@riverpod` annotation instead of `@injectable` for providers
- Use `ref.watch()` instead of `BlocBuilder`
- Use `ref.read()` for one-time operations
- Use `ref.listen()` in build method instead of `BlocListener`
- Use `ConsumerWidget` or `ConsumerStatefulWidget` instead of regular widgets
- Providers automatically manage their own lifecycle
