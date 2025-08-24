import '../api_client.dart';

class FeedRepo {
  final ApiClient api;
  FeedRepo(this.api);

  Future<bool> feed({required String animalId, required int tokens}) =>
      api.feedAnimal(animalId: animalId, tokens: tokens);
}
