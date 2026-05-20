// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get signIn => 'Iniciar sesiР“С–n';

  @override
  String get signUp => 'Registrarse';

  @override
  String get email => 'Correo electrР“С–nico';

  @override
  String get password => 'ContraseР“В±a';

  @override
  String get emailRequired => 'Ingresa tu correo electrР“С–nico';

  @override
  String get enterValidEmail => 'Ingresa un correo electrР“С–nico vР“РЋlido';

  @override
  String get passwordRequired => 'Ingresa tu contraseР“В±a';

  @override
  String get hidePassword => 'Ocultar contraseР“В±a';

  @override
  String get showPassword => 'Mostrar contraseР“В±a';

  @override
  String signInFailed(String error) {
    return 'Error al iniciar sesiР“С–n: $error';
  }

  @override
  String get apiEndpointNotFoundHint =>
      'El servidor no encontrР“С– la API (404). Usa la raР“В­z del sitio sin Р’В«/apiР’В» al final; la app llama a /api/app/login sola. Si Laravel estР“РЋ en una subcarpeta, incluye la ruta hasta public (p. ej. https://example.com/myapp/public).';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsLoadFailed =>
      'No se pudieron cargar las notificaciones. IntР“В©ntalo de nuevo.';

  @override
  String get notificationsEmpty => 'AР“С”n no hay notificaciones.';

  @override
  String get notificationsNewMark => 'Nuevo';

  @override
  String get notificationDetailsTitle => 'NotificaciР“С–n';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get name => 'Nombre';

  @override
  String get registerNameLabel => 'Ingrese nombre y apellido';

  @override
  String get nameRequired => 'Ingresa tu nombre';

  @override
  String get phone => 'TelР“В©fono';

  @override
  String get phoneRequired => 'Ingresa tu telР“В©fono';

  @override
  String get phoneMustStartWithPlus => 'El telР“В©fono debe comenzar con +';

  @override
  String get enterValidPhone => 'Ingresa un nР“С”mero de telР“В©fono vР“РЋlido';

  @override
  String get confirmPassword => 'Confirmar contraseР“В±a';

  @override
  String get passwordsDoNotMatch => 'Las contraseР“В±as no coinciden';

  @override
  String get passwordMinLength =>
      'La contraseР“В±a debe tener al menos 8 caracteres';

  @override
  String get atLeast8Chars => 'Al menos 8 caracteres';

  @override
  String get backToSignIn => 'Volver a iniciar sesiР“С–n';

  @override
  String registrationFailed(String error) {
    return 'Error al registrarse: $error';
  }

  @override
  String get loginPasswordOptionalHint =>
      'Si tu perfil fue creado por admin/importaciГіn, deja la contraseГ±a vacГ­a y continГєa.';

  @override
  String get setPasswordTitle => 'Crear contraseГ±a';

  @override
  String setPasswordSubtitle(String email) {
    return 'Crea una contraseГ±a para $email';
  }

  @override
  String get passwordSetupMinLength =>
      'La contraseГ±a debe tener al menos 6 caracteres';

  @override
  String get savePasswordAndContinue => 'Guardar contraseГ±a y continuar';

  @override
  String passwordSetupFailed(String error) {
    return 'No se pudo crear la contraseГ±a: $error';
  }

  @override
  String get account => 'Cuenta';

  @override
  String get editInfo => 'EDITAR INFORMACIР“вЂњN';

  @override
  String get fullName => 'Nombre';

  @override
  String get retry => 'Reintentar';

  @override
  String get accountSettings => 'ConfiguraciР“С–n de la cuenta';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirmTitle => 'Р’С—Eliminar cuenta?';

  @override
  String get deleteAccountConfirmMessage =>
      'Р’С—Seguro que quieres eliminar tu cuenta de forma permanente? Esta acciР“С–n no se puede deshacer.';

  @override
  String get deleteAccountSecondTitle => 'QuР“В© se eliminarР“РЋ';

  @override
  String get deleteAccountSecondMessage =>
      'Se eliminarР“РЋ de forma permanente de nuestros sistemas:\n\nРІР‚Сћ Tu cuenta y perfil\nРІР‚Сћ Todos los niР“В±os vinculados a tu cuenta\nРІР‚Сћ Todas las asignaciones a eventos, progreso en etapas, entradas y comidas\nРІР‚Сћ Fotos y demР“РЋs datos de los niР“В±os\nРІР‚Сћ Tu acceso a chats de eventos y notificaciones en la app\n\nAlgunos registros de pago o contables pueden conservarse cuando lo exija la ley.';

  @override
  String get deleteAccountContinue => 'Continuar';

  @override
  String get deleteAccountConfirmAction => 'Eliminar para siempre';

  @override
  String get deleteAccountWorking => 'Eliminando cuentaРІР‚В¦';

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
  String get noChildrenAddedYet => 'AР“С”n no has agregado hijos';

  @override
  String get ageLabel => 'Edad';

  @override
  String get settings => 'ConfiguraciР“С–n';

  @override
  String get aboutTheApp => 'Acerca de la app';

  @override
  String get aboutAppDisplayName => 'YoungFashionShow';

  @override
  String get aboutPublisherLine => 'YOUNGFASHIONSHOW';

  @override
  String get aboutVersionLabel => 'VERSIР“вЂњN';

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
  String get metricUnits => 'MР“В©trico (cm, kg)';

  @override
  String get imperialUnits => 'Americano (in, lb)';

  @override
  String get systemLanguage => 'Sistema';

  @override
  String get languageRussian => 'Ruso';

  @override
  String get languageEnglish => 'InglР“В©s';

  @override
  String get languageUkrainian => 'Ucraniano';

  @override
  String get languageSpanishUS => 'EspaР“В±ol (EE. UU.)';

  @override
  String get addChildTitle => 'Agregar hijo';

  @override
  String get firstName => 'Nombre';

  @override
  String get gender => 'GР“В©nero';

  @override
  String get genderBoy => 'NiР“В±o';

  @override
  String get genderGirl => 'NiР“В±a';

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
  String get currentParticipation => 'ParticipaciР“С–n actual';

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
  String get familyJoinDialogHint =>
      'Ingresa el cГіdigo familiar de 6 dГ­gitos.';

  @override
  String get familyJoinAction => 'Unirse';

  @override
  String get familyJoinInvalidCode =>
      'Ingresa un cГіdigo vГЎlido de 6 dГ­gitos.';

  @override
  String get familyJoinSuccess => 'SuscripciГіn familiar conectada.';

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
  String get contractSignatureTitle => 'AГ±ade la firma';

  @override
  String get contractSignedSuccess => 'Contrato firmado correctamente.';

  @override
  String get journeyProgress => 'PROGRESO';

  @override
  String get journeyPreparationPhase => 'FASE DE PREPARACIР“вЂњN';

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
      'Pronto verР“РЋs aquР“В­ los ajustes del evento.';

  @override
  String get eventSettingsConfigurationPortal => 'PORTAL DE CONFIGURACIР“вЂњN';

  @override
  String get eventSettingsMainHeadline => 'Ajustes del evento';

  @override
  String get eventSettingsFamilyButton => 'Familia';

  @override
  String get familyManageTitle => 'Familia';

  @override
  String get familyManageEnabled => 'Activar conexiones familiares';

  @override
  String get familyManageCodeLabel => 'CГіdigo familiar';

  @override
  String get familyManageRegenerateCode => 'Cambiar cГіdigo';

  @override
  String get familyManageConnectionsTitle => 'Conexiones familiares activas';

  @override
  String get familyManageNoConnections =>
      'AГєn no hay conexiones familiares activas.';

  @override
  String get familyManageUnknownUser => 'Usuario desconocido';

  @override
  String get eventSettingsLeaveFamilyButton => 'Desconectarse de la familia';

  @override
  String get eventSettingsLeaveFamilyConfirmTitle =>
      'ВїDesconectar acceso familiar?';

  @override
  String get eventSettingsLeaveFamilyConfirmText =>
      'PerderГЎs el acceso familiar al evento hasta volver a unirte con cГіdigo.';

  @override
  String get eventSettingsLeaveFamilySuccess =>
      'El acceso familiar se ha desconectado.';

  @override
  String get eventSettingsMealTitle => 'SelecciР“С–n de comidas';

  @override
  String get eventSettingsMealSubtitle =>
      'Elige un plato para el evento actual';

  @override
  String get eventSettingsMealCta => 'GESTIONAR MENР“С™';

  @override
  String eventSettingsMealOrderedPcs(int count) {
    return 'Pedido: $count ud.';
  }

  @override
  String get eventSettingsMealPurchasesListHeading => 'Pedidos realizados';

  @override
  String eventSettingsMealPurchaseChildLine(String name) {
    return 'NiГ±o/a: $name';
  }

  @override
  String get mealPurchaseIssued => 'Entregado';

  @override
  String get mealPurchaseNotIssued => 'AГєn no entregado';

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
      'AР“С”n no hay franjas de ensayo para este evento.';

  @override
  String get rehearsalLoadError =>
      'No se pudieron cargar las franjas. IntР“В©ntalo de nuevo.';

  @override
  String get rehearsalBrandNotAssigned =>
      'No hay marca asignada para este niР“В±o. La reserva de ensayos no estР“РЋ disponible.';

  @override
  String get rehearsalFull => 'Completo';

  @override
  String get rehearsalConfirmBooking => 'Confirmar reserva';

  @override
  String get rehearsalBookingFooterNote =>
      'Si es posible, cambia con 24 h de antelaciР“С–n.';

  @override
  String get rehearsalBookedTitle => 'Ensayo reservado';

  @override
  String get rehearsalChangeBooking => 'Cambiar reserva';

  @override
  String get rehearsalProgramLabel => 'DescripciР“С–n';

  @override
  String get rehearsalArriveEarly => 'Llega 15 minutos antes.';

  @override
  String get rehearsalBookingSaved => 'Reserva guardada';

  @override
  String get rehearsalBookingError => 'No se pudo completar la reserva.';

  @override
  String get rehearsalSelectChild => 'NiР“В±o/a';

  @override
  String get rehearsalUpdateBooking => 'AГ±adir y actualizar reserva';

  @override
  String get rehearsalCancelChange => 'Cancelar';

  @override
  String get rehearsalChangeBookingLockedHint =>
      'El organizador cerrР“С– los cambios de reserva. Contacta soporte si necesitas ayuda.';

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
  String get eventSettingsPackingTitle => 'Lista Р’В«No olvidesР’В»';

  @override
  String get eventSettingsPackingSubtitle => '';

  @override
  String get eventSettingsPackingCta => 'VER LISTA';

  @override
  String get eventPackingLoadFailed =>
      'No se pudo cargar la informaciР“С–n. IntР“В©ntalo de nuevo.';

  @override
  String get eventPackingEmpty =>
      'AР“С”n no se aР“В±adiР“С– informaciР“С–n para este evento.';

  @override
  String get eventDescriptionTitle => 'InformaciР“С–n del evento';

  @override
  String get eventProgressShowGallery => 'GalerР“В­a';

  @override
  String get eventProgressCheckin => 'Check-in';

  @override
  String get eventProgressCheckinPrompt => 'Escanea para iniciar el evento';

  @override
  String get eventProgressCheckinUnavailable =>
      'El cР“С–digo de check-in aР“С”n no estР“РЋ disponible.';

  @override
  String get eventDescriptionLoadFailed =>
      'No se pudo cargar la descripciР“С–n. IntР“В©ntalo de nuevo.';

  @override
  String get eventDescriptionEmpty =>
      'AР“С”n no hay descripciР“С–n de texto para este evento.';

  @override
  String get eventSettingsBrandTitle => 'Zapatos y calcetines';

  @override
  String get eventSettingsBrandSubtitle =>
      'Consulta las recomendaciones de la marca para participar en el evento';

  @override
  String get eventSettingsBrandCta => 'VER GUР“РЊAS';

  @override
  String get brandRequirementsLoadFailed =>
      'No se pudieron cargar los requisitos de marca. IntР“В©ntalo de nuevo.';

  @override
  String get brandRequirementsEmpty =>
      'AР“С”n no se aР“В±adieron requisitos de marca para este evento.';

  @override
  String get brandRequirementsEmptyItem =>
      'AР“С”n no se aР“В±adiР“С– texto de requisitos para esta marca.';

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
      'PARA VIP VALET PARKING вЂ” RESERVA UNA PLAZA PARA TU VEHICULO.';

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
  String get parkingTicketMock1 => 'TICKET A1 В· MODELO';

  @override
  String get parkingTicketMock2 => 'TICKET B7 В· INVITADO';

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
      'Este servicio de entradas no estГЎ activo ahora.';

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
      'No se pudieron cargar las salas de chat. IntР“В©ntalo de nuevo.';

  @override
  String get chatNoRooms =>
      'AР“С”n no hay salas de chat para tus marcas en este evento.';

  @override
  String get chatNoMessagesYet => 'Sin mensajes todavР“В­a';

  @override
  String get chatLoadFailed =>
      'No se pudieron cargar los mensajes. IntР“В©ntalo de nuevo.';

  @override
  String get chatSendFailed =>
      'No se pudo enviar el mensaje. IntР“В©ntalo de nuevo.';

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
  String get chatDeleteTitle => 'ВїEliminar mensaje?';

  @override
  String get chatDeleteMessageConfirm => 'Esta acciГіn no se puede deshacer.';

  @override
  String get chatDeleteFailed =>
      'No se pudo eliminar el mensaje. IntГ©ntalo de nuevo.';

  @override
  String get chatEditFailed =>
      'No se pudo editar el mensaje. IntГ©ntalo de nuevo.';

  @override
  String get chatEditingLabel => 'Editando mensaje';

  @override
  String get chatCancelEdit => 'Cancelar ediciГіn';

  @override
  String eventSettingsChatMoreParticipants(int count) {
    return '+$count';
  }

  @override
  String get mealChoiceTitle => 'Elegir comida';

  @override
  String get mealSelectChildLabel => 'NiР“В±o/a';

  @override
  String get mealSelectDishLabel => 'Plato';

  @override
  String get mealSave => 'PEDIR';

  @override
  String get mealNoMealsConfigured => 'AР“С”n no hay platos para este evento.';

  @override
  String get mealSaved => 'Guardado';

  @override
  String get mealSaveError => 'No se pudo guardar. IntР“В©ntalo de nuevo.';

  @override
  String get mealOrdersClosed =>
      'El plazo para elegir el menР“С” estР“РЋ cerrado';

  @override
  String get mealPaid => 'Pagado';

  @override
  String get mealPaidDetail => 'El menР“С” de este evento estР“РЋ pagado.';

  @override
  String get mealPayInBrowser =>
      'Completa el pago en el navegador y vuelve a la app.';

  @override
  String get mealCheckoutError =>
      'No se pudo iniciar el pago. IntР“В©ntalo de nuevo.';

  @override
  String get mealAwaitingPayment => 'Pedido registrado вЂ” pendiente de pago';

  @override
  String get mealAwaitingPaymentDetail =>
      'Tu plato estГЎ guardado. Termina el pago en el navegador; el estado se actualizarГЎ cuando Stripe lo confirme.';

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
      'No se pudo cargar el estado del pago. IntГ©ntalo de nuevo.';

  @override
  String get noActiveEvents => 'No hay eventos activos';

  @override
  String get becomeModelTitle => 'Comienza la carrera de modelo de tu hijo hoy';

  @override
  String get becomeAModel => 'SER MODELO';

  @override
  String get latestHighlights => 'Р“С™ltimos destacados';

  @override
  String get viewAll => 'VER TODO';

  @override
  String get quickActions => 'Acciones rР“РЋpidas';

  @override
  String get fillOutApplication => 'Completar\nsolicitud';

  @override
  String get upcomingShows => 'PrР“С–ximos\nshows';

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
  String get navInfo => 'InformaciР“С–n';

  @override
  String get continueButton => 'Continuar';

  @override
  String get loading => 'Cargando...';

  @override
  String get signOut => 'Cerrar sesiР“С–n';

  @override
  String get tokenValidNext => 'SesiР“С–n vР“РЋlida. Siguiente: Inicio.';

  @override
  String get homePageTitle => 'Inicio';

  @override
  String youAreSignedIn(String name) {
    return 'Has iniciado sesiР“С–n$name.';
  }

  @override
  String yourRole(String role) {
    return 'Tu rol: $role';
  }

  @override
  String get phoneHint => '+1234567890';

  @override
  String get enterValidEmailShort => 'Ingresa un correo vР“РЋlido';

  @override
  String get phoneMustStartWithPlusShort =>
      'El telР“В©fono debe comenzar con +';

  @override
  String get comingSoon => 'PrР“С–ximamente';

  @override
  String get hello => 'Hola';

  @override
  String helloName(String name) {
    return 'Hola, $name';
  }

  @override
  String get noRolesAssigned =>
      'AР“С”n no tienes roles asignados. Contacta a la administraciР“С–n.';

  @override
  String signedInAs(String name) {
    return 'SesiР“С–n iniciada como $name';
  }

  @override
  String get birthdateDialogTitle => 'Fecha de nacimiento';

  @override
  String get nextShowsTitle => 'PrР“С–ximos shows';

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
  String get ticketsPdfUnavailable => 'PDF aР“С”n no disponible';

  @override
  String get ticketsBuy => 'COMPRAR ENTRADA';

  @override
  String get ticketsBuyNoLink =>
      'No hay enlace de compra. AР“В±ade la URL de la tienda de entradas para este evento en el admin o en la web en Info.';

  @override
  String get ticketsBuyCouldNotOpen => 'No se pudo abrir el enlace.';

  @override
  String get ticketsBuySubtitle => 'Asientos VIP y estР“РЋndar disponibles';

  @override
  String get ticketsBuyEmailHint =>
      'Tus entradas llegarР“РЋn al correo electrР“С–nico indicado al comprar el billete.';

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
  String get ticketsNoEvents => 'AР“С”n no hay eventos con entradas';

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
      'No hay enlace al formulario. AР“В±ade la URL en Ajustes generales de la app en el panel.';

  @override
  String get infoHubTitle => 'Centro de informaciР“С–n';

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
      'Р’В© 2024 Young Fashion Series. Todos los derechos reservados.';

  @override
  String parentProgressLabel(int completed, int total) {
    return 'Progreso del padre/madre: $completed/$total';
  }

  @override
  String get appUpdateRequiredMessage =>
      'Actualiza la aplicaciР“С–n para continuar.';

  @override
  String get appUpdateButton => 'Actualizar aplicaciР“С–n';

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
      'No se pudo enviar. IntР“В©ntalo mР“РЋs tarde.';

  @override
  String get contactManagerServiceUnavailable =>
      'El contacto no estР“РЋ disponible temporalmente. IntР“В©ntalo mР“РЋs tarde.';

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
      'Aún no has participado en ningún desfile. Las fotos y los vídeos se añadirán después del desfile.';

  @override
  String get pastShowPhotosPendingMessage =>
      'Las fotos y los vídeos se añadirán después del desfile.';

  @override
  String get pastShowPhotosChooseEventTitle => 'Elige el desfile';

  @override
  String get pastShowPhotosChooseChildTitle => 'Foto & video';

  @override
  String get pastShowPhotosOpenPhoto => 'Foto';

  @override
  String get pastShowPhotosOpenVideo => 'Video';

  @override
  String get pastShowPhotosLinkCouldNotOpen => 'No se pudo abrir el enlace.';
}

