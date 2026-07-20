/// Catálogo estático de planes de pago disponibles. Fuente única de verdad:
/// `Pagos/src/shared/plan_catalog.py` en el backend (mismos `planKey`, nombre
/// y precio; ahí también viven los IDs de Conekta/PayPal por plan, que no le
/// conciernen a la app).
class PlanCatalogoEntity {
  final String planKey;
  final String nombre;
  final double precio;
  final String moneda;
  final String intervalo;

  const PlanCatalogoEntity({
    required this.planKey,
    required this.nombre,
    required this.precio,
    required this.moneda,
    required this.intervalo,
  });
}

const kPlanesDisponibles = [
  PlanCatalogoEntity(
    planKey: 'vision-price-pro',
    nombre: 'Pro',
    precio: 349,
    moneda: 'MXN',
    intervalo: 'mensual',
  ),
  PlanCatalogoEntity(
    planKey: 'vision-price-plan',
    nombre: 'Plan',
    precio: 899,
    moneda: 'MXN',
    intervalo: 'mensual',
  ),
];
