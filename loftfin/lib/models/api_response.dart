class ApiResponse {
  bool isError;
  String? errorMessage;
  dynamic data;

  ApiResponse({
    required this.isError,
    this.errorMessage,
    this.data,
  });
}