/// The translations for Spanish Castilian, as used in the United States (`es_US`).
class AppLocalizationsEsUs extends AppLocalizationsEs {
  AppLocalizationsEsUs() : super('es_US');

  @override
  String get signIn => 'Iniciar sesiР“С–n';

  @override
  String get signUp => 'Registrarse';

  @override
  String get email => 'Correo electrР“С–nico';

  @override
  String get password => 'ContraseР“В±a';

  @override
  String get emailRequired => 'Ingresa tu correo electrР“С–nico';

  @override
  String get enterValidEmail => 'Ingresa un correo electrР“С–nico vР“РЋlido';

  @override
  String get passwordRequired => 'Ingresa tu contraseР“В±a';

  @override
  String get hidePassword => 'Ocultar contraseР“В±a';

  @override
  String get showPassword => 'Mostrar contraseР“В±a';

  @override
  String signInFailed(String error) {
    return 'Error al iniciar sesiР“С–n: $error';
  }

  @override
  String get apiEndpointNotFoundHint =>
      'El servidor no encontrР“С– la API (404). Usa la raР“В­z del sitio sin Р’В«/apiР’В» al final; la app llama a /api/app/login sola. Si Laravel estР“РЋ en una subcarpeta, incluye la ruta hasta public (p. ej. https://example.com/myapp/public).';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsLoadFailed =>
      'No se pudieron cargar las notificaciones. IntР“В©ntalo de nuevo.';

