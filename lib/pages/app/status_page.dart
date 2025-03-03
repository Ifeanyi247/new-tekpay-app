import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/transfer_page.dart';
import 'package:tekpayapp/pages/app/confirm_transfer.dart';
import 'package:tekpayapp/controllers/transfer_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class StatusPage extends StatefulWidget {
  final String amount;
  final String status;
  final DateTime date;
  final String recipientId;
  final String transactionType;
  final String method;
  final String transactionId;
  final String transactionDate;
  final String? lightToken;

  const StatusPage({
    super.key,
    required this.amount,
    required this.status,
    required this.date,
    required this.recipientId,
    required this.transactionType,
    required this.method,
    required this.transactionId,
    required this.transactionDate,
    this.lightToken,
  });

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  Color get statusColor {
    switch (widget.status.toLowerCase()) {
      case 'delivered':
      case 'successful':
        return Colors.green;
      case 'pending':
      case 'initiated':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _generateAndDownloadReceipt() async {
    try {
      // Create PDF document
      final pdf = pw.Document();

      // Add content to PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Text(
                    'Transaction Receipt',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Amount
                pw.Center(
                  child: pw.Text(
                    'NGN ${NumberFormat('#,##0.00').format(double.parse(widget.amount))}',
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),

                // Status
                pw.Center(
                  child: pw.Text(
                    'Transaction ${widget.status}',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 5),

                // Date
                pw.Center(
                  child: pw.Text(
                    DateFormat('MMM d, y h:mma').format(widget.date),
                    style: const pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.SizedBox(height: 30),

                // Transaction Details
                pw.Text(
                  'Transaction Details:',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 15),

                // Details List
                _buildPdfDetailRow('Recipient ID:', widget.recipientId),
                _buildPdfDetailRow('Transaction Type:', widget.transactionType),
                _buildPdfDetailRow('Method:', widget.method),
                _buildPdfDetailRow('Transaction Date:', widget.transactionDate),
                _buildPdfDetailRow('Transaction ID:', widget.transactionId),
                widget.lightToken != ""
                    ? _buildPdfDetailRow(
                        'Electricity Token:', widget.lightToken.toString())
                    : pw.SizedBox(),
              ],
            );
          },
        ),
      );

      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'receipt_${widget.transactionId}.pdf';
      final file = File('${directory.path}/$fileName');

      // Save the PDF
      await file.writeAsBytes(await pdf.save());

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Receipt downloaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
        print('Receipt downloaded to ${file.path}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download receipt'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareReceipt() async {
    try {
      // Create PDF document
      final pdf = pw.Document();

      // Add content to PDF (same as download receipt)
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Text(
                    'Transaction Receipt',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Amount
                pw.Center(
                  child: pw.Text(
                    'NGN ${NumberFormat('#,##0.00').format(double.parse(widget.amount))}',
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),

                // Status
                pw.Center(
                  child: pw.Text(
                    'Transaction ${widget.status}',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 5),

                // Date
                pw.Center(
                  child: pw.Text(
                    DateFormat('MMM d, y h:mma').format(widget.date),
                    style: const pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.SizedBox(height: 30),

                // Transaction Details
                pw.Text(
                  'Transaction Details:',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 15),

                // Details List
                _buildPdfDetailRow('Recipient ID:', widget.recipientId),
                _buildPdfDetailRow('Transaction Type:', widget.transactionType),
                _buildPdfDetailRow('Method:', widget.method),
                _buildPdfDetailRow('Transaction Date:', widget.transactionDate),
                _buildPdfDetailRow('Transaction ID:', widget.transactionId),
              ],
            );
          },
        ),
      );

      // Get temporary directory to store the file for sharing
      final tempDir = await getTemporaryDirectory();
      final fileName = 'tekpay_receipt_${widget.transactionId}.pdf';
      final file = File('${tempDir.path}/$fileName');

      // Save the PDF
      await file.writeAsBytes(await pdf.save());

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'TekPay Transaction Receipt',
        text:
            'Transaction Receipt for ${widget.transactionType} - NGN ${NumberFormat('#,##0.00').format(double.parse(widget.amount))}',
      );

      // Delete the temporary file after sharing
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share receipt'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error sharing receipt: $e');
    }
  }

  pw.Widget _buildPdfDetailRow(String label, String value) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              fontSize: 14,
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Transaction Receipt',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Amount and Status
            Text(
              '₦${NumberFormat('#,##0.00').format(double.parse(widget.amount))}',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Transaction ${widget.status}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Today ${DateFormat('h:mma').format(widget.date).toLowerCase()}',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32.h),

            // Transaction Details
            const Text(
              'Transaction Details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),

            // Details List
            _buildDetailRow('Recipient ID:', widget.recipientId),
            _buildDetailRow('Transaction Type:', widget.transactionType),
            _buildDetailRow('Method:', widget.method),
            _buildDetailRow('Transaction Date:', widget.transactionDate),
            _buildDetailRow('Transaction ID:', widget.transactionId),
            widget.lightToken != ""
                ? Row(
                    children: [
                      Expanded(
                        child: _buildDetailRow(
                            'Token:', widget.lightToken.toString()),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: widget.lightToken.toString(),
                            ),
                          );
                        },
                        icon: Icon(Icons.copy),
                      ),
                    ],
                  )
                : SizedBox(),

            SizedBox(height: 48.h),

            // Action Buttons
            Row(
              children: [
                if (widget.transactionType.toLowerCase() == 'in-app transfer')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final controller = Get.find<TransferController>();
                        // First search for the user to get their details
                        final recipientName =
                            await controller.searchUser(widget.recipientId);
                        if (recipientName != null) {
                          Get.to(() => ConfirmTransferPage(
                                recipientName: recipientName,
                                accountNumber: widget.recipientId,
                                bankName: 'In-App Transfer',
                                bankCode: 'INTERNAL',
                                prefillAmount: widget.amount,
                                isInAppTransfer: true,
                              ));
                        }
                      },
                      icon: const Icon(Icons.repeat, color: Colors.white),
                      label: const Text('Quick Transfer'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                if (widget.transactionType.toLowerCase() == 'in-app transfer')
                  SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareReceipt,
                    icon: const Icon(Icons.share, color: primaryColor),
                    label: const Text('Share Receipt'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generateAndDownloadReceipt,
                    icon: const Icon(Icons.download),
                    label: const Text('Download Receipt'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Flexible(
                flex: 3,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
