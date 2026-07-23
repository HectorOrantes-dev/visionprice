/// Métodos de pago disponibles en la pantalla de pago.
enum PaymentMethod { conekta, paypal }

/// Sub-método dentro de Conekta: tarjeta va por suscripción recurrente
/// (tokenización propia); efectivo/transferencia van por checkout hospedado
/// (no recurrente, `allowed_payment_methods: ['cash']`/`['bank_transfer']`).
enum ConektaMetodo { tarjeta, efectivo, transferencia }