  @override
  String get notificationsEmpty => 'AР“С”n no hay notificaciones.';

  @override
  String get notificationsNewMark => 'Nuevo';

  @override
  String get notificationDetailsTitle => 'NotificaciР“С–n';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get name => 'Nombre';

  @override
  String get registerNameLabel => 'Ingrese nombre y apellido';

  @override
  String get nameRequired => 'Ingresa tu nombre';

  @override
  String get phone => 'TelР“В©fono';

  @override
  String get phoneRequired => 'Ingresa tu telР“В©fono';

  @override
  String get phoneMustStartWithPlus => 'El telР“В©fono debe comenzar con +';

  @override
  String get enterValidPhone => 'Ingresa un nР“С”mero de telР“В©fono vР“РЋlido';

  @override
  String get confirmPassword => 'Confirmar contraseР“В±a';

  @override
  String get passwordsDoNotMatch => 'Las contraseР“В±as no coinciden';

  @override
  String get passwordMinLength =>
      'La contraseР“В±a debe tener al menos 8 caracteres';

  @override
  String get atLeast8Chars => 'Al menos 8 caracteres';

  @override
  String get backToSignIn => 'Volver a iniciar sesiР“С–n';

  @override
  String registrationFailed(String error) {
    return 'Error al registrarse: $error';
  }

