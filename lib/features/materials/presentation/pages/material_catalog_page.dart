import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class _Brand {
  final String name, logo, origin, deliveryTime, description;
  final Color color;
  final double pricePerUnit;
  final String unit;
  final bool isAvailable, isBestSeller, isCertified;
  final double rating;
  final int reviews;
  final List<String> specs;
  const _Brand({required this.name,required this.logo,required this.origin,required this.color,required this.pricePerUnit,required this.unit,required this.isAvailable,this.isBestSeller=false,this.isCertified=false,required this.rating,required this.reviews,required this.deliveryTime,required this.description,required this.specs});
}

class _CatalogMaterial {
  final String id, name, category, categoryLabel, unit;
  final IconData icon;
  final Color categoryColor;
  final List<_Brand> brands;
  const _CatalogMaterial({required this.id,required this.name,required this.category,required this.categoryLabel,required this.icon,required this.categoryColor,required this.unit,required this.brands});
  double get bestPrice => brands.where((b)=>b.isAvailable).map((b)=>b.pricePerUnit).reduce((a,b)=>a<b?a:b);
  double get worstPrice => brands.where((b)=>b.isAvailable).map((b)=>b.pricePerUnit).reduce((a,b)=>a>b?a:b);
}

final _catalogMaterials = [
  _CatalogMaterial(id:'cat_001',name:'Azulejo Porcelanico 60x60',category:'ceramic',categoryLabel:'Ceramica',icon:Icons.grid_4x4,categoryColor:const Color(0xFF6C63FF),unit:'m2',brands:[
    _Brand(name:'Porcelanosa',logo:'P',origin:'Espana',color:const Color(0xFF2563EB),pricePerUnit:620.0,unit:'m2',isAvailable:true,isCertified:true,rating:4.8,reviews:342,deliveryTime:'3-5 dias',description:'Porcelanico rectificado de alta resistencia, absorcion menor a 0.5%.',specs:['60x60 cm','Rectificado','R10 antideslizante','Resistencia 45N/mm2']),
    _Brand(name:'Lamosa',logo:'L',origin:'Mexico',color:const Color(0xFFF59E0B),pricePerUnit:485.0,unit:'m2',isAvailable:true,isBestSeller:true,isCertified:true,rating:4.5,reviews:1240,deliveryTime:'1-2 dias',description:'Porcelanico nacional, acabado mate, resistente a manchas.',specs:['60x60 cm','Mate','Uso interior/exterior','ISO 13006']),
    _Brand(name:'Interceramic',logo:'IC',origin:'Mexico',color:const Color(0xFF10B981),pricePerUnit:510.0,unit:'m2',isAvailable:true,isCertified:true,rating:4.3,reviews:876,deliveryTime:'2-3 dias',description:'Diseno moderno, acabado semipulido con efecto continuo.',specs:['60x60 cm','Semipulido','PEI 4','ANCE certificado']),
    _Brand(name:'Daltile',logo:'D',origin:'EUA',color:const Color(0xFFEF4444),pricePerUnit:695.0,unit:'m2',isAvailable:false,isCertified:true,rating:4.9,reviews:215,deliveryTime:'Sin stock',description:'Premium importado, alta definicion de textura piedra natural.',specs:['60x60 cm','Polished','PEI 5','Green Certified']),
  ]),
  _CatalogMaterial(id:'cat_002',name:'Adhesivo Cementoso Flexible',category:'cement',categoryLabel:'Adhesivos',icon:Icons.layers_outlined,categoryColor:const Color(0xFFF59E0B),unit:'saco 25kg',brands:[
    _Brand(name:'Weber',logo:'W',origin:'Francia',color:const Color(0xFF2563EB),pricePerUnit:340.0,unit:'saco',isAvailable:true,isCertified:true,rating:4.7,reviews:523,deliveryTime:'1-2 dias',description:'Mortero adhesivo flexible C2TE para interiores y exteriores.',specs:['C2TE','Flexible','Antideslizante','Para porcelanico']),
    _Brand(name:'Sika',logo:'S',origin:'Suiza',color:const Color(0xFFEF4444),pricePerUnit:295.0,unit:'saco',isAvailable:true,isBestSeller:true,isCertified:true,rating:4.6,reviews:980,deliveryTime:'Inmediato',description:'Adhesivo cementoso de fraguado normal, alta adherencia.',specs:['C1T','Normal','Interior','ISO 13007']),
    _Brand(name:'Mortero Plus',logo:'MP',origin:'Mexico',color:const Color(0xFF10B981),pricePerUnit:265.0,unit:'saco',isAvailable:true,rating:3.9,reviews:340,deliveryTime:'1 dia',description:'Adhesivo estandar para ceramica de interiores.',specs:['C1','Estandar','Solo interior','No certificado NMX']),
  ]),
  _CatalogMaterial(id:'cat_003',name:'Varilla de Acero Corrugado',category:'steel',categoryLabel:'Acero',icon:Icons.architecture,categoryColor:const Color(0xFF6B7280),unit:'ton',brands:[
    _Brand(name:'Ternium',logo:'T',origin:'Mexico',color:const Color(0xFF2563EB),pricePerUnit:29400.0,unit:'ton',isAvailable:true,isBestSeller:true,isCertified:true,rating:4.8,reviews:2100,deliveryTime:'2-3 dias',description:'Varilla grado 42 num 8, ASTM A615, proceso EAF.',specs:['Grado 42','num8 (25mm)','ASTM A615','Siderurgica certificada']),
    _Brand(name:'Deacero',logo:'DA',origin:'Mexico',color:const Color(0xFFF59E0B),pricePerUnit:28100.0,unit:'ton',isAvailable:true,isCertified:true,rating:4.6,reviews:1540,deliveryTime:'1-2 dias',description:'Varilla corrugada nacional, entrega inmediata en CDMX.',specs:['Grado 42','num8 (25mm)','NMX-B-294','Planta Monterrey']),
    _Brand(name:'Aceros del Norte',logo:'AN',origin:'Mexico',color:const Color(0xFF10B981),pricePerUnit:27800.0,unit:'ton',isAvailable:true,isCertified:true,rating:4.4,reviews:870,deliveryTime:'Inmediato',description:'Distribuidor local con stock permanente, entrega en obra.',specs:['Grado 42','num8 (25mm)','NMX-B-294','Entrega en sitio']),
  ]),
  _CatalogMaterial(id:'cat_004',name:'Pintura Vinilica Interior',category:'paint',categoryLabel:'Pinturas',icon:Icons.format_paint_outlined,categoryColor:const Color(0xFF3B82F6),unit:'litro',brands:[
    _Brand(name:'Comex',logo:'CX',origin:'Mexico',color:const Color(0xFFEF4444),pricePerUnit:178.0,unit:'litro',isAvailable:true,isBestSeller:true,rating:4.5,reviews:3200,deliveryTime:'Inmediato',description:'Pintura vinilica lavable, cobertura 10-12 m2/L.',specs:['Vinilica','Lavable','10-12 m2/L','Secado 1h']),
    _Brand(name:'Sherwin Williams',logo:'SW',origin:'EUA',color:const Color(0xFF2563EB),pricePerUnit:210.0,unit:'litro',isAvailable:true,isCertified:true,rating:4.7,reviews:1580,deliveryTime:'1-2 dias',description:'Pintura acrilica premium, alta cobertura, resistente a hongos.',specs:['Acrilica','Anti-hongo','12-14 m2/L','LEED compatible']),
    _Brand(name:'Berel',logo:'BR',origin:'Mexico',color:const Color(0xFF10B981),pricePerUnit:145.0,unit:'litro',isAvailable:true,rating:4.1,reviews:980,deliveryTime:'Inmediato',description:'Pintura economica, ideal para proyectos de bajo presupuesto.',specs:['Vinilica','Estandar','8-10 m2/L','Secado 2h']),
  ]),
];

