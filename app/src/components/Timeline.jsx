import React, { useEffect, useState } from 'react';
import { GraduationCap, BookOpen, Briefcase, Award, Sparkles, ChevronLeft, ChevronRight } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import AOS from 'aos';
import 'aos/dist/aos.css';

const TimelineItem = ({ icon: Icon, image, year, title, subtitle, description, items = [] }) => {
  return (
    <div className="flex-shrink-0 w-full px-4 h-full">
      <div 
        className="bg-gradient-to-br from-slate-900/90 to-slate-800/90 backdrop-blur-lg border border-white/10 rounded-2xl p-6 shadow-2xl hover:shadow-purple-500/20 transition-all duration-300 hover:scale-105 h-full flex flex-col"
        data-aos="fade-up"
        data-aos-duration="800"
      >
        <div className="space-y-4 flex flex-col h-full">
          {/* Icon or Image */}
          <div className="flex justify-center">
            <div className="relative">
              <div className="absolute -inset-2 bg-gradient-to-r from-[#6366f1] to-[#a855f7] rounded-full blur opacity-50 animate-pulse" />
              <div className="relative w-16 h-16 rounded-full bg-gradient-to-br from-slate-900 to-slate-800 border-4 border-[#6366f1] flex items-center justify-center shadow-2xl overflow-hidden">
                {image ? (
                  <img src={image} alt={title} className="w-full h-full object-cover rounded-full" />
                ) : (
                  <Icon className="w-8 h-8 text-white" />
                )}
              </div>
            </div>
          </div>

          {/* Content */}
          <div className="text-center space-y-3 flex-grow flex flex-col">
            <span className="inline-block self-center px-3 py-1 text-xs font-semibold text-transparent bg-clip-text bg-gradient-to-r from-[#6366f1] to-[#a855f7] bg-white/5 rounded-full border border-white/10">
              {year}
            </span>
            <h3 className="text-lg font-bold text-white leading-tight">
              {title}
            </h3>
            <p className="text-sm text-gray-300 font-medium leading-relaxed">
              {subtitle}
            </p>
            
            {/* Liste à puces si items fournis, sinon description normale */}
            {items && items.length > 0 ? (
              <ul className="text-xs text-gray-400 leading-relaxed text-left space-y-1.5 px-4">
                {items.map((item, idx) => (
                  <li key={idx} className="flex items-start">
                    <span className="text-[#6366f1] mr-2 flex-shrink-0 mt-1">•</span>
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-xs text-gray-400 leading-relaxed text-justify px-2">
                {description}
              </p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

const Timeline = () => {
  const { t } = useTranslation('timeline');
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    AOS.init({
      once: false,
    });
  }, []);

  const translatedItems = t('items', { returnObjects: true });
  const timelineData = translatedItems.map((item, index) => ({
    ...item,
    image: ["/timeline/capgemini.jpg", "/timeline/cycle-ingenieur.jpg", "/timeline/stage-sbin.jpg", "/timeline/esigelec-prepa.jpg"][index]
  }));

  // Fonctions de navigation
  const goToPrevious = () => {
    setCurrentIndex((prevIndex) => Math.max(0, prevIndex - 1));
  };

  const goToNext = () => {
    setCurrentIndex((prevIndex) => Math.min(timelineData.length - 1, prevIndex + 1));
  };

  return (
    <div className="min-h-screen bg-[#030014] px-[5%] sm:px-[5%] lg:px-[10%] py-20 overflow-hidden" id="Formation">
      {/* Header */}
      <div className="text-center mb-16">
        <div className="inline-block relative group">
          <h2 
            className="text-4xl md:text-5xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-[#6366f1] to-[#a855f7]" 
            data-aos="zoom-in-up"
            data-aos-duration="600"
          >
            {t('title')}
          </h2>
        </div>
        <p 
          className="mt-4 text-gray-400 max-w-2xl mx-auto text-base sm:text-lg flex items-center justify-center gap-2"
          data-aos="zoom-in-up"
          data-aos-duration="800"
        >
          <Sparkles className="w-5 h-5 text-purple-400" />
          {t('subtitle')}
          <Sparkles className="w-5 h-5 text-purple-400" />
        </p>
      </div>

      {/* Timeline Container */}
      <div className="relative max-w-7xl mx-auto">
        {/* Bouton précédent */}
        <button
          onClick={goToPrevious}
          className="absolute left-0 top-1/2 -translate-y-1/2 z-20 bg-gradient-to-r from-[#6366f1] to-[#a855f7] p-3 rounded-full shadow-lg hover:scale-110 transition-all duration-300 hover:shadow-purple-500/50"
          aria-label={t('navigation.previous')}
        >
          <ChevronLeft className="w-6 h-6 text-white" />
        </button>

        {/* Bouton suivant */}
        <button
          onClick={goToNext}
          className="absolute right-0 top-1/2 -translate-y-1/2 z-20 bg-gradient-to-r from-[#6366f1] to-[#a855f7] p-3 rounded-full shadow-lg hover:scale-110 transition-all duration-300 hover:shadow-purple-500/50"
          aria-label={t('navigation.next')}
        >
          <ChevronRight className="w-6 h-6 text-white" />
        </button>
        
        {/* Timeline Items */}
        <div className="overflow-hidden px-16" style={{ height: '480px' }}>
          <div 
            className="flex h-full transition-transform duration-1000 ease-in-out"
            style={{
              transform: `translateX(-${currentIndex * (100 / 3)}%)`
            }}
          >
            {timelineData.map((item, index) => (
              <div key={`timeline-${index}`} className="w-full md:w-1/3 flex-shrink-0 h-full">
                <TimelineItem {...item} />
              </div>
            ))}
          </div>
        </div>

        {/* Indicateurs de pagination */}
        <div className="flex justify-center gap-2 mt-8">
          {timelineData.map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentIndex(index)}
              className={`h-2 rounded-full transition-all duration-300 ${
                currentIndex === index
                  ? 'w-8 bg-gradient-to-r from-[#6366f1] to-[#a855f7]' 
                  : 'w-2 bg-white/20 hover:bg-white/40'
              }`}
              aria-label={`Go to slide ${index + 1}`}
            />
          ))}
        </div>
      </div>
    </div>
  );
};

export default Timeline;
