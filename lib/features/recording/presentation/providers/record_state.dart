/// Estados de la pantalla de grabación:
/// - [idle] → sin grabar.
/// - [recording] → capturando audio.
/// - [recorded] → audio listo para subir.
/// - [uploading] → subiendo al back-end.
/// - [error] → ver `errorMessage`.
enum RecordState { idle, recording, recorded, uploading, error }