class MaterialCatalogPage extends StatefulWidget {
  const MaterialCatalogPage({super.key, this.materialId});
  final String? materialId;
  @override
  State<MaterialCatalogPage> createState() => _MaterialCatalogPageState();
}

class _MaterialCatalogPageState extends State<MaterialCatalogPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Todos';
  _CatalogMaterial? _openMaterial;
  _Brand? _selectedBrand;
  final _categories = ['Todos', 'Ceramica', 'Adhesivos', 'Acero', 'Pinturas'];

  List<_CatalogMaterial> get _filtered => _catalogMaterials.where((m) {
    final ms = m.name.toLowerCase().contains(_searchQuery.toLowerCase()) || m.categoryLabel.toLowerCase().contains(_searchQuery.toLowerCase());
    final mc = _selectedCategory == 'Todos' || m.categoryLabel == _selectedCategory;
    return ms && mc;
  }).toList();

  @override
  void initState() {
    super.initState();
    if (widget.materialId != null) {
      try { _openMaterial = _catalogMaterials.firstWhere((m) => m.id == widget.materialId); } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: _openMaterial != null
        ? _DetailView(material:_openMaterial!,selectedBrand:_selectedBrand,onBrandSelected:(b)=>setState(()=>_selectedBrand=b),onBack:()=>setState((){_openMaterial=null;_selectedBrand=null;}),onConfirm:(){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Marca confirmada: '),backgroundColor:AppColors.success));setState((){_openMaterial=null;_selectedBrand=null;});})
        : _ListView(searchQuery:_searchQuery,onSearchChanged:(v)=>setState(()=>_searchQuery=v),selectedCategory:_selectedCategory,categories:_categories,onCategoryChanged:(c)=>setState(()=>_selectedCategory=c),filtered:_filtered,onMaterialTap:(m)=>setState((){_openMaterial=m;_selectedBrand=m.brands.firstWhere((b)=>b.isAvailable,orElse:()=>m.brands.first);})),
    );
  }
}

class _ListView extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onCategoryChanged;
  final List<_CatalogMaterial> filtered;
  final ValueChanged<_CatalogMaterial> onMaterialTap;
  const _ListView({required this.searchQuery,required this.onSearchChanged,required this.selectedCategory,required this.categories,required this.onCategoryChanged,required this.filtered,required this.onMaterialTap});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned:true,
          backgroundColor:AppColors.bgDark,
          surfaceTintColor:Colors.transparent,
          leading:IconButton(icon:const Icon(Icons.arrow_back_ios_new,size:18,color:AppColors.textPrimary),onPressed:(){if(Navigator.canPop(context))Navigator.pop(context);else context.pop();}),
          title:Text('Catalogo de Materiales',style:AppTypography.textTheme.titleMedium),
          actions:[Padding(padding:const EdgeInsets.only(right:16),child:Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:5),decoration:BoxDecoration(color:AppColors.primary.withOpacity(0.1),borderRadius:BorderRadius.circular(8)),child:Text('\ materiales',style:AppTypography.textTheme.labelSmall?.copyWith(color:AppColors.primary))))],
          bottom:PreferredSize(preferredSize:const Size.fromHeight(110),child:Column(children:[
            Padding(padding:const EdgeInsets.fromLTRB(16,0,16,8),child:TextField(onChanged:onSearchChanged,decoration:InputDecoration(hintText:'Buscar material o categoria...',prefixIcon:const Icon(Icons.search,color:AppColors.textHint,size:20),filled:true,fillColor:AppColors.bgCard,contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:12),border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:AppColors.border)),enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:AppColors.border)),focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:AppColors.primary,width:1.5))))),
            SizedBox(height:44,child:ListView.separated(scrollDirection:Axis.horizontal,padding:const EdgeInsets.fromLTRB(16,4,16,4),itemCount:categories.length,separatorBuilder:(_,__)=>const SizedBox(width:8),itemBuilder:(ctx,i){final cat=categories[i];final sel=selectedCategory==cat;return GestureDetector(onTap:()=>onCategoryChanged(cat),child:AnimatedContainer(duration:const Duration(milliseconds:200),padding:const EdgeInsets.symmetric(horizontal:16,vertical:6),decoration:BoxDecoration(color:sel?AppColors.primary:AppColors.bgCard,borderRadius:BorderRadius.circular(20),border:Border.all(color:sel?AppColors.primary:AppColors.border)),child:Text(cat,style:AppTypography.textTheme.labelMedium?.copyWith(color:sel?Colors.white:AppColors.textSecondary,fontWeight:sel?FontWeight.bold:FontWeight.normal))));},)),
          ])),
        ),
        SliverPadding(
          padding:const EdgeInsets.fromLTRB(16,16,16,80),
          sliver:filtered.isEmpty
            ? SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.only(top:80),child:Column(children:[Icon(Icons.search_off,size:64,color:AppColors.textHint.withOpacity(0.5)),const SizedBox(height:16),Text('Sin resultados',style:AppTypography.textTheme.titleMedium?.copyWith(color:AppColors.textHint)),const SizedBox(height:4),Text('Intenta con otra busqueda',style:AppTypography.textTheme.bodySmall)])))
            : SliverList(delegate:SliverChildBuilderDelegate((ctx,i)=>_CatalogCard(material:filtered[i],onTap:()=>onMaterialTap(filtered[i])),childCount:filtered.length)),
        ),
      ],
    );
  }
}

