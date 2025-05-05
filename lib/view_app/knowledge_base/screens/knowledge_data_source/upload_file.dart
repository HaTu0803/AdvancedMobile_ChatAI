import 'dart:io';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/knowledge_data_source_repository%20copy.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ImportLocalFilesDialog extends StatefulWidget {
  final String id;
  const ImportLocalFilesDialog({super.key, required this.id});

  @override
  State<ImportLocalFilesDialog> createState() => _ImportLocalFilesDialogState();
}

class _ImportLocalFilesDialogState extends State<ImportLocalFilesDialog> {
  bool _isUploading = false;
  File? _selectedFile;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Import Local Files',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: [6, 3],
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isHovered ? Colors.grey.shade100 : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: _isUploading
                        ? const CircularProgressIndicator()
                        : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, size: 40, color: Colors.blue),
                        SizedBox(height: 8),
                        Text('Click or drag files to upload'),
                        SizedBox(height: 4),
                        Text(
                          'Supported formats: .c, .cpp, .docx, .html, ...',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),


            // Hiển thị thông tin file đã chọn
            if (_selectedFile != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset('images/file.png', width: 20, height: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedFile!.path.split('/').last,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_sharp, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _selectedFile = null; // Xóa file đã chọn
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
                FilledButton(
                  onPressed: _selectedFile != null && !_isUploading
                      ? () => _uploadFile(_selectedFile!)
                      : null,
                  child: const Text('Import'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn cần cấp quyền truy cập bộ nhớ')),
        );
        return;
      }
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'c', 'cpp', 'docx', 'html', 'java', 'json', 'md',
        'pdf', 'php', 'pptx', 'py', 'rb', 'tex', 'txt', 'jpg', 'jpeg', 'png', 'gif'
      ],
    );

    if (result != null && result.files.isNotEmpty) {
      final platformFile = result.files.first;
      setState(() {
        _selectedFile = File(platformFile.path!);
      });
    }
  }

  Future<void> _uploadFile(File file) async {
    setState(() {
      _isUploading = true;
    });

    try {
      await KnowledgeDataRepository().uploadLocalFile(widget.id, file);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tải file lên thành công!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải file: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }
}
