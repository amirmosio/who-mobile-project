# who-mobile-project

Major features of the app:
- ~~Login (guest, admin) Firebase Authentication~~
- Packing list (automatic visual recognition of items) Kian
- Step by step installation Amir
- Maintenance instructions Amin
- ~~automatic alert Amin~~
- Furniture and equipment instruction Kian
- Dismantling and repacking Amir
- Facility use and functioning Amin
- Every user can leave notes after use (document damages, reparations etc for future users)


- ~~Login (guest, admin) Firebase Authentication~~
- "Add comment" only authenticated users
- "read comment" only authenticated users


Dashboard (Main Page):
The dashboard displays multiple cards to guide users through different stages:

1. **Installation Status Card**
   - Shows current installation status (Not Started, In Progress, Completed)
   - Provides action buttons based on status:
     - Not Started: "Start Installation"
     - In Progress: "Continue Installation" + progress indicator
     - Completed: Shows completion status

2. **Installation Guide Card**
   - Shows step-by-step installation guide
   - Tracks progress for each installation step
   - Allows navigation to detailed step instructions
   - Displays substeps with completion status

3. **IDTM Status Card**
   - Shows IDTM (Installation, Dismantling, Transportation, Maintenance) status
   - Displays available actions based on installation state

4. **IDTM Guide Card**
   - Provides access to IDTM documentation and guides:
     - Packing List (visual item recognition)
     - Installation Steps
     - Maintenance Instructions (with automatic alerts)
     - Dismantling and Repacking guide
   - Each section has dedicated navigation

Note: All cards refresh automatically when returning to the dashboard
