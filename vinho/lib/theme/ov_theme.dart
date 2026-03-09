import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OVTheme {
  /*
  {
  "typography": {
    "titles": {
      "fontFamily": "Outrun Bold",
      "fontWeight": "700",
      "usage": "Page titles, headers, section titles"
    },
    "subtitles": {
      "fontFamily": "VCR OSD Mono",
      "fontWeight": "400",
      "usage": "Labels, filters, category names"
    },
    "body": {
      "fontFamily": "Inter",
      "fontWeight": "400",
      "usage": "Paragraphs, descriptions, long text"
    },
    "numeric": {
      "fontFamily": "DS-Digital",
      "fontWeight": "400",
      "usage": "Dates, distances, timers, XP counters"
    }
  },

  "colors": {
    "base": {
      "blackRetro": "#0A0A0F",
      "blueNight": "#001F3F"
    },
    "neon": {
      "purpleNeon": "#8A2BE2",
      "magentaNeon": "#FF009D",
      "electricBlue": "#00C9FF",
      "pinkGlow": "#FF6EC7"
    },
    "accent": {
      "sunsetOrange": "#FF7A00",
      "neonYellow": "#FFE600"
    },
    "neutral": {
      "vaporwaveGray": "#2A2A3A",
      "lightGray": "#D7D7E0"
    }
  },

  "spacing": {
    "xs": 4,
    "sm": 8,
    "md": 16,
    "lg": 24,
    "xl": 32
  },

  "radius": {
    "button": 12,
    "card": 16,
    "input": 10
  },

  "shadows": {
    "neonGlowPrimary": "0px 0px 12px #8A2BE2",
    "neonGlowSecondary": "0px 0px 18px #00C9FF"
  },

  "gradients": {
    "outrunPurple": ["#2A0066", "#8A2BE2"],
    "laserBlue": ["#001F3F", "#00C9FF"]
  },

  "components": {
    "button": {
      "primary": {
        "background": "#00C9FF",
        "textColor": "#0A0A0F",
        "shadow": "0px 0px 12px #00C9FF"
      },
      "secondary": {
        "border": "2px solid #8A2BE2",
        "textColor": "#8A2BE2",
        "background": "transparent"
      },
      "tertiary": {
        "textColor": "#FF009D",
        "background": "transparent"
      }
    },

    "card": {
      "background": "#0A0A0F",
      "border": "1px solid #8A2BE2",
      "radius": 16,
      "shadow": "0px 0px 8px #8A2BE2"
    },

    "input": {
      "background": "transparent",
      "borderBottom": "2px solid #00C9FF",
      "placeholderColor": "#D7D7E0"
    },

    "tabs": {
      "active": {
        "background": "#00C9FF",
        "textColor": "#0A0A0F"
      },
      "inactive": {
        "background": "#2A2A3A",
        "textColor": "#D7D7E0"
      }
    }
  }
}

*/
  static double wideLayoutBreakpoint = 600.0;

  static const Color blackRetro = Color.fromRGBO(10, 10, 15, 1);
  static const Color blueNight = Color.fromRGBO(0, 31, 63, 1);
  static const Color lightGray = Color.fromRGBO(215, 215, 224, 1);
  static const Color purpleNeon = Color.fromRGBO(138, 43, 226, 1);
  static const Color magentaNeon = Color.fromRGBO(255, 0, 157, 1);
  static const Color electricBlue = Color.fromRGBO(0, 201, 255, 1);
  static const Color pinkGlow = Color.fromRGBO(255, 110, 199, 1);
  static const Color sunsetOrange = Color.fromRGBO(255, 122, 0, 1);
  static const Color neonYellow = Color.fromRGBO(255, 230, 0, 1);
  static const Color vaporwaveGray = Color.fromRGBO(42, 42, 58, 1);
  static const Color deepPurple = Color.fromRGBO(27, 11, 54, 1);


  static const Color backgroundColor = Color.fromRGBO(250, 248, 245, 1);
  static const Color primaryColor = Color.fromRGBO(45, 24, 16, 1);
  static const Color muted = Color.fromRGBO(112, 93, 82, 1);
  static const Color semiTransparent = Color.fromRGBO(109, 77, 58, 0.15);
  static const Color primaryBlack = Color.fromRGBO(45, 24, 16, 1);
  static const Color primaryRed = Color.fromRGBO(107, 40, 52, 1);
  

  static TextStyle bodyBase = GoogleFonts.lato(
    color: OVTheme.vaporwaveGray
  );
  static TextStyle titlesBase = GoogleFonts.playfair(
    color: OVTheme.vaporwaveGray
  );
}
