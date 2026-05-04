// lib/view/inventario/inventario_screen.dart

import 'package:flutter/material.dart';
import '../widgets/agro_app_bar.dart';
import 'package:provider/provider.dart';

import '../../controller/inventario/inventario_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../model/inventario_item_model.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<InventarioController>();

    return Scaffold(
      body: Column(
        children: [
          AgroAppBar(titulo: 'Gestion del Lote'),

          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(color: AppColors.background)),

                // Pasto inferior
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Image.asset(
                    'assets/images/grass_bottom.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
                  ),
                ),

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimens.pageHorizontalPad,
                        AppDimens.spaceLG,
                        AppDimens.pageHorizontalPad,
                        AppDimens.spaceMD,
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged:  ctrl.buscar,
                        style:      AppTextStyles.bodyRegular.copyWith(
                            color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Buscar lote',
                          hintStyle:   AppTextStyles.hintText,
                          prefixIcon:  const Icon(Icons.search,
                              color: AppColors.textHint),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: AppColors.textHint),
                                  onPressed: () {
                                    _searchController.clear();
                                    ctrl.buscar('');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ctrl.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary))
                          : ctrl.itemsPagina.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.inventory_2_outlined,
                                          size: 48,
                                          color: AppColors.textHint),
                                      const SizedBox(
                                          height: AppDimens.spaceSM),
                                      Text('No se encontraron resultados',
                                          style: AppTextStyles.bodyRegular),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.only(
                                    left:   AppDimens.pageHorizontalPad,
                                    right:  AppDimens.pageHorizontalPad,
                                    bottom: 120,
                                  ),
                                  itemCount: ctrl.itemsPagina.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(
                                          height: AppDimens.spaceMD),
                                  itemBuilder: (_, i) =>
                                      _InventarioCard(
                                          item: ctrl.itemsPagina[i]),
                                ),
                    ),
                    if (!ctrl.isLoading && ctrl.totalPaginas > 1)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 110,
                          top:    AppDimens.spaceSM,
                        ),
                        child: _Paginacion(ctrl: ctrl),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _InventarioCard extends StatelessWidget {
  const _InventarioCard({required this.item});
  final InventarioItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        color:        const Color(0xFFDCEFDC),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width:  44,
            height: 44,
            decoration: BoxDecoration(
              color:        AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
            ),
            child: const Center(
              child: Text('', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.variedad,
                  style: AppTextStyles.labelField.copyWith(
                    fontSize: 15,
                    color:    AppColors.primaryDark,
                  ),
                ),
                Text(
                  'Lote ${item.idLote}',
                  style: AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppDimens.spaceXS),
                Row(
                  children: [
                    _MiniChip(label: 'Empaque: ${item.fechaFormateada}'),
                    const SizedBox(width: AppDimens.spaceSM),
                    _MiniChip(label: 'Stock: ${item.stock} uds'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceSM,
              vertical:   AppDimens.spaceXS,
            ),
            decoration: BoxDecoration(
              color:        item.stock > 25
                  ? AppColors.primary
                  : AppColors.accent,
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
            ),
            child: Text(
              '${item.stock}',
              style: const TextStyle(
                color:      Colors.white,
                fontWeight: FontWeight.w700,
                fontSize:   13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceSM, vertical: 2),
      decoration: BoxDecoration(
        color:        AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyRegular.copyWith(
          fontSize: 11,
          color:    AppColors.primaryDark,
        ),
      ),
    );
  }
}
class _Paginacion extends StatelessWidget {
  const _Paginacion({required this.ctrl});
  final InventarioController ctrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Boton anterior
        _PageBtn(
          icon:      Icons.chevron_left,
          onPressed: ctrl.paginaActual > 1
              ? () => ctrl.irAPagina(ctrl.paginaActual - 1)
              : null,
        ),
        ...List.generate(ctrl.totalPaginas, (i) {
          final pagina   = i + 1;
          final activa   = pagina == ctrl.paginaActual;
          return GestureDetector(
            onTap: () => ctrl.irAPagina(pagina),
            child: Container(
              width:  32,
              height: 32,
              margin: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceXS),
              decoration: BoxDecoration(
                color:        activa ? AppColors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                border: Border.all(
                  color: activa ? AppColors.accent : AppColors.textHint,
                ),
              ),
              child: Center(
                child: Text(
                  '$pagina',
                  style: TextStyle(
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                    color:      activa
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),

        // Boton siguiente
        _PageBtn(
          icon:      Icons.chevron_right,
          onPressed: ctrl.paginaActual < ctrl.totalPaginas
              ? () => ctrl.irAPagina(ctrl.paginaActual + 1)
              : null,
        ),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  const _PageBtn({required this.icon, required this.onPressed});
  final IconData       icon;
  final VoidCallback?  onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width:  32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXS),
        decoration: BoxDecoration(
          color:        onPressed != null
              ? AppColors.accent
              : AppColors.inputFill,
          borderRadius: BorderRadius.circular(AppDimens.radiusSM),
        ),
        child: Icon(
          icon,
          size:  18,
          color: onPressed != null ? Colors.white : AppColors.textHint,
        ),
      ),
    );
  }
}