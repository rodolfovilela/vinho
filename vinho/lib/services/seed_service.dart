import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vinho/services/firestore_service.dart';

class SeedService {
  static Future<void> seedEvents() async {
    final firestore = FirestoreService();

    // Clear existing events
    final snapshot = await firestore.events.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // Add mocked events
    /*  for (var event in mockedEvents) {
      await firestore.events.add(event.toJson());
    }

    print('✅ Seeded ${mockedEvents.length} events to Firestore'); */
  }

  static Future<void> disableEvents() async {
    final firestore = FirestoreService();

    // Clear existing events
    final snapshot = await firestore.events.get();
    for (var doc in snapshot.docs) {
      await doc.reference.update({"status": "I"});
    }

    print('✅ Disabled ${snapshot.docs.length} events in Firestore');
  }

  static const portugalLocations = {
    'AVEIRO': [
      'Águeda',
      'Albergaria-a-Velha',
      'Anadia',
      'Arouca',
      'Aveiro',
      'Castelo de Paiva',
      'Espinho',
      'Estarreja',
      'Ílhavo',
      'Mealhada',
      'Murtosa',
      'Oliveira de Azeméis',
      'Oliveira do Bairro',
      'Ovar',
      'Santa Maria da Feira',
      'São João da Madeira',
      'Sever do Vouga',
      'Vagos',
      'Vale de Cambra'
    ],
    'BEJA': [
      'Aljustrel',
      'Almodôvar',
      'Alvito',
      'Barrancos',
      'Beja',
      'Castro Verde',
      'Cuba',
      'Ferreira do Alentejo',
      'Mértola',
      'Moura',
      'Odemira',
      'Ourique',
      'Serpa',
      'Vidigueira'
    ],
    'BRAGA': [
      'Amares',
      'Barcelos',
      'Braga',
      'Cabeceiras de Basto',
      'Celorico de Basto',
      'Esposende',
      'Fafe',
      'Guimarães',
      'Póvoa de Lanhoso',
      'Terras de Bouro',
      'Vieira do Minho',
      'Vila Nova de Famalicão',
      'Vizela'
    ],
    'BRAGANCA': [
      'Alfândega da Fé',
      'Bragança',
      'Carrazeda de Ansiães',
      'Freixo de Espada à Cinta',
      'Macedo de Cavaleiros',
      'Miranda do Douro',
      'Mirandela',
      'Mogadouro',
      'Torre de Moncorvo',
      'Vila Flor',
      'Vimioso',
      'Vinhais'
    ],
    'CASTELO BRANCO': [
      'Belmonte',
      'Castelo Branco',
      'Covilhã',
      'Fundão',
      'Idanha-a-Nova',
      'Oleiros',
      'Penamacor',
      'Proença-a-Nova',
      'Sertã',
      'Vila de Rei',
      'Vila Velha de Ródão'
    ],
    'COIMBRA': [
      'Arganil',
      'Cantanhede',
      'Coimbra',
      'Condeixa-a-Nova',
      'Figueira da Foz',
      'Góis',
      'Lousã',
      'Mira',
      'Miranda do Corvo',
      'Montemor-o-Velho',
      'Oliveira do Hospital',
      'Pampilhosa da Serra',
      'Penacova',
      'Penela',
      'Soure',
      'Tábua',
      'Vila Nova de Poiares'
    ],
    'EVORA': [
      'Alandroal',
      'Arraiolos',
      'Borba',
      'Estremoz',
      'Évora',
      'Montemor-o-Novo',
      'Mora',
      'Mourão',
      'Portel',
      'Redondo',
      'Reguengos de Monsaraz',
      'Vendas Novas',
      'Viana do Alentejo',
      'Vila Viçosa'
    ],
    'FARO': [
      'Albufeira',
      'Alcoutim',
      'Aljezur',
      'Castro Marim',
      'Faro',
      'Lagoa',
      'Lagos',
      'Loulé',
      'Monchique',
      'Olhão',
      'Portimão',
      'São Brás de Alportel',
      'Silves',
      'Tavira',
      'Vila do Bispo',
      'Vila Real de Santo António'
    ],
    'GUARDA': [
      'Aguiar da Beira',
      'Almeida',
      'Celorico da Beira',
      'Figueira de Castelo Rodrigo',
      'Fornos de Algodres',
      'Gouveia',
      'Guarda',
      'Manteigas',
      'Meda',
      'Pinhel',
      'Sabugal',
      'Seia',
      'Trancoso',
      'Vila Nova de Foz Côa'
    ],
    'LEIRIA': [
      'Alcobaça',
      'Alvaiázere',
      'Ansião',
      'Batalha',
      'Bombarral',
      'Caldas da Rainha',
      'Castanheira de Pera',
      'Figueiró dos Vinhos',
      'Leiria',
      'Marinha Grande',
      'Nazaré',
      'Óbidos',
      'Pedrógão Grande',
      'Peniche',
      'Pombal',
      'Porto de Mós'
    ],
    'LISBOA': [
      'Alenquer',
      'Amadora',
      'Arruda dos Vinhos',
      'Azambuja',
      'Cadaval',
      'Cascais',
      'Lisboa',
      'Loures',
      'Lourinhã',
      'Mafra',
      'Odivelas',
      'Oeiras',
      'Sintra',
      'Sobral de Monte Agraço',
      'Torres Vedras',
      'Vila Franca de Xira'
    ],
    'PORTALEGRE': [
      'Alter do Chão',
      'Arronches',
      'Avis',
      'Campo Maior',
      'Castelo de Vide',
      'Crato',
      'Elvas',
      'Fronteira',
      'Gavião',
      'Marvão',
      'Monforte',
      'Nisa',
      'Ponte de Sor',
      'Portalegre',
      'Sousel'
    ],
    'PORTO': [
      'Amarante',
      'Baião',
      'Felgueiras',
      'Gondomar',
      'Lousada',
      'Maia',
      'Marco de Canaveses',
      'Matosinhos',
      'Paços de Ferreira',
      'Paredes',
      'Penafiel',
      'Porto',
      'Póvoa de Varzim',
      'Santo Tirso',
      'Trofa',
      'Valongo',
      'Vila do Conde',
      'Vila Nova de Gaia'
    ],
    'SANTAREM': [
      'Abrantes',
      'Alcanena',
      'Almeirim',
      'Alpiarça',
      'Benavente',
      'Cartaxo',
      'Chamusca',
      'Constância',
      'Coruche',
      'Entroncamento',
      'Ferreira do Zêzere',
      'Golegã',
      'Mação',
      'Ourém',
      'Rio Maior',
      'Salvaterra de Magos',
      'Santarém',
      'Sardoal',
      'Tomar',
      'Torres Novas',
      'Vila Nova da Barquinha'
    ],
    'SETUBAL': [
      'Alcácer do Sal',
      'Almada',
      'Barreiro',
      'Grândola',
      'Moita',
      'Montijo',
      'Palmela',
      'Santiago do Cacém',
      'Seixal',
      'Sesimbra',
      'Setúbal'
    ],
    'VIANA DO CASTELO': [
      'Arcos de Valdevez',
      'Caminha',
      'Melgaço',
      'Monção',
      'Paredes de Coura',
      'Ponte da Barca',
      'Ponte de Lima',
      'Valença',
      'Viana do Castelo',
      'Vila Nova de Cerveira'
    ],
    'VILA REAL': [
      'Alijó',
      'Boticas',
      'Chaves',
      'Mesão Frio',
      'Mondim de Basto',
      'Montalegre',
      'Murça',
      'Peso da Régua',
      'Ribeira de Pena',
      'Sabrosa',
      'Santa Marta de Penaguião',
      'Valpaços',
      'Vila Pouca de Aguiar',
      'Vila Real'
    ],
    'VISEU': [
      'Armamar',
      'Carregal do Sal',
      'Castro Daire',
      'Cinfães',
      'Lamego',
      'Mangualde',
      'Moimenta da Beira',
      'Mortágua',
      'Nelas',
      'Oliveira de Frades',
      'Penalva do Castelo',
      'Penedono',
      'Resende',
      'Santa Comba Dão',
      'São João da Pesqueira',
      'São Pedro do Sul',
      'Sátão',
      'Sernancelhe',
      'Tabuaço',
      'Tarouca',
      'Tondela',
      'Vila Nova de Paiva',
      'Viseu',
      'Vouzela'
    ]
  };