  @override
  String get loginPasswordOptionalHint =>
      'Si tu perfil fue creado por admin/importaciГіn, deja la contraseГ±a vacГ­a y continГєa.';

  @override
  String get setPasswordTitle => 'Crear contraseГ±a';

  @override
  String setPasswordSubtitle(String email) {
    return 'Crea una contraseГ±a para $email';
  }

  @override
  String get passwordSetupMinLength =>
      'La contraseГ±a debe tener al menos 6 caracteres';

  @override
  String get savePasswordAndContinue => 'Guardar contraseГ±a y continuar';

  @override
  String passwordSetupFailed(String error) {
    return 'No se pudo crear la contraseГ±a: $error';
  }

  @override
  String get account => 'Cuenta';

  @override
  String get editInfo => 'EDITAR INFORMACIР“вЂњN';

  @override
  String get fullName => 'Nombre';

  @override
  String get retry => 'Reintentar';

  @override
  String get accountSettings => 'ConfiguraciР“С–n de la cuenta';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirmTitle => 'Р’С—Eliminar cuenta?';

  @override
  String get deleteAccountConfirmMessage =>
      'Р’С—Seguro que quieres eliminar tu cuenta de forma permanente? Esta acciР“С–n no se puede deshacer.';

  @override
  String get deleteAccountSecondTitle => 'QuР“В© se eliminarР“РЋ';

