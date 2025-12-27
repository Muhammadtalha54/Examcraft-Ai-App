import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFHelper {
  static Future<String> generateAndSavePDF({
    required String title,
    required List<Map<String, dynamic>> questions,
    required String type, // 'mcq', 'short', 'long'
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                title,
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;

              if (type == 'mcq') {
                return _buildMCQQuestion(index + 1, question);
              } else if (type == 'short') {
                return _buildShortQuestion(index + 1, question);
              } else {
                return _buildLongQuestion(index + 1, question);
              }
            }).toList(),
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        '${title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static pw.Widget _buildMCQQuestion(
      int number, Map<String, dynamic> question) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Q$number. ${question['question']}',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        ...List.generate(
          (question['options'] as List).length,
          (index) => pw.Padding(
            padding: pw.EdgeInsets.only(left: 16, bottom: 4),
            child: pw.Text(
              '${String.fromCharCode(65 + index)}. ${question['options'][index]}',
              style: pw.TextStyle(fontSize: 12),
            ),
          ),
        ),
        if (question['explanation'] != null) ...[
          pw.SizedBox(height: 8),
          pw.Text(
            'Answer: ${String.fromCharCode(65 + (question['correctAnswerIndex'] as int))}',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'Explanation: ${question['explanation']}',
            style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic),
          ),
        ],
        pw.SizedBox(height: 16),
      ],
    );
  }

  static pw.Widget _buildShortQuestion(
      int number, Map<String, dynamic> question) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Q$number. ${question['question']}',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          height: 60,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
          ),
        ),
        if (question['suggestedAnswer'] != null) ...[
          pw.SizedBox(height: 8),
          pw.Text(
            'Suggested Answer: ${question['suggestedAnswer']}',
            style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic),
          ),
        ],
        pw.SizedBox(height: 16),
      ],
    );
  }

  static pw.Widget _buildLongQuestion(
      int number, Map<String, dynamic> question) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Q$number. ${question['question']}',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          height: 120,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
          ),
        ),
        if (question['suggestedAnswer'] != null) ...[
          pw.SizedBox(height: 8),
          pw.Text(
            'Suggested Answer: ${question['suggestedAnswer']}',
            style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic),
          ),
        ],
        pw.SizedBox(height: 20),
      ],
    );
  }
}
