import 'package:flutter/material.dart';

class ContratistaCuadrillaPage extends StatefulWidget {
  final VoidCallback? onBack;
  const ContratistaCuadrillaPage({super.key, this.onBack});

  @override
  State<ContratistaCuadrillaPage> createState() =>
      _ContratistaCuadrillaPageState();
}

class _ContratistaCuadrillaPageState extends State<ContratistaCuadrillaPage> {
  String _selectedFilter = 'Todos';

  final List<_Worker> _workers = const [
    _Worker(
      name: 'Juan Pérez',
      role: 'Maestro de Obra',
      project: 'Torre Reforma',
      status: 'Activo',
      initials: 'JP',
      avatarColor: Color(0xFF2563EB),
      specialty: 'Estructura',
      phone: '+52 55 1234 5678',
    ),
    _Worker(
      name: 'Carlos Gómez',
      role: 'Albañil',
      project: '—',
      status: 'Descanso',
      initials: 'CG',
      avatarColor: Color(0xFF64748B),
      specialty: 'Mampostería',
      phone: '+52 55 2345 6789',
    ),
    _Worker(
      name: 'Luis Martínez',
      role: 'Electricista',
      project: 'Residencia Lomas',
      status: 'Activo',
      initials: 'LM',
      avatarColor: Color(0xFF10B981),
      specialty: 'Instalaciones',
      phone: '+52 55 3456 7890',
    ),
    _Worker(
      name: 'Roberto Jiménez',
      role: 'Plomero',
      project: 'Residencia Lomas',
      status: 'Activo',
      initials: 'RJ',
      avatarColor: Color(0xFF6C63FF),
      specialty: 'Hidráulica',
      phone: '+52 55 4567 8901',
    ),
    _Worker(
      name: 'Miguel Torres',
      role: 'Ayudante general',
      project: '—',
      status: 'Licencia',
      initials: 'MT',
      avatarColor: Color(0xFFF59E0B),
      specialty: 'Apoyo general',
      phone: '+52 55 5678 9012',
    ),
  ];

  List<_Worker> get _filtered {
    if (_selectedFilter == 'Todos') return _workers;
    return _workers.where((w) => w.status == _selectedFilter).toList();
  }

  int get _activeCount =>
      _workers.where((w) => w.status == 'Activo').length;
  int get _restCount =>
      _workers.where((w) => w.status == 'Descanso').length;
  int get _licenseCount =>
      _workers.where((w) => w.status == 'Licencia').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mi Cuadrilla',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.blue, size: 20),
                onPressed: widget.onBack,
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menú de cuadrilla (demo)')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats row
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                _StatChip(
                  label: 'Total',
                  value: '${_workers.length}',
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Activos',
                  value: '$_activeCount',
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Descanso',
                  value: '$_restCount',
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Licencia',
                  value: '$_licenseCount',
                  color: Colors.orange,
                ),
              ],
            ),
          ),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildChip('Todos'),
                const SizedBox(width: 8),
                _buildChip('Activo'),
                const SizedBox(width: 8),
                _buildChip('Descanso'),
                const SizedBox(width: 8),
                _buildChip('Licencia'),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Worker list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.group_off_outlined,
                            size: 48, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          'Sin trabajadores en este estado',
                          style: TextStyle(
                              color: Colors.grey[400], fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _WorkerCard(worker: _filtered[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showInviteSheet(context),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Invitar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected
                  ? Colors.blue
                  : Colors.grey.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showInviteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Invitar trabajador',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Rol',
                prefixIcon: const Icon(Icons.work_outline),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'Maestro de Obra',
                    child: Text('Maestro de Obra')),
                DropdownMenuItem(
                    value: 'Albañil', child: Text('Albañil')),
                DropdownMenuItem(
                    value: 'Electricista', child: Text('Electricista')),
                DropdownMenuItem(
                    value: 'Plomero', child: Text('Plomero')),
                DropdownMenuItem(
                    value: 'Ayudante general',
                    child: Text('Ayudante general')),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Invitación enviada (demo).')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Enviar invitación',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data model ───────────────────────────────────────────────────────────────

class _Worker {
  final String name;
  final String role;
  final String project;
  final String status;
  final String initials;
  final Color avatarColor;
  final String specialty;
  final String phone;

  const _Worker({
    required this.name,
    required this.role,
    required this.project,
    required this.status,
    required this.initials,
    required this.avatarColor,
    required this.specialty,
    required this.phone,
  });
}

// ─── Stat chip ────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Worker card ──────────────────────────────────────────────────────────────

class _WorkerCard extends StatefulWidget {
  final _Worker worker;
  const _WorkerCard({required this.worker});

  @override
  State<_WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<_WorkerCard> {
  bool _expanded = false;

  Color get _statusColor {
    switch (widget.worker.status) {
      case 'Activo':
        return Colors.green;
      case 'Descanso':
        return Colors.grey;
      case 'Licencia':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.worker;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: w.avatarColor.withOpacity(0.15),
                    radius: 24,
                    child: Text(
                      w.initials,
                      style: TextStyle(
                          color: w.avatarColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(w.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(w.role,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      w.status,
                      style: TextStyle(
                          color: _statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  _DetailRow(
                      icon: Icons.work_outline,
                      label: 'Especialidad',
                      value: w.specialty),
                  const SizedBox(height: 6),
                  _DetailRow(
                      icon: Icons.folder_outlined,
                      label: 'Proyecto asignado',
                      value: w.project),
                  const SizedBox(height: 6),
                  _DetailRow(
                      icon: Icons.phone_outlined,
                      label: 'Teléfono',
                      value: w.phone),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Llamando a ${w.name} (demo)')),
                            );
                          },
                          icon: const Icon(Icons.call, size: 16),
                          label: const Text('Llamar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            minimumSize: const Size(0, 36),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Reasignando a ${w.name} (demo)')),
                            );
                          },
                          icon: const Icon(Icons.swap_horiz, size: 16),
                          label: const Text('Reasignar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            side: BorderSide(
                                color: Colors.grey.withOpacity(0.4)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            minimumSize: const Size(0, 36),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ',
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