class _CatalogCard extends StatelessWidget {
  final _CatalogMaterial material;
  final VoidCallback onTap;
  const _CatalogCard({required this.material,required this.onTap});
  @override
  Widget build(BuildContext context) {
    final avail = material.brands.where((b)=>b.isAvailable).length;
    return GestureDetector(onTap:onTap,child:Container(margin:const EdgeInsets.only(bottom:12),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:AppColors.bgCard,borderRadius:BorderRadius.circular(16),border:Border.all(color:AppColors.border,width:0.5),boxShadow:const [BoxShadow(color:Color(0x0A000000),blurRadius:8,offset:Offset(0,2))]),child:Row(children:[
      Container(width:52,height:52,decoration:BoxDecoration(color:material.categoryColor.withOpacity(0.1),borderRadius:BorderRadius.circular(14)),child:Icon(material.icon,color:material.categoryColor,size:26)),
      const SizedBox(width:14),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:2),decoration:BoxDecoration(color:material.categoryColor.withOpacity(0.1),borderRadius:BorderRadius.circular(6)),child:Text(material.categoryLabel,style:TextStyle(fontSize:10,fontWeight:FontWeight.bold,color:material.categoryColor))),
        const SizedBox(height:4),
        Text(material.name,style:AppTypography.textTheme.titleMedium,overflow:TextOverflow.ellipsis),
        const SizedBox(height:4),
        Row(children:[const Icon(Icons.store_outlined,size:13,color:AppColors.textHint),const SizedBox(width:4),Text('\ marcas',style:AppTypography.textTheme.bodySmall),const SizedBox(width:8),Text('\-\ /',style:AppTypography.textTheme.bodySmall?.copyWith(color:AppColors.primary,fontWeight:FontWeight.w600))]),
      ])),
      const SizedBox(width:8),
      Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),decoration:BoxDecoration(color:AppColors.primary.withOpacity(0.08),borderRadius:BorderRadius.circular(10)),child:const Row(mainAxisSize:MainAxisSize.min,children:[Text('Ver',style:TextStyle(fontSize:13,fontWeight:FontWeight.bold,color:AppColors.primary)),SizedBox(width:4),Icon(Icons.chevron_right,size:16,color:AppColors.primary)])),
    ])));
  }
}

