/// Estado de la pantalla de Perfil:
/// - [loading] → cargando el perfil desde el back-end.
/// - [success] → `perfil` disponible.
/// - [error] → ver `errorMessage`.
enum PerfilState { loading, success, error }
