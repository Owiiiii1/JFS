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
  String get fullName => 'Nombre completo';

  @override
  String get retry => 'Reintentar';

  @override
  String get accountSettings => 'Configuración de la cuenta';

  @override
  String get editProfile => 'Editar perfil';

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
  String get navInfo => 'Info';

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
  String get fullName => 'Nombre completo';

  @override
  String get retry => 'Reintentar';

  @override
  String get accountSettings => 'Configuración de la cuenta';

  @override
  String get editProfile => 'Editar perfil';

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
  String get navInfo => 'Info';

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
}