class _DetailView extends StatelessWidget {
  final _CatalogMaterial material;
  final _Brand? selectedBrand;
  final ValueChanged<_Brand> onBrandSelected;
  final VoidCallback onBack, onConfirm;
  const _DetailView({required this.material,required this.selectedBrand,required this.onBrandSelected,required this.onBack,required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Column(children:[
      SafeArea(bottom:false,child:Padding(padding:const EdgeInsets.fromLTRB(4,8,16,8),child:Row(children:[
        IconButton(icon:const Icon(Icons.arrow_back_ios,size:18,color:AppColors.textPrimary),onPressed:onBack),
        Container(width:36,height:36,decoration:BoxDecoration(color:material.categoryColor.withOpacity(0.1),borderRadius:BorderRadius.circular(10)),child:Icon(material.icon,color:material.categoryColor,size:20)),
        const SizedBox(width:12),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(material.name,style:AppTypography.textTheme.titleMedium,overflow:TextOverflow.ellipsis),Text('\ marcas disponibles',style:AppTypography.textTheme.bodySmall)])),
      ]))),
      Expanded(child:ListView(padding:const EdgeInsets.fromLTRB(16,0,16,16),children:[
        Container(padding:const EdgeInsets.symmetric(horizontal:16,vertical:12),decoration:BoxDecoration(color:AppColors.primary.withOpacity(0.06),borderRadius:BorderRadius.circular(12),border:Border.all(color:AppColors.primary.withOpacity(0.15))),child:Row(children:[const Icon(Icons.compare_arrows,color:AppColors.primary,size:18),const SizedBox(width:10),RichText(text:TextSpan(style:AppTypography.textTheme.bodySmall?.copyWith(color:AppColors.textSecondary),children:[const TextSpan(text:'Rango de precios: '),TextSpan(text:'\$',style:const TextStyle(color:AppColors.success,fontWeight:FontWeight.bold)),const TextSpan(text:' - '),TextSpan(text:'\$\ /',style:const TextStyle(color:AppColors.error,fontWeight:FontWeight.bold))]))])),
        const SizedBox(height:16),
        ...material.brands.map((brand)=>_BrandCard(brand:brand,material:material,isSelected:selectedBrand==brand,isBestPrice:brand.isAvailable&&brand.pricePerUnit==material.bestPrice,onTap:brand.isAvailable?()=>onBrandSelected(brand):null)),
      ])),
      SafeArea(top:false,child:Padding(padding:const EdgeInsets.fromLTRB(16,8,16,16),child:Column(mainAxisSize:MainAxisSize.min,children:[
        if(selectedBrand!=null) Padding(padding:const EdgeInsets.only(bottom:8),child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.check_circle,color:AppColors.success,size:16),const SizedBox(width:6),Text('\ - \$\/',style:AppTypography.textTheme.bodySmall?.copyWith(color:AppColors.success))])),
        SizedBox(width:double.infinity,height:52,child:ElevatedButton.icon(onPressed:selectedBrand!=null?onConfirm:null,icon:const Icon(Icons.check_circle_outline,size:20),label:Text(selectedBrand!=null?'Confirmar: ':'Selecciona una marca',style:const TextStyle(fontSize:15,fontWeight:FontWeight.bold)),style:ElevatedButton.styleFrom(backgroundColor:selectedBrand!=null?AppColors.primary:AppColors.border,foregroundColor:Colors.white,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14))))),
      ]))),
    ]);
  }
}