  @override
  String get deleteAccountSecondMessage =>
      'Se eliminarР“РЋ de forma permanente de nuestros sistemas:\n\nРІР‚Сћ Tu cuenta y perfil\nРІР‚Сћ Todos los niР“В±os vinculados a tu cuenta\nРІР‚Сћ Todas las asignaciones a eventos, progreso en etapas, entradas y comidas\nРІР‚Сћ Fotos y demР“РЋs datos de los niР“В±os\nРІР‚Сћ Tu acceso a chats de eventos y notificaciones en la app\n\nAlgunos registros de pago o contables pueden conservarse cuando lo exija la ley.';

  @override
  String get deleteAccountContinue => 'Continuar';

  @override
  String get deleteAccountConfirmAction => 'Eliminar para siempre';

  @override
  String get deleteAccountWorking => 'Eliminando cuentaРІР‚В¦';

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
  String get noChildrenAddedYet => 'AР“С”n no has agregado hijos';

  @override
  String get ageLabel => 'Edad';

  @override
  String get settings => 'ConfiguraciР“С–n';

  @override
  String get aboutTheApp => 'Acerca de la app';

  @override
  String get aboutAppDisplayName => 'YoungFashionShow';

  @override
  String get aboutPublisherLine => 'YOUNGFASHIONSHOW';

