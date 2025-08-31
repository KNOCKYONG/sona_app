#!/usr/bin/env python3
"""
Check translation status across all ARB files.
Shows which keys are missing or need translation in each language.

Usage: python scripts/check_translation_status.py [--verbose] [--lang LANG]
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, Any, List, Set, Tuple
import argparse
from datetime import datetime

# ANSI color codes for terminal output
class Colors:
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

def load_arb_file(file_path: Path) -> Dict[str, Any]:
    """Load an ARB file as JSON."""
    if not file_path.exists():
        return {}
    
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def get_translation_keys(arb_data: Dict[str, Any]) -> Set[str]:
    """Get all translation keys (excluding metadata keys that start with @)."""
    return {key for key in arb_data.keys() if not key.startswith('@')}

def find_untranslated_keys(arb_data: Dict[str, Any], lang_code: str) -> List[str]:
    """Find keys that appear to be untranslated (contain TODO markers)."""
    untranslated = []
    for key, value in arb_data.items():
        if not key.startswith('@') and isinstance(value, str):
            # Check for TODO markers or language code markers
            if (f"[TODO-{lang_code.upper()}]" in value or 
                f"[{lang_code.upper()}]" in value or
                value.startswith("[TODO")):
                untranslated.append(key)
    return untranslated

def analyze_language_file(english_data: Dict[str, Any], target_data: Dict[str, Any], 
                         lang_code: str) -> Dict[str, Any]:
    """Analyze a language file compared to English master."""
    english_keys = get_translation_keys(english_data)
    target_keys = get_translation_keys(target_data)
    
    missing_keys = sorted(english_keys - target_keys)
    extra_keys = sorted(target_keys - english_keys)
    untranslated_keys = find_untranslated_keys(target_data, lang_code)
    
    # Calculate statistics
    total_keys = len(english_keys)
    translated_keys = len(target_keys & english_keys) - len(untranslated_keys)
    completion_rate = (translated_keys / total_keys * 100) if total_keys > 0 else 0
    
    return {
        'lang_code': lang_code,
        'total_keys': total_keys,
        'translated_keys': translated_keys,
        'missing_keys': missing_keys,
        'extra_keys': extra_keys,
        'untranslated_keys': untranslated_keys,
        'completion_rate': completion_rate
    }

def print_language_report(report: Dict[str, Any], verbose: bool = False):
    """Print a formatted report for a language."""
    lang = report['lang_code'].upper()
    rate = report['completion_rate']
    
    # Choose color based on completion rate
    if rate >= 95:
        color = Colors.GREEN
        status = "✅"
    elif rate >= 80:
        color = Colors.YELLOW
        status = "⚠️"
    else:
        color = Colors.RED
        status = "❌"
    
    # Print header
    print(f"\n{Colors.BOLD}{color}{'='*60}{Colors.RESET}")
    print(f"{status} {Colors.BOLD}{lang} - {color}{rate:.1f}% Complete{Colors.RESET}")
    print(f"{color}{'='*60}{Colors.RESET}")
    
    # Print statistics
    print(f"  📊 Total keys: {report['total_keys']}")
    print(f"  ✅ Translated: {report['translated_keys']}")
    
    if report['missing_keys']:
        print(f"  {Colors.RED}❌ Missing: {len(report['missing_keys'])}{Colors.RESET}")
    
    if report['untranslated_keys']:
        print(f"  {Colors.YELLOW}⚠️  Untranslated: {len(report['untranslated_keys'])}{Colors.RESET}")
    
    if report['extra_keys']:
        print(f"  {Colors.CYAN}➕ Extra: {len(report['extra_keys'])}{Colors.RESET}")
    
    # Show details if verbose
    if verbose:
        if report['missing_keys']:
            print(f"\n  {Colors.RED}Missing Keys:{Colors.RESET}")
            for key in report['missing_keys'][:10]:
                print(f"    • {key}")
            if len(report['missing_keys']) > 10:
                print(f"    ... and {len(report['missing_keys']) - 10} more")
        
        if report['untranslated_keys']:
            print(f"\n  {Colors.YELLOW}Untranslated Keys:{Colors.RESET}")
            for key in report['untranslated_keys'][:10]:
                print(f"    • {key}")
            if len(report['untranslated_keys']) > 10:
                print(f"    ... and {len(report['untranslated_keys']) - 10} more")

def generate_markdown_report(reports: List[Dict[str, Any]], output_file: Path):
    """Generate a markdown report file."""
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"# Translation Status Report\n\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        
        # Summary table
        f.write("## Summary\n\n")
        f.write("| Language | Completion | Translated | Missing | Untranslated | Extra |\n")
        f.write("|----------|------------|------------|---------|--------------|-------|\n")
        
        for report in reports:
            lang = report['lang_code'].upper()
            rate = report['completion_rate']
            status = "✅" if rate >= 95 else "⚠️" if rate >= 80 else "❌"
            
            f.write(f"| {status} {lang} | {rate:.1f}% | ")
            f.write(f"{report['translated_keys']} | ")
            f.write(f"{len(report['missing_keys'])} | ")
            f.write(f"{len(report['untranslated_keys'])} | ")
            f.write(f"{len(report['extra_keys'])} |\n")
        
        # Detailed sections for incomplete languages
        incomplete = [r for r in reports if r['completion_rate'] < 100]
        if incomplete:
            f.write("\n## Languages Needing Attention\n\n")
            for report in incomplete:
                if report['missing_keys'] or report['untranslated_keys']:
                    lang = report['lang_code'].upper()
                    f.write(f"### {lang} ({report['completion_rate']:.1f}%)\n\n")
                    
                    if report['missing_keys']:
                        f.write("**Missing Keys:**\n")
                        for key in report['missing_keys'][:20]:
                            f.write(f"- `{key}`\n")
                        if len(report['missing_keys']) > 20:
                            f.write(f"- ... and {len(report['missing_keys']) - 20} more\n")
                        f.write("\n")
                    
                    if report['untranslated_keys']:
                        f.write("**Untranslated Keys:**\n")
                        for key in report['untranslated_keys'][:20]:
                            f.write(f"- `{key}`\n")
                        if len(report['untranslated_keys']) > 20:
                            f.write(f"- ... and {len(report['untranslated_keys']) - 20} more\n")
                        f.write("\n")

def main():
    parser = argparse.ArgumentParser(description='Check translation status of ARB files')
    parser.add_argument('--verbose', '-v', action='store_true',
                       help='Show detailed information about missing/untranslated keys')
    parser.add_argument('--lang', type=str,
                       help='Check only a specific language (e.g., ko, ja, zh)')
    parser.add_argument('--report', action='store_true',
                       help='Generate a markdown report file')
    parser.add_argument('--fix', action='store_true',
                       help='Show commands to fix issues')
    args = parser.parse_args()
    
    # Path to ARB files
    arb_dir = Path("sona_app/lib/l10n")
    if not arb_dir.exists():
        print(f"Error: ARB directory {arb_dir} does not exist")
        sys.exit(1)
    
    # Load English master file
    english_file = arb_dir / "app_en.arb"
    english_data = load_arb_file(english_file)
    if not english_data:
        print("Error: Could not load English ARB file")
        sys.exit(1)
    
    # Determine which languages to check
    if args.lang:
        languages = [args.lang.lower()]
    else:
        languages = ['ko', 'ja', 'zh', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'id', 'th', 'vi']
    
    # Analyze all language files
    reports = []
    total_missing = 0
    total_untranslated = 0
    
    print(f"{Colors.BOLD}{Colors.BLUE}🌍 Translation Status Report{Colors.RESET}")
    print(f"{Colors.BLUE}{'='*60}{Colors.RESET}")
    print(f"📖 Master file (English): {len(get_translation_keys(english_data))} keys")
    
    for lang in languages:
        arb_file = arb_dir / f"app_{lang}.arb"
        target_data = load_arb_file(arb_file)
        
        if not target_data:
            print(f"\n{Colors.RED}⚠️  Warning: {arb_file} not found or empty{Colors.RESET}")
            continue
        
        report = analyze_language_file(english_data, target_data, lang)
        reports.append(report)
        total_missing += len(report['missing_keys'])
        total_untranslated += len(report['untranslated_keys'])
        
        print_language_report(report, args.verbose)
    
    # Overall summary
    print(f"\n{Colors.BOLD}{Colors.CYAN}{'='*60}{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.CYAN}📊 Overall Summary{Colors.RESET}")
    print(f"{Colors.CYAN}{'='*60}{Colors.RESET}")
    
    fully_translated = sum(1 for r in reports if r['completion_rate'] >= 100)
    nearly_complete = sum(1 for r in reports if 95 <= r['completion_rate'] < 100)
    in_progress = sum(1 for r in reports if 0 < r['completion_rate'] < 95)
    
    print(f"  ✅ Fully translated: {fully_translated}/{len(reports)}")
    print(f"  🔄 Nearly complete (≥95%): {nearly_complete}/{len(reports)}")
    print(f"  ⚠️  In progress (<95%): {in_progress}/{len(reports)}")
    
    if total_missing > 0:
        print(f"  {Colors.RED}❌ Total missing keys: {total_missing}{Colors.RESET}")
    if total_untranslated > 0:
        print(f"  {Colors.YELLOW}⚠️  Total untranslated keys: {total_untranslated}{Colors.RESET}")
    
    # Generate markdown report if requested
    if args.report:
        report_file = Path("translation_status_report.md")
        generate_markdown_report(reports, report_file)
        print(f"\n📄 Detailed report saved to: {report_file}")
    
    # Show fix commands if requested
    if args.fix and (total_missing > 0 or total_untranslated > 0):
        print(f"\n{Colors.BOLD}{Colors.GREEN}🔧 How to Fix:{Colors.RESET}")
        
        if total_missing > 0:
            print(f"\n1. To add missing keys to all languages:")
            print(f"   {Colors.CYAN}python scripts/sync_arb_files.py{Colors.RESET}")
        
        if total_untranslated > 0:
            print(f"\n2. To find and translate TODO items:")
            print(f"   {Colors.CYAN}grep -r \"\\[TODO-\" sona_app/lib/l10n/{Colors.RESET}")
            print(f"\n3. After translating, regenerate files:")
            print(f"   {Colors.CYAN}cd sona_app && flutter gen-l10n{Colors.RESET}")
    
    # Exit with error code if not all languages are complete
    if total_missing > 0 or total_untranslated > 0:
        sys.exit(1)

if __name__ == "__main__":
    main()