#!/usr/bin/env python3
"""
Extract images from IDTM Installation PDF
Focuses on pages 1, 7-9, 13-33 (installation-related content)
"""

import fitz  # PyMuPDF
import os
from pathlib import Path

# Configuration
PDF_PATH = "/Volumes/CrucialSSD/Sem 5/who-mobile-project/project_assets/EN-MAN-AZF4-27-WFP_User_Manual_DRAFT01 (1).pdf"
OUTPUT_DIR = "/Volumes/CrucialSSD/Sem 5/who-mobile-project/project_assets/project_feature_description/installation_description/images"

# Installation-related pages (0-indexed for PyMuPDF)
PAGES_TO_EXTRACT = {
    # Cover and overview
    0: "01_cover_idtm_general_view",
    6: "07_idtm_general_view",
    7: "08_idtm_exploded_view",
    8: "09_idtm_dimensions_1",
    9: "10_idtm_dimensions_2",

    # Pre-installation (pages 13-14)
    12: "13_required_conditions",
    13: "14_safety_warnings",

    # Site preparation (page 15)
    14: "15_site_preparation",

    # Hard floor installation (page 16)
    15: "16_hard_floor_installation",

    # Tent inflation (pages 17-24)
    16: "17_tent_inflation_step_1-2",
    17: "18_tent_inflation_step_3-7",
    18: "19_tent_inflation_step_8-9",
    19: "20_tent_inflation_step_10-13",
    20: "21_tent_inflation_step_14-15",
    21: "22_tent_inflation_step_16-18",
    22: "23_tent_inflation_step_19-23",
    23: "24_tent_inflation_step_24",

    # Vestibules (pages 25-29)
    24: "25_vestibules_step_1-4",
    25: "26_vestibules_step_5-7",
    26: "27_vestibules_step_8-10",
    27: "28_vestibules_step_11",
    28: "29_vestibules_step_12-13",

    # Inner cabins (pages 30-32)
    29: "30_inner_cabins_step_1",
    30: "31_inner_cabins_step_2-4",
    31: "32_inner_cabins_step_5-6",

    # Electrical system (page 33)
    32: "33_electrical_system",
}

def extract_images_from_pdf():
    """Extract images from specific PDF pages"""

    # Create output directory
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # Open PDF
    pdf_document = fitz.open(PDF_PATH)

    print(f"Processing {len(PAGES_TO_EXTRACT)} pages...")
    image_count = 0

    for page_num, page_name in PAGES_TO_EXTRACT.items():
        if page_num >= len(pdf_document):
            print(f"⚠️  Page {page_num + 1} not found in PDF")
            continue

        page = pdf_document[page_num]

        # Get images from page
        image_list = page.get_images()

        if not image_list:
            print(f"Page {page_num + 1}: No images found")
            # Still save page as image for diagrams/text
            pix = page.get_pixmap(dpi=150)
            output_path = os.path.join(OUTPUT_DIR, f"{page_name}.png")
            pix.save(output_path)
            print(f"✓ Saved page render: {page_name}.png")
            image_count += 1
        else:
            # Extract each image
            for img_index, img in enumerate(image_list):
                xref = img[0]
                base_image = pdf_document.extract_image(xref)
                image_bytes = base_image["image"]
                image_ext = base_image["ext"]

                # Save image
                if len(image_list) == 1:
                    output_path = os.path.join(OUTPUT_DIR, f"{page_name}.{image_ext}")
                else:
                    output_path = os.path.join(OUTPUT_DIR, f"{page_name}_img{img_index + 1}.{image_ext}")

                with open(output_path, "wb") as image_file:
                    image_file.write(image_bytes)

                print(f"✓ Extracted: {os.path.basename(output_path)}")
                image_count += 1

    pdf_document.close()
    print(f"\n✅ Extraction complete: {image_count} images saved to {OUTPUT_DIR}")
    return image_count

if __name__ == "__main__":
    extract_images_from_pdf()
