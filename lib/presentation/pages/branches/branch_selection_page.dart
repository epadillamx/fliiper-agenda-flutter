import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/branches/list/entities/branch.dart';
import '../../../domain/branches/list/usecases/get_branches_use_case.dart';
import '../../../infrastructure/branches/list/adapters/branch_repository_impl.dart';
import '../../widgets/gradient_background.dart';
import '../professionals/professionals_list_page.dart';

class BranchSelectionPage extends StatefulWidget {
  final String email;
  final String? idcuenta;

  const BranchSelectionPage({
    super.key,
    required this.email,
    this.idcuenta,
  });

  @override
  State<BranchSelectionPage> createState() => _BranchSelectionPageState();
}

class _BranchSelectionPageState extends State<BranchSelectionPage> {
  late final GetBranchesUseCase _getBranchesUseCase;
  List<Branch> _branches = [];
  List<Branch> _filteredBranches = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  bool _showMap = true;
  int _selectedIndex = 0;
  final int _currentStep = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    final repository = BranchRepositoryImpl();
    _getBranchesUseCase = GetBranchesUseCase(repository);
    _loadBranches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBranches() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final branches = await _getBranchesUseCase.execute(
        widget.idcuenta,
        widget.email,
      );

      if (mounted) {
        setState(() {
          _branches = branches;
          _filteredBranches = branches;
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
          const Positioned.fill(
            child: GradientBackground(),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildStepIndicator(),
                if (_showMap) _buildMapSection(),
                _buildToggleButtons(),
                Expanded(
                  child: _isLoading
                      ? _buildLoading()
                      : _errorMessage != null
                          ? _buildError()
                          : _buildBranchList(),
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
                'Seleccionar Sucursal',
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

  Widget _buildStepItem(int step, String label, bool isCompleted, bool isCurrent) {
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
        color: isCompleted || isCurrent ? AppColors.primary : AppColors.slate300,
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
            ? const Icon(
                Icons.check,
                color: AppColors.white,
                size: 18,
              )
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
            color: isCompleted || isCurrent ? AppColors.primary : AppColors.textLight,
          ),
        ),
        if (isCompleted && !isCurrent)
          const SizedBox(width: 4),
        if (isCompleted && !isCurrent)
          const Icon(
            Icons.check,
            size: 14,
            color: AppColors.primary,
          ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              color: const Color(0xFFF5F5F5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 48,
                      color: AppColors.textLight.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mapa de sucursales',
                      style: TextStyle(
                        color: AppColors.textLight.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              top: 20,
              left: 20,
              child: Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const Positioned(
              top: 40,
              right: 60,
              child: Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const Positioned(
              bottom: 30,
              left: 80,
              child: Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const Positioned(
              bottom: 50,
              right: 40,
              child: Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showMap = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !_showMap ? AppColors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Lista',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: !_showMap ? FontWeight.w600 : FontWeight.w500,
                      color: !_showMap ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showMap = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: _showMap ? AppColors.primaryGradient : null,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Mapa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: _showMap ? FontWeight.w600 : FontWeight.w500,
                      color: _showMap ? AppColors.white : AppColors.textLight,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Error al cargar sucursales',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadBranches,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchList() {
    if (_filteredBranches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'No hay sucursales disponibles',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: _filteredBranches.length,
      itemBuilder: (context, index) {
        return _buildBranchCard(_filteredBranches[index], index);
      },
    );
  }

  Widget _buildBranchCard(Branch branch, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfessionalsListPage(
              branchId: branch.id,
              branchName: branch.name,
              branchIdcuenta: branch.idcuenta,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image.network(
                'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=200',
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 110,
                    height: 110,
                    color: AppColors.slate200,
                    child: const Icon(
                      Icons.business,
                      size: 40,
                      color: AppColors.slate400,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            branch.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(index + 1) * 0.5 + 2} km',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            branch.address.isNotEmpty ? branch.address : 'Av Primera 123',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          branch.schedule.isNotEmpty ? branch.schedule : 'Hoy: 9:00 AM - 8:00 M',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textLight,
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
