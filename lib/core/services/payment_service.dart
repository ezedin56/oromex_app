import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';
import '../../features/payment/domain/models/payment_model.dart';

class PaymentService {
  final ApiService _apiService = ApiService();
  final ImagePicker _imagePicker = ImagePicker();

  Future<List<PaymentMethod>> getPaymentMethods() async {
    final response = await _apiService.get('/api/payments/methods');
    return (response['data'] as List)
        .map((method) => PaymentMethod.fromJson(method))
        .toList();
  }

  Future<Payment> initiatePayment(double amount, String method) async {
    final response = await _apiService.post('/api/payments/initiate', {
      'amount': amount,
      'method': method,
    });
    return Payment.fromJson(response['data']);
  }

  Future<Payment> uploadPaymentProof(String paymentId, File imageFile) async {
    final fileBytes = await imageFile.readAsBytes();
    final response = await _apiService.uploadFile(
      '/api/payments/upload-proof',
      fileBytes,
      'payment_proof_$paymentId.jpg',
    );
    return Payment.fromJson(response['data']);
  }

  Future<Payment> getPaymentStatus(String paymentId) async {
    final response = await _apiService.get('/api/payments/$paymentId/status');
    return Payment.fromJson(response['data']);
  }

  Future<List<Payment>> getPaymentHistory() async {
    final response = await _apiService.get('/api/payments/history');
    return (response['data'] as List)
        .map((payment) => Payment.fromJson(payment))
        .toList();
  }

  Future<File?> pickPaymentProof() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<bool> verifyAutoPayment(String transactionRef, String method) async {
    final response = await _apiService.post('/api/payments/auto-verify', {
      'transaction_ref': transactionRef,
      'method': method,
    });
    return response['data']['verified'];
  }
}
