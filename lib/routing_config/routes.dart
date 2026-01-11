class YRRoutes {
  YRRoutes._privateConstructor();

  /// base pages
  static const initialLoading = "/initialLoading";
  static const unknown = "/unknown";

  static const login = "/login";
  static const register = "/register";
  static const resetPassword = "/reset-password";
  static const resetPasswordSuccess = "/reset-password-success";

  /// Admin pages
  static const adminLogin = "/admin/login";
  static const adminPanel = "/admin/panel";
  static const alertTemplates = "/admin/alert-templates";
  static const initializeMaintenanceAlerts = "/admin/initialize-maintenance-alerts";

  /// nav bar pages
  static const dashBoard = "/dashboard";
  static const comments = "/comments";
  static const blog = "/blog";
  static const profileMenu = "/menu-and-settings";

  /// IDTM pages
  static const idtmHome = "/idtm";
  static const whatIsIdtm = "/what-is-idtm";
  static const idtmFacilityList = "/idtm/facilities";
  static const idtmFacilityDetail = "/idtm/facility/:facilityId";
  static const idtmInstallationsList = "/idtm/installations";
  static const idtmCreateInstallation = "/idtm/create-installation/:facilityId";
  static const idtmInstallationDetail = "/idtm/installation/:installationId";
  static const idtmStepViewer = "/idtm/installation/:installationId/step/:stepId";
  static const idtmNotes = "/idtm/installation/:installationId/notes";
  static const idtmCreateNote = "/idtm/installation/:installationId/create-note";

  /// Installation Guide pages
  static const installationStepsList = "/installation-steps";
  static const installationStepDetail = "/installation-steps/:stepId";
  static const installationSubstepDetail = "/installation-steps/:stepId/substep/:substepId";

  /// Dismantling Guide pages
  static const dismantlingStepsList = "/dismantling-steps";
  static const dismantlingStepDetail = "/dismantling-steps/:stepId";
  static const dismantlingSubstepDetail = "/dismantling-steps/:stepId/substep/:substepId";

  /// Maintenance Guide pages
  static const maintenanceStepsList = "/maintenance-steps";
  static const maintenanceStepDetail = "/maintenance-steps/:stepId";
  static const maintenanceSubstepDetail = "/maintenance-steps/:stepId/substep/:substepId";

  /// Facility Use Guide pages
  static const facilityUseStepsList = "/facility-use-steps";
  static const facilityUseStepDetail = "/facility-use-steps/:stepId";
  static const facilityUseSubstepDetail = "/facility-use-steps/:stepId/substep/:substepId";

  /// Packing list pages
  static const idtmPackingList = "/idtm/packing-list";
  static const idtmMaintenance = "/idtm/maintenance/:installationId";
  static const idtmDismantling = "/idtm/dismantling/:installationId";
}

extension RouteData on String {
  String addDataTag(String data) {
    return "$this?data=$data";
  }
}
