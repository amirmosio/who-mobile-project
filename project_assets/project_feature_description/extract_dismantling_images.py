#!/usr/bin/env python3
"""
Extract images from IDTM Dismantling PDF
Focuses on pages 34-38 (dismantling-related content)
Based on dismantling_steps.json structure
"""

import fitz  # PyMuPDF
import os
from pathlib import Path

# Configuration
PDF_PATH = "/Volumes/CrucialSSD/Sem 5/who-mobile-project/project_assets/EN-MAN-AZF4-27-WFP_User_Manual_DRAFT01 (1).pdf"
OUTPUT_DIR = "/Volumes/CrucialSSD/Sem 5/who-mobile-project/assets/dismantelling_description/images"

# Dismantling-related pages (0-indexed for PyMuPDF)
# Based on dismantling_steps.json structure
PAGES_TO_EXTRACT = {
    # Pre-dismantling requirements (page 34)
    33: "34_pre_dismantling_requirements",

    # Electrical removal, cleaning, anchoring removal (page 34)
    # These share the same page but are different sections

    # Inner cabins removal (page 34, steps 3.0-4.0)

    # Vestibule disconnection and sun shadowing (page 35)
    34: "35_vestibule_sun_shadowing_removal",

    # Tent deflation (pages 36-37, steps 7.0-10.0)
    35: "36_tent_deflation_step_7-8",
    36: "37_tent_deflation_step_9-10",

    # Tent folding and packing (pages 37-38, steps 11.0-16.0)
    37: "38_tent_folding_packing",

    # Hard floor removal (reverse of page 16)
    15: "16_hard_floor_installation_reverse",

    # Storage preparation (pages 39-41, Section 4.1 PMI 5-8)
    38: "39_storage_preparation_1",
    39: "40_storage_preparation_2",
    40: "41_storage_preparation_3",
}

def extract_images_from_pdf():
    """Extract images from specific PDF pages for dismantling"""

    # Create output directory
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # Open PDF
    pdf_document = fitz.open(PDF_PATH)

    print(f"Processing {len(PAGES_TO_EXTRACT)} pages for dismantling...")
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
