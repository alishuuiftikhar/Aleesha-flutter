import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';

import 'package:seats_reserve/services/report_service.dart';

class DailyReportScreen extends StatefulWidget {
  const DailyReportScreen({super.key});

  @override
  State<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataProvider>().fetchReport(_selectedDate);
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      context.read<DataProvider>().fetchReport(_selectedDate);
    }
  }

  void _exportPdf() {
    final data = context.read<DataProvider>().reportReservations;
    if (data.isEmpty) return;
    ReportService.generateAttendancePdf(data, "Daily Attendance - ${DateFormat('dd MMM yyyy').format(_selectedDate)}");
  }

  void _exportExcel() {
    final data = context.read<DataProvider>().reportReservations;
    if (data.isEmpty) return;
    ReportService.generateAttendanceExcel(data);
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    final reports = data.reportReservations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Daily Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.download),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'pdf', child: Text('Export as PDF')),
              const PopupMenuItem(value: 'excel', child: Text('Export as Excel')),
            ],
            onSelected: (val) {
              if (val == 'pdf') _exportPdf();
              if (val == 'excel') _exportExcel();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Total: ${reports.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: data.isLoading
                ? const Center(child: CircularProgressIndicator())
                : reports.isEmpty
                    ? const Center(child: Text('No data found for this date.'))
                    : ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final res = reports[index];
                          return ListTile(
                            leading: CircleAvatar(child: Text(res.seat?.seatNumber.replaceAll('Seat ', '') ?? '')),
                            title: Text(res.student?.fullName ?? 'Unknown'),
                            subtitle: Text('Status: ${res.status.toUpperCase()}'),
                            trailing: Text(DateFormat('hh:mm a').format(res.reservedAt)),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
