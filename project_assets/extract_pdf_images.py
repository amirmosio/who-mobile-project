#!/usr/bin/env python3
"""
Script to extract images from the IDTM User Manual PDF for the Facility Use feature.
Extracts images from Sections 2, 3.1, 3.2, and 3.3.
"""

import fitz  # PyMuPDF
import os
from PIL import Image
import io

# Paths
PDF_PATH = "/Users/mohammadaminrahimi/Desktop/Project/Android/uni/who-mobile-project/project_assets/EN-MAN-AZF4-27-WFP_User_Manual_DRAFT01 (1).pdf"
OUTPUT_DIR = "/Users/mohammadaminrahimi/Desktop/Project/Android/uni/who-mobile-project/assets/facility_use_description/images"

# Create output directory if it doesn't exist
os.makedirs(OUTPUT_DIR, exist_ok=True)

def extract_images_from_pdf():
    """Extract all images from the PDF and save them."""
    doc = fitz.open(PDF_PATH)

    print(f"PDF has {len(doc)} pages")
    print(f"Extracting images to: {OUTPUT_DIR}")
    print("-" * 50)

    image_count = 0

    # We need sections 2, 3.1, 3.2, 3.3 which are typically pages 5-15 in IDTM manuals
    # Let's extract from all pages to be safe and then filter
    for page_num in range(len(doc)):
        page = doc[page_num]
        image_list = page.get_images(full=True)

        if image_list:
            print(f"\nPage {page_num + 1}: Found {len(image_list)} image(s)")

        for img_index, img_info in enumerate(image_list):
            xref = img_info[0]  # Image XREF

            try:
                # Extract image
                base_image = doc.extract_image(xref)
                image_bytes = base_image["image"]
                image_ext = base_image["ext"]
                width = base_image["width"]
                height = base_image["height"]

                # Skip very small images (likely icons or artifacts)
                if width < 50 or height < 50:
                    print(f"  Skipping small image ({width}x{height})")
                    continue

                # Create filename
                image_count += 1
                filename = f"page{page_num + 1:02d}_img{img_index + 1:02d}_{width}x{height}.png"
                filepath = os.path.join(OUTPUT_DIR, filename)

                # Convert to PNG using PIL for consistency
                img = Image.open(io.BytesIO(image_bytes))

                # Convert to RGB if necessary (some PDFs have CMYK images)
                if img.mode in ('RGBA', 'LA') or (img.mode == 'P' and 'transparency' in img.info):
                    # Keep alpha for transparent images
                    img = img.convert('RGBA')
                elif img.mode != 'RGB':
                    img = img.convert('RGB')

                # Save as PNG
                img.save(filepath, 'PNG', optimize=True)

                print(f"  Saved: {filename} ({width}x{height})")

            except Exception as e:
                print(f"  Error extracting image {img_index}: {e}")

    doc.close()
    print("\n" + "=" * 50)
    print(f"Total images extracted: {image_count}")
    print(f"Output directory: {OUTPUT_DIR}")

    return image_count

def render_pages_as_images():
    """
    Render specific PDF pages as high-quality images.
    This is useful when images are embedded in complex vector graphics.
    """
    doc = fitz.open(PDF_PATH)

    # Pages to render (0-indexed) - focusing on sections 2, 3.1, 3.2, 3.3
    # Typically these are around pages 5-15, but let's render pages 4-20 to be safe
    pages_to_render = list(range(4, min(25, len(doc))))

    print(f"\nRendering {len(pages_to_render)} pages as full-page images...")
    print("-" * 50)

    for page_num in pages_to_render:
        page = doc[page_num]

        # Render at 2x zoom for higher quality
        zoom = 2.0
        mat = fitz.Matrix(zoom, zoom)
        pix = page.get_pixmap(matrix=mat)

        # Save as PNG
        filename = f"fullpage_{page_num + 1:02d}.png"
        filepath = os.path.join(OUTPUT_DIR, filename)
        pix.save(filepath)

        print(f"  Saved: {filename} ({pix.width}x{pix.height})")

    doc.close()
    print(f"\nRendered {len(pages_to_render)} pages")

if __name__ == "__main__":
    print("=" * 50)
    print("IDTM PDF Image Extractor")
    print("=" * 50)

    # First, extract embedded images
    print("\n[Step 1] Extracting embedded images...")
    count = extract_images_from_pdf()

    # If we didn't get many images, also render pages
    if count < 10:
        print("\n[Step 2] Rendering full pages as images...")
        print("(This captures diagrams that may be vector graphics)")
        render_pages_as_images()

    print("\n" + "=" * 50)
    print("DONE! Check the output directory for extracted images.")
    print(f"Output: {OUTPUT_DIR}")
    print("=" * 50)
