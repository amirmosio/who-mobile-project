# IDTM Installation Documentation

This directory contains comprehensive documentation and visual assets for the IDTM (Infectious Disease Treatment Module) installation process.

## Contents

### 📄 Documentation Files

1. **[Installation_Description.md](Installation_Description.md)**
   - Complete step-by-step installation guide
   - 8 major installation phases
   - Detailed procedures with PDF page references
   - Image references for each step
   - Mobile app implementation guide

2. **[IMAGE_MAPPING.md](IMAGE_MAPPING.md)**
   - Complete catalog of all extracted images
   - Organized by installation step
   - Image descriptions and purposes
   - Quick reference for finding specific images

### 📷 Images Directory

**Location**: `images/`

**Total Images**: 168 images extracted from 26 pages of the PDF manual

**Image Organization**:
- Images are named by PDF page and step number
- Format: `[page]_[section]_[description]_img[number].[ext]`
- Examples:
  - `16_hard_floor_installation_img4.jpeg`
  - `21_tent_inflation_step_14-15_img5.png`
  - `28_vestibules_step_11_img3.jpeg`

## Installation Steps Overview

### 1. Pre-Installation Requirements (Pages 13-14)
- **Images**: 5 images
- Required personnel, tools, climatic conditions, safety warnings

### 2. Installation Site Selection and Preparation (Page 15)
- Site assessment and preparation guidelines

### 3. Hard Floor Installation (Page 16)
- **Images**: 4 images
- Positioning floor tiles pallet, laying hard floor (17m x 8m)

### 4. Tents Inflation and Pressure Monitoring System (Pages 17-24)
- **Images**: 32+ images across 12 sub-steps
- Comprehensive tent deployment and inflation procedures
- Pressure monitoring system setup

### 5. Vestibules Inflation and Connection (Pages 25-29)
- **Images**: 19+ images across 6 sub-steps
- Vestibule deployment, inflation, connection, and anchoring

### 6. Installation of Inner Cabins (Pages 30-32)
- **Images**: 10+ images across 3 sub-steps
- Support bars, cabin liners, frame attachment

### 7. Electrical System Installation (Page 33)
- **Images**: 2 images
- Complete electrical diagram and component layout

### 8. Final Inspection and Completion
- Comprehensive installation verification checklist
- System activation procedures

## For Mobile App Development

### Image Usage

All images can be embedded in the mobile app to provide visual guidance during installation:

```dart
// Example: Display image for a specific step
Image.asset('assets/images/16_hard_floor_installation_img4.jpeg')
```

### Installation State Tracking

The documentation includes a mobile app implementation guide with:
- 8 trackable installation phases
- Per-tent state management structure
- Dashboard UI specifications
- Progress tracking guidelines

### Image-Step Mapping

Each installation step in `Installation_Description.md` includes:
- **📄 PDF Reference**: Original page numbers
- **📷 Step Images**: List of relevant images with descriptions

Example:
```markdown
### Step 4.8: Inflate Tents
**📄 PDF Step Reference**: Page 21, Steps 14.0-15.0

**📷 Step Images**:
- `images/21_tent_inflation_step_14-15_img4.jpeg` - Inflator ON, tent inflating
- `images/21_tent_inflation_step_14-15_img5.png` - Tent during inflation process
- `images/21_tent_inflation_step_14-15_img6.jpeg` - Fully inflated tent
```

## Source Material

**Original PDF**: `EN-MAN-AZF4-27-WFP_User_Manual_DRAFT01 (1).pdf`

**Extracted Pages**: 1, 7-10, 13-33 (installation-related content only)

## File Structure

```
installation_description/
├── Installation_Description.md    # Main installation guide
├── IMAGE_MAPPING.md               # Image catalog
├── README.md                      # This file
└── images/                        # Image directory (168 images)
    ├── 01_cover_idtm_general_view_*.png
    ├── 07_idtm_general_view_*.png
    ├── 08_idtm_exploded_view_*.png
    ├── 09_idtm_dimensions_1_*.png
    ├── 10_idtm_dimensions_2_*.png
    ├── 13_required_conditions_*.png
    ├── 14_safety_warnings_*.png
    ├── 15_site_preparation_*.png
    ├── 16_hard_floor_installation_*.png
    ├── 17_tent_inflation_step_1-2_*.*
    ├── 18_tent_inflation_step_3-7_*.*
    ├── ...
    ├── 30_inner_cabins_step_1_*.*
    ├── 31_inner_cabins_step_2-4_*.*
    ├── 32_inner_cabins_step_5-6_*.*
    └── 33_electrical_system_*.png
```

## Usage Guidelines

### For Developers
1. Reference `Installation_Description.md` for step-by-step procedures
2. Use `IMAGE_MAPPING.md` to find specific images for each step
3. Load images from `images/` directory in your mobile app assets

### For Content Updates
1. Extract new images using `extract_pdf_images.py` (located in parent directory)
2. Update `IMAGE_MAPPING.md` with new image descriptions
3. Run `update_md_with_images.py` to add references to the main document

### Image Format
- **PNG**: Diagrams, technical drawings, icons
- **JPEG**: Photographs of equipment and procedures

## Quick Reference

| Installation Phase | Image Count | PDF Pages |
|-------------------|-------------|-----------|
| System Overview | 15 images | 1, 7-10 |
| Pre-Installation | 5 images | 13-14 |
| Hard Floor | 4 images | 16 |
| Tent Inflation | 32 images | 17-24 |
| Vestibules | 19 images | 25-29 |
| Inner Cabins | 10 images | 30-32 |
| Electrical System | 2 images | 33 |
| **Total** | **168 images** | **26 pages** |

---

**Last Updated**: January 2026
**Source**: LANCO IDTM AZF4-27 User Manual
