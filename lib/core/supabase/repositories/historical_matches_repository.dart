import '../supabase_client.dart';
import '../../database/daos/historical_matches_dao.dart';
import '../../cache/cache_service.dart';
import '../../cache/offline_first_repository.dart';
import '../../../features/roleplay/models/historical_match_model.dart';

class HistoricalMatchesRepository with OfflineFirstRepository<HistoricalMatchModel> {
  final HistoricalMatchesDao _dao;
  final CacheService _cache;

  HistoricalMatchesRepository(this._dao, this._cache);

  @override
  String get cacheKey => 'historical_matches';

  @override
  CacheService get cacheService => _cache;

  @override
  Future<List<HistoricalMatchModel>> fetchFromLocal() => _dao.getAll();

  @override
  Future<List<HistoricalMatchModel>> fetchFromRemote() async {
    final data = await supabase
        .from('historical_matches')
        .select()
        .order('sort_order');
    return data.map<HistoricalMatchModel>(HistoricalMatchModel.fromJson).toList();
  }

  @override
  Future<void> saveToLocal(List<HistoricalMatchModel> items) =>
      _dao.upsertAll(items);
}
