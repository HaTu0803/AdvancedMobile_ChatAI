import 'dart:convert';
import 'dart:io';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_data_source_model_v2.dart';
import 'package:advancedmobile_chatai/data_app/url_api/knowledge_base/knowledge_data_source_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../core/navigation/routes.dart';
import '../../repository/auth/authentication_repository.dart';

class KnowledgeDataApiClient {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
 Future<ConfluenceResponse> uploadSlack(
      String id, SlackDatasourceWrapper request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.uploadLocal(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());
      final response = await http.post(url, headers: headers, body: body);
print("response.statusCode ConfluenceResponse : ${response.statusCode}");
      print("response.body ConfluenceResponse: ${response.body}");
      print("request.toJson() ConfluenceResponse: ${request.toJson()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ConfluenceResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: body,
          method: 'POST',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return ConfluenceResponse.fromJson(jsonDecode(retryResponse.body));
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

  Future<ConfluenceResponse> uploadConfluence(
      String id, DataSourcesModel request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.uploadLocal(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());
      final response = await http.post(url, headers: headers, body: body);
print("response.statusCode ConfluenceResponse : ${response.statusCode}");
      print("response.body ConfluenceResponse: ${response.body}");
      print("request.toJson() ConfluenceResponse: ${request.toJson()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ConfluenceResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: body,
          method: 'POST',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return ConfluenceResponse.fromJson(jsonDecode(retryResponse.body));
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
print("response.statusCode getDataSources: ${response.statusCode}");
    print("response.body getDataSources: ${response.body}");
    print("params.toQueryString(): ${params.toQueryString()}");
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
    final headers = {
      'Authorization': 'Bearer $token',
      'x-jarvis-guid': '',
    };
 final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath(
        'files', 
        file.path,
          contentType: MediaType.parse(mimeType),
        filename: file.uri.pathSegments.last, 
      ));

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    print("response.statusCode: ${response.statusCode}");
    print("response.body: $responseBody");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return FileModelResponse.fromJson(jsonDecode(responseBody));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        body: await file.readAsBytes(),
        method: 'POST',
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

 
  Future<DataSourceFileResponse> importDataSource(String id, DataSourceRequest request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.importDataSource(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());
      final response = await http.post(url, headers: headers, body: body);
print("response.statusCode importDataSource: ${response.statusCode}");
      print("response.body importDataSource: ${response.body}");
      print("request.toJson() importDataSource: ${request.toJson()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DataSourceFileResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: body,
          method: 'POST',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return DataSourceFileResponse.fromJson(jsonDecode(retryResponse.body));
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
 Future<KnowledgeDataSource> updateDataSource(String id, String dataSourceId, bool status) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeDataSourceUrl.updateDataSource(id, dataSourceId));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode({"status": status});
      final response = await http.patch(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return KnowledgeDataSource.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: body,
          method: 'PATCH',
        );

        if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
          return KnowledgeDataSource.fromJson(jsonDecode(retryResponse.body));
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

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
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

