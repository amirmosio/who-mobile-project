import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';

/// Page displaying IDTM overview information (pages 7-10 from the manual)
/// Shows general view, exploded view, and dimensions using PDF viewer
class WhatIsIdtmPage extends StatefulWidget {
  const WhatIsIdtmPage({super.key});

  @override
  State<WhatIsIdtmPage> createState() => _WhatIsIdtmPageState();
}

class _WhatIsIdtmPageState extends State<WhatIsIdtmPage> {
  late PdfControllerPinch _pdfController;
  bool _isLoading = true;
  String? _errorMessage;

  // Pages 7-10 from the PDF (actual PDF pages)
  final int _startPage = 7;
  final int _endPage = 10;
  final int _totalPages = 4; // Total pages to show (7,8,9,10 = 4 pages)
  int _currentPage = 7; // Current PDF page

  // Get display page number (1-4 instead of 7-10)
  int get _displayPage => _currentPage - _startPage + 1;

  @override
  void initState() {
    super.initState();
    _initializePdfController();
  }

  Future<void> _initializePdfController() async {
    try {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openAsset('assets/pdfs/idtm_user_manual.pdf'),
        initialPage: _startPage,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load PDF: $e';
      });
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What is IDTM'),
        backgroundColor: BZColors.bronzeDark,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Info card
                    Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: BZColors.bronzeDark.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: BZColors.bronzeDark,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'IDTM Overview',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Page $_displayPage of $_totalPages',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // PDF Viewer - Continuous scroll
                    Expanded(
                      child: PdfViewPinch(
                        controller: _pdfController,
                        scrollDirection: Axis.vertical,
                        onPageChanged: (page) {
                          // Restrict navigation to pages 7-10
                          if (page < _startPage) {
                            _pdfController.jumpToPage(_startPage);
                          } else if (page > _endPage) {
                            _pdfController.jumpToPage(_endPage);
                          } else {
                            setState(() {
                              _currentPage = page;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
