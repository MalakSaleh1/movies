import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../modules/auth/data/data_sources/auth_remote_data_source.dart';
import '../../modules/auth/data/repositories/auth_repository.dart';
import '../../modules/auth/providers/auth_provider.dart';
import '../../modules/library/data/data_sources/library_local_data_source.dart';
import '../../modules/library/data/data_sources/library_remote_data_source.dart';
import '../../modules/library/data/repositories/library_repository.dart';
import '../../modules/library/providers/library_provider.dart';
import '../../modules/movies/data/data_sources/movies_local_data_source.dart';
import '../../modules/movies/data/data_sources/movies_remote_data_source.dart';
import '../../modules/movies/data/repositories/movies_repository.dart';
import '../../modules/movies/providers/home_provider.dart';
import '../../modules/movies/providers/search_provider.dart';
import '../../modules/profile/data/data_sources/user_local_data_source.dart';
import '../../modules/profile/data/data_sources/user_remote_data_source.dart';
import '../../modules/profile/data/repositories/user_repository.dart';
import '../../modules/profile/providers/profile_provider.dart';
import '../cache/cache_service.dart';
import '../network/api_client.dart';

class AppDependencies {
  AppDependencies._();

  static Future<List<SingleChildWidget>> providers() async {
    final cache = await CacheService.create();
    final api = ApiClient();
    final firestore = FirebaseFirestore.instance;

    // Repositories
    final moviesRepo = MoviesRepository(
      remote: MoviesRemoteDataSource(api),
      local: MoviesLocalDataSource(cache),
    );
    final libraryRepo = LibraryRepository(
      remote: LibraryRemoteDataSource(firestore),
      local: LibraryLocalDataSource(cache),
    );
    final userRepo = UserRepository(
      remote: UserRemoteDataSource(firestore),
      local: UserLocalDataSource(cache),
    );
    final authRepo = AuthRepository(
      remote: AuthRemoteDataSource(),
      userRepository: userRepo,
      libraryRepository: libraryRepo,
    );

    return [
      Provider<MoviesRepository>.value(value: moviesRepo),

      ChangeNotifierProvider(create: (_) => AppAuthProvider(authRepo)),
      ChangeNotifierProvider(
        lazy: false,
        create: (_) => LibraryProvider(libraryRepo),
      ),
      ChangeNotifierProvider(
        lazy: false,
        create: (_) => ProfileProvider(userRepo, authRepo),
      ),
      ChangeNotifierProvider(create: (_) => HomeProvider(moviesRepo)),
      ChangeNotifierProvider(create: (_) => SearchProvider(moviesRepo)),
    ];
  }
}
