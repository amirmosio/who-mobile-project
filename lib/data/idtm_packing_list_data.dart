import '../models/packing_list_item.dart';

/// IDTM Packing List Data extracted from the user manual
/// Source: EN-MAN-AZF4-27-WFP_User_Manual_DRAFT01 (Section 2.5, Pages 11-12)
class IdtmPackingListData {
  static List<PackingListItem> getPackingList() {
    return [
      // EUROPALLET 1
      const PackingListItem(
        id: 'pallet_1',
        name: 'EUROPALLET 1',
        quantity: 1,
        dimensions: '130x90x100 cm',
        weight: '245 kg',
        description: 'First europallet containing main tent and accessories',
        level: 1,
        imageAsset: 'assets/images/packing/europallet.png',
      ),
      const PackingListItem(
        id: 'pallet_1_azf4',
        name: 'AZF4 27 WFP',
        quantity: 1,
        dimensions: '',
        weight: '',
        description: 'Main tent structure',
        level: 2,
        parentId: 'pallet_1',
      ),
      const PackingListItem(
        id: 'pallet_1_inner_cabins',
        name: 'BAG FOR INNER CABINS',
        quantity: 1,
        dimensions: '200x20x20 cm',
        weight: '',
        description: 'Inner cabin partitions',
        level: 2,
        parentId: 'pallet_1',
      ),
      const PackingListItem(
        id: 'pallet_1_sun_net',
        name: 'BAG FOR SUN SHADOWING NET',
        quantity: 1,
        dimensions: '200x20x20 cm',
        weight: '',
        description: 'Sun protection net',
        level: 2,
        parentId: 'pallet_1',
      ),

      // EUROPALLET 2
      const PackingListItem(
        id: 'pallet_2',
        name: 'EUROPALLET 2',
        quantity: 1,
        dimensions: '130x90x100 cm',
        weight: '245 kg',
        description: 'Second europallet containing main tent and sun net',
        level: 1,
        imageAsset: 'assets/images/packing/europallet.png',
      ),
      const PackingListItem(
        id: 'pallet_2_azf4',
        name: 'AZF4 27 WFP',
        quantity: 1,
        dimensions: '',
        weight: '',
        description: 'Main tent structure',
        level: 2,
        parentId: 'pallet_2',
      ),
      const PackingListItem(
        id: 'pallet_2_sun_net',
        name: 'BAG FOR SUN SHADOWING NET',
        quantity: 1,
        dimensions: '200x20x20 cm',
        weight: '',
        description: 'Sun protection net',
        level: 2,
        parentId: 'pallet_2',
      ),

      // EUROPALLET 3
      const PackingListItem(
        id: 'pallet_3',
        name: 'EUROPALLET 3',
        quantity: 1,
        dimensions: '130x90x100 cm',
        weight: '245 kg',
        description: 'Third europallet containing main tent and sun net',
        level: 1,
        imageAsset: 'assets/images/packing/europallet.png',
      ),
      const PackingListItem(
        id: 'pallet_3_azf4',
        name: 'AZF4 27 WFP',
        quantity: 1,
        dimensions: '',
        weight: '',
        description: 'Main tent structure',
        level: 2,
        parentId: 'pallet_3',
      ),
      const PackingListItem(
        id: 'pallet_3_sun_net',
        name: 'BAG FOR SUN SHADOWING NET',
        quantity: 1,
        dimensions: '200x20x20 cm',
        weight: '',
        description: 'Sun protection net',
        level: 2,
        parentId: 'pallet_3',
      ),

      // LOGISTIC BOX 1
      const PackingListItem(
        id: 'box_1',
        name: 'LOGISTIC BOX 1',
        quantity: 1,
        dimensions: '115x105x58 cm',
        weight: '95 kg',
        description: 'Logistics box with sun shadowing net',
        level: 1,
        imageAsset: 'assets/images/packing/logistic_box.png',
      ),
      const PackingListItem(
        id: 'box_1_sun_net',
        name: 'SUN SHADOWING NET',
        quantity: 1,
        dimensions: '',
        weight: '',
        description: 'Additional sun protection net',
        level: 2,
        parentId: 'box_1',
      ),

      // LOGISTIC BOX 2
      const PackingListItem(
        id: 'box_2',
        name: 'LOGISTIC BOX 2',
        quantity: 1,
        dimensions: '115x105x58 cm',
        weight: '136 kg',
        description: 'Logistics box with mid and inner liners',
        level: 1,
        imageAsset: 'assets/images/packing/logistic_box.png',
      ),
      const PackingListItem(
        id: 'box_2_mid_liner',
        name: 'MID LINER',
        quantity: 1,
        dimensions: '',
        weight: '',
        description: 'Mid layer insulation liner',
        level: 2,
        parentId: 'box_2',
      ),
      const PackingListItem(
        id: 'box_2_inner_liner',
        name: 'INNER LINER',
        quantity: 1,
        dimensions: '',
        weight: '',
        description: 'Inner insulation liner',
        level: 2,
        parentId: 'box_2',
      ),

      // LOGISTIC BOX 3
      const PackingListItem(
        id: 'box_3',
        name: 'LOGISTIC BOX 3',
        quantity: 1,
        dimensions: '115x105x58 cm',
        weight: '116 kg',
        description: 'Logistics box with vestibules',
        level: 1,
        imageAsset: 'assets/images/packing/logistic_box.png',
      ),
      const PackingListItem(
        id: 'box_3_vestibule',
        name: 'VESTIBULE',
        quantity: 3,
        dimensions: '',
        weight: '',
        description: 'Entry vestibules',
        level: 2,
        parentId: 'box_3',
      ),

      // LOGISTIC BOX 4
      const PackingListItem(
        id: 'box_4',
        name: 'LOGISTIC BOX 4',
        quantity: 1,
        dimensions: '115x105x58 cm',
        weight: '199 kg',
        description: 'Logistics box with staking kit, inflator, and repair kit',
        level: 1,
        imageAsset: 'assets/images/packing/logistic_box.png',
      ),
      const PackingListItem(
        id: 'box_4_staking',
        name: 'AZF4 27 & VESTIBULE STAKING KIT',
        quantity: 3,
        dimensions: '',
        weight: '',
        description: 'Ground anchoring stakes and ropes',
        level: 2,
        parentId: 'box_4',
      ),
      const PackingListItem(
        id: 'box_4_inflator',
        name: 'MANUAL INFLATOR',
        quantity: 3,
        dimensions: '',
        weight: '',
        description: 'Manual pump for tent inflation',
        level: 2,
        parentId: 'box_4',
      ),
      const PackingListItem(
        id: 'box_4_repair',
        name: 'REPAIR KIT',
        quantity: 3,
        dimensions: '',
        weight: '',
        description: 'Emergency repair materials and tools',
        level: 2,
        parentId: 'box_4',
      ),

      // LOGISTIC BOX 5-9 (Empty or TBD in manual)
      const PackingListItem(
        id: 'box_5',
        name: 'LOGISTIC BOX 5',
        quantity: 1,
        dimensions: '115x105x58 cm',
        weight: '',
        description: 'Additional logistics box',
        level: 1,
        imageAsset: 'assets/images/packing/logistic_box.png',
      ),
      const PackingListItem(
        id: 'box_6',
        name: 'LOGISTIC BOX 6',
        quantity: 1,
        dimensions: '115x105x58 cm',
        weight: '',
        description: 'Additional logistics box',
        level: 1,
        imageAsset: 'assets/images/packing/logistic_box.png',
      ),
      const PackingListItem(
        id: 'box_7',
        name: 'LOGISTIC BOX 7',
        quantity: 1,
        dimensions: '115x105x58 cm',
        weight: '',
        description: 'Additional logistics box',
        level: 1,
        imageAsset: 'assets/images/packing/logistic_box.png',
      ),
      const PackingListItem(
        id: 'box_8',
        name: 'LOGISTIC BOX 8',
        quantity: 1,
        dimensions: '115x105x58 cm',
        weight: '',
        description: 'Additional logistics box',
        level: 1,
        imageAsset: 'assets/images/packing/logistic_box.png',
      ),
      const PackingListItem(
        id: 'box_9',
        name: 'LOGISTIC BOX 9',
        quantity: 1,
        dimensions: '115x105x58 cm',
        weight: '',
        description: 'Additional logistics box',
        level: 1,
        imageAsset: 'assets/images/packing/logistic_box.png',
      ),

      // TILES PALLET
      const PackingListItem(
        id: 'tiles_pallet',
        name: 'TILES PALLET',
        quantity: 1,
        dimensions: '80x120x125 cm',
        weight: '180 kg',
        description: 'Hard flooring tiles for tent base',
        level: 1,
        imageAsset: 'assets/images/packing/tiles_pallet.png',
      ),
    ];
  }

  /// Get only main-level items (Level 1)
  static List<PackingListItem> getMainItems() {
    return getPackingList().where((item) => item.level == 1).toList();
  }

  /// Get sub-items for a specific parent
  static List<PackingListItem> getSubItems(String parentId) {
    return getPackingList()
        .where((item) => item.level == 2 && item.parentId == parentId)
        .toList();
  }

  /// Get total number of packages
  static int getTotalPackages() {
    return getMainItems().length;
  }

  /// Get total weight (only items with weight specified)
  static double getTotalWeight() {
    double total = 0;
    for (var item in getPackingList()) {
      if (item.weight != null && item.weight!.isNotEmpty) {
        final weightStr = item.weight!.replaceAll(RegExp(r'[^0-9.]'), '');
        total += double.tryParse(weightStr) ?? 0;
      }
    }
    return total;
  }
}
