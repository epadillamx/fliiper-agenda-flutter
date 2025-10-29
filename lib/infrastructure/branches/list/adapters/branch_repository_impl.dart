import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../domain/branches/list/entities/branch.dart';
import '../../../../domain/branches/list/repositories/i_branch_repository.dart';
import '../models/branch_dto.dart';

class BranchRepositoryImpl implements IBranchRepository {
  final _storage = SecureStorageService();

  @override
  Future<List<Branch>> getBranches(String? idcuenta, String email) async {
    try {
      developer.log('Obteniendo sucursales', name: 'BranchRepository');
      developer.log('Email: $email', name: 'BranchRepository');

      final url = Uri.parse('${ApiConfig.baseUrl}/api/sucursal/getAllPublic');
      
      final token = await _storage.getToken();
      final headers = token != null 
          ? ApiConfig.headersWithToken(token)
          : ApiConfig.headers;

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'idcuenta': idcuenta,
          'email': email,
        }),
      ).timeout(ApiConfig.timeout);

      developer.log('Status code: ${response.statusCode}', name: 'BranchRepository');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        developer.log('Response data: $responseData', name: 'BranchRepository');
        
        final List<dynamic> branchList = responseData['list'] ?? [];
        
        final branches = branchList
            .map((json) => BranchDto.fromJson(json).toDomain())
            .toList();

        developer.log('Sucursales obtenidas: ${branches.length}', name: 'BranchRepository');
        
        if (branches.isNotEmpty) {
          developer.log('Primera sucursal - ID: ${branches[0].id}, idcuenta: ${branches[0].idcuenta}', name: 'BranchRepository');
        }

        return branches;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al obtener sucursales');
      }
    } catch (e) {
      developer.log('Error al obtener sucursales: $e', name: 'BranchRepository', error: e);
      throw Exception('Error al obtener sucursales: $e');
    }
  }
}
