# IDTM Translation Guide

## Status

✅ **English (en)** - Complete translation file created: `idtm_translations_en.txt`

📋 **Pending**: Spanish (es), Italian (it), German (de), French (fr)

## How to Add IDTM Translations

### Step 1: Add to English ARB (intl_en.arb)

The file `idtm_translations_en.txt` contains all 56 IDTM translation keys in English.

**To integrate:**
1. Open `lib/l10n/intl_en.arb`
2. Before the closing `}` on line 1895, add a comma after the last entry
3. Copy the contents of `idtm_translations_en.txt`
4. Paste before the closing brace

### Step 2: Translate to Other Languages

For each language (es, it, de, fr), translate the following keys:

#### Core Features (10 keys)
- `idtm_guide` - "IDTM Guide"
- `facilities` - "Facilities"
- `installation_guide` - "Installation Guide"
- `maintenance_guide` - "Maintenance Guide"
- `dismantling_guide` - "Dismantling Guide"
- `packing_list` - "Packing List"
- `step_by_step` - "Step by Step"
- `current_phase` - "Current Phase"
- `progress_tracking` - "Progress Tracking"
- `specifications` - "Specifications"

#### Phase Labels (5 keys)
- `phase_initial` - "Not Started"
- `phase_installing` - "Installing"
- `phase_maintenance` - "Maintenance"
- `phase_dismantling` - "Dismantling"
- `phase_completed` - "Completed"

#### Actions (15 keys)
- `add_note` - "Add Note"
- `view_notes` - "View Notes"
- `next_step` - "Next Step"
- `previous_step` - "Previous Step"
- `mark_complete` - "Mark as Complete"
- `mark_incomplete` - "Mark as Incomplete"
- `create_installation` - "Create Installation"
- `verify_components` - "Verify Components"
- `add_photos` - "Add Photos"
- `delete_installation` - "Delete Installation"
- `delete_note` - "Delete Note"
- `edit_note` - "Edit Note"
- `start_new_installation` - "Start New Installation"
- `component_verified` - "Component Verified"
- `step_completed` - "Step Completed"

#### Labels (15 keys)
- `installation_location` - "Installation Location"
- `team_members` - "Team Members"
- `facility_name` - "Facility Name"
- `components` - "Components"
- `installation_steps` - "Installation Steps"
- `maintenance_tasks` - "Maintenance Tasks"
- `dismantling_steps` - "Dismantling Steps"
- `notes` - "Notes"
- `estimated_time` - "Estimated Time"
- `time_spent` - "Time Spent"
- `warnings` - "Warnings"
- `dependencies` - "Dependencies"
- `manufacturer` - "Manufacturer"
- `version` - "Version"
- `active_installations` - "Active Installations"
- `all_installations` - "All Installations"

#### Note Types (4 keys)
- `note_type_damage` - "Damage"
- `note_type_repair` - "Repair"
- `note_type_observation` - "Observation"
- `note_type_warning` - "Warning"

#### Severity Levels (4 keys)
- `severity_low` - "Low"
- `severity_medium` - "Medium"
- `severity_high` - "High"
- `severity_critical` - "Critical"

#### Messages (8 keys)
- `loading_facilities` - "Loading facilities..."
- `loading_guide` - "Loading guide..."
- `loading_progress` - "Loading progress..."
- `installation_created` - "Installation created successfully"
- `installation_deleted` - "Installation deleted"
- `transitioned_to_next_phase` - "Transitioned to next phase"
- `no_facilities_available` - "No facilities available"
- `no_installations` - "No installations"
- `delete_installation_confirmation` - "Are you sure you want to delete this installation? This action cannot be undone."
- `note_saved` - "Note saved"
- `note_deleted` - "Note deleted"

### Step 3: Run Code Generation

After updating all ARB files:

```bash
flutter gen-l10n
```

This generates the Dart localization classes.

## Quick Translation Template

For translators, use this format:

```json
  "idtm_guide": "[TRANSLATION]",
  "@idtm_guide": {"description": "Title for IDTM guide feature"}
```

## Professional Translation Services

For production use, consider:
1. Using professional translation services for technical accuracy
2. Having native speakers review medical/technical terminology
3. Testing with actual field users in each language region

## Total Translation Keys

**56 new keys** need to be added to each of 5 language files:
- ✅ English (en) - Ready
- ⏳ Spanish (es) - Pending
- ⏳ Italian (it) - Pending
- ⏳ German (de) - Pending
- ⏳ French (fr) - Pending

## Current Implementation

The English translations have been prepared and are ready to be integrated. The app will work with English translations immediately. Other languages can be added incrementally as they are completed.
