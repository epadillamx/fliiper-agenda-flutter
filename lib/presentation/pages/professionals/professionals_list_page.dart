import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/professionals/list/entities/professional.dart';
import '../../../domain/professionals/list/usecases/get_professionals_use_case.dart';
import '../../../infrastructure/professionals/list/adapters/professional_repository_impl.dart';
import '../../widgets/gradient_background.dart';

class ProfessionalsListPage extends StatefulWidget {
  final String branchId;
  final String branchName;
  final String branchIdcuenta;

  const ProfessionalsListPage({
    super.key,
    required this.branchId,
    required this.branchName,
    required this.branchIdcuenta,
  });

  @override
  State<ProfessionalsListPage> createState() => _ProfessionalsListPageState();
}

class _ProfessionalsListPageState extends State<ProfessionalsListPage> {
  late final GetProfessionalsUseCase _getProfessionalsUseCase;
  List<Professional> _professionals = [];
  List<Professional> _filteredProfessionals = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';
  int _selectedIndex = 0;
  final int _currentStep = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    final repository = ProfessionalRepositoryImpl();
    _getProfessionalsUseCase = GetProfessionalsUseCase(repository);
    _loadProfessionals();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProfessionals(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProfessionals = _professionals;
      } else {
        _filteredProfessionals = _professionals.where((professional) {
          final nameLower = professional.displayName.toLowerCase();
          final specialtyLower = professional.displaySpecialty.toLowerCase();
          final searchLower = query.toLowerCase();
          return nameLower.contains(searchLower) ||
              specialtyLower.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _loadProfessionals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final professionals = await _getProfessionalsUseCase.execute(
        widget.branchId,
        widget.branchIdcuenta,
        '',
      );

      if (mounted) {
        setState(() {
          _professionals = professionals;
          _filteredProfessionals = professionals;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: GradientBackground()),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildStepIndicator(),
                _buildSelectedBranch(),
                _buildFilterChips(),
                Expanded(
                  child: _isLoading
                      ? _buildLoading()
                      : _errorMessage != null
                      ? _buildError()
                      : _buildProfessionalsList(),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: _buildBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Error al cargar profesionales',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.textDark),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadProfessionals,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterProfessionals,
                decoration: InputDecoration(
                  hintText: 'Buscar profesional...',
                  hintStyle: TextStyle(
                    color: AppColors.textLight.withValues(alpha: 0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16, right: 12),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 52,
                    minHeight: 24,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.textLight.withValues(alpha: 0.6),
                            size: 20,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterProfessionals('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalsList() {
    if (_filteredProfessionals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'No hay profesionales disponibles',
            style: const TextStyle(fontSize: 16, color: AppColors.textLight),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 100),
      itemCount: _filteredProfessionals.length,
      itemBuilder: (context, index) {
        return _buildProfessionalCard(_filteredProfessionals[index], index);
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textDark,
                size: 24,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Elegir Profesional',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: Row(
        children: [
          _buildStepItem(1, 'Sucursal', _currentStep > 1, _currentStep == 1),
          _buildStepLine(_currentStep > 1),
          _buildStepItem(2, 'Profesional', _currentStep > 2, _currentStep == 2),
          _buildStepLine(_currentStep > 2),
          _buildStepItem(3, 'Servicio', _currentStep > 3, _currentStep == 3),
          _buildStepLine(_currentStep > 3),
          _buildStepItem(4, 'Fecha', false, _currentStep == 4),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    int step,
    String label,
    bool isCompleted,
    bool isCurrent,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStepCircle(step, isCompleted, isCurrent),
        const SizedBox(height: 4),
        _buildStepLabel(label, isCompleted, isCurrent),
      ],
    );
  }

  Widget _buildStepCircle(int step, bool isCompleted, bool isCurrent) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isCurrent
            ? AppColors.primary
            : AppColors.slate300,
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted && !isCurrent
            ? const Icon(Icons.check, color: AppColors.white, size: 18)
            : Text(
                step.toString(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildStepLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? AppColors.primary : AppColors.slate300,
      ),
    );
  }

  Widget _buildStepLabel(String label, bool isCompleted, bool isCurrent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
            color: isCompleted || isCurrent
                ? AppColors.primary
                : AppColors.textLight,
          ),
        ),
        if (isCompleted && !isCurrent) const SizedBox(width: 4),
        if (isCompleted && !isCurrent)
          const Icon(Icons.check, size: 14, color: AppColors.primary),
      ],
    );
  }

  Widget _buildSelectedBranch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(48),
            ),
            child: const Icon(
              Icons.business,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sucursal seleccionada:',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.branchName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.search_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Todos', 'Mayor rating', 'Disponible hoy'];
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.textDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfessionalCard(Professional professional, int index) {
    final imageUrl = professional.foto?.isNotEmpty == true
        ? professional.displayPhoto
        : 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800';
    final bool isAvailable = index == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.white, width: 4),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: AppColors.slate200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.slate400,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        professional.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        professional.displaySpecialty,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.slate100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '8 años de experiencia',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9C4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Top Rated',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF57F17),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1BEE7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Experto',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6A1B9A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isAvailable) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC8E6C9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Disponible hoy',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.textLight,
                ),
                const SizedBox(width: 4),
                const Text(
                  '11:00 AM',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                const Text(
                  'desde',
                  style: TextStyle(fontSize: 12, color: AppColors.textLight),
                ),
                const SizedBox(width: 4),
                const Text(
                  '\$25,000',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.white.withValues(alpha: 0.95),
                  AppColors.white.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(icon: Icons.home_outlined, index: 0),
                  _buildNavItem(icon: Icons.calendar_month_outlined, index: 1),
                  _buildCenterNavItem(),
                  _buildNavItem(icon: Icons.chat_bubble_outline, index: 3),
                  _buildNavItem(icon: Icons.person_outline, index: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textLight,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterNavItem() {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(2),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppColors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
