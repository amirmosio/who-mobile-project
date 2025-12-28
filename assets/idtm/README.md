# IDTM Assets Directory

This directory contains all assets for the Interactive Digital Technical Manual (IDTM) feature.

## Structure

```
assets/idtm/
├── data/                      # JSON guide data
│   └── facilities.json       # Facility definitions with steps and components
├── images/
│   ├── 3d_views/            # 3D renderings of the facility
│   ├── exploded_view/       # Exploded view diagrams
│   ├── elevations/          # Front, side, back elevations
│   ├── panels/              # Panel details and specifications
│   └── components/          # Individual component images
└── README.md
```

## JSON Data Structure

The `facilities.json` file contains an array of facility objects. Each facility includes:

- **Basic Info**: id, name, description, manufacturer, version
- **Components**: List of all physical components with specifications
- **Steps**: Installation, maintenance, and dismantling steps organized by phase

### Phases

Steps are organized by the following phases:
- `initial` - Pre-installation (packing list verification)
- `installing` - Installation steps
- `maintenance` - Maintenance procedures
- `dismantling` - Dismantling and packing steps

## Image Extraction from PDF

To extract images from the IDTM PDF:

1. Open the PDF in Adobe Acrobat or similar tool
2. Export images at high resolution (300 DPI recommended)
3. Save images in the appropriate subdirectory
4. Update the `facilities.json` file with the correct image paths

### Image Naming Convention

- Use descriptive names: `front_elevation.png`, `exploded_view.png`
- Use lowercase with underscores
- Include page number if needed: `page_1_view_1.png`

## Current Status

**Sample Data**: The current `facilities.json` contains a complete sample structure for the Infectious Disease Treatment Centre facility based on the IDTM2024.pdf document.

**Images**: Placeholder paths are included. Actual images need to be extracted from the PDF and placed in the appropriate directories.

## Adding New Facilities

1. Extract images from the facility PDF
2. Add a new facility object to `facilities.json`
3. Ensure all image paths are correct
4. Run the app to verify the facility loads correctly

## Testing

To test asset loading:

```dart
final loader = IdtmAssetLoader();
final facilities = await loader.loadFacilities();
print('Loaded ${facilities.length} facilities');
```
