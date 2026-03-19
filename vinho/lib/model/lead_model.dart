import 'package:flutter/material.dart';

class LeadModel {
  final String title;
  final String description;
  final IconData? icon;
  final Widget? image;
  final String? route;

  const LeadModel({
    required this.title,
    required this.description,
    this.icon,
    this.image,
    this.route,
  });
}

List<LeadModel> leads = [
 /*  LeadModel(
    title: 'Nossa comunidade',
    description: 'O vinho é mais do que uma bebida: é para partilhar.',
    image: Image.asset(
      "assets/images/glass.png",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(),
    ),
    // icon: Icons.wine_bar,
    //route: '/leads',
  ), */
  LeadModel(
    title: 'Nossa missão',
    description:
        'Conectar pessoas, espaços e talentos e criar uma comunidade <b>onde o vinho</b> acontece.',
    icon: Icons.adjust_outlined,
    //  route: '/leads',
  ),
  LeadModel(
    title: 'Seja o local do próximo evento',
    description:
        'Tens um restaurante, bar ou espaço comercial e queres receber um dos nossos eventos?<br/><br/>Escreve-nos para hosts@ondeovinho.com e vamos falar sobre o teu espaço.',
    icon: Icons.storefront_outlined,
    //route: '/leads',
  ),
  LeadModel(
    title: 'Para profissionais',
    description:
        'Se és um escanção e queres partilhar seus conhecimentos e paixão pelo vinho, ofereça seu evento para a nossa comunidade.<br/><br/>Mostra-nos a tua paixão pelo vinho: partilha o teu conhecimento e propõe o teu evento por email.<br/>Escreve-nos para sommelier@ondeovinho.com',
    icon: Icons.work_outline,
    // route: '/reports',
  ),
];
