import React, { useState, useEffect, useCallback, useRef } from "react";
import { ChevronLeft, ChevronRight, X, ZoomIn } from "lucide-react";

const ScreenshotCarousel = ({ screenshots = [], projectTitle = "" }) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isFullscreen, setIsFullscreen] = useState(false);
  const [isPaused, setIsPaused] = useState(false);
  const intervalRef = useRef(null);

  const totalSlides = screenshots.length;

  useEffect(() => {
    if (totalSlides <= 1 || isPaused) return;
    intervalRef.current = setInterval(() => {
      setCurrentIndex((prev) => (prev + 1) % totalSlides);
    }, 4000);
    return () => clearInterval(intervalRef.current);
  }, [totalSlides, isPaused, currentIndex]);

  useEffect(() => {
    if (!isFullscreen) return;
    const handleKey = (e) => {
      if (e.key === "Escape") setIsFullscreen(false);
      if (e.key === "ArrowRight") setCurrentIndex((prev) => (prev + 1) % totalSlides);
      if (e.key === "ArrowLeft") setCurrentIndex((prev) => (prev - 1 + totalSlides) % totalSlides);
    };
    window.addEventListener("keydown", handleKey);
    return () => window.removeEventListener("keydown", handleKey);
  }, [isFullscreen, totalSlides]);

  const goTo = useCallback((index) => setCurrentIndex(index), []);
  const goNext = useCallback(() => setCurrentIndex((prev) => (prev + 1) % totalSlides), [totalSlides]);
  const goPrev = useCallback(() => setCurrentIndex((prev) => (prev - 1 + totalSlides) % totalSlides), [totalSlides]);

  if (totalSlides === 0) return null;

  // Single image — simple display, no carousel controls
  if (totalSlides === 1) {
    return (
      <div className="relative rounded-2xl overflow-hidden border border-white/10 shadow-2xl group">
        <div className="absolute inset-0 bg-gradient-to-t from-[#030014] via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
        <img
          src={screenshots[0]}
          alt={projectTitle}
          className="w-full object-cover transform transition-transform duration-700 will-change-transform group-hover:scale-105"
        />
        <div className="absolute inset-0 border-2 border-white/0 group-hover:border-white/10 transition-colors duration-300 rounded-2xl" />
      </div>
    );
  }

  return (
    <>
      <div
        className="relative rounded-2xl overflow-hidden border border-white/10 shadow-2xl group"
        onMouseEnter={() => setIsPaused(true)}
        onMouseLeave={() => setIsPaused(false)}
      >
        {/* Main slide area */}
        <div className="relative aspect-video bg-slate-900 overflow-hidden">
          {screenshots.map((src, i) => (
            <img
              key={i}
              src={src}
              alt={`${projectTitle} - ${i + 1}`}
              className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-700 ease-in-out ${
                i === currentIndex ? "opacity-100 z-10" : "opacity-0 z-0"
              }`}
            />
          ))}

          {/* Zoom button */}
          <button
            onClick={() => setIsFullscreen(true)}
            className="absolute top-3 right-3 z-20 p-2 bg-black/50 backdrop-blur-sm rounded-lg text-white/70 hover:text-white hover:bg-black/70 transition-all opacity-0 group-hover:opacity-100"
          >
            <ZoomIn className="w-5 h-5" />
          </button>

          {/* Arrow navigation */}
          <button
            onClick={goPrev}
            className="absolute left-3 top-1/2 -translate-y-1/2 z-20 p-2 bg-black/40 backdrop-blur-sm rounded-full text-white/70 hover:text-white hover:bg-black/60 transition-all opacity-0 group-hover:opacity-100"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>
          <button
            onClick={goNext}
            className="absolute right-3 top-1/2 -translate-y-1/2 z-20 p-2 bg-black/40 backdrop-blur-sm rounded-full text-white/70 hover:text-white hover:bg-black/60 transition-all opacity-0 group-hover:opacity-100"
          >
            <ChevronRight className="w-5 h-5" />
          </button>

          {/* Gradient overlay */}
          <div className="absolute inset-0 bg-gradient-to-t from-[#030014]/60 via-transparent to-transparent pointer-events-none z-10" />

          {/* Dots indicator */}
          <div className="absolute bottom-3 left-1/2 -translate-x-1/2 flex gap-2 z-20">
            {screenshots.map((_, i) => (
              <button
                key={i}
                onClick={() => goTo(i)}
                className={`h-2 rounded-full transition-all duration-300 ${
                  i === currentIndex
                    ? "bg-white w-6"
                    : "bg-white/40 hover:bg-white/60 w-2"
                }`}
              />
            ))}
          </div>
        </div>

        {/* Thumbnail strip */}
        <div className="flex gap-2 p-3 bg-black/30 backdrop-blur-sm overflow-x-auto scrollbar-thin scrollbar-thumb-white/20">
          {screenshots.map((src, i) => (
            <button
              key={i}
              onClick={() => goTo(i)}
              className={`flex-shrink-0 w-16 h-10 md:w-20 md:h-12 rounded-lg overflow-hidden border-2 transition-all duration-300 ${
                i === currentIndex
                  ? "border-blue-400 scale-105 shadow-lg shadow-blue-500/20"
                  : "border-transparent opacity-60 hover:opacity-100"
              }`}
            >
              <img src={src} alt="" className="w-full h-full object-cover" />
            </button>
          ))}
        </div>
      </div>

      {/* Fullscreen modal */}
      {isFullscreen && (
        <div
          className="fixed inset-0 z-50 bg-black/95 backdrop-blur-xl flex items-center justify-center"
          onClick={() => setIsFullscreen(false)}
        >
          <button className="absolute top-4 right-4 p-3 bg-white/10 rounded-full text-white hover:bg-white/20 transition-all z-10">
            <X className="w-6 h-6" />
          </button>

          <button
            onClick={(e) => { e.stopPropagation(); goPrev(); }}
            className="absolute left-4 top-1/2 -translate-y-1/2 p-3 bg-white/10 rounded-full text-white hover:bg-white/20 transition-all"
          >
            <ChevronLeft className="w-8 h-8" />
          </button>
          <button
            onClick={(e) => { e.stopPropagation(); goNext(); }}
            className="absolute right-4 top-1/2 -translate-y-1/2 p-3 bg-white/10 rounded-full text-white hover:bg-white/20 transition-all"
          >
            <ChevronRight className="w-8 h-8" />
          </button>

          <img
            src={screenshots[currentIndex]}
            alt={`${projectTitle} - ${currentIndex + 1}`}
            className="max-w-[90vw] max-h-[85vh] object-contain rounded-lg"
            onClick={(e) => e.stopPropagation()}
          />

          {/* Counter */}
          <div className="absolute bottom-6 left-1/2 -translate-x-1/2 flex items-center gap-4">
            <span className="text-white/70 text-sm font-medium">
              {currentIndex + 1} / {totalSlides}
            </span>
            <div className="flex gap-2">
              {screenshots.map((_, i) => (
                <button
                  key={i}
                  onClick={(e) => { e.stopPropagation(); goTo(i); }}
                  className={`h-1.5 rounded-full transition-all duration-300 ${
                    i === currentIndex ? "bg-white w-4" : "bg-white/30 w-1.5"
                  }`}
                />
              ))}
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default ScreenshotCarousel;
