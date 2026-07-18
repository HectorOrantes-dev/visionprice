/// Estado de sincronización de un audio en cola, para la UI. Antes el privado
/// `_SyncStatus` de la pantalla de cola.
enum SyncStatus { uploading, processing, pending, ready, error }
