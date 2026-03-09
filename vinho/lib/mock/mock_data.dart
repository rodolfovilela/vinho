import 'package:vinho/model/event_model.dart';

List<EventModel> get mockedEvents => List.from(<EventModel>[
      EventModel(
        id: 1,
        title: "Degustação Descobre",
        desc: "Degustação de 5 vinhos no Restaurante Descobre",
        order: 1,
        date: "07 jan",
        time: "15h - 17h30",
        location: "Restaurante Descobre (Belém)",
        paxPrice: 25,
        availableSeats: 10,
      ),
      EventModel(
        id: 2,
        title: "Workshop de Harmonização",
        desc: "Para quem se interessa em harmonizar vinho com comidas de natal",
        order: 2,
        date: "06 jan",
        time: "20h - 21h30",
        location: "Pizzaria Chica Pimenta (Charneca de Caparica)",
        paxPrice: 25,
        availableSeats: 2,
      ),
      EventModel(
        id: 3,
        title: "Especial Beira Interior",
        desc:
            "Degustação aprofundada na região dos vinhos de altitude da Beira Interior",
        order: 3,
        image: "/mock/bi.jpg",
        date: "10 jan",
        time: "18h30 - 22h",
        location: "Restaurante A Caldeira (Charneca de Caparica)",
        paxPrice: 25,
        availableSeats: 3,
      ),
      EventModel(
          title: "Lisbon Urban Wine Tourism – Enoturismo Urbano",
          desc:
              "Evento dedicado ao enoturismo urbano em Lisboa, com provas e visitas às vinhas urbanas da cidade e conversas sobre vinho urbano.",
          date: "13-12-2025",
          time: "17:00–00:00",
          location: "Fábrica do Pão, Beato Innovation District, Lisboa",
          region: "Lisboa",
          paxPrice: 25,
          availableSeats: 40),
      EventModel(
        title: "Experiência Casal Garcia",
        desc:
            "Experiência de enoturismo com provas e atividades relacionadas aos vinhos Casal Garcia.",
        date: "30-12-2025",
        time: "11:00–16:00",
        location: "Quinta da Aveleda, V.N. de Gaia",
        region: "Norte",
        paxPrice: 25,
        availableSeats: 10,
      ),
      EventModel(
        title: "Vinho na Vila 2026",
        desc:
            "Evento vínico e gastronômico em Vila Alva (Alentejo), reunindo produtores locais com provas de vinhos, rota de petiscos e atividades culturais.",
        date: "09-05-2026",
        time: "14:30–22:00",
        location: "Vila Alva, Cuba, Alentejo",
        region: "Alentejo",
        paxPrice: 25,
        availableSeats: 234,
      ),
      EventModel(
        title: "Essência do Vinho — Porto",
        desc:
            "O principal festival de vinho de Portugal, com mais de 400 produtores e milhares de vinhos para provar, além de masterclasses e programação profissional e para público.",
        date: "26-02-2026 a 01-03-2026",
        time: "Variável",
        location: "Palácio da Bolsa, Porto",
        region: "Norte",
        paxPrice: 25,
        availableSeats: 5,
      ),
      EventModel(
        title: "Porto and Douro Valley Festival",
        desc:
            "Festival organizado pela International Wine & Food Society com provas, gastronomia e imersões vínicas no Porto e no Douro.",
        date: "06-05-2026 a 11-05-2026",
        time: "Variável",
        location: "Porto e Douro Valley",
        region: "Norte",
        paxPrice: 25,
        availableSeats: 189,
      ),
      EventModel(
          title: "Douro & Porto Wine Festival",
          desc:
              "Festival vínico e gastronômico com música, degustações e atividades nas margens do Douro.",
          date: "03-07-2026 a 04-07-2026",
          time: "Variável",
          location: "Porto Comercial de Cambres – Lamego",
          region: "Douro"),
      EventModel(
          title: "Feira do Alvarinho",
          desc:
              "Uma das maiores festas de vinho em Portugal, dedicada ao Alvarinho, com degustações, gastronomia e música.",
          date: "02-07-2026 a 05-07-2026",
          time: "Variável",
          location: "Parque das Caldas, Monção",
          region: "Norte"),
      EventModel(
          title: "Feira do Vinho Verde",
          desc:
              "Celebração dos vinhos verdes com provas e gastronomia na região de Castelo de Paiva.",
          date: "Primeiro fim de semana de Julho de 2026",
          time: "Variável",
          location: "Castelo de Paiva",
          region: "Norte"),
      EventModel(
          title: "ÉvoraWine – Alentejo Wine Festival",
          desc:
              "Maior festival de vinho do Alentejo com dezenas de produtores e centenas de vinhos, gastronomia local e música.",
          date: "Maio de 2026 (fim de semana)",
          time: "Variável",
          location: "Praça do Giraldo, Évora",
          region: "Alentejo"),
      EventModel(
          title: "Palmela’s Harvest Festival / Festa das Vindimas",
          desc:
              "Festival tradicional de vindimas em Palmela, com provas e celebração das colheitas de Moscatel de Setúbal.",
          date: "Setembro de 2026 (primeira semana)",
          time: "Variável",
          location: "Palmela, Setúbal",
          region: "Sul"),
      EventModel(
          title: "Wine & Beats – Quinta dos Vales",
          desc:
              "Prova de vinhos com música ao vivo, sabores regionais e ambiente festivo no Algarve.",
          date: "13-12-2025",
          time: "14:00–19:00",
          location: "Quinta dos Vales, Estômbar",
          region: "Algarve"),
      EventModel(
          title: "Simplesmente Vinho (esperado em 2026)",
          desc:
              "Feira alternativa de vinhos artesanais com produtores focados em tradição e terroir, normalmente realizada no Porto.",
          date: "A confirmar 2026",
          time: "Variável",
          location: "Porto",
          region: "Norte"),
      EventModel(
          title: "Enóphilo Wine Fest (edições regionais)",
          desc:
              "Eventos vínicos em várias cidades como Lisboa, Porto, Braga e Coimbra com dezenas de produtores selecionados.",
          date: "Datas variadas 2026",
          time: "Variável",
          location: "Diversas cidades em Portugal",
          region: "Portugal"),
      EventModel(
          title: "Collage Workshop & Wine Tasting",
          desc:
              "Workshop criativo com degustação de vinhos festivos, combinando arte e vinho numa experiência social descontraída.",
          date: "19-12-2025",
          time: "19:00",
          location: "Clueless Wines, Rua Tenente Ferreira Durão 62B, Lisboa",
          region: "Lisboa"),
      EventModel(
          title: "Christmas Wine Tasting at Clueless Wines",
          desc:
              "Prova guiada de vinhos especialmente selecionados para a época natalícia, com notas explicativas e harmonizações sazonais.",
          date: "23-12-2025",
          time: "16:00–19:00",
          location: "Clueless Wines, Rua Tenente Ferreira Durão 62B, Lisboa",
          region: "Lisboa"),
      EventModel(
          title: "1933 Wine & Spirits – MasterClass Vinho da Madeira",
          desc:
              "Masterclass de vinhos da Madeira com degustação de vários estilos clássicos, organizada pela Garrafeira Nacional.",
          date: "18-12-2025",
          time: "18:00–19:30",
          location:
              "1933 Wine & Spirits by Garrafeira Nacional, Hotel Tivoli Avenida Liberdade, Lisboa",
          region: "Lisboa"),
      EventModel(
          title: "Prova de Vinhos Quinta Dona Sancha",
          desc:
              "Degustação de vinhos da Quinta Dona Sancha em ambiente de prova comentada.",
          date: "18-12-2025",
          time: "18:30–20:30",
          location: "Cave Lusa Premium, Lisboa",
          region: "Lisboa"),
      EventModel(
          title: "Festa do Vinho do Cartaxo",
          desc:
              "Festival anual de vinhos e cultura local, tradicionalmente em abril/maio.",
          date: "Esperada 2026",
          time: "Variável",
          location: "Cartaxo, Ribatejo",
          region: "Ribatejo"),
      EventModel(
          title: "Festa da Vinha e do Vinho (Borba)",
          desc:
              "Celebração de vindimas e vinho alentejano com provas e gastronomia.",
          date: "Esperada 2026",
          time: "Variável",
          location: "Borba, Alentejo",
          region: "Alentejo"),
      EventModel(
          title: "Festa da Vinha e do Vinho (Arruda dos Vinhos)",
          desc: "Celebração vitivinícola com provas e eventos culturais.",
          date: "Esperada 2026",
          time: "Variável",
          location: "Arruda dos Vinhos, Lisboa",
          region: "Lisboa"),
      EventModel(
          title: "Salão Nacional de Vinhos & Gastronomia",
          desc:
              "Parte de festival gastronómico com provas de vinhos regionais.",
          date: "Esperada 2026",
          time: "Variável",
          location: "Santarém",
          region: "Ribatejo"),
      EventModel(
          title: "Dia Internacional da Baga / Baga nas 8 Quintas",
          desc: "Evento vínico em Bairrada com provas em várias quintas.",
          date: "Esperada 2026",
          time: "Variável",
          location: "Bairrada, Centro",
          region: "Centro"),
      EventModel(
          title: "Wine and Classics (Maia)",
          desc: "Mostra de vinhos alinhada com temáticas culturais.",
          date: "Esperada 2026",
          time: "Variável",
          location: "Maia, Porto",
          region: "Norte"),
      EventModel(
          title: "Festival do Vinho do Douro Superior",
          desc: "Provas de produtores num contexto festivo.",
          date: "Esperada 2026",
          time: "Variável",
          location: "Douro Superior, Norte",
          region: "Douro")
    ]);
