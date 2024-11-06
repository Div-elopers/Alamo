import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:alamo/src/features/library/application/files_service.dart';
import 'package:alamo/src/features/library/domain/app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_screen_controller.g.dart';

@riverpod
class LibraryScreenController extends _$LibraryScreenController {
  @override
  LibraryScreenState build() {
    // Initialize with default state and start listening to files stream
    final filesService = ref.watch(filesServiceProvider);
    _filesSubscription = filesService.watchFiles().listen((files) {
      state = state.copyWith(
        files: files,
        filteredFiles: _applyFilters(files, state.searchQuery, state.selectedFilter),
      );
    });

    return LibraryScreenState(
      files: [],
      filteredFiles: [],
      searchQuery: '',
      selectedFilter: null,
    );
  }

  late final StreamSubscription<List<AppFile>> _filesSubscription;

  void dispose() {
    _filesSubscription.cancel();
    dispose();
  }

  // Update search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _filterFiles();
  }

  // Set filter
  void setFilter(String? filter) {
    state = state.copyWith(selectedFilter: filter);
    _filterFiles();
  }

  // Open file (e.g., increment views)
  Future<void> openFile(AppFile file) async {
    final filesService = ref.read(filesServiceProvider);
    await filesService.incrementFileViews(file);
  }

  // Upload a new file
  Future<void> uploadFile({
    required String name,
    required String type,
    required File file,
    required String createdBy,
  }) async {
    final filesService = ref.read(filesServiceProvider);
    await filesService.uploadFile(
      name: name,
      type: type,
      file: file,
      createdBy: createdBy,
    );
  }

  // Filter files based on current state
  void _filterFiles() {
    final filtered = _applyFilters(state.files, state.searchQuery, state.selectedFilter);
    state = state.copyWith(filteredFiles: filtered);
  }

  // Helper method to apply search and filter
  List<AppFile> _applyFilters(List<AppFile> files, String query, String? filter) {
    final lowerQuery = query.toLowerCase();
    return files.where((file) {
      final matchesQuery = file.name.toLowerCase().contains(lowerQuery);
      final matchesFilter = filter == null || file.type.toLowerCase() == filter.toLowerCase();
      return matchesQuery && matchesFilter;
    }).toList();
  }

  Future<File> downloadFile(String url, String filename) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$filename';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to load PDF file');
    }
  }
}

class LibraryScreenState {
  final List<AppFile> files;
  final List<AppFile> filteredFiles;
  final String searchQuery;
  final String? selectedFilter;

  LibraryScreenState({
    required this.files,
    required this.filteredFiles,
    required this.searchQuery,
    this.selectedFilter,
  });

  LibraryScreenState copyWith({
    List<AppFile>? files,
    List<AppFile>? filteredFiles,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return LibraryScreenState(
      files: files ?? this.files,
      filteredFiles: filteredFiles ?? this.filteredFiles,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
