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
  String get registerNameLabel => 'Ingrese nombre y apellido';

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
  String get loginPasswordOptionalHint =>
      'Si tu perfil fue creado por admin/importacion, deja la contrasena vacia y continua.';

  @override
  String get setPasswordTitle => 'Crear contrasena';

  @override
  String setPasswordSubtitle(String email) {
    return 'Crea una contrasena para $email';
  }

  @override
  String get passwordSetupMinLength =>
      'La contrasena debe tener al menos 6 caracteres';

  @override
  String get savePasswordAndContinue => 'Guardar contrasena y continuar';

  @override
  String passwordSetupFailed(String error) {
    return 'No se pudo crear la contrasena: $error';
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
  String get timeDisplayFormat => 'Formato de hora';

  @override
  String get timeFormat24Hour => '24 horas';

  @override
  String get timeFormat12Hour => '12 horas (AM/PM)';

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
  String childSubscribedBrands(String brands) {
    return 'Marcas: $brands';
  }

  @override
  String get unknownError => 'Error desconocido';

  @override
  String model(String name) {
    return 'Modelo: $name';
  }

  @override
  String get active => 'ACTIVO';

  @override
  String get familyLabel => 'FAMILY';

  @override
  String get familyJoinButton => 'UNIRSE A FAMILIA';

  @override
  String get familyJoinDialogHint => 'Ingresa el codigo familiar de 6 digitos.';

  @override
  String get familyJoinAction => 'Unirse';

  @override
  String get familyJoinInvalidCode => 'Ingresa un codigo valido de 6 digitos.';

  @override
  String get familyJoinSuccess => 'Suscripcion familiar conectada.';

  @override
  String get contractWarningTitle => 'Aviso';

  @override
  String get contractWarningFallbackText =>
      'Antes de comprar boletos, revisa y firma el contrato.';

  @override
  String get contractViewButton => 'Ver';

  @override
  String get contractPreviewTitle => 'Texto del contrato';

  @override
  String get contractSignButton => 'Firmar';

  @override
  String get contractSignatureTitle => 'Anade la firma';

  @override
  String get contractSignedSuccess => 'Contrato firmado correctamente.';

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
  String get eventSettingsFamilyButton => 'Familia';

  @override
  String get familyManageTitle => 'Familia';

  @override
  String get familyManageEnabled => 'Activar conexiones familiares';

  @override
  String get familyManageCodeLabel => 'Codigo familiar';

  @override
  String get familyManageRegenerateCode => 'Cambiar codigo';

  @override
  String get familyManageConnectionsTitle => 'Conexiones familiares activas';

  @override
  String get familyManageNoConnections =>
      'Aun no hay conexiones familiares activas.';

  @override
  String get familyManageUnknownUser => 'Usuario desconocido';

  @override
  String get eventSettingsLeaveFamilyButton => 'Desconectarse de la familia';

  @override
  String get eventSettingsLeaveFamilyConfirmTitle =>
      '?Desconectar acceso familiar?';

  @override
  String get eventSettingsLeaveFamilyConfirmText =>
      'Perderas el acceso familiar al evento hasta volver a unirte con codigo.';

  @override
  String get eventSettingsLeaveFamilySuccess =>
      'El acceso familiar se ha desconectado.';

  @override
  String get eventSettingsMealTitle => 'Selección de comidas';

  @override
  String get eventSettingsMealSubtitle =>
      'Elige un plato para el evento actual';

  @override
  String get eventSettingsMealCta => 'GESTIONAR MENÚ';

  @override
  String eventSettingsMealOrderedPcs(int count) {
    return 'Pedido: $count ud.';
  }

  @override
  String get eventSettingsMealPurchasesListHeading => 'Pedidos realizados';

  @override
  String eventSettingsMealPurchaseChildLine(String name) {
    return 'Nino/a: $name';
  }

  @override
  String get mealPurchaseIssued => 'Entregado';

  @override
  String get mealPurchaseNotIssued => 'Aun no entregado';

  @override
  String get eventSettingsRehearsalTitle => 'Reserva de ensayo';

  @override
  String get eventSettingsRehearsalSubtitle =>
      'Reserva tu plaza para el ensayo';

  @override
  String get eventSettingsRehearsalCta => 'RESERVAR';

  @override
  String get eventSettingsBrandRehearsalsHeading => 'Tus ensayos de marca';

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
  String get rehearsalUpdateBooking => 'Anadir y actualizar reserva';

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
  String get eventSettingsBrandTitle => 'Zapatos y calcetines';

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
  String get eventSettingsParkingTitle => 'Valet parking';

  @override
  String get eventSettingsParkingSubtitle =>
      'Abre tu pase de valet parking y el estado de llegada';

  @override
  String get eventSettingsParkingCta => 'ABRIR VALET PARKING';

  @override
  String get parkingChooseModeTitle => 'Modo valet parking';

  @override
  String get parkingChooseModeHint =>
      'Elige el estado de pantalla para probar el visual.';

  @override
  String get parkingModeInactive => 'INACTIVO';

  @override
  String get parkingModeActive => 'ACTIVO';

  @override
  String get parkingInactiveHeadline => 'VALET PARKING NO ACTIVO';

  @override
  String get parkingInactiveBody =>
      'EL VALET PARKING APARECERA AQUI DESPUES DE COMPRAR EL TICKET.';

  @override
  String get parkingInactiveBuyCta => 'COMPRAR';

  @override
  String get parkingInactiveVipBody =>
      'PARA VIP VALET PARKING — RESERVA UNA PLAZA PARA TU VEHICULO.';

  @override
  String get parkingInactiveVipBookCta => 'RESERVAR VALET PARKING';

  @override
  String get parkingPayForParkingCta => 'PAGAR VALET PARKING';

  @override
  String get parkingVipQuotaNextPaymentBody =>
      'YA HAS USADO LOS VALETS DE CORTESIA PARA ESTE EVENTO. AUN PUEDES ANADIR UNA PLAZA AL PRECIO REGULAR.';

  @override
  String parkingFreeTicketsQuotaLine(int used, int quota, int remaining) {
    return 'Valet de cortesia: $used de $quota usados (quedan $remaining)';
  }

  @override
  String get parkingActiveTicketLabel => 'TICKET';

  @override
  String get parkingTicketMock1 => 'TICKET A1 · MODELO';

  @override
  String get parkingTicketMock2 => 'TICKET B7 · INVITADO';

  @override
  String get parkingActiveValetLabel => 'VALET SERVICE';

  @override
  String get parkingActiveStatusLine => 'VALET PARKING ACTIVO';

  @override
  String get parkingActiveShowEntryPointCta => 'MOSTRAR PUNTO DE ENTRADA';

  @override
  String get parkingActiveCarLabel => 'AUTOMOVIL';

  @override
  String get parkingActiveRegistrationNumberLabel => 'NUMERO DE PLACA';

  @override
  String get parkingCreateTicketTitle => 'Crear ticket';

  @override
  String get parkingCreateEventLabel => 'Evento';

  @override
  String get parkingCreateAccountNameLabel => 'Nombre';

  @override
  String get parkingCreateCarModelLabel => 'MARCA Y MODELO';

  @override
  String get parkingCreateCarModelHint => 'Por ejemplo: Ford Mustang';

  @override
  String get parkingCreatePlateNumberLabel => 'NUMERO DE PLACA';

  @override
  String get parkingCreatePlateNumberHint => 'Por ejemplo: CA 7JXK921';

  @override
  String get parkingCreateRepeatPlateNumberLabel => 'REPITE EL NUMERO DE PLACA';

  @override
  String get parkingCreateRepeatPlateNumberHint =>
      'Vuelve a escribir el numero de placa';

  @override
  String get parkingCreatePlateNumberMismatch =>
      'Los numeros de placa no coinciden';

  @override
  String get parkingCreateBuyCta => 'COMPRAR';

  @override
  String get parkingCreateBookCta => 'RESERVAR VALET PARKING';

  @override
  String get parkingCheckoutInBrowser => 'Completa el pago en tu navegador.';

  @override
  String get parkingPurchasedWithoutPayment => 'Ticket comprado con exito.';

  @override
  String get parkingVipBooked => 'Valet parking VIP reservado con exito.';

  @override
  String get parkingCheckoutError =>
      'No se pudo iniciar el pago de valet parking. Intentalo de nuevo.';

  @override
  String get clientTicketServiceUnavailableTitle => 'Servicio no disponible';

  @override
  String get clientTicketServiceUnavailableBody =>
      'Este servicio de entradas no esta activo ahora.';

  @override
  String get parkingActivePassLabel => 'CODIGO';

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
  String get chatEdit => 'Editar';

  @override
  String get chatDelete => 'Eliminar';

  @override
  String get chatDeleteTitle => '?Eliminar mensaje?';

  @override
  String get chatDeleteMessageConfirm => 'Esta accion no se puede deshacer.';

  @override
  String get chatDeleteFailed =>
      'No se pudo eliminar el mensaje. Intentalo de nuevo.';

  @override
  String get chatEditFailed =>
      'No se pudo editar el mensaje. Intentalo de nuevo.';

  @override
  String get chatEditingLabel => 'Editando mensaje';

  @override
  String get chatCancelEdit => 'Cancelar edicion';

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
      'Tu plato esta guardado. Termina el pago en el navegador; el estado se actualizara cuando Stripe lo confirme.';

  @override
  String get mealPaymentContinue => 'Continuar pago';

  @override
  String get mealPaymentCancel => 'Cancelar pago';

  @override
  String get mealPaymentStartAgain => 'Iniciar pago de nuevo';

  @override
  String get mealPaymentCanceled =>
      'Pago cancelado. Puedes empezar de nuevo cuando quieras.';

  @override
  String get mealPaymentStatusLoadError =>
      'No se pudo cargar el estado del pago. Intentalo de nuevo.';

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
  String get eventsYoutubeLiveButton => 'YouTube en directo';

  @override
  String get eventsYoutubeLiveInvalidUrl =>
      'No se pudo abrir este enlace de YouTube.';

  @override
  String get eventsYoutubeLiveOpenExternally => 'Abrir en YouTube';

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
  String get ticketsBuyEmailHint =>
      'Tus entradas llegarán al correo electrónico indicado al comprar el billete.';

  @override
  String get extraTicketButton => 'OPEN BAR';

  @override
  String get extraTicketSelectEventFirst => 'Selecciona primero un evento.';

  @override
  String get extraTicketNoActiveHeadline => 'NO HAY BEVERAGE PACKAGE ACTIVOS';

  @override
  String get extraTicketBuyCta => 'COMPRAR';

  @override
  String get extraTicketAccessOpen => 'ACCESO A BEVERAGE PACKAGE ABIERTO';

  @override
  String get extraTicketCheckoutInBrowser =>
      'Completa el pago en tu navegador.';

  @override
  String get extraTicketCheckoutError =>
      'No se pudo iniciar el pago de BEVERAGE PACKAGE. Intentalo de nuevo.';

  @override
  String get backstageTicketButton => 'BACKSTAGE PASS';

  @override
  String get backstageTicketSelectEventFirst => 'Selecciona primero un evento.';

  @override
  String get backstageTicketNoActiveHeadline => 'NO HAY BACKSTAGE PASS ACTIVOS';

  @override
  String get backstageTicketBuyCta => 'COMPRAR';

  @override
  String get backstageTicketAccessOpen => 'ACCESO A BACKSTAGE PASS ABIERTO';

  @override
  String get backstageTicketCheckoutInBrowser =>
      'Completa el pago en tu navegador.';

  @override
  String get backstageTicketCheckoutError =>
      'No se pudo iniciar el pago de BACKSTAGE PASS. Intentalo de nuevo.';

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
  String get chatCouldNotPickPhoto => 'No se pudo elegir la foto';

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

  @override
  String get close => 'Cerrar';

  @override
  String get pastShowPhotosButtonTitle => 'Foto & video';

  @override
  String get pastShowPhotosButtonSubtitle => 'de desfiles pasados';

  @override
  String get pastShowPhotosTitle => 'Foto & video';

  @override
  String get pastShowPhotosNotParticipatedMessage =>
      'Aun no has participado en ningun desfile. Las fotos y los videos se anadiran despues del desfile.';

  @override
  String get pastShowPhotosPendingMessage =>
      'Las fotos y los videos se anadiran despues del desfile.';

  @override
  String get pastShowPhotosChooseEventTitle => 'Elige el desfile';

  @override
  String get pastShowPhotosChooseChildTitle => 'Foto & video';

  @override
  String get pastShowPhotosOpenPhoto => 'Foto';

  @override
  String get pastShowPhotosOpenVideo => 'Video';

  @override
  String get pastShowPhotosOpenPreview => 'Abrir vista previa';

  @override
  String get pastShowPhotosOpenPaid => 'Abrir fotos pagadas';

  @override
  String get pastShowPhotosOrderFromPreview => 'Pedir foto desde vista previa';

  @override
  String get pastShowPhotosManagePayment => 'Gestionar pago';

  @override
  String get pastShowPhotosManagePaymentTitle => 'Pago en proceso';

  @override
  String get pastShowPhotosManagePaymentMessage =>
      'Puedes continuar el pago actual o cancelarlo.';

  @override
  String pastShowPhotosAdditionalPhotoPrice(Object price) {
    return 'Precio: $price';
  }

  @override
  String get pastShowPhotosLinkCouldNotOpen => 'No se pudo abrir el enlace.';
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
  String get registerNameLabel => 'Ingrese nombre y apellido';

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
  String get loginPasswordOptionalHint =>
      'Si tu perfil fue creado por admin/importacion, deja la contrasena vacia y continua.';

  @override
  String get setPasswordTitle => 'Crear contrasena';

  @override
  String setPasswordSubtitle(String email) {
    return 'Crea una contrasena para $email';
  }

  @override
  String get passwordSetupMinLength =>
      'La contrasena debe tener al menos 6 caracteres';

  @override
  String get savePasswordAndContinue => 'Guardar contrasena y continuar';

  @override
  String passwordSetupFailed(String error) {
    return 'No se pudo crear la contrasena: $error';
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
  String get timeDisplayFormat => 'Formato de hora';

  @override
  String get timeFormat24Hour => '24 horas';

  @override
  String get timeFormat12Hour => '12 horas (AM/PM)';

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
  String childSubscribedBrands(String brands) {
    return 'Marcas: $brands';
  }

  @override
  String get unknownError => 'Error desconocido';

  @override
  String model(String name) {
    return 'Modelo: $name';
  }

  @override
  String get active => 'ACTIVO';

  @override
  String get familyLabel => 'FAMILY';

  @override
  String get familyJoinButton => 'UNIRSE A FAMILIA';

  @override
  String get familyJoinDialogHint => 'Ingresa el codigo familiar de 6 digitos.';

  @override
  String get familyJoinAction => 'Unirse';

  @override
  String get familyJoinInvalidCode => 'Ingresa un codigo valido de 6 digitos.';

  @override
  String get familyJoinSuccess => 'Suscripcion familiar conectada.';

  @override
  String get contractWarningTitle => 'Aviso';

  @override
  String get contractWarningFallbackText =>
      'Antes de comprar boletos, revisa y firma el contrato.';

  @override
  String get contractViewButton => 'Ver';

  @override
  String get contractPreviewTitle => 'Texto del contrato';

  @override
  String get contractSignButton => 'Firmar';

  @override
  String get contractSignatureTitle => 'Anade la firma';

  @override
  String get contractSignedSuccess => 'Contrato firmado correctamente.';

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
  String get eventSettingsFamilyButton => 'Familia';

  @override
  String get familyManageTitle => 'Familia';

  @override
  String get familyManageEnabled => 'Activar conexiones familiares';

  @override
  String get familyManageCodeLabel => 'Codigo familiar';

  @override
  String get familyManageRegenerateCode => 'Cambiar codigo';

  @override
  String get familyManageConnectionsTitle => 'Conexiones familiares activas';

  @override
  String get familyManageNoConnections =>
      'Aun no hay conexiones familiares activas.';

  @override
  String get familyManageUnknownUser => 'Usuario desconocido';

  @override
  String get eventSettingsLeaveFamilyButton => 'Desconectarse de la familia';

  @override
  String get eventSettingsLeaveFamilyConfirmTitle =>
      '?Desconectar acceso familiar?';

  @override
  String get eventSettingsLeaveFamilyConfirmText =>
      'Perderas el acceso familiar al evento hasta volver a unirte con codigo.';

  @override
  String get eventSettingsLeaveFamilySuccess =>
      'El acceso familiar se ha desconectado.';

  @override
  String get eventSettingsMealTitle => 'Selección de comidas';

  @override
  String get eventSettingsMealSubtitle =>
      'Elige un plato para el evento actual';

  @override
  String get eventSettingsMealCta => 'GESTIONAR MENÚ';

  @override
  String eventSettingsMealOrderedPcs(int count) {
    return 'Pedido: $count ud.';
  }

  @override
  String get eventSettingsMealPurchasesListHeading => 'Pedidos realizados';

  @override
  String eventSettingsMealPurchaseChildLine(String name) {
    return 'Nino/a: $name';
  }

  @override
  String get mealPurchaseIssued => 'Entregado';

  @override
  String get mealPurchaseNotIssued => 'Aun no entregado';

  @override
  String get eventSettingsRehearsalTitle => 'Reserva de ensayo';

  @override
  String get eventSettingsRehearsalSubtitle =>
      'Reserva tu plaza para el ensayo';

  @override
  String get eventSettingsRehearsalCta => 'RESERVAR';

  @override
  String get eventSettingsBrandRehearsalsHeading => 'Tus ensayos de marca';

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
  String get rehearsalUpdateBooking => 'Agregar y actualizar reserva';

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
  String get eventSettingsBrandTitle => 'Zapatos y calcetines';

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
  String get eventSettingsParkingTitle => 'Valet parking';

  @override
  String get eventSettingsParkingSubtitle =>
      'Abre tu pase de valet parking y el estado de llegada';

  @override
  String get eventSettingsParkingCta => 'ABRIR VALET PARKING';

  @override
  String get parkingChooseModeTitle => 'Modo valet parking';

  @override
  String get parkingChooseModeHint =>
      'Elige el estado de pantalla para probar el visual.';

  @override
  String get parkingModeInactive => 'INACTIVO';

  @override
  String get parkingModeActive => 'ACTIVO';

  @override
  String get parkingInactiveHeadline => 'VALET PARKING NO ACTIVO';

  @override
  String get parkingInactiveBody =>
      'EL VALET PARKING APARECERA AQUI DESPUES DE COMPRAR EL TICKET.';

  @override
  String get parkingInactiveBuyCta => 'COMPRAR';

  @override
  String get parkingInactiveVipBody =>
      'PARA VIP VALET PARKING — RESERVA UNA PLAZA PARA TU VEHICULO.';

  @override
  String get parkingInactiveVipBookCta => 'RESERVAR VALET PARKING';

  @override
  String get parkingPayForParkingCta => 'PAGAR VALET PARKING';

  @override
  String get parkingVipQuotaNextPaymentBody =>
      'YA HAS USADO LOS VALETS DE CORTESIA PARA ESTE EVENTO. AUN PUEDES ANADIR UNA PLAZA AL PRECIO REGULAR.';

  @override
  String parkingFreeTicketsQuotaLine(int used, int quota, int remaining) {
    return 'Valet de cortesia: $used de $quota usados (quedan $remaining)';
  }

  @override
  String get parkingActiveTicketLabel => 'TICKET';

  @override
  String get parkingTicketMock1 => 'TICKET A1 · MODELO';

  @override
  String get parkingTicketMock2 => 'TICKET B7 · INVITADO';

  @override
  String get parkingActiveValetLabel => 'VALET SERVICE';

  @override
  String get parkingActiveStatusLine => 'VALET PARKING ACTIVO';

  @override
  String get parkingActiveShowEntryPointCta => 'MOSTRAR PUNTO DE ENTRADA';

  @override
  String get parkingActiveCarLabel => 'AUTOMOVIL';

  @override
  String get parkingActiveRegistrationNumberLabel => 'NUMERO DE PLACA';

  @override
  String get parkingCreateTicketTitle => 'Crear ticket';

  @override
  String get parkingCreateEventLabel => 'Evento';

  @override
  String get parkingCreateAccountNameLabel => 'Nombre';

  @override
  String get parkingCreateCarModelLabel => 'MARCA Y MODELO';

  @override
  String get parkingCreateCarModelHint => 'Por ejemplo: Ford Mustang';

  @override
  String get parkingCreatePlateNumberLabel => 'NUMERO DE PLACA';

  @override
  String get parkingCreatePlateNumberHint => 'Por ejemplo: CA 7JXK921';

  @override
  String get parkingCreateRepeatPlateNumberLabel => 'REPITE EL NUMERO DE PLACA';

  @override
  String get parkingCreateRepeatPlateNumberHint =>
      'Vuelve a escribir el numero de placa';

  @override
  String get parkingCreatePlateNumberMismatch =>
      'Los numeros de placa no coinciden';

  @override
  String get parkingCreateBuyCta => 'COMPRAR';

  @override
  String get parkingCreateBookCta => 'RESERVAR VALET PARKING';

  @override
  String get parkingCheckoutInBrowser => 'Completa el pago en tu navegador.';

  @override
  String get parkingPurchasedWithoutPayment => 'Ticket comprado con exito.';

  @override
  String get parkingVipBooked => 'Valet parking VIP reservado con exito.';

  @override
  String get parkingCheckoutError =>
      'No se pudo iniciar el pago de valet parking. Intentalo de nuevo.';

  @override
  String get clientTicketServiceUnavailableTitle => 'Servicio no disponible';

  @override
  String get clientTicketServiceUnavailableBody =>
      'Este servicio de entradas no esta activo ahora.';

  @override
  String get parkingActivePassLabel => 'CODIGO';

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
  String get chatEdit => 'Editar';

  @override
  String get chatDelete => 'Eliminar';

  @override
  String get chatDeleteTitle => '?Eliminar mensaje?';

  @override
  String get chatDeleteMessageConfirm => 'Esta accion no se puede deshacer.';

  @override
  String get chatDeleteFailed =>
      'No se pudo eliminar el mensaje. Intentalo de nuevo.';

  @override
  String get chatEditFailed =>
      'No se pudo editar el mensaje. Intentalo de nuevo.';

  @override
  String get chatEditingLabel => 'Editando mensaje';

  @override
  String get chatCancelEdit => 'Cancelar edicion';

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
      'Tu plato esta guardado. Termina el pago en el navegador; el estado se actualizara cuando Stripe lo confirme.';

  @override
  String get mealPaymentContinue => 'Continuar pago';

  @override
  String get mealPaymentCancel => 'Cancelar pago';

  @override
  String get mealPaymentStartAgain => 'Iniciar pago de nuevo';

  @override
  String get mealPaymentCanceled =>
      'Pago cancelado. Puedes empezar de nuevo cuando quieras.';

  @override
  String get mealPaymentStatusLoadError =>
      'No se pudo cargar el estado del pago. Intentalo de nuevo.';

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
  String get eventsYoutubeLiveButton => 'YouTube en directo';

  @override
  String get eventsYoutubeLiveInvalidUrl =>
      'No se pudo abrir este enlace de YouTube.';

  @override
  String get eventsYoutubeLiveOpenExternally => 'Abrir en YouTube';

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
  String get ticketsBuyEmailHint =>
      'Tus entradas llegarán al correo electrónico indicado al comprar el billete.';

  @override
  String get extraTicketButton => 'OPEN BAR';

  @override
  String get extraTicketSelectEventFirst => 'Selecciona primero un evento.';

  @override
  String get extraTicketNoActiveHeadline => 'NO HAY BEVERAGE PACKAGE ACTIVOS';

  @override
  String get extraTicketBuyCta => 'COMPRAR';

  @override
  String get extraTicketAccessOpen => 'ACCESO A BEVERAGE PACKAGE ABIERTO';

  @override
  String get extraTicketCheckoutInBrowser =>
      'Completa el pago en tu navegador.';

  @override
  String get extraTicketCheckoutError =>
      'No se pudo iniciar el pago de BEVERAGE PACKAGE. Intentalo de nuevo.';

  @override
  String get backstageTicketButton => 'BACKSTAGE PASS';

  @override
  String get backstageTicketSelectEventFirst => 'Selecciona primero un evento.';

  @override
  String get backstageTicketNoActiveHeadline => 'NO HAY BACKSTAGE PASS ACTIVOS';

  @override
  String get backstageTicketBuyCta => 'COMPRAR';

  @override
  String get backstageTicketAccessOpen => 'ACCESO A BACKSTAGE PASS ABIERTO';

  @override
  String get backstageTicketCheckoutInBrowser =>
      'Completa el pago en tu navegador.';

  @override
  String get backstageTicketCheckoutError =>
      'No se pudo iniciar el pago de BACKSTAGE PASS. Intentalo de nuevo.';

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
  String get chatCouldNotPickPhoto => 'No se pudo elegir la foto';

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

  @override
  String get close => 'Cerrar';

  @override
  String get pastShowPhotosButtonTitle => 'Foto & video';

  @override
  String get pastShowPhotosButtonSubtitle => 'de desfiles pasados';

  @override
  String get pastShowPhotosTitle => 'Foto & video';

  @override
  String get pastShowPhotosNotParticipatedMessage =>
      'Aun no has participado en ningun desfile. Las fotos y los videos se anadiran despues del desfile.';

  @override
  String get pastShowPhotosPendingMessage =>
      'Las fotos y los videos se anadiran despues del desfile.';

  @override
  String get pastShowPhotosChooseEventTitle => 'Elige el desfile';

  @override
  String get pastShowPhotosChooseChildTitle => 'Foto & video';

  @override
  String get pastShowPhotosOpenPhoto => 'Foto';

  @override
  String get pastShowPhotosOpenVideo => 'Video';

  @override
  String get pastShowPhotosOpenPreview => 'Abrir vista previa';

  @override
  String get pastShowPhotosOpenPaid => 'Abrir fotos pagadas';

  @override
  String get pastShowPhotosOrderFromPreview => 'Pedir foto desde vista previa';

  @override
  String get pastShowPhotosManagePayment => 'Gestionar pago';

  @override
  String get pastShowPhotosManagePaymentTitle => 'Pago en proceso';

  @override
  String get pastShowPhotosManagePaymentMessage =>
      'Puedes continuar el pago actual o cancelarlo.';

  @override
  String pastShowPhotosAdditionalPhotoPrice(Object price) {
    return 'Precio: $price';
  }

  @override
  String get pastShowPhotosLinkCouldNotOpen => 'No se pudo abrir el enlace.';
}
