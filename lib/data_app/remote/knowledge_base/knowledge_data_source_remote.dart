import 'dart:convert';
import 'dart:io';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_data_source_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/knowledge_base/knowledge_data_source_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/navigation/routes.dart';
import '../../repository/auth/authentication_repository.dart';

class KnowledgeDataApiClient {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<UploadFileResponse> uploadLocalFile(String id, File file) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.uploadLocal(id));

      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(ApiHeaders.getHeadersWithFile("", token));

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadFileResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        // Nếu server trả 401, xử lý refresh token
        final retryResponse = await retryWithRefreshTokenMultipart(
          url: url,
          headers: request.headers,
          filePath: file.path,
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return UploadFileResponse.fromJson(jsonDecode(retryResponse.body));
        } else {
          await AuthRepository().logOut();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => true,
          );
          throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        }
      } else {
        handleErrorResponse(response);

        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<UploadFileResponse> uploadGgDrive(String id) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.uploadGgDrive(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadFileResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: null,
          method: 'POST',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return UploadFileResponse.fromJson(jsonDecode(retryResponse.body));
        } else {
          await AuthRepository().logOut();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => true,
          );
          throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        }
      } else {
        handleErrorResponse(response);

        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<UploadFileResponse> uploadSlack(
      String id, UpLoadFileSlack request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.uploadSlack(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadFileResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: body,
          method: 'POST',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return UploadFileResponse.fromJson(jsonDecode(retryResponse.body));
        } else {
          await AuthRepository().logOut();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => true,
          );
          throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        }
      } else {
        handleErrorResponse(response);

        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<UploadFileResponse> uploadConfluence(
      String id, UploadFileConfluence request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.uploadLocal(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadFileResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: body,
          method: 'POST',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return UploadFileResponse.fromJson(jsonDecode(retryResponse.body));
        } else {
          await AuthRepository().logOut();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => true,
          );
          throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        }
      } else {
        handleErrorResponse(response);

        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<UploadFileResponse> uploadWeb(String id, UploadWebsite request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.uploadLocal(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadFileResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: body,
          method: 'POST',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return UploadFileResponse.fromJson(jsonDecode(retryResponse.body));
        } else {
          await AuthRepository().logOut();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => true,
          );
          throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        }
      } else {
        handleErrorResponse(response);
        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }
  Future<DataSourceResponse> getDataSources(String id,BaseQueryParams params) async {
  try {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');

    final url = Uri.parse(
        ApiKnowledgeDataSourceUrl.getDataSources(id,params.toQueryString()));
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return DataSourceResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        body: null,
        method: 'GET',
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return DataSourceResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to upload file due to an error response');
    }
  } catch (e) {
    throw Exception('Đã xảy ra lỗi: $e');
  }
}
Future<FileModelResponse> uploadFile(File file) async {
  try {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');

    final url = Uri.parse(ApiKnowledgeDataSourceUrl.uploadFile());
    final header = ApiHeaders.getHeadersWithFile("", token);

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(header);

    // ✅ Chỉ thêm một MultipartFile duy nhất
    final multipartFile = await http.MultipartFile.fromPath(
      'files', // 👈 tên trường phải đúng theo API yêu cầu
      file.path,
      filename: file.path.split('/').last,
    );
    request.files.add(multipartFile);

    print("File path: ${file.path}");
    print("File exists: ${await file.exists()}");
    print("File length: ${await file.length()} bytes");
    print("Multipart file name: ${multipartFile.filename}");

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("response.statusCode: ${response.statusCode}");
    print("response.body: ${response.body}");
final decoded = jsonDecode(response.body);
print(decoded); 
    if (response.statusCode == 200 || response.statusCode == 201) {
      return FileModelResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshTokenMultipart(
        url: url,
        headers: request.headers,
        filePath: file.path,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return FileModelResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to upload file due to an error response');
    }
  } catch (e) {
    throw Exception('Đã xảy ra lỗi: $e');
  }
}

 
  Future<DataSourceResponse> importDataSource(String id, DataSourceRequest request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.uploadLocal(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DataSourceResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: body,
          method: 'POST',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return DataSourceResponse.fromJson(jsonDecode(retryResponse.body));
        } else {
          await AuthRepository().logOut();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => true,
          );
          throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        }
      } else {
        handleErrorResponse(response);
        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }
 
  Future<bool> deleteDataSource(String id, String dataSourceId) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.deleteDataSource(id, dataSourceId));
      final headers = ApiHeaders.getAIChatHeaders("", token);

      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: null,
          method: 'DELETE',
        );

        if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
          return true;
        } else {
          await AuthRepository().logOut();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => true,
          );
          throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        }
      } else {
        handleErrorResponse(response);
        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }
}