  @override
  String get aboutVersionLabel => 'VERSIР“вЂњN';

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
  String get metricUnits => 'MР“В©trico (cm, kg)';

  @override
  String get imperialUnits => 'Americano (in, lb)';

  @override
  String get systemLanguage => 'Sistema';

  @override
  String get languageRussian => 'Ruso';

  @override
  String get languageEnglish => 'InglР“В©s';

  @override
  String get languageUkrainian => 'Ucraniano';

  @override
  String get languageSpanishUS => 'EspaР“В±ol (EE. UU.)';

  @override
  String get addChildTitle => 'Agregar hijo';

  @override
  String get firstName => 'Nombre';

  @override
  String get gender => 'GР“В©nero';

  @override
  String get genderBoy => 'NiР“В±o';

  @override
  String get genderGirl => 'NiР“В±a';

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
  String get currentParticipation => 'ParticipaciР“С–n actual';

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
  String get familyJoinDialogHint =>
      'Ingresa el cГіdigo familiar de 6 dГ­gitos.';

  @override
  String get familyJoinAction => 'Unirse';

  @override
  String get familyJoinInvalidCode =>
      'Ingresa un cГіdigo vГЎlido de 6 dГ­gitos.';

  @override
  String get familyJoinSuccess => 'SuscripciГіn familiar conectada.';

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
  String get contractSignatureTitle => 'AГ±ade la firma';

  @override
  String get contractSignedSuccess => 'Contrato firmado correctamente.';

  @override
  String get journeyProgress => 'PROGRESO';

  @override
  String get journeyPreparationPhase => 'FASE DE PREPARACIР“вЂњN';

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
      'Pronto verР“РЋs aquР“В­ los ajustes del evento.';

  @override
  String get eventSettingsConfigurationPortal => 'PORTAL DE CONFIGURACIР“вЂњN';

  @override
  String get eventSettingsMainHeadline => 'Ajustes del evento';

  @override
  String get eventSettingsFamilyButton => 'Familia';

  @override
  String get familyManageTitle => 'Familia';

  @override
  String get familyManageEnabled => 'Activar conexiones familiares';

  @override
  String get familyManageCodeLabel => 'CГіdigo familiar';

  @override
  String get familyManageRegenerateCode => 'Cambiar cГіdigo';

  @override
  String get familyManageConnectionsTitle => 'Conexiones familiares activas';

  @override
  String get familyManageNoConnections =>
      'AГєn no hay conexiones familiares activas.';

  @override
  String get familyManageUnknownUser => 'Usuario desconocido';

  @override
  String get eventSettingsLeaveFamilyButton => 'Desconectarse de la familia';

  @override
  String get eventSettingsLeaveFamilyConfirmTitle =>
      'ВїDesconectar acceso familiar?';

  @override
  String get eventSettingsLeaveFamilyConfirmText =>
      'PerderГЎs el acceso familiar al evento hasta volver a unirte con cГіdigo.';

  @override
  String get eventSettingsLeaveFamilySuccess =>
      'El acceso familiar se ha desconectado.';

  @override
  String get eventSettingsMealTitle => 'SelecciР“С–n de comidas';

  @override
  String get eventSettingsMealSubtitle =>
      'Elige un plato para el evento actual';

  @override
  String get eventSettingsMealCta => 'GESTIONAR MENР“С™';

  @override
  String eventSettingsMealOrderedPcs(int count) {
    return 'Pedido: $count ud.';
  }

  @override
  String get eventSettingsMealPurchasesListHeading => 'Pedidos realizados';

  @override
  String eventSettingsMealPurchaseChildLine(String name) {
    return 'NiГ±o/a: $name';
  }

  @override
  String get mealPurchaseIssued => 'Entregado';

  @override
  String get mealPurchaseNotIssued => 'AГєn no entregado';

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
      'AР“С”n no hay franjas de ensayo para este evento.';

  @override
  String get rehearsalLoadError =>
      'No se pudieron cargar las franjas. IntР“В©ntalo de nuevo.';

  @override
  String get rehearsalBrandNotAssigned =>
      'No hay marca asignada para este niР“В±o. La reserva de ensayos no estР“РЋ disponible.';

  @override
  String get rehearsalFull => 'Completo';

  @override
  String get rehearsalConfirmBooking => 'Confirmar reserva';

  @override
  String get rehearsalBookingFooterNote =>
      'Si es posible, cambia con 24 h de antelaciР“С–n.';

  @override
  String get rehearsalBookedTitle => 'Ensayo reservado';

  @override
  String get rehearsalChangeBooking => 'Cambiar reserva';

  @override
  String get rehearsalProgramLabel => 'DescripciР“С–n';

