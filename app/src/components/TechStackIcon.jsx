import React from 'react';

const TechStackIcon = ({ TechStackIcon, Language, level = 70 }) => {
  return (
    <div className="group p-6 rounded-2xl bg-slate-800/50 hover:bg-slate-700/50 transition-all duration-300 ease-in-out flex flex-col items-center justify-center gap-3 hover:scale-105 cursor-pointer shadow-lg hover:shadow-xl">
      <div className="relative">
        <div className="absolute -inset-1 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full opacity-0 group-hover:opacity-50 blur transition duration-300"></div>
        <img 
          src={TechStackIcon} 
          alt={`${Language} icon`} 
          className="relative h-16 w-16 md:h-20 md:w-20 transform transition-transform duration-300"
        />
      </div>
      <span className="text-slate-300 font-semibold text-sm md:text-base tracking-wide group-hover:text-white transition-colors duration-300">
        {Language}
      </span>
      
      {/* Barre de progression */}
      <div className="w-full mt-2">
        <div className="w-full bg-slate-700/50 rounded-full h-2 overflow-hidden">
          <div 
            className="h-full bg-gradient-to-r from-blue-500 to-purple-500 rounded-full transition-all duration-500 ease-out group-hover:shadow-lg group-hover:shadow-purple-500/50"
            style={{ width: `${level}%` }}
          />
        </div>
        <p className="text-xs text-slate-400 mt-1 text-center">{level}%</p>
      </div>
    </div>
  );
};

export default TechStackIcon; 