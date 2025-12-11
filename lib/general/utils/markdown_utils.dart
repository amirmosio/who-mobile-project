import 'package:markdown/markdown.dart' as md;

/// Utility functions for processing markdown text
class MarkdownUtils {
  /// Converts markdown text to plain text by removing all markdown syntax
  /// This is useful for text-to-speech where symbols should not be read aloud
  ///
  /// Uses the official `markdown` package's `markdownToHtml()` function
  /// and then strips HTML tags to get clean plain text.
  ///
  /// Example:
  /// ```dart
  /// final markdown = "# Title\n\n**Bold** text with *italic*";
  /// final plain = MarkdownUtils.markdownToPlainText(markdown);
  /// // Result: "Title\n\nBold text with italic"
  /// ```
  static String? markdownToPlainText(String? markdown) {
    if (markdown == null || markdown.isEmpty) return null;

    // Convert markdown to HTML using the official markdown package
    final html = md.markdownToHtml(
      markdown,
      extensionSet: md.ExtensionSet.gitHubWeb,
    );

    // Strip HTML tags to get plain text
    String text = _stripHtmlTags(html);

    // Clean up the result
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n'); // Max 2 newlines
    text = text.replaceAll(RegExp(r' +'), ' '); // Collapse spaces

    return text.trim();
  }

  /// Strips HTML tags from a string
  static String _stripHtmlTags(String html) {
    String text = html;

    // Replace block-level tags with newlines to preserve paragraph structure
    text = text.replaceAllMapped(
      RegExp(r'</(p|div|h[1-6]|li|blockquote|pre|tr)>', caseSensitive: false),
      (match) => '\n',
    );

    // Replace <br> tags with newlines
    text = text.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    // Remove all remaining HTML tags
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode HTML entities
    text = _decodeHtmlEntities(text);

    return text;
  }

  /// Decodes HTML entities (named, numeric decimal, and hexadecimal)
  static String _decodeHtmlEntities(String text) {
    String result = text;

    // Decode numeric entities (decimal: &#123; and hex: &#x7B;)
    result = result.replaceAllMapped(RegExp(r'&#(x?)([0-9a-fA-F]+);'), (match) {
      final isHex = match.group(1) == 'x';
      final value = match.group(2)!;
      try {
        final codePoint = int.parse(value, radix: isHex ? 16 : 10);
        return String.fromCharCode(codePoint);
      } catch (e) {
        return match.group(0)!; // Return original if parsing fails
      }
    });

    // Decode common named entities
    final entities = {
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&quot;': '"',
      '&apos;': "'",
      '&#39;': "'",
      '&nbsp;': ' ',
      '&ndash;': '–',
      '&mdash;': '—',
      '&hellip;': '…',
      '&copy;': '©',
      '&reg;': '®',
      '&trade;': '™',
      '&bull;': '•',
      '&middot;': '·',
      '&lsquo;': ''',
      '&rsquo;': ''',
      '&ldquo;': '"',
      '&rdquo;': '"',
      '&laquo;': '«',
      '&raquo;': '»',
      '&cent;': '¢',
      '&pound;': '£',
      '&euro;': '€',
      '&yen;': '¥',
      '&sect;': '§',
      '&para;': '¶',
      '&dagger;': '†',
      '&Dagger;': '‡',
      '&permil;': '‰',
      '&deg;': '°',
      '&times;': '×',
      '&divide;': '÷',
      '&plusmn;': '±',
      '&ne;': '≠',
      '&le;': '≤',
      '&ge;': '≥',
      '&minus;': '−',
      '&asymp;': '≈',
      '&infin;': '∞',
      '&sum;': '∑',
      '&prod;': '∏',
      '&radic;': '√',
      '&int;': '∫',
      '&part;': '∂',
      '&nabla;': '∇',
      '&perp;': '⊥',
      '&ang;': '∠',
      '&and;': '∧',
      '&or;': '∨',
      '&cap;': '∩',
      '&cup;': '∪',
      '&isin;': '∈',
      '&notin;': '∉',
      '&sub;': '⊂',
      '&sup;': '⊃',
      '&sube;': '⊆',
      '&supe;': '⊇',
      '&exist;': '∃',
      '&forall;': '∀',
      '&empty;': '∅',
      '&larr;': '←',
      '&uarr;': '↑',
      '&rarr;': '→',
      '&darr;': '↓',
      '&harr;': '↔',
      '&lArr;': '⇐',
      '&uArr;': '⇑',
      '&rArr;': '⇒',
      '&dArr;': '⇓',
      '&hArr;': '⇔',
      '&alpha;': 'α',
      '&beta;': 'β',
      '&gamma;': 'γ',
      '&delta;': 'δ',
      '&epsilon;': 'ε',
      '&zeta;': 'ζ',
      '&eta;': 'η',
      '&theta;': 'θ',
      '&iota;': 'ι',
      '&kappa;': 'κ',
      '&lambda;': 'λ',
      '&mu;': 'μ',
      '&nu;': 'ν',
      '&xi;': 'ξ',
      '&omicron;': 'ο',
      '&pi;': 'π',
      '&rho;': 'ρ',
      '&sigma;': 'σ',
      '&tau;': 'τ',
      '&upsilon;': 'υ',
      '&phi;': 'φ',
      '&chi;': 'χ',
      '&psi;': 'ψ',
      '&omega;': 'ω',
      '&Alpha;': 'Α',
      '&Beta;': 'Β',
      '&Gamma;': 'Γ',
      '&Delta;': 'Δ',
      '&Epsilon;': 'Ε',
      '&Zeta;': 'Ζ',
      '&Eta;': 'Η',
      '&Theta;': 'Θ',
      '&Iota;': 'Ι',
      '&Kappa;': 'Κ',
      '&Lambda;': 'Λ',
      '&Mu;': 'Μ',
      '&Nu;': 'Ν',
      '&Xi;': 'Ξ',
      '&Omicron;': 'Ο',
      '&Pi;': 'Π',
      '&Rho;': 'Ρ',
      '&Sigma;': 'Σ',
      '&Tau;': 'Τ',
      '&Upsilon;': 'Υ',
      '&Phi;': 'Φ',
      '&Chi;': 'Χ',
      '&Psi;': 'Ψ',
      '&Omega;': 'Ω',
    };

    // Replace all named entities
    entities.forEach((entity, char) {
      result = result.replaceAll(entity, char);
    });

    // Note: &amp; must be decoded last to avoid double-decoding
    // (already handled in the map above, positioned first)

    return result;
  }
}