  static Future<void> seedLocations() async {
    final firestore = FirebaseFirestore.instance;
   /*  final countryRef = firestore.collection('locations').doc('PT');

    await countryRef.set({
      'country': 'Portugal',
      'code': 'PT',
    });

    final batch = firestore.batch();

    for (final entry in portugalLocations.entries) {
      final districtCode = entry.key;

      final districtRef = countryRef.collection('districts').doc(districtCode);

      batch.set(districtRef, {
        'code': districtCode,
        'name': _formatName(districtCode),
      });

      for (final municipality in entry.value) {
        final id = municipality
            .toUpperCase()
            .replaceAll(' ', '_')
            .replaceAll('Á', 'A')
            .replaceAll('É', 'E')
            .replaceAll('Í', 'I')
            .replaceAll('Ó', 'O')
            .replaceAll('Ú', 'U')
            .replaceAll('Ç', 'C');

        final munRef = districtRef.collection('municipalities').doc(id);

        batch.set(munRef, {
          'name': municipality,
          'districtCode': districtCode,
        });
      }
    }

    await batch.commit(); */

    await firestore
        .collection('config')
        .doc('locations')
        .set(portugalLocations);

    print('✅ FULL Portugal locations seeded');
  }

  /* static Future<void> seedLocations() async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('config').doc('locations');

    // 🔥 opcional: normalizar keys
    final normalized = {
      for (final entry in portugalLocations.entries)
        entry.key.toUpperCase(): entry.value
            .map((m) => {
                  'name': m,
                  'search': normalize(m),
                })
            .toList(),
    };

    await docRef.set({
      'country': 'Portugal',
      'code': 'PT',
      'districts': normalized,
    });

    print('✅ Locations seeded (single document)');
  }
 */

  static String _formatName1(String code) {
    return code
        .toLowerCase()
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  static String normalize(String input) {
    return input
        .toUpperCase()
        .replaceAll(' ', '_')
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ç', 'C');
  }

  static String _formatName(String code) {
    return code[0] + code.substring(1).toLowerCase();
  }
}
