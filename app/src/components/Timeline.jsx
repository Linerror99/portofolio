import React, { useEffect, useState } from 'react';
import { GraduationCap, BookOpen, Briefcase, Award, Sparkles } from 'lucide-react';
import AOS from 'aos';
import 'aos/dist/aos.css';

const TimelineItem = ({ icon: Icon, year, title, subtitle, description }) => {
  return (
    <div className="flex-shrink-0 w-full px-4">
      <div 
        className="bg-gradient-to-br from-slate-900/90 to-slate-800/90 backdrop-blur-lg border border-white/10 rounded-2xl p-8 shadow-2xl hover:shadow-purple-500/20 transition-all duration-300 hover:scale-105 h-full"
        data-aos="fade-up"
        data-aos-duration="800"
      >
        <div className="space-y-4">
          {/* Icon */}
          <div className="flex justify-center">
            <div className="relative">
              <div className="absolute -inset-2 bg-gradient-to-r from-[#6366f1] to-[#a855f7] rounded-full blur opacity-50 animate-pulse" />
              <div className="relative w-20 h-20 rounded-full bg-gradient-to-br from-slate-900 to-slate-800 border-4 border-[#6366f1] flex items-center justify-center shadow-2xl">
                <Icon className="w-10 h-10 text-white" />
              </div>
            </div>
          </div>

          {/* Content */}
          <div className="text-center space-y-3">
            <span className="text-base font-semibold text-transparent bg-clip-text bg-gradient-to-r from-[#6366f1] to-[#a855f7]">
              {year}
            </span>
            <h3 className="text-2xl font-bold text-white">
              {title}
            </h3>
            <p className="text-lg text-gray-300 font-medium">
              {subtitle}
            </p>
            <p className="text-base text-gray-400 leading-relaxed">
              {description}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

const Timeline = () => {
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    AOS.init({
      once: false,
    });
  }, []);

  const timelineData = [
    {
      icon: GraduationCap,
      year: "2017-2018",
      title: "Baccalauréat Scientifique",
      subtitle: "Lycée - Bénin",
      description: "Obtention du Baccalauréat série C avec mention, première étape vers une carrière d'ingénieur."
    },
    {
      icon: BookOpen,
      year: "2018-2020",
      title: "Classes Préparatoires",
      subtitle: "CPGE - 2 ans",
      description: "Deux années intensives de classes préparatoires scientifiques pour préparer les concours d'écoles d'ingénieurs."
    },
    {
      icon: Briefcase,
      year: "2020",
      title: "Stage Technique",
      subtitle: "Première expérience professionnelle",
      description: "Découverte du monde professionnel et mise en pratique des connaissances acquises."
    },
    {
      icon: Award,
      year: "2020-2021",
      title: "Cycle Ingénieur - 1ère année",
      subtitle: "Formation Classique",
      description: "Première année du cycle ingénieur en formation initiale, spécialisation progressive vers le Cloud & DevOps."
    },
    {
      icon: Sparkles,
      year: "2021-2023",
      title: "Cycle Ingénieur - 2ème & 3ème années",
      subtitle: "Formation en Alternance",
      description: "Deux années en alternance permettant d'allier théorie et pratique professionnelle en Cloud Computing et DevOps."
    }
  ];

  // Auto-scroll toutes les 5 secondes
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentIndex((prevIndex) => (prevIndex + 1) % timelineData.length);
    }, 5000);

    return () => clearInterval(interval);
  }, [timelineData.length]);

  // Créer un tableau étendu pour le défilement continu
  const extendedData = [...timelineData, ...timelineData, ...timelineData];

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
            Parcours de Formation
          </h2>
        </div>
        <p 
          className="mt-4 text-gray-400 max-w-2xl mx-auto text-base sm:text-lg flex items-center justify-center gap-2"
          data-aos="zoom-in-up"
          data-aos-duration="800"
        >
          <Sparkles className="w-5 h-5 text-purple-400" />
          Mon chemin vers l'excellence en Cloud & DevOps
          <Sparkles className="w-5 h-5 text-purple-400" />
        </p>
      </div>

      {/* Timeline Container */}
      <div className="relative max-w-7xl mx-auto">
        {/* Gradient overlays pour effet de fondu sur les côtés */}
        <div className="absolute left-0 top-0 bottom-0 w-10 bg-gradient-to-r from-[#030014] to-transparent z-10 pointer-events-none" />
        <div className="absolute right-0 top-0 bottom-0 w-10 bg-gradient-to-l from-[#030014] to-transparent z-10 pointer-events-none" />
        
        {/* Timeline Items - Défilement continu */}
        <div className="overflow-hidden">
          <div 
            className="flex transition-transform duration-1000 ease-in-out"
            style={{
              transform: `translateX(-${(currentIndex % timelineData.length) * (100 / 3)}%)`
            }}
          >
            {extendedData.map((item, index) => (
              <div key={`timeline-${index}`} className="w-full md:w-1/3 flex-shrink-0">
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
                (currentIndex % timelineData.length) === index
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
