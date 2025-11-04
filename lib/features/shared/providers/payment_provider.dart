import 'dart:io'; // Add this import for File class
import 'package:flutter/material.dart';
import '../../../core/services/payment_service.dart';
import '../../payment/domain/models/payment_model.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  List<PaymentMethod> _paymentMethods = [];
  List<Payment> _paymentHistory = [];
  Payment? _currentPayment;
  bool _isLoading = false;
  String? _error;

  List<PaymentMethod> get paymentMethods => _paymentMethods;
  List<Payment> get paymentHistory => _paymentHistory;
  Payment? get currentPayment => _currentPayment;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPaymentMethods() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _paymentMethods = await _paymentService.getPaymentMethods();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> initiatePayment(double amount, String method) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentPayment = await _paymentService.initiatePayment(amount, method);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> submitPaymentProof(
    String transactionRef,
    String imagePath,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_currentPayment == null) {
        throw Exception('No active payment found');
      }

      _currentPayment = await _paymentService.uploadPaymentProof(
        _currentPayment!.id,
        File(imagePath),
      );

      // Update transaction reference
      _currentPayment!.transactionRef = transactionRef;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadPaymentHistory() async {
    try {
      _isLoading = true;
      notifyListeners();

      _paymentHistory = await _paymentService.getPaymentHistory();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> checkPaymentStatus(String paymentId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentPayment = await _paymentService.getPaymentStatus(paymentId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> verifyAutoPayment(String transactionRef, String method) async {
    try {
      return await _paymentService.verifyAutoPayment(transactionRef, method);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearCurrentPayment() {
    _currentPayment = null;
    notifyListeners();
  }
}
