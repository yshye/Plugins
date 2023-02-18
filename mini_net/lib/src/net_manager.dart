import 'package:dio/dio.dart';
import 'package:mini_net/src/response_model.dart';

class NetManager {
  static NetManager? _instance;
  Dio? _dio;

  NetManager._();

  static NetManager? internal({
    String contentType = Headers.jsonContentType,
    String baseUrl = '',
    Map<String, String> headers = const {},
    int connectTimeout = 3000,
    int receiveTimeout = 600000,
    int sendTimeout = 3000,
    ResponseType responseType = ResponseType.json,
    List<Interceptor>? interceptors,
  }) {
    bool flag = _instance == null ||
        _instance!._dio == null ||
        _instance!._dio?.options == null ||
        (_instance!._dio!.options.contentType != contentType) ||
        (_instance!._dio!.options.baseUrl != baseUrl) ||
        (_instance!._dio!.options.connectTimeout != connectTimeout) ||
        (_instance!._dio!.options.sendTimeout != sendTimeout) ||
        (_instance!._dio!.options.receiveTimeout != receiveTimeout) ||
        (_instance!._dio!.options.headers.toString() != headers.toString());
    if (flag) {
      BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        contentType: contentType,
        headers: headers,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        responseType: responseType,
      );
      _instance = NetManager._();
      _instance!._dio = Dio(options);
      _instance!._dio!.interceptors.addAll(interceptors ?? []);
    }
    return _instance;
  }

  Future<ResponseModel> get(String path, {
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
    Map<String, dynamic> extra = const {},
  }) async {
    _dio!.options
      ..extra.clear()
      ..extra = extra;
    ResponseModel responseModel;
    try {
      Response response = await _dio!.get(
        path,
        queryParameters: body,
        cancelToken: cancelToken,
      );
      responseModel = ResponseModel(
        response.statusCode == 200,
        response,
        DioErrorType.response,
      );
    } on DioError catch (error) {
      responseModel = ResponseModel(false, null, error.type);
    } on Exception {
      responseModel = ResponseModel(false, null, DioErrorType.other);
    }

    return responseModel;
  }

  Future<ResponseModel> post(String path, {
    Map<String, dynamic>? body,
    List? list,
    CancelToken? cancelToken,
    Map<String, dynamic> extra = const {},
  }) async {
    _dio!.options
      ..extra.clear()
      ..extra = extra;
    var data;
    // print(_dio!.options.contentType);
    // print(Headers.formUrlEncodedContentType);
    if (_dio!.options.contentType == Headers.formUrlEncodedContentType) {
      data = FormData.fromMap(body ?? {});
    } else {
      data = list ?? body;
    }

    // print(data);

    ResponseModel responseModel;
    try {
      Response response = await _dio!.post(
        path,
        data: data,
        cancelToken: cancelToken,
      );
      responseModel = ResponseModel(
        response.statusCode == 200,
        response,
        DioErrorType.response,
      );
    } on DioError catch (error) {
      responseModel = ResponseModel(false, null, error.type);
    } on Exception {
      responseModel = ResponseModel(false, null, DioErrorType.other);
    }

    return responseModel;
  }
}
