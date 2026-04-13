// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get emailRequired => 'Ingresa tu correo electrónico';

  @override
  String get enterValidEmail => 'Ingresa un correo electrónico válido';

  @override
  String get passwordRequired => 'Ingresa tu contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String signInFailed(String error) {
    return 'Error al iniciar sesión: $error';
  }

  @override
  String get apiEndpointNotFoundHint =>
      'El servidor no encontró la API (404). Usa la raíz del sitio sin «/api» al final; la app llama a /api/app/login sola. Si Laravel está en una subcarpeta, incluye la ruta hasta public (p. ej. https://example.com/myapp/public).';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsLoadFailed =>
      'No se pudieron cargar las notificaciones. Inténtalo de nuevo.';

  @override
  String get notificationsEmpty => 'Aún no hay notificaciones.';

  @override
  String get notificationsNewMark => 'Nuevo';

  @override
  String get notificationDetailsTitle => 'Notificación';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get name => 'Nombre';

  @override
  String get nameRequired => 'Ingresa tu nombre';

  @override
  String get phone => 'Teléfono';

  @override
  String get phoneRequired => 'Ingresa tu teléfono';

  @override
  String get phoneMustStartWithPlus => 'El teléfono debe comenzar con +';

  @override
  String get enterValidPhone => 'Ingresa un número de teléfono válido';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get atLeast8Chars => 'Al menos 8 caracteres';

  @override
  String get backToSignIn => 'Volver a iniciar sesión';

  @override
  String registrationFailed(String error) {
    return 'Error al registrarse: $error';
  }

  @override
  String get account => 'Cuenta';

  @override
  String get editInfo => 'EDITAR INFORMACIÓN';

  @override
  String get fullName => 'Nombre';

  @override
  String get retry => 'Reintentar';

  @override
  String get accountSettings => 'Configuración de la cuenta';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirmTitle => '¿Eliminar cuenta?';

  @override
  String get deleteAccountConfirmMessage =>
      '¿Seguro que quieres eliminar tu cuenta de forma permanente? Esta acción no se puede deshacer.';

  @override
  String get deleteAccountSecondTitle => 'Qué se eliminará';

  @override
  String get deleteAccountSecondMessage =>
      'Se eliminará de forma permanente de nuestros sistemas:\n\n• Tu cuenta y perfil\n• Todos los niños vinculados a tu cuenta\n• Todas las asignaciones a eventos, progreso en etapas, entradas y comidas\n• Fotos y demás datos de los niños\n• Tu acceso a chats de eventos y notificaciones en la app\n\nAlgunos registros de pago o contables pueden conservarse cuando lo exija la ley.';

  @override
  String get deleteAccountContinue => 'Continuar';

  @override
  String get deleteAccountConfirmAction => 'Eliminar para siempre';

  @override
  String get deleteAccountWorking => 'Eliminando cuenta…';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get role => 'Rol';

  @override
  String get myChildren => 'Mis hijos';

  @override
  String get addChild => 'Agregar hijo';

  @override
  String get noChildrenAddedYet => 'Aún no has agregado hijos';

  @override
  String get ageLabel => 'Edad';

  @override
  String get settings => 'Configuración';

  @override
  String get aboutTheApp => 'Acerca de la app';

  @override
  String get aboutAppDisplayName => 'YoungFashionShow';

  @override
  String get aboutPublisherLine => 'YOUNGFASHIONSHOW';

  @override
  String get aboutVersionLabel => 'VERSIÓN';

  @override
  String get aboutReleaseDateLabel => 'FECHA DE LANZAMIENTO';

  @override
  String get aboutDevelopedByPrefix => 'Desarrollado por:';

  @override
  String get aboutDeveloperBrand => 'OWLSOLUTIONS';

  @override
  String get aboutLinkCouldNotOpen => 'No se pudo abrir el enlace.';

  @override
  String get appLanguage => 'Idioma de la app';

  @override
  String get unitsOfMeasurement => 'Unidades de medida';

  @override
  String get metricUnits => 'Métrico (cm, kg)';

  @override
  String get imperialUnits => 'Americano (in, lb)';

  @override
  String get systemLanguage => 'Sistema';

  @override
  String get languageRussian => 'Ruso';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageUkrainian => 'Ucraniano';

  @override
  String get languageSpanishUS => 'Español (EE. UU.)';

  @override
  String get addChildTitle => 'Agregar hijo';

  @override
  String get firstName => 'Nombre';

  @override
  String get gender => 'Género';

  @override
  String get genderBoy => 'Niño';

  @override
  String get genderGirl => 'Niña';

  @override
  String get lastName => 'Apellido';

  @override
  String get birthdate => 'Fecha de nacimiento';

  @override
  String get chooseDate => 'Elige la fecha';

  @override
  String get create => 'Crear';

  @override
  String get enterFirstName => 'Ingresa el nombre';

  @override
  String get mainPhoto => 'Foto principal';

  @override
  String get changePhoto => 'Cambiar';

  @override
  String get deletePhoto => 'Eliminar';

  @override
  String get addPhoto => 'Agregar foto';

  @override
  String get photoSaved => 'Foto guardada';

  @override
  String get photoDeleted => 'Foto eliminada';

  @override
  String get photoAdded => 'Foto agregada';

  @override
  String get extraPhotos => 'Fotos adicionales';

  @override
  String get cancel => 'Cancelar';

  @override
  String get clear => 'Limpiar';

  @override
  String get height => 'Estatura';

  @override
  String get weight => 'Peso';

  @override
  String get shoulders => 'Hombros';

  @override
  String get chest => 'Pecho';

  @override
  String get waist => 'Cintura';

  @override
  String get hips => 'Caderas';

  @override
  String get measurementLengthUnitCm => 'cm';

  @override
  String get measurementLengthUnitIn => 'in';

  @override
  String get currentParticipation => 'Participación actual';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String model(String name) {
    return 'Modelo: $name';
  }

  @override
  String get active => 'ACTIVO';

  @override
  String get journeyProgress => 'PROGRESO';

  @override
  String get journeyPreparationPhase => 'FASE DE PREPARACIÓN';

  @override
  String get journeyMainEventTitle => 'EVENTO PRINCIPAL';

  @override
  String get journeyMainEventSubtitle => 'EXCLUSIVO PASARELA';

  @override
  String stepOf(int completed, int total) {
    return 'Paso $completed de $total';
  }

  @override
  String next(String text) {
    return 'Siguiente: $text';
  }

  @override
  String get viewProgress => 'VER PROGRESO';

  @override
  String get eventSettings => 'AJUSTES DEL EVENTO';

  @override
  String get homeEventCardMyEvent => 'MI EVENTO';

  @override
  String get homeEventCardRunwayJourney => 'RECORRIDO DE PASARELA';

  @override
  String get eventSettingsPlaceholder =>
      'Pronto verás aquí los ajustes del evento.';

  @override
  String get eventSettingsConfigurationPortal => 'PORTAL DE CONFIGURACIÓN';

  @override
  String get eventSettingsMainHeadline => 'Ajustes del evento';

  @override
  String get eventSettingsMealTitle => 'Selección de comidas';

  @override
  String get eventSettingsMealSubtitle =>
      'Elige un plato para el evento actual';

  @override
  String get eventSettingsMealCta => 'GESTIONAR MENÚ';

  @override
  String get eventSettingsRehearsalTitle => 'Reserva de ensayo';

  @override
  String get eventSettingsRehearsalSubtitle =>
      'Reserva tu plaza para el ensayo';

  @override
  String get eventSettingsRehearsalCta => 'RESERVAR';

  @override
  String get rehearsalModalTitle => 'Reserva de ensayo';

  @override
  String get rehearsalSelectDate => 'Elige fecha';

  @override
  String get rehearsalAvailableSlots => 'Horarios disponibles';

  @override
  String get rehearsalFreeLabel => 'Libres:';

  @override
  String get rehearsalNoSlotsConfigured =>
      'Aún no hay franjas de ensayo para este evento.';

  @override
  String get rehearsalLoadError =>
      'No se pudieron cargar las franjas. Inténtalo de nuevo.';

  @override
  String get rehearsalBrandNotAssigned =>
      'No hay marca asignada para este niño. La reserva de ensayos no está disponible.';

  @override
  String get rehearsalFull => 'Completo';

  @override
  String get rehearsalConfirmBooking => 'Confirmar reserva';

  @override
  String get rehearsalBookingFooterNote =>
      'Si es posible, cambia con 24 h de antelación.';

  @override
  String get rehearsalBookedTitle => 'Ensayo reservado';

  @override
  String get rehearsalChangeBooking => 'Cambiar reserva';

  @override
  String get rehearsalProgramLabel => 'Descripción';

  @override
  String get rehearsalArriveEarly => 'Llega 15 minutos antes.';

  @override
  String get rehearsalBookingSaved => 'Reserva guardada';

  @override
  String get rehearsalBookingError => 'No se pudo completar la reserva.';

  @override
  String get rehearsalSelectChild => 'Niño/a';

  @override
  String get rehearsalUpdateBooking => 'Actualizar reserva';

  @override
  String get rehearsalCancelChange => 'Cancelar';

  @override
  String get rehearsalChangeBookingLockedHint =>
      'El organizador cerró los cambios de reserva. Contacta soporte si necesitas ayuda.';

  @override
  String get rehearsalMilestoneTitle => 'Ensayo general';

  @override
  String rehearsalBrandMilestoneTitle(String brandName) {
    return 'Ensayo de marca: $brandName';
  }

  @override
  String get rehearsalBrandMilestoneShort => 'Ensayo de marca';

  @override
  String get rehearsalNextBookHint =>
      'Reserva tu ensayo en Ajustes del evento.';

  @override
  String get eventSettingsPackingTitle => 'Lista «No olvides»';

  @override
  String get eventSettingsPackingSubtitle => '';

  @override
  String get eventSettingsPackingCta => 'VER LISTA';

  @override
  String get eventPackingLoadFailed =>
      'No se pudo cargar la información. Inténtalo de nuevo.';

  @override
  String get eventPackingEmpty =>
      'Aún no se añadió información para este evento.';

  @override
  String get eventDescriptionTitle => 'Información del evento';

  @override
  String get eventProgressShowGallery => 'Galería';

  @override
  String get eventProgressCheckin => 'Check-in';

  @override
  String get eventProgressCheckinPrompt => 'Escanea para iniciar el evento';

  @override
  String get eventProgressCheckinUnavailable =>
      'El código de check-in aún no está disponible.';

  @override
  String get eventDescriptionLoadFailed =>
      'No se pudo cargar la descripción. Inténtalo de nuevo.';

  @override
  String get eventDescriptionEmpty =>
      'Aún no hay descripción de texto para este evento.';

  @override
  String get eventSettingsBrandTitle => 'Requisitos de marca';

  @override
  String get eventSettingsBrandSubtitle =>
      'Consulta las recomendaciones de la marca para participar en el evento';

  @override
  String get eventSettingsBrandCta => 'VER GUÍAS';

  @override
  String get brandRequirementsLoadFailed =>
      'No se pudieron cargar los requisitos de marca. Inténtalo de nuevo.';

  @override
  String get brandRequirementsEmpty =>
      'Aún no se añadieron requisitos de marca para este evento.';

  @override
  String get brandRequirementsEmptyItem =>
      'Aún no se añadió texto de requisitos para esta marca.';

  @override
  String get brandRequirementsPickBrandTitle => 'Elige una marca';

  @override
  String brandRequirementsBrandNumber(int brandId) {
    return 'Marca $brandId';
  }

  @override
  String get eventSettingsChatTitle => 'Chat grupal';

  @override
  String get eventSettingsChatSubtitle =>
      'Chat grupal con participantes del grupo y managers';

  @override
  String get eventSettingsChatCta => 'ABRIR CHAT';

  @override
  String get chatRoomsLoadFailed =>
      'No se pudieron cargar las salas de chat. Inténtalo de nuevo.';

  @override
  String get chatNoRooms =>
      'Aún no hay salas de chat para tus marcas en este evento.';

  @override
  String get chatNoMessagesYet => 'Sin mensajes todavía';

  @override
  String get chatLoadFailed =>
      'No se pudieron cargar los mensajes. Inténtalo de nuevo.';

  @override
  String get chatSendFailed =>
      'No se pudo enviar el mensaje. Inténtalo de nuevo.';

  @override
  String get chatMessagePlaceholder => 'Mensaje al grupo...';

  @override
  String get chatReply => 'Responder';

  @override
  String get chatReplyCancel => 'Cancelar';

  @override
  String chatReplyingTo(String name) {
    return 'Respondiendo a $name';
  }

  @override
  String get chatReplyPreviewPhoto => 'Foto';

  @override
  String eventSettingsChatMoreParticipants(int count) {
    return '+$count';
  }

  @override
  String get mealChoiceTitle => 'Elegir comida';

  @override
  String get mealSelectChildLabel => 'Niño/a';

  @override
  String get mealSelectDishLabel => 'Plato';

  @override
  String get mealSave => 'PEDIR';

  @override
  String get mealNoMealsConfigured => 'Aún no hay platos para este evento.';

  @override
  String get mealSaved => 'Guardado';

  @override
  String get mealSaveError => 'No se pudo guardar. Inténtalo de nuevo.';

  @override
  String get mealOrdersClosed => 'El plazo para elegir el menú está cerrado';

  @override
  String get mealPaid => 'Pagado';

  @override
  String get mealPaidDetail => 'El menú de este evento está pagado.';

  @override
  String get mealPayInBrowser =>
      'Completa el pago en el navegador y vuelve a la app.';

  @override
  String get mealCheckoutError =>
      'No se pudo iniciar el pago. Inténtalo de nuevo.';

  @override
  String get mealAwaitingPayment => 'Pedido registrado — pendiente de pago';

  @override
  String get mealAwaitingPaymentDetail =>
      'Tu plato está guardado. Termina el pago en el navegador; el estado se actualizará cuando Stripe lo confirme.';

  @override
  String get noActiveEvents => 'No hay eventos activos';

  @override
  String get becomeModelTitle => 'Comienza la carrera de modelo de tu hijo hoy';

  @override
  String get becomeAModel => 'SER MODELO';

  @override
  String get latestHighlights => 'Últimos destacados';

  @override
  String get viewAll => 'VER TODO';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get fillOutApplication => 'Completar\nsolicitud';

  @override
  String get upcomingShows => 'Próximos\nshows';

  @override
  String get manageKids => 'Mis\nhijos';

  @override
  String get navHome => 'Inicio';

  @override
  String get navEvents => 'Eventos';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navInfo => 'Información';

  @override
  String get continueButton => 'Continuar';

  @override
  String get loading => 'Cargando...';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get tokenValidNext => 'Sesión válida. Siguiente: Inicio.';

  @override
  String get homePageTitle => 'Inicio';

  @override
  String youAreSignedIn(String name) {
    return 'Has iniciado sesión$name.';
  }

  @override
  String yourRole(String role) {
    return 'Tu rol: $role';
  }

  @override
  String get phoneHint => '+1234567890';

  @override
  String get enterValidEmailShort => 'Ingresa un correo válido';

  @override
  String get phoneMustStartWithPlusShort => 'El teléfono debe comenzar con +';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get hello => 'Hola';

  @override
  String helloName(String name) {
    return 'Hola, $name';
  }

  @override
  String get noRolesAssigned =>
      'Aún no tienes roles asignados. Contacta a la administración.';

  @override
  String signedInAs(String name) {
    return 'Sesión iniciada como $name';
  }

  @override
  String get staff => 'Personal';

  @override
  String get birthdateDialogTitle => 'Fecha de nacimiento';

  @override
  String get nextShowsTitle => 'Próximos shows';

  @override
  String get nextShowsSeason => 'Temporada 2026';

  @override
  String get details => 'Detalles';

  @override
  String get contact => 'Contacto';

  @override
  String get registrationOpen => 'Registro abierto';

  @override
  String get myTicketsButton => 'MIS ENTRADAS';

  @override
  String get myTicketsTitle => 'Mis entradas';

  @override
  String get selectEventForTickets => 'Selecciona el evento';

  @override
  String get ticketsMomName => 'Nombre del padre/madre';

  @override
  String get ticketsEventDate => 'Fecha';

  @override
  String get ticketsOpenPdf => 'ABRIR';

  @override
  String get ticketsPdfUnavailable => 'PDF aún no disponible';

  @override
  String get ticketsBuy => 'COMPRAR ENTRADA';

  @override
  String get ticketsBuyNoLink =>
      'No hay enlace de compra. Añade la URL de la tienda de entradas para este evento en el admin o en la web en Info.';

  @override
  String get ticketsBuyCouldNotOpen => 'No se pudo abrir el enlace.';

  @override
  String get ticketsBuySubtitle => 'Asientos VIP y estándar disponibles';

  @override
  String get ticketsNoEvents => 'Aún no hay eventos con entradas';

  @override
  String get ticketsNoneForEvent => 'No hay entradas para este evento';

  @override
  String get ticketsLoadError => 'No se pudieron cargar las entradas';

  @override
  String get ticketsEventsLoadError => 'No se pudieron cargar los eventos';

  @override
  String get faqBrandCatalogTitle => 'Marcas de ropa';

  @override
  String get pdfViewerTitle => 'Entrada';

  @override
  String get contactFormLinkMissing =>
      'No hay enlace al formulario. Añade la URL en Ajustes generales de la app en el panel.';

  @override
  String get infoHubTitle => 'Centro de información';

  @override
  String get infoMenuAboutYfs => 'Acerca de YFS';

  @override
  String get infoMenuGeneralFaq => 'FAQ general';

  @override
  String get infoMenuContactManager => 'Contactar al gestor';

  @override
  String get infoFooterBrand => 'YFS';

  @override
  String get infoFooterCopyright =>
      '© 2024 Young Fashion Series. Todos los derechos reservados.';

  @override
  String parentProgressLabel(int completed, int total) {
    return 'Progreso del padre/madre: $completed/$total';
  }

  @override
  String get appUpdateRequiredMessage =>
      'Actualiza la aplicación para continuar.';

  @override
  String get appUpdateButton => 'Actualizar aplicación';

  @override
  String get showAll => 'Ver todo';

  @override
  String get staffNoneSelected => '— Ninguno —';

  @override
  String get staffRoleInactive => 'INACTIVA';

  @override
  String get staffWorkerStatusRefreshFailed =>
      'No se pudo actualizar el estado del rol. Comprueba la conexión.';

  @override
  String get staffScanRoleInactive =>
      'Este rol fue desactivado en el panel. El escaneo no está disponible.';

  @override
  String staffScanFailed(String error) {
    return 'Error al escanear: $error';
  }

  @override
  String get staffScanSelectEventStageFirst =>
      'Selecciona el evento y la etapa activos en Ajustes del personal antes de escanear.';

  @override
  String get staffScanProcessed => 'Escaneo procesado';

  @override
  String get chatCouldNotPickPhoto => 'No se pudo elegir la foto';

  @override
  String get staffChildProfileTitle => 'Perfil del niño';

  @override
  String get staffCurrentStage => 'ETAPA ACTUAL';

  @override
  String staffProgressPercentComplete(int percent) {
    return '$percent% completado';
  }

  @override
  String get staffChildDetailEmpty =>
      'No hay datos del niño en la base de datos';

  @override
  String get staffLoadFailed => 'Error al cargar';

  @override
  String get staffGuardianLiaison => 'ENLACE CON TUTORES';

  @override
  String get staffAssignedBrand => 'MARCA ASIGNADA';

  @override
  String get staffSupervisor => 'SUPERVISOR';

  @override
  String get staffSectionCoreDetails => 'Datos principales';

  @override
  String get staffSectionParentContact => 'Contacto del padre/madre';

  @override
  String staffPhaseWithName(String stageName) {
    return 'Fase: $stageName';
  }

  @override
  String get staffNoCurrentStage => 'Sin etapa actual';

  @override
  String staffAgeYearsOld(int age) {
    return '$age años';
  }

  @override
  String get staffNotesLabel => 'Notas';

  @override
  String get staffParentRoleDefault => 'Padre/madre';

  @override
  String get contactManagerIntro =>
      'Puedes dejar un mensaje sobre cualquier consulta; nos pondremos en contacto contigo lo antes posible.';

  @override
  String get contactManagerMessageLabel => 'Tu mensaje';

  @override
  String get contactManagerMessageRequired => 'Escribe tu mensaje';

  @override
  String get contactManagerSend => 'Enviar';

  @override
  String get contactManagerSent =>
      'Tu mensaje se ha enviado. Nos pondremos en contacto contigo pronto.';

  @override
  String get contactManagerSendFailed =>
      'No se pudo enviar. Inténtalo más tarde.';

  @override
  String get contactManagerServiceUnavailable =>
      'El contacto no está disponible temporalmente. Inténtalo más tarde.';
}

