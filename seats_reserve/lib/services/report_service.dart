import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:seats_reserve/models/reservation.dart';

class ReportService {
  static Future<void> generateAttendancePdf(List<Reservation> data, String title) async {
    final pdf = pw.Document();
    final dateStr = DateFormat('dd MMM yyyy').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('SeatSync - Software House Management', style: pw.TextStyle(fontSize: 12))),
          pw.SizedBox(height: 10),
          pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.Text('Generated on: $dateStr'),
          pw.Divider(),
          pw.TableHelper.fromTextArray(
            headers: ['Student Name', 'Student ID', 'Seat', 'Date', 'Status'],
            data: data.map((res) => [
              res.student?.fullName ?? 'Unknown',
              res.student?.studentId ?? 'N/A',
              res.seat?.seatNumber ?? 'N/A',
              DateFormat('dd-MM-yyyy').format(res.reservationDate),
              res.status.toUpperCase(),
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/attendance_report.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  static Future<void> generateAttendanceExcel(List<Reservation> data) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Attendance Report'];

    sheetObject.appendRow([
      TextCellValue('Student Name'),
      TextCellValue('Student ID'),
      TextCellValue('Seat'),
      TextCellValue('Date'),
      TextCellValue('Status')
    ]);

    for (var res in data) {
      sheetObject.appendRow([
        TextCellValue(res.student?.fullName ?? 'Unknown'),
        TextCellValue(res.student?.studentId ?? 'N/A'),
        TextCellValue(res.seat?.seatNumber ?? 'N/A'),
        TextCellValue(DateFormat('dd-MM-yyyy').format(res.reservationDate)),
        TextCellValue(res.status.toUpperCase()),
      ]);
    }

    final output = await getTemporaryDirectory();
    final filePath = "${output.path}/report.xlsx";
    final fileBytes = excel.save();
    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
      await OpenFile.open(filePath);
    }
  }
}
