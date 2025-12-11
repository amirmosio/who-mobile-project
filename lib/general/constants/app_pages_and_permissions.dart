enum SidebarPage {
  dashboard,
  callHistory,
  voiceCalls,
  reservations,
  integrations,
  payments,
  businessInfo,
  details,
  location,
  hours,
  contacts,
  usersRoles,
  systemSettings,
  aiSettings,
  aiInstructions,
}

extension SidebarPageExtension on SidebarPage {
  String get id {
    switch (this) {
      case SidebarPage.dashboard:
        return 'dashboard';
      case SidebarPage.callHistory:
        return 'calls';
      case SidebarPage.voiceCalls:
        return 'voice_call';
      case SidebarPage.reservations:
        return 'reservations';
      case SidebarPage.integrations:
        return 'integrations';
      case SidebarPage.payments:
        return 'plans';
      case SidebarPage.businessInfo:
        return 'business_info';
      case SidebarPage.details:
        return 'details';
      case SidebarPage.location:
        return 'place';
      case SidebarPage.hours:
        return 'time';
      case SidebarPage.contacts:
        return 'contacts';
      case SidebarPage.usersRoles:
        return 'roles';
      case SidebarPage.systemSettings:
        return 'system_settings';
      case SidebarPage.aiSettings:
        return 'ai';
      case SidebarPage.aiInstructions:
        return 'ai-instructions';
    }
  }

  String get label {
    switch (this) {
      case SidebarPage.dashboard:
        return 'Dashboard';
      case SidebarPage.callHistory:
        return 'Storico chiamate';
      case SidebarPage.voiceCalls:
        return 'Chiamate';
      case SidebarPage.reservations:
        return 'Prenotazioni';
      case SidebarPage.integrations:
        return 'Integrazioni';
      case SidebarPage.payments:
        return 'Pagamenti e piani';
      case SidebarPage.businessInfo:
        return 'Informazioni attività';
      case SidebarPage.details:
        return 'Dettagli';
      case SidebarPage.location:
        return 'Luogo';
      case SidebarPage.hours:
        return 'Orari';
      case SidebarPage.contacts:
        return 'Rubrica';
      case SidebarPage.usersRoles:
        return 'Utenti e Ruoli';
      case SidebarPage.systemSettings:
        return 'Impostazioni sistema';
      case SidebarPage.aiSettings:
        return 'AI';
      case SidebarPage.aiInstructions:
        return 'Istruzioni AI';
    }
  }
}
