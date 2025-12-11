import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:markdown/markdown.dart' as md;

class MindmapNode {
  final String text;
  final int level;
  final bool isMainTopic;
  final MindmapNode? parent;
  final List<MindmapNode> children;

  MindmapNode({
    required this.text,
    required this.level,
    this.isMainTopic = false,
    this.parent,
    List<MindmapNode>? children,
  }) : children = children ?? [];
}

class MindmapModalWidget extends StatefulWidget {
  final String mindmapUrl;

  const MindmapModalWidget({super.key, required this.mindmapUrl});

  @override
  State<MindmapModalWidget> createState() => _MindmapModalWidgetState();
}

class _MindmapModalWidgetState extends State<MindmapModalWidget> {
  String? _mindmapContent;
  bool _isLoading = true;
  String? _error;
  List<MindmapNode> _mindmapNodes = [];

  @override
  void initState() {
    super.initState();
    _loadMindmapContent();
  }

  Future<void> _loadMindmapContent() async {
    try {
      final dio = Dio();
      final response = await dio.get(widget.mindmapUrl);

      if (response.statusCode == 200) {
        final content = response.data.toString();
        setState(() {
          _mindmapContent = content;
          _mindmapNodes = _parseMarkdownToMindmap(content);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load mindmap content';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading mindmap: $e';
        _isLoading = false;
      });
    }
  }

  List<MindmapNode> _parseMarkdownToMindmap(String markdown) {
    try {
      // Parse markdown to AST
      final document = md.Document();
      final nodes = document.parse(markdown);

      List<MindmapNode> mindmapNodes = [];
      MindmapNode? currentParent;

      for (final node in nodes) {
        if (node is md.Element) {
          if (node.tag == 'h1') {
            // Main topic
            final text = _extractTextFromNode(node);
            if (text.isNotEmpty) {
              currentParent = MindmapNode(
                text: text,
                level: 0,
                isMainTopic: true,
              );
              mindmapNodes.add(currentParent);
            }
          } else if (node.tag == 'h2' && currentParent != null) {
            // Sub-topic
            final text = _extractTextFromNode(node);
            if (text.isNotEmpty) {
              final subNode = MindmapNode(
                text: text,
                level: 1,
                parent: currentParent,
              );
              currentParent.children.add(subNode);
            }
          } else if (node.tag == 'h3' && currentParent != null) {
            // Sub-sub-topic
            final text = _extractTextFromNode(node);
            if (text.isNotEmpty && currentParent.children.isNotEmpty) {
              final lastChild = currentParent.children.last;
              final subSubNode = MindmapNode(
                text: text,
                level: 2,
                parent: lastChild,
              );
              lastChild.children.add(subSubNode);
            }
          } else if (node.tag == 'ul' && currentParent != null) {
            // Bullet points
            _parseBulletPoints(node, currentParent);
          }
        }
      }

      return mindmapNodes;
    } catch (e) {
      // If parsing fails, create a simple text node
      return [MindmapNode(text: markdown, level: 0, isMainTopic: true)];
    }
  }

  String _extractTextFromNode(md.Element node) {
    final buffer = StringBuffer();
    if (node.children != null) {
      for (final child in node.children!) {
        if (child is md.Text) {
          buffer.write(child.text);
        } else if (child is md.Element) {
          buffer.write(_extractTextFromNode(child));
        }
      }
    }
    return buffer.toString().trim();
  }

  void _parseBulletPoints(md.Element ulNode, MindmapNode parent) {
    if (ulNode.children != null) {
      for (final child in ulNode.children!) {
        if (child is md.Element && child.tag == 'li') {
          final text = _extractTextFromNode(child);
          if (text.isNotEmpty) {
            final bulletNode = MindmapNode(
              text: text,
              level: parent.level + 1,
              parent: parent,
            );
            parent.children.add(bulletNode);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: GVColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: GVColors.guidaEvaiOrange.withValues(
                      alpha: 0.1 * 255,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/figma_designs/icon_lesson_start.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        GVColors.guidaEvaiOrange,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.conceptual_mind_map,
                    style: AppTextStyles.bodyTextBold.copyWith(
                      fontSize: 18,
                      color: GVColors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: GVColors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: GVColors.lightGreyBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: GVColors.borderGrey.withValues(alpha: 0.3 * 255),
                    width: 0.5,
                  ),
                ),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: GVColors.guidaEvaiOrange),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: GVColors.redDanger,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: AppTextStyles.bodyText.copyWith(color: GVColors.redDanger),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadMindmapContent();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GVColors.guidaEvaiOrange,
                foregroundColor: GVColors.white,
              ),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    if (_mindmapNodes.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _mindmapNodes
              .map((node) => _buildMindmapNode(node))
              .toList(),
        ),
      );
    }

    if (_mindmapContent != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: GVColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: GVColors.borderGrey.withValues(alpha: 0.3 * 255),
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _mindmapContent!,
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.black,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    return const Center(child: Text('No content available'));
  }

  Widget _buildMindmapNode(MindmapNode node) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main node
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: node.isMainTopic
                  ? GVColors.guidaEvaiOrange.withValues(alpha: 0.1 * 255)
                  : GVColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: node.isMainTopic
                    ? GVColors.guidaEvaiOrange
                    : GVColors.borderGrey.withValues(alpha: 0.3 * 255),
                width: node.isMainTopic ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: node.isMainTopic
                        ? GVColors.guidaEvaiOrange
                        : GVColors.lightGreyBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      node.isMainTopic
                          ? Icons.circle
                          : Icons.fiber_manual_record,
                      size: 12,
                      color: node.isMainTopic
                          ? GVColors.white
                          : GVColors.black54,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    node.text,
                    style: AppTextStyles.bodyText.copyWith(
                      color: GVColors.black,
                      fontSize: node.isMainTopic ? 16 : 14,
                      fontWeight: node.isMainTopic
                          ? FontWeight.w600
                          : FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Children nodes
          if (node.children.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                children: node.children
                    .map((child) => _buildChildNode(child))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChildNode(MindmapNode node) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connection line
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(top: 6),
            child: CustomPaint(painter: ConnectionLinePainter()),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GVColors.lightGreyBackground,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: GVColors.borderGrey.withValues(alpha: 0.2 * 255),
                  width: 0.5,
                ),
              ),
              child: Text(
                node.text,
                style: AppTextStyles.bodyText.copyWith(
                  color: GVColors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectionLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GVColors.borderGrey.withValues(alpha: 0.5 * 255)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.moveTo(size.width, size.height / 2);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