  @override
  String get rehearsalArriveEarly => 'Llega 15 minutos antes.';

  @override
  String get rehearsalBookingSaved => 'Reserva guardada';

  @override
  String get rehearsalBookingError => 'No se pudo completar la reserva.';

  @override
  String get rehearsalSelectChild => 'NiР“В±o/a';

  @override
  String get rehearsalUpdateBooking => 'Agregar y actualizar reserva';

  @override
  String get rehearsalCancelChange => 'Cancelar';

  @override
  String get rehearsalChangeBookingLockedHint =>
      'El organizador cerrР“С– los cambios de reserva. Contacta soporte si necesitas ayuda.';

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
  String get eventSettingsPackingTitle => 'Lista Р’В«No olvidesР’В»';

  @override
  String get eventSettingsPackingSubtitle => '';

  @override
  String get eventSettingsPackingCta => 'VER LISTA';

  @override
  String get eventPackingLoadFailed =>
      'No se pudo cargar la informaciР“С–n. IntР“В©ntalo de nuevo.';

  @override
  String get eventPackingEmpty =>
      'AР“С”n no se aР“В±adiР“С– informaciР“С–n para este evento.';

  @override
  String get eventDescriptionTitle => 'InformaciР“С–n del evento';

  @override
  String get eventProgressShowGallery => 'GalerР“В­a';

  @override
  String get eventProgressCheckin => 'Check-in';

  @override
  String get eventProgressCheckinPrompt => 'Escanea para iniciar el evento';

  @override
  String get eventProgressCheckinUnavailable =>
      'El cР“С–digo de check-in aР“С”n no estР“РЋ disponible.';

  @override
  String get eventDescriptionLoadFailed =>
      'No se pudo cargar la descripciР“С–n. IntР“В©ntalo de nuevo.';

  @override
  String get eventDescriptionEmpty =>
      'AР“С”n no hay descripciР“С–n de texto para este evento.';

  @override
  String get eventSettingsBrandTitle => 'Zapatos y calcetines';

  @override
  String get eventSettingsBrandSubtitle =>
      'Consulta las recomendaciones de la marca para participar en el evento';

  @override
  String get eventSettingsBrandCta => 'VER GUР“РЊAS';

  @override
  String get brandRequirementsLoadFailed =>
      'No se pudieron cargar los requisitos de marca. IntР“В©ntalo de nuevo.';

  @override
  String get brandRequirementsEmpty =>
      'AР“С”n no se aР“В±adieron requisitos de marca para este evento.';

  @override
  String get brandRequirementsEmptyItem =>
      'AР“С”n no se aР“В±adiР“С– texto de requisitos para esta marca.';

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
      'PARA VIP VALET PARKING вЂ” RESERVA UNA PLAZA PARA TU VEHICULO.';

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
  String get parkingTicketMock1 => 'TICKET A1 В· MODELO';

  @override
  String get parkingTicketMock2 => 'TICKET B7 В· INVITADO';

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
      'Este servicio de entradas no estГЎ activo ahora.';

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
      'No se pudieron cargar las salas de chat. IntР“В©ntalo de nuevo.';

  @override
  String get chatNoRooms =>
      'AР“С”n no hay salas de chat para tus marcas en este evento.';

  @override
  String get chatNoMessagesYet => 'Sin mensajes todavР“В­a';

  @override
  String get chatLoadFailed =>
      'No se pudieron cargar los mensajes. IntР“В©ntalo de nuevo.';

  @override
  String get chatSendFailed =>
      'No se pudo enviar el mensaje. IntР“В©ntalo de nuevo.';

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
  String get chatDeleteTitle => 'ВїEliminar mensaje?';

  @override
  String get chatDeleteMessageConfirm => 'Esta acciГіn no se puede deshacer.';

  @override
  String get chatDeleteFailed =>
      'No se pudo eliminar el mensaje. IntГ©ntalo de nuevo.';

  @override
  String get chatEditFailed =>
      'No se pudo editar el mensaje. IntГ©ntalo de nuevo.';

  @override
  String get chatEditingLabel => 'Editando mensaje';

  @override
  String get chatCancelEdit => 'Cancelar ediciГіn';

  @override
  String eventSettingsChatMoreParticipants(int count) {
    return '+$count';
  }

  @override
  String get mealChoiceTitle => 'Elegir comida';

  @override
  String get mealSelectChildLabel => 'NiР“В±o/a';

  @override
  String get mealSelectDishLabel => 'Plato';

  @override
  String get mealSave => 'PEDIR';

  @override
  String get mealNoMealsConfigured => 'AР“С”n no hay platos para este evento.';

  @override
  String get mealSaved => 'Guardado';

  @override
  String get mealSaveError => 'No se pudo guardar. IntР“В©ntalo de nuevo.';

  @override
  String get mealOrdersClosed =>
      'El plazo para elegir el menР“С” estР“РЋ cerrado';

  @override
  String get mealPaid => 'Pagado';

  @override
  String get mealPaidDetail => 'El menР“С” de este evento estР“РЋ pagado.';

