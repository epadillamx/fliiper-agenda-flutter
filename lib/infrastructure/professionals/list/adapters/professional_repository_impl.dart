import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../domain/professionals/list/entities/professional.dart';
import '../../../../domain/professionals/list/repositories/i_professional_repository.dart';
import '../models/professional_dto.dart';

class ProfessionalRepositoryImpl implements IProfessionalRepository {
  final _storage = SecureStorageService();

  @override
  Future<List<Professional>> getProfessionals(
    String branchId,
    String branchIdcuenta,
    String username,
  ) async {
    try {
      developer.log('Obteniendo profesionales', name: 'ProfessionalRepository');
      developer.log('Branch ID: $branchId', name: 'ProfessionalRepository');
      developer.log('Branch Idcuenta: $branchIdcuenta', name: 'ProfessionalRepository');
      developer.log('Username filter: $username', name: 'ProfessionalRepository');

      if (branchId.isEmpty) {
        throw Exception('Branch ID es requerido');
      }

      if (branchIdcuenta.isEmpty) {
        throw Exception('Branch Idcuenta es requerido');
      }

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/api/users/userscalendarioPublic/$branchId/$branchIdcuenta',
      );
      
      developer.log('URL: $url', name: 'ProfessionalRepository');
      
      final token = await _storage.getToken();
      final headers = token != null 
          ? ApiConfig.headersWithToken(token)
          : ApiConfig.headers;

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'username': username,
          'page': 1,
          'take': 50,
          'skip': 0,
        }),
      ).timeout(ApiConfig.timeout);

      developer.log('Status code: ${response.statusCode}', name: 'ProfessionalRepository');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        List<dynamic> professionalList;
        if (responseData is List) {
          professionalList = responseData;
        } else if (responseData is Map && responseData.containsKey('list')) {
          professionalList = responseData['list'] ?? [];
        } else {
          professionalList = [];
        }
        
        final professionals = professionalList
            .map((json) => ProfessionalDto.fromJson(json).toDomain())
            .toList();

        developer.log('Profesionales obtenidos: ${professionals.length}', name: 'ProfessionalRepository');

        return professionals;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al obtener profesionales');
      }
    } catch (e) {
      developer.log('Error al obtener profesionales: $e', name: 'ProfessionalRepository', error: e);
      throw Exception('Error al obtener profesionales: $e');
    }
  }
}
