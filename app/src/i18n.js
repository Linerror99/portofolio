import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';

// Import translations
import commonFr from './locales/fr/common.json';
import commonEn from './locales/en/common.json';
import homeFr from './locales/fr/home.json';
import homeEn from './locales/en/home.json';
import aboutFr from './locales/fr/about.json';
import aboutEn from './locales/en/about.json';
import timelineFr from './locales/fr/timeline.json';
import timelineEn from './locales/en/timeline.json';
import contactFr from './locales/fr/contact.json';
import contactEn from './locales/en/contact.json';
import portfolioFr from './locales/fr/portfolio.json';
import portfolioEn from './locales/en/portfolio.json';

i18n
  .use(LanguageDetector) // Détecte la langue du navigateur
  .use(initReactI18next) // Passe i18n à react-i18next
  .init({
    resources: {
      fr: {
        common: commonFr,
        home: homeFr,
        about: aboutFr,
        timeline: timelineFr,
        contact: contactFr,
        portfolio: portfolioFr,
      },
      en: {
        common: commonEn,
        home: homeEn,
        about: aboutEn,
        timeline: timelineEn,
        contact: contactEn,
        portfolio: portfolioEn,
      },
    },
    fallbackLng: 'fr', // Langue par défaut
    debug: false,
    interpolation: {
      escapeValue: false, // React échappe déjà les valeurs
    },
    detection: {
      order: ['localStorage', 'navigator'],
      caches: ['localStorage'],
    },
  });

export default i18n;