  @override
  String get mealPayInBrowser =>
      'Completa el pago en el navegador y vuelve a la app.';

  @override
  String get mealCheckoutError =>
      'No se pudo iniciar el pago. IntР“В©ntalo de nuevo.';

  @override
  String get mealAwaitingPayment => 'Pedido registrado вЂ” pendiente de pago';

  @override
  String get mealAwaitingPaymentDetail =>
      'Tu plato estГЎ guardado. Termina el pago en el navegador; el estado se actualizarГЎ cuando Stripe lo confirme.';

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
      'No se pudo cargar el estado del pago. IntГ©ntalo de nuevo.';

  @override
  String get noActiveEvents => 'No hay eventos activos';

  @override
  String get becomeModelTitle => 'Comienza la carrera de modelo de tu hijo hoy';

  @override
  String get becomeAModel => 'SER MODELO';

  @override
  String get latestHighlights => 'Р“С™ltimos destacados';

  @override
  String get viewAll => 'VER TODO';

  @override
  String get quickActions => 'Acciones rР“РЋpidas';

  @override
  String get fillOutApplication => 'Completar\nsolicitud';

  @override
  String get upcomingShows => 'PrР“С–ximos\nshows';

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
  String get navInfo => 'InformaciР“С–n';

  @override
  String get continueButton => 'Continuar';

  @override
  String get loading => 'Cargando...';

  @override
  String get signOut => 'Cerrar sesiР“С–n';

  @override
  String get tokenValidNext => 'SesiР“С–n vР“РЋlida. Siguiente: Inicio.';

  @override
  String get homePageTitle => 'Inicio';

  @override
  String youAreSignedIn(String name) {
    return 'Has iniciado sesiР“С–n$name.';
  }

  @override
  String yourRole(String role) {
    return 'Tu rol: $role';
  }

  @override
  String get phoneHint => '+1234567890';

  @override
  String get enterValidEmailShort => 'Ingresa un correo vР“РЋlido';

  @override
  String get phoneMustStartWithPlusShort =>
      'El telР“В©fono debe comenzar con +';

  @override
  String get comingSoon => 'PrР“С–ximamente';

  @override
  String get hello => 'Hola';

  @override
  String helloName(String name) {
    return 'Hola, $name';
  }

  @override
  String get noRolesAssigned =>
      'AР“С”n no tienes roles asignados. Contacta a la administraciР“С–n.';

  @override
  String signedInAs(String name) {
    return 'SesiР“С–n iniciada como $name';
  }

  @override
  String get birthdateDialogTitle => 'Fecha de nacimiento';

  @override
  String get nextShowsTitle => 'PrР“С–ximos shows';

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
  String get ticketsPdfUnavailable => 'PDF aР“С”n no disponible';

  @override
  String get ticketsBuy => 'COMPRAR ENTRADA';

  @override
  String get ticketsBuyNoLink =>
      'No hay enlace de compra. AР“В±ade la URL de la tienda de entradas para este evento en el admin o en la web en Info.';

  @override
  String get ticketsBuyCouldNotOpen => 'No se pudo abrir el enlace.';

  @override
  String get ticketsBuySubtitle => 'Asientos VIP y estР“РЋndar disponibles';

  @override
  String get ticketsBuyEmailHint =>
      'Tus entradas llegarР“РЋn al correo electrР“С–nico indicado al comprar el billete.';

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
  String get ticketsNoEvents => 'AР“С”n no hay eventos con entradas';

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
      'No hay enlace al formulario. AР“В±ade la URL en Ajustes generales de la app en el panel.';

  @override
  String get infoHubTitle => 'Centro de informaciР“С–n';

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
      'Р’В© 2024 Young Fashion Series. Todos los derechos reservados.';

  @override
  String parentProgressLabel(int completed, int total) {
    return 'Progreso del padre/madre: $completed/$total';
  }

  @override
  String get appUpdateRequiredMessage =>
      'Actualiza la aplicaciР“С–n para continuar.';

  @override
  String get appUpdateButton => 'Actualizar aplicaciР“С–n';

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
      'No se pudo enviar. IntР“В©ntalo mР“РЋs tarde.';

  @override
  String get contactManagerServiceUnavailable =>
      'El contacto no estР“РЋ disponible temporalmente. IntР“В©ntalo mР“РЋs tarde.';

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
      'Aún no has participado en ningún desfile. Las fotos y los vídeos se añadirán después del desfile.';

  @override
  String get pastShowPhotosPendingMessage =>
      'Las fotos y los vídeos se añadirán después del desfile.';

  @override
  String get pastShowPhotosChooseEventTitle => 'Elige el desfile';

  @override
  String get pastShowPhotosChooseChildTitle => 'Foto & video';

  @override
  String get pastShowPhotosOpenPhoto => 'Foto';

  @override
  String get pastShowPhotosOpenVideo => 'Video';

  @override
  String get pastShowPhotosLinkCouldNotOpen => 'No se pudo abrir el enlace.';
}
