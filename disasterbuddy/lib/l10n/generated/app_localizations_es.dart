// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Disaster AIDvisor';

  @override
  String get tagline => 'Preparar · Responder · Recuperar';

  @override
  String greetingMorningNamed(String name) {
    return 'Buenos días, $name. ¿En qué puedo ayudarle hoy?';
  }

  @override
  String greetingAfternoonNamed(String name) {
    return 'Buenas tardes, $name. ¿En qué puedo ayudarle hoy?';
  }

  @override
  String greetingEveningNamed(String name) {
    return 'Buenas noches, $name. ¿En qué puedo ayudarle hoy?';
  }

  @override
  String get greetingMorningAnon =>
      'Buenos días. Soy su Disaster AIDvisor. ¿En qué puedo ayudarle hoy?';

  @override
  String get greetingAfternoonAnon =>
      'Buenas tardes. Soy su Disaster AIDvisor. ¿En qué puedo ayudarle hoy?';

  @override
  String get greetingEveningAnon =>
      'Buenas noches. Soy su Disaster AIDvisor. ¿En qué puedo ayudarle hoy?';

  @override
  String get briefingLabel => 'RESUMEN DE HOY';

  @override
  String briefingLoading(String date, String area) {
    return '$date  ·  Consultando las condiciones actuales para $area…';
  }

  @override
  String briefingUnavailable(String date) {
    return '$date  ·  Condiciones en tiempo real no disponibles. Siempre verifique con las autoridades locales durante eventos activos.';
  }

  @override
  String briefingNoAlerts(String date, String area) {
    return '$date  ·  No hay alertas activas del NWS para $area.';
  }

  @override
  String briefingAlertsSummary(String date, String summary, String area) {
    return '$date  ·  $summary vigente para $area. Siga las instrucciones oficiales locales.';
  }

  @override
  String briefingAreaZip(String zip) {
    return 'código postal $zip';
  }

  @override
  String get briefingAreaGeneric => 'su zona';

  @override
  String get topicPrepareTitle => 'Prepararse para la Temporada de Huracanes';

  @override
  String get topicPrepareSubtitle => 'Planes, suministros y prioridades';

  @override
  String get topicPreparePrompt =>
      'Explíqueme cómo prepararme para la temporada de huracanes.';

  @override
  String get topicRespondTitle => 'Respuesta Durante un Evento';

  @override
  String get topicRespondSubtitle =>
      'Qué hacer según se desarrollen las condiciones';

  @override
  String get topicRespondPrompt =>
      'Una gran tormenta se dirige hacia mí. ¿Qué debo hacer ahora mismo?';

  @override
  String get topicRecoverTitle => 'Después de un Incidente';

  @override
  String get topicRecoverSubtitle => 'Recuperación, reclamos y próximos pasos';

  @override
  String get topicRecoverPrompt =>
      'Mi casa sufrió daños. ¿Cómo empiezo a recuperarme y a presentar reclamos?';

  @override
  String get chatInputPlaceholder => 'Escriba un mensaje…';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get noConversationToShare => 'Aún no hay conversación para compartir.';

  @override
  String shareSubject(String date) {
    return 'Conversación con Disaster AIDvisor — $date';
  }

  @override
  String shareHeader(String date) {
    return 'Conversación con Disaster AIDvisor — $date';
  }

  @override
  String get shareSpeakerYou => 'Usted';

  @override
  String get shareSpeakerBot => 'AIDvisor';

  @override
  String get menuShareConversation => 'Compartir Conversación';

  @override
  String get menuClearChat => 'Borrar Conversación';

  @override
  String get menuReportIssue => 'Reportar un Problema';

  @override
  String get menuLogout => 'Cerrar Sesión';

  @override
  String get menuDeleteAccount => 'Eliminar Cuenta';

  @override
  String get menuTermsConditions => 'Términos y Condiciones';

  @override
  String get menuLanguage => 'Idioma';

  @override
  String get homeTooltip => 'Volver al inicio';

  @override
  String get clearChatTitle => 'Borrar Conversación';

  @override
  String get clearChatBody =>
      'Esto eliminará permanentemente todo su historial de conversación. ¿Continuar?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get clear => 'Borrar';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get inputDisclaimer =>
      'Disaster AIDvisor es solo para fines informativos generales y no sustituye a los servicios de emergencia. Si se encuentra en peligro inmediato, llame al 911.';
}
