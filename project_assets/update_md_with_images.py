#!/usr/bin/env python3
"""
Add image references to Installation_Description.md
"""

# Image mappings for each section
IMAGE_MAPPINGS = {
    "## Hard Floor Installation": """
**📷 Related Images**:
- `images/16_hard_floor_installation_img4.jpeg` - Pallet of floor tiles
- `images/16_hard_floor_installation_img6.jpeg` - Pallet placement diagram
- `images/16_hard_floor_installation_img8.jpeg` - Floor tile installation showing layout pattern
- `images/16_hard_floor_installation_img5.png` - Floor layout configuration (17m x 8m)
""",

    "### Step 4.1: Position Tent Bags": """
**📷 Step Images**:
- `images/17_tent_inflation_step_1-2_img5.jpeg` - Tent bags on pallet
- `images/17_tent_inflation_step_1-2_img8.jpeg` - Positioning bags on floor
- `images/17_tent_inflation_step_1-2_img9.jpeg` - Three bags positioned on hard floor
""",

    "### Step 4.2: Deploy Tents": """
**📷 Step Images**:
- `images/18_tent_inflation_step_3-7_img5.jpeg` - Opening tent bag
- `images/18_tent_inflation_step_3-7_img6.jpeg` - Rolling out tent
- `images/18_tent_inflation_step_3-7_img7.jpeg` - Unfolding tent, spreading by corner loops
""",

    "### Step 4.3: Locate Inflation Valves": """
**📷 Step Images**:
- `images/18_tent_inflation_step_3-7_img3.png` - Valve location on pneumatic arch
- `images/18_tent_inflation_step_3-7_img4.png` - Close-up of inflation valve and over-pressure valve
""",

    "### Step 4.4: Install Sun Shadowing Nets": """
**📷 Step Images**:
- `images/19_tent_inflation_step_8-9_img1.png` - Sun shadowing nets
- `images/19_tent_inflation_step_8-9_img2.png` - Pneumatic spacers
- `images/19_tent_inflation_step_8-9_img3.png` - Coupling connection detail
- `images/19_tent_inflation_step_8-9_img4.png` - Spacers installed on roof
- `images/19_tent_inflation_step_8-9_img5.png` - Net spread over tent
- `images/19_tent_inflation_step_8-9_img6.jpeg` - Complete sun shadowing installation
""",

    "### Step 4.5: Connect Electric Inflator": """
**📷 Step Images**:
- `images/19_tent_inflation_step_8-9_img7.png` - Electric inflator unit
- `images/20_tent_inflation_step_10-13_img1.png` - Inflator with manifold attached
- `images/20_tent_inflation_step_10-13_img5.jpeg` - Removing valve protective caps
""",

    "### Step 4.6: Prepare Valves for Inflation": """
**📷 Step Images**:
- `images/20_tent_inflation_step_10-13_img6.png` - Valve states diagram (CLOSED vs OPEN)
- `images/20_tent_inflation_step_10-13_img7.jpeg` - Closing valve by turning clockwise
- `images/20_tent_inflation_step_10-13_img8.jpeg` - Verifying valve is closed
""",

    "### Step 4.7: Connect Inflation Hoses": """
**📷 Step Images**:
- `images/20_tent_inflation_step_10-13_img4.png` - Connecting hose to valve
- `images/20_tent_inflation_step_10-13_img3.png` - Fastening screw ring
""",

    "### Step 4.8: Inflate Tents": """
**📷 Step Images**:
- `images/21_tent_inflation_step_14-15_img4.jpeg` - Inflator ON, tent inflating
- `images/21_tent_inflation_step_14-15_img5.png` - Tent during inflation process
- `images/21_tent_inflation_step_14-15_img6.jpeg` - Fully inflated tent
""",

    "### Step 4.9: Disconnect and Secure Valves": """
**📷 Step Images**:
- `images/22_tent_inflation_step_16-18_img3.jpeg` - Disconnecting inflation hoses
- `images/22_tent_inflation_step_16-18_img5.jpeg` - Screwing protective caps back on
- `images/22_tent_inflation_step_16-18_img7.jpeg` - Closing PVC protective flap
""",

    "### Step 4.10: Install Pressure Monitoring System": """
**📷 Step Images**:
- `images/22_tent_inflation_step_16-18_img1.png` - Pressure monitoring coupling on inflator
- `images/22_tent_inflation_step_16-18_img2.png` - Pressure feedback tube insertion
- `images/23_tent_inflation_step_19-23_img3.png` - Feedback tube routing into tent
- `images/23_tent_inflation_step_19-23_img5.jpeg` - Pressure feedback valve inside tent
- `images/23_tent_inflation_step_19-23_img6.png` - Connecting tap to feedback valve
""",

    "### Step 4.11: Enable Automatic Pressure Control": """
**📷 Step Images**:
- `images/23_tent_inflation_step_19-23_img7.png` - Inflator display showing AUTO mode and pressure reading
""",

    "### Step 4.12: Final Tent Positioning": """
**📷 Step Images**:
- `images/24_tent_inflation_step_24_img4.jpeg` - Pulling corners to straighten groundsheet
- `images/24_tent_inflation_step_24_img3.png` - Aligned tent with no folds
""",

    "### Step 5.1: Position Vestibule Bags": """
**📷 Step Images**:
- `images/25_vestibules_step_1-4_img5.jpeg` - Vestibule bags
- `images/25_vestibules_step_1-4_img7.jpeg` - Placing bags on hard floor
""",

    "### Step 5.2: Deploy Vestibules": """
**📷 Step Images**:
- `images/25_vestibules_step_1-4_img8.png` - Opening vestibule bag
- `images/25_vestibules_step_1-4_img9.png` - Rolling out vestibule
- `images/26_vestibules_step_5-7_img3.jpeg` - Unfolded vestibule
- `images/26_vestibules_step_5-7_img4.jpeg` - Spreading vestibule by corner loops
""",

    "### Step 5.3: Prepare Vestibule Valves": """
**📷 Step Images**:
- `images/26_vestibules_step_5-7_img5.png` - Removing valve protective caps
""",

    "### Step 5.4: Inflate Vestibules": """
**📷 Step Images**:
- `images/26_vestibules_step_5-7_img6.png` - Connecting inflator to vestibule
- `images/26_vestibules_step_5-7_img7.png` - Inflator ON
- `images/27_vestibules_step_8-10_img4.jpeg` - Vestibule inflating
- `images/27_vestibules_step_8-10_img5.jpeg` - Fully inflated vestibule
""",

    "### Step 5.5: Connect Vestibules to Main Tents": """
**📷 Step Images**:
- `images/28_vestibules_step_11_img3.jpeg` - Coupling system with double/single studs
- `images/28_vestibules_step_11_img5.jpeg` - Connecting with locking pin/bolt (step 1)
- `images/28_vestibules_step_11_img6.jpeg` - Connecting with locking pin/bolt (step 2)
- `images/28_vestibules_step_11_img7.jpeg` - Connecting with locking pin/bolt (step 3)
- `images/28_vestibules_step_11_img8.jpeg` - Completed connection
""",

    "### Step 5.6: Anchor Vestibules": """
**📷 Step Images**:
- `images/29_vestibules_step_12-13_img4.jpeg` - 30cm T-pegs for groundsheet loops
- `images/29_vestibules_step_12-13_img5.jpeg` - 50cm T-pegs for guy ropes
- `images/29_vestibules_step_12-13_img6.png` - Peg placement diagram showing distances
- `images/29_vestibules_step_12-13_img7.jpeg` - Cleat tensioner for guy rope adjustment
""",

    "### Step 6.1: Install Support Bars": """
**📷 Step Images**:
- `images/30_inner_cabins_step_1_img6.jpeg` - Support bar installation (patient pods: x4 bars)
- `images/30_inner_cabins_step_1_img8.jpeg` - Support bar installation (staff pod: x2 bars)
""",

    "### Step 6.2: Deploy Inner Cabin Liners": """
**📷 Step Images**:
- `images/31_inner_cabins_step_2-4_img6.jpeg` - Inner cabin bag
- `images/31_inner_cabins_step_2-4_img7.jpeg` - Unfolding inner cabin liner
""",

    "### Step 6.3: Attach Inner Cabins to Frame": """
**📷 Step Images**:
- `images/31_inner_cabins_step_2-4_img1.png` - Toggle button attachment method
- `images/31_inner_cabins_step_2-4_img2.png` - Connecting toggle buttons to plastic studs
- `images/32_inner_cabins_step_5-6_img4.jpeg` - Toggle button connection close-up
- `images/32_inner_cabins_step_5-6_img6.jpeg` - Completed inner cabin attachment
- `images/32_inner_cabins_step_5-6_img7.jpeg` - Interior view with all toggle buttons connected
""",

    "### Step 7.1: Electrical System Overview": """
**📷 Step Images**:
- `images/33_electrical_system_img2.png` - Complete electrical system diagram
- `images/33_electrical_system_img3.png` - Component list and wiring layout
"""
}

def add_images_to_markdown():
    """Add image references to the markdown file"""

    md_path = "/Volumes/CrucialSSD/Sem 5/who-mobile-project/project_assets/project_feature_description/installation_description/Installation_Description.md"

    with open(md_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Add image references after each section header
    for section_header, image_block in IMAGE_MAPPINGS.items():
        # Find the section and insert images after the header
        if section_header in content:
            # Insert after the header and any existing PDF reference
            lines = content.split('\n')
            new_lines = []
            i = 0
            while i < len(lines):
                new_lines.append(lines[i])

                if lines[i].startswith(section_header):
                    # Skip PDF reference line if it exists
                    if i + 1 < len(lines) and lines[i + 1].startswith('**📄 PDF'):
                        i += 1
                        new_lines.append(lines[i])

                    # Add image block if not already there
                    if i + 1 < len(lines) and not lines[i + 1].startswith('**📷'):
                        new_lines.append('')
                        new_lines.append(image_block.strip())

                i += 1

            content = '\n'.join(new_lines)

    # Write back
    with open(md_path, 'w', encoding='utf-8') as f:
        f.write(content)

    print("✅ Updated Installation_Description.md with image references")

if __name__ == "__main__":
    add_images_to_markdown()
