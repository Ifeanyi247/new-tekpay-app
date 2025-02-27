import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/transactions_controller.dart';
import 'package:tekpayapp/models/transaction_model.dart';
import 'package:tekpayapp/pages/app/status_page.dart';

class TransactionsPage extends StatefulWidget {
  TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final TransactionsController _controller = Get.put(TransactionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Transactions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onSelected: (value) {
              _controller.setCategory(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'All Categories',
                child: Text('All Categories'),
              ),
              const PopupMenuItem(
                value: 'airtime',
                child: Text('Airtime'),
              ),
              const PopupMenuItem(
                value: 'data',
                child: Text('Data'),
              ),
              const PopupMenuItem(
                value: 'electricity',
                child: Text('Electricity'),
              ),
              const PopupMenuItem(
                value: 'transfer',
                child: Text('Transfer'),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onSelected: (value) {
              _controller.setMonth(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mar_2024',
                child: Text('Mar 2024'),
              ),
              const PopupMenuItem(
                value: 'feb_2024',
                child: Text('Feb 2024'),
              ),
              const PopupMenuItem(
                value: 'jan_2024',
                child: Text('Jan 2024'),
              ),
            ],
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _controller.refreshTransactions,
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.transactions.isEmpty) {
            return Center(
              child: Text(
                'No transactions found',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: _controller.filteredTransactions.length,
            itemBuilder: (context, index) {
              final transaction = _controller.filteredTransactions[index];
              return _TransactionItem(
                transaction: transaction,
                controller: _controller,
              );
            },
          );
        }),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final TransactionsController controller;

  const _TransactionItem({
    required this.transaction,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  transaction.icon,
                  color: Colors.purple,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      transaction.subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      transaction.transactionDate.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.formattedAmount,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: transaction.formattedAmount.startsWith('-')
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _getStatusColor(transaction.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      transaction.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _getStatusColor(transaction.status),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () async {
              try {
                if (transaction.type == 'deposit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatusPage(
                        amount: transaction.amount,
                        status: transaction.status,
                        date: transaction.transactionDate,
                        recipientId: transaction.phone,
                        transactionType: 'Deposit',
                        method: transaction.method,
                        transactionId: transaction.transactionId,
                        transactionDate: transaction.transactionDate.toString(),
                      ),
                    ),
                  );
                } else if (transaction.type == 'Transfer') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatusPage(
                        amount: transaction.amount,
                        status: transaction.status,
                        date: transaction.transactionDate,
                        recipientId: transaction.phone,
                        transactionType: 'Transfer',
                        method: transaction.method,
                        transactionId: transaction.transactionId,
                        transactionDate: transaction.transactionDate.toString(),
                      ),
                    ),
                  );
                } else {
                  final statusData = await controller.checkTransactionStatus(
                    transaction.requestId,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatusPage(
                        amount: statusData['amount'],
                        status: statusData['status'],
                        date: DateTime.parse(statusData['transaction_date']),
                        recipientId: statusData['phone'],
                        transactionType: statusData['product_name'],
                        method: statusData['method'],
                        transactionId: statusData['transactionId'],
                        transactionDate: statusData['transaction_date'],
                        lightToken: statusData['purchased_code'],
                      ),
                    ),
                  );
                }
              } catch (e) {
                // Error is already handled in the controller
              }
            },
            child: Text(
              'View Receipt',
              style: TextStyle(
                fontSize: 12.sp,
                color: primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'pending':
      case 'initiated':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'success':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