/// The translations for Spanish Castilian, as used in the United States (`es_US`).
class AppLocalizationsEsUs extends AppLocalizationsEs {
  AppLocalizationsEsUs() : super('es_US');

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get emailRequired => 'Ingresa tu correo electrónico';

  @override
  String get enterValidEmail => 'Ingresa un correo electrónico válido';

  @override
  String get passwordRequired => 'Ingresa tu contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String signInFailed(String error) {
    return 'Error al iniciar sesión: $error';
  }

  @override
  String get apiEndpointNotFoundHint =>
      'El servidor no encontró la API (404). Usa la raíz del sitio sin «/api» al final; la app llama a /api/app/login sola. Si Laravel está en una subcarpeta, incluye la ruta hasta public (p. ej. https://example.com/myapp/public).';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsLoadFailed =>
      'No se pudieron cargar las notificaciones. Inténtalo de nuevo.';

  @override
  String get notificationsEmpty => 'Aún no hay notificaciones.';

  @override
  String get notificationsNewMark => 'Nuevo';

  @override
  String get notificationDetailsTitle => 'Notificación';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get name => 'Nombre';

  @override
  String get nameRequired => 'Ingresa tu nombre';

  @override
  String get phone => 'Teléfono';

  @override
  String get phoneRequired => 'Ingresa tu teléfono';

  @override
  String get phoneMustStartWithPlus => 'El teléfono debe comenzar con +';

  @override
  String get enterValidPhone => 'Ingresa un número de teléfono válido';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get atLeast8Chars => 'Al menos 8 caracteres';

  @override
  String get backToSignIn => 'Volver a iniciar sesión';

  @override
  String registrationFailed(String error) {
    return 'Error al registrarse: $error';
  }

  @override
  String get account => 'Cuenta';

  @override
  String get editInfo => 'EDITAR INFORMACIÓN';

  @override
  String get fullName => 'Nombre';

  @override
  String get retry => 'Reintentar';

  @override
  String get accountSettings => 'Configuración de la cuenta';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirmTitle => '¿Eliminar cuenta?';

  @override
  String get deleteAccountConfirmMessage =>
      '¿Seguro que quieres eliminar tu cuenta de forma permanente? Esta acción no se puede deshacer.';

  @override
  String get deleteAccountSecondTitle => 'Qué se eliminará';

  @override
  String get deleteAccountSecondMessage =>
      'Se eliminará de forma permanente de nuestros sistemas:\n\n• Tu cuenta y perfil\n• Todos los niños vinculados a tu cuenta\n• Todas las asignaciones a eventos, progreso en etapas, entradas y comidas\n• Fotos y demás datos de los niños\n• Tu acceso a chats de eventos y notificaciones en la app\n\nAlgunos registros de pago o contables pueden conservarse cuando lo exija la ley.';

  @override
  String get deleteAccountContinue => 'Continuar';

  @override
  String get deleteAccountConfirmAction => 'Eliminar para siempre';

  @override
  String get deleteAccountWorking => 'Eliminando cuenta…';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get role => 'Rol';

  @override
  String get myChildren => 'Mis hijos';

  @override
  String get addChild => 'Agregar hijo';

  @override
  String get noChildrenAddedYet => 'Aún no has agregado hijos';

  @override
  String get ageLabel => 'Edad';

  @override
  String get settings => 'Configuración';

  @override
  String get aboutTheApp => 'Acerca de la app';

  @override
  String get aboutAppDisplayName => 'YoungFashionShow';

  @override
  String get aboutPublisherLine => 'YOUNGFASHIONSHOW';

  @override
  String get aboutVersionLabel => 'VERSIÓN';

  @override
  String get aboutReleaseDateLabel => 'FECHA DE LANZAMIENTO';

  @override
  String get aboutDevelopedByPrefix => 'Desarrollado por:';

  @override
  String get aboutDeveloperBrand => 'OWLSOLUTIONS';

  @override
  String get aboutLinkCouldNotOpen => 'No se pudo abrir el enlace.';

  @override
  String get appLanguage => 'Idioma de la app';

  @override
  String get unitsOfMeasurement => 'Unidades de medida';

  @override
  String get metricUnits => 'Métrico (cm, kg)';

  @override
  String get imperialUnits => 'Americano (in, lb)';

  @override
  String get systemLanguage => 'Sistema';

  @override
  String get languageRussian => 'Ruso';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageUkrainian => 'Ucraniano';

  @override
  String get languageSpanishUS => 'Español (EE. UU.)';

  @override
  String get addChildTitle => 'Agregar hijo';

  @override
  String get firstName => 'Nombre';

  @override
  String get gender => 'Género';

  @override
  String get genderBoy => 'Niño';

  @override
  String get genderGirl => 'Niña';

  @override
  String get lastName => 'Apellido';

  @override
  String get birthdate => 'Fecha de nacimiento';

  @override
  String get chooseDate => 'Elige la fecha';

  @override
  String get create => 'Crear';

  @override
  String get enterFirstName => 'Ingresa el nombre';

  @override
  String get mainPhoto => 'Foto principal';

  @override
  String get changePhoto => 'Cambiar';

  @override
  String get deletePhoto => 'Eliminar';

  @override
  String get addPhoto => 'Agregar foto';

  @override
  String get photoSaved => 'Foto guardada';

  @override
  String get photoDeleted => 'Foto eliminada';

  @override
  String get photoAdded => 'Foto agregada';

  @override
  String get extraPhotos => 'Fotos adicionales';

  @override
  String get cancel => 'Cancelar';

  @override
  String get clear => 'Limpiar';

  @override
  String get height => 'Estatura';

  @override
  String get weight => 'Peso';

  @override
  String get shoulders => 'Hombros';

  @override
  String get chest => 'Pecho';

  @override
  String get waist => 'Cintura';

  @override
  String get hips => 'Caderas';

  @override
  String get measurementLengthUnitCm => 'cm';

  @override
  String get measurementLengthUnitIn => 'in';

  @override
  String get currentParticipation => 'Participación actual';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String model(String name) {
    return 'Modelo: $name';
  }

  @override
  String get active => 'ACTIVO';

  @override
  String get journeyProgress => 'PROGRESO';

  @override
  String get journeyPreparationPhase => 'FASE DE PREPARACIÓN';

  @override
  String get journeyMainEventTitle => 'EVENTO PRINCIPAL';

  @override
  String get journeyMainEventSubtitle => 'EXCLUSIVO PASARELA';

  @override
  String stepOf(int completed, int total) {
    return 'Paso $completed de $total';
  }

  @override
  String next(String text) {
    return 'Siguiente: $text';
  }

  @override
  String get viewProgress => 'VER PROGRESO';

  @override
  String get eventSettings => 'AJUSTES DEL EVENTO';

  @override
  String get homeEventCardMyEvent => 'MI EVENTO';

  @override
  String get homeEventCardRunwayJourney => 'RECORRIDO DE PASARELA';

  @override
  String get eventSettingsPlaceholder =>
      'Pronto verás aquí los ajustes del evento.';

  @override
  String get eventSettingsConfigurationPortal => 'PORTAL DE CONFIGURACIÓN';

  @override
  String get eventSettingsMainHeadline => 'Ajustes del evento';

  @override
  String get eventSettingsMealTitle => 'Selección de comidas';

  @override
  String get eventSettingsMealSubtitle =>
      'Elige un plato para el evento actual';

  @override
  String get eventSettingsMealCta => 'GESTIONAR MENÚ';

  @override
  String get eventSettingsRehearsalTitle => 'Reserva de ensayo';

  @override
  String get eventSettingsRehearsalSubtitle =>
      'Reserva tu plaza para el ensayo';

  @override
  String get eventSettingsRehearsalCta => 'RESERVAR';

  @override
  String get rehearsalModalTitle => 'Reserva de ensayo';

  @override
  String get rehearsalSelectDate => 'Elige fecha';

  @override
  String get rehearsalAvailableSlots => 'Horarios disponibles';

  @override
  String get rehearsalFreeLabel => 'Libres:';

  @override
  String get rehearsalNoSlotsConfigured =>
      'Aún no hay franjas de ensayo para este evento.';

  @override
  String get rehearsalLoadError =>
      'No se pudieron cargar las franjas. Inténtalo de nuevo.';

  @override
  String get rehearsalBrandNotAssigned =>
      'No hay marca asignada para este niño. La reserva de ensayos no está disponible.';

  @override
  String get rehearsalFull => 'Completo';

  @override
  String get rehearsalConfirmBooking => 'Confirmar reserva';

  @override
  String get rehearsalBookingFooterNote =>
      'Si es posible, cambia con 24 h de antelación.';

  @override
  String get rehearsalBookedTitle => 'Ensayo reservado';

  @override
  String get rehearsalChangeBooking => 'Cambiar reserva';

  @override
  String get rehearsalProgramLabel => 'Descripción';

  @override
  String get rehearsalArriveEarly => 'Llega 15 minutos antes.';

  @override
  String get rehearsalBookingSaved => 'Reserva guardada';

  @override
  String get rehearsalBookingError => 'No se pudo completar la reserva.';

  @override
  String get rehearsalSelectChild => 'Niño/a';

  @override
  String get rehearsalUpdateBooking => 'Actualizar reserva';

  @override
  String get rehearsalCancelChange => 'Cancelar';

  @override
  String get rehearsalChangeBookingLockedHint =>
      'El organizador cerró los cambios de reserva. Contacta soporte si necesitas ayuda.';

  @override
  String get rehearsalMilestoneTitle => 'Ensayo general';

  @override
  String rehearsalBrandMilestoneTitle(String brandName) {
    return 'Ensayo de marca: $brandName';
  }

  @override
  String get rehearsalBrandMilestoneShort => 'Ensayo de marca';

  @override
  String get rehearsalNextBookHint =>
      'Reserva tu ensayo en Ajustes del evento.';

  @override
  String get eventSettingsPackingTitle => 'Lista «No olvides»';

  @override
  String get eventSettingsPackingSubtitle => '';

  @override
  String get eventSettingsPackingCta => 'VER LISTA';

  @override
  String get eventPackingLoadFailed =>
      'No se pudo cargar la información. Inténtalo de nuevo.';

  @override
  String get eventPackingEmpty =>
      'Aún no se añadió información para este evento.';

  @override
  String get eventDescriptionTitle => 'Información del evento';

  @override
  String get eventProgressShowGallery => 'Galería';

  @override
  String get eventProgressCheckin => 'Check-in';

  @override
  String get eventProgressCheckinPrompt => 'Escanea para iniciar el evento';

  @override
  String get eventProgressCheckinUnavailable =>
      'El código de check-in aún no está disponible.';

  @override
  String get eventDescriptionLoadFailed =>
      'No se pudo cargar la descripción. Inténtalo de nuevo.';

  @override
  String get eventDescriptionEmpty =>
      'Aún no hay descripción de texto para este evento.';

  @override
  String get eventSettingsBrandTitle => 'Requisitos de marca';

  @override
  String get eventSettingsBrandSubtitle =>
      'Consulta las recomendaciones de la marca para participar en el evento';

  @override
  String get eventSettingsBrandCta => 'VER GUÍAS';

  @override
  String get brandRequirementsLoadFailed =>
      'No se pudieron cargar los requisitos de marca. Inténtalo de nuevo.';

  @override
  String get brandRequirementsEmpty =>
      'Aún no se añadieron requisitos de marca para este evento.';

  @override
  String get brandRequirementsEmptyItem =>
      'Aún no se añadió texto de requisitos para esta marca.';

  @override
  String get brandRequirementsPickBrandTitle => 'Elige una marca';

  @override
  String brandRequirementsBrandNumber(int brandId) {
    return 'Marca $brandId';
  }

  @override
  String get eventSettingsChatTitle => 'Chat grupal';

  @override
  String get eventSettingsChatSubtitle =>
      'Chat grupal con participantes del grupo y managers';

  @override
  String get eventSettingsChatCta => 'ABRIR CHAT';

  @override
  String get chatRoomsLoadFailed =>
      'No se pudieron cargar las salas de chat. Inténtalo de nuevo.';

  @override
  String get chatNoRooms =>
      'Aún no hay salas de chat para tus marcas en este evento.';

  @override
  String get chatNoMessagesYet => 'Sin mensajes todavía';

  @override
  String get chatLoadFailed =>
      'No se pudieron cargar los mensajes. Inténtalo de nuevo.';

  @override
  String get chatSendFailed =>
      'No se pudo enviar el mensaje. Inténtalo de nuevo.';

  @override
  String get chatMessagePlaceholder => 'Mensaje al grupo...';

  @override
  String get chatReply => 'Responder';

  @override
  String get chatReplyCancel => 'Cancelar';

  @override
  String chatReplyingTo(String name) {
    return 'Respondiendo a $name';
  }

  @override
  String get chatReplyPreviewPhoto => 'Foto';

  @override
  String eventSettingsChatMoreParticipants(int count) {
    return '+$count';
  }

  @override
  String get mealChoiceTitle => 'Elegir comida';

  @override
  String get mealSelectChildLabel => 'Niño/a';

  @override
  String get mealSelectDishLabel => 'Plato';

  @override
  String get mealSave => 'PEDIR';

  @override
  String get mealNoMealsConfigured => 'Aún no hay platos para este evento.';

  @override
  String get mealSaved => 'Guardado';

  @override
  String get mealSaveError => 'No se pudo guardar. Inténtalo de nuevo.';

  @override
  String get mealOrdersClosed => 'El plazo para elegir el menú está cerrado';

  @override
  String get mealPaid => 'Pagado';

  @override
  String get mealPaidDetail => 'El menú de este evento está pagado.';

  @override
  String get mealPayInBrowser =>
      'Completa el pago en el navegador y vuelve a la app.';

  @override
  String get mealCheckoutError =>
      'No se pudo iniciar el pago. Inténtalo de nuevo.';

  @override
  String get mealAwaitingPayment => 'Pedido registrado — pendiente de pago';

  @override
  String get mealAwaitingPaymentDetail =>
      'Tu plato está guardado. Termina el pago en el navegador; el estado se actualizará cuando Stripe lo confirme.';

  @override
  String get noActiveEvents => 'No hay eventos activos';

  @override
  String get becomeModelTitle => 'Comienza la carrera de modelo de tu hijo hoy';

  @override
  String get becomeAModel => 'SER MODELO';

  @override
  String get latestHighlights => 'Últimos destacados';

  @override
  String get viewAll => 'VER TODO';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get fillOutApplication => 'Completar\nsolicitud';

  @override
  String get upcomingShows => 'Próximos\nshows';

  @override
  String get manageKids => 'Mis\nhijos';

  @override
  String get navHome => 'Inicio';

  @override
  String get navEvents => 'Eventos';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navInfo => 'Información';

  @override
  String get continueButton => 'Continuar';

  @override
  String get loading => 'Cargando...';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get tokenValidNext => 'Sesión válida. Siguiente: Inicio.';

  @override
  String get homePageTitle => 'Inicio';

  @override
  String youAreSignedIn(String name) {
    return 'Has iniciado sesión$name.';
  }

  @override
  String yourRole(String role) {
    return 'Tu rol: $role';
  }

  @override
  String get phoneHint => '+1234567890';

  @override
  String get enterValidEmailShort => 'Ingresa un correo válido';

  @override
  String get phoneMustStartWithPlusShort => 'El teléfono debe comenzar con +';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get hello => 'Hola';

  @override
  String helloName(String name) {
    return 'Hola, $name';
  }

  @override
  String get noRolesAssigned =>
      'Aún no tienes roles asignados. Contacta a la administración.';

  @override
  String signedInAs(String name) {
    return 'Sesión iniciada como $name';
  }

  @override
  String get staff => 'Personal';

  @override
  String get birthdateDialogTitle => 'Fecha de nacimiento';

  @override
  String get nextShowsTitle => 'Próximos shows';

  @override
  String get nextShowsSeason => 'Temporada 2026';

  @override
  String get details => 'Detalles';

  @override
  String get contact => 'Contacto';

  @override
  String get registrationOpen => 'Registro abierto';

  @override
  String get myTicketsButton => 'MIS ENTRADAS';

  @override
  String get myTicketsTitle => 'Mis entradas';

  @override
  String get selectEventForTickets => 'Selecciona el evento';

  @override
  String get ticketsMomName => 'Nombre del padre/madre';

  @override
  String get ticketsEventDate => 'Fecha';

  @override
  String get ticketsOpenPdf => 'ABRIR';

  @override
  String get ticketsPdfUnavailable => 'PDF aún no disponible';

  @override
  String get ticketsBuy => 'COMPRAR ENTRADA';

  @override
  String get ticketsBuyNoLink =>
      'No hay enlace de compra. Añade la URL de la tienda de entradas para este evento en el admin o en la web en Info.';

  @override
  String get ticketsBuyCouldNotOpen => 'No se pudo abrir el enlace.';

  @override
  String get ticketsBuySubtitle => 'Asientos VIP y estándar disponibles';

  @override
  String get ticketsNoEvents => 'Aún no hay eventos con entradas';

  @override
  String get ticketsNoneForEvent => 'No hay entradas para este evento';

  @override
  String get ticketsLoadError => 'No se pudieron cargar las entradas';

  @override
  String get ticketsEventsLoadError => 'No se pudieron cargar los eventos';

  @override
  String get faqBrandCatalogTitle => 'Marcas de ropa';

  @override
  String get pdfViewerTitle => 'Entrada';

  @override
  String get contactFormLinkMissing =>
      'No hay enlace al formulario. Añade la URL en Ajustes generales de la app en el panel.';

  @override
  String get infoHubTitle => 'Centro de información';

  @override
  String get infoMenuAboutYfs => 'Acerca de YFS';

  @override
  String get infoMenuGeneralFaq => 'FAQ general';

  @override
  String get infoMenuContactManager => 'Contactar al gestor';

  @override
  String get infoFooterBrand => 'YFS';

  @override
  String get infoFooterCopyright =>
      '© 2024 Young Fashion Series. Todos los derechos reservados.';

  @override
  String parentProgressLabel(int completed, int total) {
    return 'Progreso del padre/madre: $completed/$total';
  }

  @override
  String get appUpdateRequiredMessage =>
      'Actualiza la aplicación para continuar.';

  @override
  String get appUpdateButton => 'Actualizar aplicación';

  @override
  String get showAll => 'Ver todo';

  @override
  String get staffNoneSelected => '— Ninguno —';

  @override
  String get staffRoleInactive => 'INACTIVA';

  @override
  String get staffWorkerStatusRefreshFailed =>
      'No se pudo actualizar el estado del rol. Comprueba la conexión.';

  @override
  String get staffScanRoleInactive =>
      'Este rol fue desactivado en el panel. El escaneo no está disponible.';

  @override
  String staffScanFailed(String error) {
    return 'Error al escanear: $error';
  }

  @override
  String get staffScanSelectEventStageFirst =>
      'Selecciona el evento y la etapa activos en Ajustes del personal antes de escanear.';

  @override
  String get staffScanProcessed => 'Escaneo procesado';

  @override
  String get chatCouldNotPickPhoto => 'No se pudo elegir la foto';

  @override
  String get staffChildProfileTitle => 'Perfil del niño';

  @override
  String get staffCurrentStage => 'ETAPA ACTUAL';

  @override
  String staffProgressPercentComplete(int percent) {
    return '$percent% completado';
  }

  @override
  String get staffChildDetailEmpty =>
      'No hay datos del niño en la base de datos';

  @override
  String get staffLoadFailed => 'Error al cargar';

  @override
  String get staffGuardianLiaison => 'ENLACE CON TUTORES';

  @override
  String get staffAssignedBrand => 'MARCA ASIGNADA';

  @override
  String get staffSupervisor => 'SUPERVISOR';

  @override
  String get staffSectionCoreDetails => 'Datos principales';

  @override
  String get staffSectionParentContact => 'Contacto del padre/madre';

  @override
  String staffPhaseWithName(String stageName) {
    return 'Fase: $stageName';
  }

  @override
  String get staffNoCurrentStage => 'Sin etapa actual';

  @override
  String staffAgeYearsOld(int age) {
    return '$age años';
  }

  @override
  String get staffNotesLabel => 'Notas';

  @override
  String get staffParentRoleDefault => 'Padre/madre';

  @override
  String get contactManagerIntro =>
      'Puedes dejar un mensaje sobre cualquier consulta; nos pondremos en contacto contigo lo antes posible.';

  @override
  String get contactManagerMessageLabel => 'Tu mensaje';

  @override
  String get contactManagerMessageRequired => 'Escribe tu mensaje';

  @override
  String get contactManagerSend => 'Enviar';

  @override
  String get contactManagerSent =>
      'Tu mensaje se ha enviado. Nos pondremos en contacto contigo pronto.';

  @override
  String get contactManagerSendFailed =>
      'No se pudo enviar. Inténtalo más tarde.';

  @override
  String get contactManagerServiceUnavailable =>
      'El contacto no está disponible temporalmente. Inténtalo más tarde.';
}
