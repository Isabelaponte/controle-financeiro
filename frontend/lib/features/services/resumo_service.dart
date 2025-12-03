import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/features/models/resumo_model.dart';

class ResumoService {
  final ApiClient _apiClient;

  ResumoService([ApiClient? apiClient]) 
      : _apiClient = apiClient ?? ApiClient();

  Future<ResumoMensal> getResumoMensal({
    required String usuarioId,
  }) async {
    return _apiClient.get(
      ApiConstants.resumoMensal(usuarioId),
      (json) => ResumoMensal.fromJson(json),
    );
  }
}