class _BrandCard extends StatefulWidget {
  final _Brand brand;
  final _CatalogMaterial material;
  final bool isSelected, isBestPrice;
  final VoidCallback? onTap;
  const _BrandCard({required this.brand,required this.material,required this.isSelected,required this.isBestPrice,required this.onTap});
  @override
  State<_BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<_BrandCard> {
  bool _showSpecs = false;
  @override
  Widget build(BuildContext context) {
    final brand = widget.brand;
    final disabled = !brand.isAvailable;
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds:220),
        margin: const EdgeInsets.only(bottom:12),
        decoration: BoxDecoration(
          color: disabled?AppColors.bgCard.withOpacity(0.5):widget.isSelected?brand.color.withOpacity(0.05):AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color:disabled?AppColors.border:widget.isSelected?brand.color:AppColors.border,width:widget.isSelected?2:0.8),
          boxShadow: widget.isSelected?[BoxShadow(color:brand.color.withOpacity(0.15),blurRadius:12,offset:const Offset(0,4))]:null,
        ),
        child: Column(children:[
          Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Container(width:44,height:44,decoration:BoxDecoration(color:disabled?Colors.grey.withOpacity(0.1):brand.color.withOpacity(0.12),borderRadius:BorderRadius.circular(12)),child:Center(child:Text(brand.logo,style:TextStyle(fontSize:brand.logo.length>1?12:18,fontWeight:FontWeight.bold,color:disabled?Colors.grey:brand.color)))),
              const SizedBox(width:12),
              Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Wrap(children:[
                  Text(brand.name,style:TextStyle(fontWeight:FontWeight.bold,fontSize:15,color:disabled?AppColors.textHint:AppColors.textPrimary)),
                  if(brand.isBestSeller) _Bdg(label:'Mas vendido',color:AppColors.accent),
                  if(brand.isCertified&&!brand.isBestSeller) _Bdg(label:'Cert.',color:AppColors.success),
                  if(widget.isBestPrice&&!disabled) _Bdg(label:'Mejor precio',color:AppColors.primary),
                ]),
                Text('\ · ',style:TextStyle(fontSize:12,color:disabled?AppColors.textHint:AppColors.textSecondary)),
              ])),
              Column(crossAxisAlignment:CrossAxisAlignment.end,children:[
                Text(disabled?'Sin stock':'\$',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:disabled?AppColors.textHint:widget.isBestPrice?AppColors.success:AppColors.textPrimary)),
                if(!disabled) Text('/',style:AppTypography.textTheme.bodySmall),
              ]),
            ]),
            const SizedBox(height:8),
            Row(children:[
              ...List.generate(5,(i){
                final f=i<brand.rating.floor();
                final h=!f&&i<brand.rating&&brand.rating-i>=0.5;
                return Icon(f?Icons.star:h?Icons.star_half:Icons.star_border,size:14,color:disabled?AppColors.textHint:AppColors.accent);
              }),
              const SizedBox(width:6),
              Text('\ (\ resenas)',style:TextStyle(fontSize:11,color:disabled?AppColors.textHint:AppColors.textSecondary)),
            ]),
            const SizedBox(height:8),
            Text(brand.description,style:TextStyle(fontSize:13,color:disabled?AppColors.textHint:AppColors.textSecondary)),
            GestureDetector(onTap:()=>setState(()=>_showSpecs=!_showSpecs),child:Padding(padding:const EdgeInsets.only(top:10),child:Row(children:[Text(_showSpecs?'Ocultar specs':'Ver especificaciones',style:TextStyle(fontSize:12,fontWeight:FontWeight.w600,color:disabled?AppColors.textHint:brand.color)),const SizedBox(width:4),Icon(_showSpecs?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,size:14,color:disabled?AppColors.textHint:brand.color)]))),
            AnimatedCrossFade(duration:const Duration(milliseconds:200),crossFadeState:_showSpecs?CrossFadeState.showSecond:CrossFadeState.showFirst,firstChild:const SizedBox.shrink(),secondChild:Padding(padding:const EdgeInsets.only(top:10),child:Wrap(spacing:8,runSpacing:6,children:brand.specs.map((s)=>Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),decoration:BoxDecoration(color:brand.color.withOpacity(0.07),borderRadius:BorderRadius.circular(8),border:Border.all(color:brand.color.withOpacity(0.2))),child:Text(s,style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:brand.color)))).toList()))),
          ])),
          if(widget.isSelected&&!disabled) Container(width:double.infinity,padding:const EdgeInsets.symmetric(vertical:8),decoration:BoxDecoration(color:brand.color,borderRadius:const BorderRadius.vertical(bottom:Radius.circular(14))),child:const Row(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.check,color:Colors.white,size:14),SizedBox(width:6),Text('Seleccionada',style:TextStyle(color:Colors.white,fontSize:12,fontWeight:FontWeight.bold))])),
        ]),
      ),
    );
  }
}

class _Bdg extends StatelessWidget {
  final String label; final Color color;
  const _Bdg({required this.label,required this.color});
  @override
  Widget build(BuildContext context) => Container(margin:const EdgeInsets.only(left:4),padding:const EdgeInsets.symmetric(horizontal:6,vertical:2),decoration:BoxDecoration(color:color.withOpacity(0.12),borderRadius:BorderRadius.circular(6)),child:Text(label,style:TextStyle(fontSize:9,fontWeight:FontWeight.bold,color:color)));
}
