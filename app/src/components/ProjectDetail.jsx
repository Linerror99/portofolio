import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useTranslation } from 'react-i18next';
import i18n from '../i18n';
import {
  ArrowLeft, ExternalLink, Github, Code2, Star,
  ChevronRight, Layers, Layout, Globe, Package, Cpu, Code, Network, ZoomIn,
  Database, Container, Cloud, GitBranch, Brain, Monitor,
} from "lucide-react";
import Swal from 'sweetalert2';
import ScreenshotCarousel from "./ScreenshotCarousel";

const CATEGORY_STYLES = {
  frontend:  { icon: Globe,     color: "cyan",    from: "from-cyan-600/10",    to: "to-cyan-600/10",    border: "border-cyan-500/10",    hoverBorder: "hover:border-cyan-500/30",    text: "text-cyan-300/90",    iconColor: "text-cyan-400" },
  backend:   { icon: Cpu,       color: "violet",  from: "from-violet-600/10",  to: "to-violet-600/10",  border: "border-violet-500/10",  hoverBorder: "hover:border-violet-500/30",  text: "text-violet-300/90",  iconColor: "text-violet-400" },
  ai:        { icon: Brain,     color: "amber",   from: "from-amber-600/10",   to: "to-amber-600/10",   border: "border-amber-500/10",   hoverBorder: "hover:border-amber-500/30",   text: "text-amber-300/90",   iconColor: "text-amber-400" },
  database:  { icon: Database,  color: "emerald", from: "from-emerald-600/10", to: "to-emerald-600/10", border: "border-emerald-500/10", hoverBorder: "hover:border-emerald-500/30", text: "text-emerald-300/90", iconColor: "text-emerald-400" },
  cloud:     { icon: Cloud,     color: "blue",    from: "from-blue-600/10",    to: "to-blue-600/10",    border: "border-blue-500/10",    hoverBorder: "hover:border-blue-500/30",    text: "text-blue-300/90",    iconColor: "text-blue-400" },
  cicd:      { icon: GitBranch, color: "orange",  from: "from-orange-600/10",  to: "to-orange-600/10",  border: "border-orange-500/10",  hoverBorder: "hover:border-orange-500/30",  text: "text-orange-300/90",  iconColor: "text-orange-400" },
};

const TechBadge = ({ tech, category = "cloud" }) => {
  const style = CATEGORY_STYLES[category] || CATEGORY_STYLES.cloud;
  const Icon = style.icon;
  
  return (
    <div className={`group relative overflow-hidden px-3 py-2 md:px-4 md:py-2.5 bg-gradient-to-r ${style.from} ${style.to} rounded-xl border ${style.border} ${style.hoverBorder} transition-all duration-300 cursor-default`}>
      <div className="relative flex items-center gap-1.5 md:gap-2">
        <Icon className={`w-3.5 h-3.5 md:w-4 md:h-4 ${style.iconColor} transition-colors`} />
        <span className={`text-xs md:text-sm font-medium ${style.text} transition-colors`}>
          {tech}
        </span>
      </div>
    </div>
  );
};

const TechCategory = ({ label, techs, categoryKey }) => (
  <div className="space-y-2">
    <span className={`text-xs font-semibold uppercase tracking-wider ${(CATEGORY_STYLES[categoryKey] || CATEGORY_STYLES.cloud).iconColor} opacity-80`}>
      {label}
    </span>
    <div className="flex flex-wrap gap-2 md:gap-2.5">
      {techs.map((tech, i) => (
        <TechBadge key={i} tech={tech} category={categoryKey} />
      ))}
    </div>
  </div>
);

const FeatureItem = ({ feature }) => {
  return (
    <li className="group flex items-start space-x-3 p-2.5 md:p-3.5 rounded-xl hover:bg-white/5 transition-all duration-300 border border-transparent hover:border-white/10">
      <div className="relative mt-2">
        <div className="absolute -inset-1 bg-gradient-to-r from-blue-600/20 to-purple-600/20 rounded-full blur group-hover:opacity-100 opacity-0 transition-opacity duration-300" />
        <div className="relative w-1.5 h-1.5 md:w-2 md:h-2 rounded-full bg-gradient-to-r from-blue-400 to-purple-400 group-hover:scale-125 transition-transform duration-300" />
      </div>
      <span className="text-sm md:text-base text-gray-300 group-hover:text-white transition-colors">
        {feature}
      </span>
    </li>
  );
};

const ProjectStats = ({ project, t }) => {
  const techStackCount = project?.TechStack
    ? Object.values(project.TechStack).flat().length
    : 0;
  const featuresCount = project?.Features?.length || 0;

  return (
    <div className="grid grid-cols-2 gap-3 md:gap-4 p-3 md:p-4 bg-[#0a0a1a] rounded-xl overflow-hidden relative">
      <div className="absolute inset-0 bg-gradient-to-br from-blue-900/20 to-purple-900/20 opacity-50 blur-2xl z-0" />

      <div className="relative z-10 flex items-center space-x-2 md:space-x-3 bg-white/5 p-2 md:p-3 rounded-lg border border-blue-500/20 transition-all duration-300 hover:scale-105 hover:border-blue-500/50 hover:shadow-lg">
        <div className="bg-blue-500/20 p-1.5 md:p-2 rounded-full">
          <Code2 className="text-blue-300 w-4 h-4 md:w-6 md:h-6" strokeWidth={1.5} />
        </div>
        <div className="flex-grow">
          <div className="text-lg md:text-xl font-semibold text-blue-200">{techStackCount}</div>
          <div className="text-[10px] md:text-xs text-gray-400">{t('projectDetail.stats.technologies')}</div>
        </div>
      </div>

      <div className="relative z-10 flex items-center space-x-2 md:space-x-3 bg-white/5 p-2 md:p-3 rounded-lg border border-purple-500/20 transition-all duration-300 hover:scale-105 hover:border-purple-500/50 hover:shadow-lg">
        <div className="bg-purple-500/20 p-1.5 md:p-2 rounded-full">
          <Layers className="text-purple-300 w-4 h-4 md:w-6 md:h-6" strokeWidth={1.5} />
        </div>
        <div className="flex-grow">
          <div className="text-lg md:text-xl font-semibold text-purple-200">{featuresCount}</div>
          <div className="text-[10px] md:text-xs text-gray-400">{t('projectDetail.stats.features')}</div>
        </div>
      </div>
    </div>
  );
};

const handleGithubClick = (githubLink, t) => {
  if (githubLink === 'Private') {
    Swal.fire({
      icon: 'info',
      title: t('projectDetail.privateRepo.title'),
      text: t('projectDetail.privateRepo.text'),
      confirmButtonText: t('projectDetail.privateRepo.confirmButton'),
      confirmButtonColor: '#3085d6',
      background: '#030014',
      color: '#ffffff'
    });
    return false;
  }
  return true;
};

const ProjectDetails = () => {
  const { t, i18n } = useTranslation('portfolio');
  const { id } = useParams();
  const navigate = useNavigate();
  const [project, setProject] = useState(null);
  const [isImageLoaded, setIsImageLoaded] = useState(false);
  const [isArchFullscreen, setIsArchFullscreen] = useState(false);

  useEffect(() => {
    window.scrollTo(0, 0);
    
    // Charger depuis les traductions au lieu de localStorage
    const projectsData = t('projects', { returnObjects: true });
    const translatedProjects = projectsData.map((project, index) => ({
      id: project.id,
      Img: ["/projects/Coming_soon.jpg", "/projects/project-mimo-finance.jpg", "/projects/project-portfolio.jpg", "/projects/project-tiktok-pipeline.jpg", "/projects/project-job-hunter.jpg"][index],
      Title: project.title,
      Description: project.description,
      Link: ["#", "https://mimo.ldjossou.com", "https://ldjossou.com", "https://reetik.ldjossou.com", null][index],
      Github: ["https://github.com/Tanou-Organization/Autoforge-core", "https://github.com/Linerror99/Mimo-core", "https://github.com/Linerror99/portofolio", "https://github.com/Linerror99Su/pipeline-video-tiktok", "https://github.com/Linerror99/Job-hunter"][index],
      comingSoon: index === 0,
      Features: project.features,
      screenshots: [
        ["/projects/Coming_soon.jpg"],
        ["/projects/project-mimo-finance.jpg"],
        ["/projects/project-portfolio.jpg"],
        ["/projects/project-tiktok-pipeline.jpg"],
        ["/projects/project-job-hunter.jpg"]
      ][index],
      architectureImg: [
        "/projects/autoforge/architecture.png",
        "/projects/mimo/architecture.png",
        "/projects/portfolio/architecture.png",
        "/projects/reetik/architecture.png",
        "/projects/job-hunter/architecture.png"
      ][index],
      architectureDesc: project.architectureDesc || null,
      TechStack: [
        // AutoForge
        {
          backend: ["TypeScript + Fastify", "WebSocket", "OAuth 2.0", "MCP SDK"],
          ai: ["Claude Sonnet 4"],
          database: ["Firestore"],
          cloud: ["GCP Cloud Run", "Compute Engine (Spot VMs)"],
          cicd: ["Docker", "Terraform"]
        },
        // Mimo Finance
        {
          frontend: ["React 18", "Shadcn/ui"],
          backend: ["FastAPI + Python 3.12"],
          database: ["PostgreSQL 15", "Redis 7", "Cloud SQL"],
          cloud: ["GCP Cloud Run", "Artifact Registry"],
          cicd: ["Terraform", "GitHub Actions", "SonarCloud", "Docker"]
        },
        // Portfolio
        {
          frontend: ["React + Vite", "Tailwind CSS", "Nginx"],
          cloud: ["AWS ECS Fargate", "GCP Cloud Run"],
          cicd: ["Terraform", "Docker", "GitHub Actions"]
        },
        // Reetik
        {
          frontend: ["React 18 + TypeScript"],
          backend: ["FastAPI + Python 3.12", "FFmpeg"],
          ai: ["Gemini 2.5 Pro", "Veo 3.1", "Google TTS Premium", "OpenAI Whisper"],
          database: ["Firestore", "Cloud Storage"],
          cloud: ["GCP Cloud Run", "Cloud Functions Gen2"],
          cicd: ["Terraform", "GitHub Actions", "Docker"]
        },
        // Job Hunter
        {
          frontend: ["React 19", "Vite", "Tailwind CSS"],
          backend: ["FastAPI", "Python 3.12", "Playwright"],
          ai: ["OpenClaw", "Claude Sonnet 4", "Chromium Headless"],
          database: ["PostgreSQL 16", "Cloud SQL", "Firebase Auth"],
          cloud: ["GCP Cloud Run", "Cloud Scheduler"],
          cicd: ["Terraform", "Docker", "GitHub Actions"]
        }
      ][index]
    }));
    
    const selectedProject = translatedProjects.find((p) => String(p.id) === id);
    
    if (selectedProject) {
      const enhancedProject = {
        ...selectedProject,
        Features: selectedProject.Features || [],
        TechStack: selectedProject.TechStack || [],
        Github: selectedProject.Github || 'https://github.com/Linerror99',
      };
      setProject(enhancedProject);
    }
  }, [id, t, i18n.language]);

  if (!project) {
    return (
      <div className="min-h-screen bg-[#030014] flex items-center justify-center">
        <div className="text-center space-y-6 animate-fadeIn">
          <div className="w-16 h-16 md:w-24 md:h-24 mx-auto border-4 border-blue-500/30 border-t-blue-500 rounded-full animate-spin" />
          <h2 className="text-xl md:text-3xl font-bold text-white">Loading Project...</h2>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#030014] px-[2%] sm:px-0 relative overflow-hidden">
      {/* Background animations remain unchanged */}
      <div className="fixed inset-0">
        <div className="absolute -inset-[10px] opacity-20">
          <div className="absolute top-0 -left-4 w-72 md:w-96 h-72 md:h-96 bg-purple-500 rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob" />
          <div className="absolute top-0 -right-4 w-72 md:w-96 h-72 md:h-96 bg-blue-500 rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob animation-delay-2000" />
          <div className="absolute -bottom-8 left-20 w-72 md:w-96 h-72 md:h-96 bg-pink-500 rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob animation-delay-4000" />
        </div>
        <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-[0.02]" />
      </div>

      <div className="relative">
        <div className="max-w-7xl mx-auto px-4 md:px-6 py-8 md:py-16">
          <div className="flex items-center space-x-2 md:space-x-4 mb-8 md:mb-12 animate-fadeIn">
            <button
              onClick={() => navigate(-1)}
              className="group inline-flex items-center space-x-1.5 md:space-x-2 px-3 md:px-5 py-2 md:py-2.5 bg-white/5 backdrop-blur-xl rounded-xl text-white/90 hover:bg-white/10 transition-all duration-300 border border-white/10 hover:border-white/20 text-sm md:text-base"
            >
              <ArrowLeft className="w-4 h-4 md:w-5 md:h-5 group-hover:-translate-x-1 transition-transform" />
              <span>{t('projectDetail.back')}</span>
            </button>
            <div className="flex items-center space-x-1 md:space-x-2 text-sm md:text-base text-white/50">
              <span>{t('projectDetail.projects')}</span>
              <ChevronRight className="w-3 h-3 md:w-4 md:h-4" />
              <span className="text-white/90 truncate">{project.Title}</span>
            </div>
          </div>

          <div className="grid lg:grid-cols-2 gap-8 md:gap-16">
            <div className="space-y-6 md:space-y-10 animate-slideInLeft">
              <div className="space-y-4 md:space-y-6">
                <h1 className="text-3xl md:text-6xl font-bold bg-gradient-to-r from-blue-200 via-purple-200 to-pink-200 bg-clip-text text-transparent leading-tight">
                  {project.Title}
                </h1>
                <div className="relative h-1 w-16 md:w-24">
                  <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full animate-pulse" />
                  <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full blur-sm" />
                </div>
              </div>

              <div className="prose prose-invert max-w-none">
                <p className="text-base md:text-lg text-gray-300/90 leading-relaxed">
                  {project.Description}
                </p>
              </div>

              <ProjectStats project={project} t={t} />

              <div className="flex flex-wrap gap-3 md:gap-4">
                {/* Action buttons */}
                {project.comingSoon ? (
                  <div className="inline-flex items-center space-x-1.5 md:space-x-2 px-4 md:px-8 py-2.5 md:py-4 bg-gradient-to-r from-yellow-600/10 to-orange-600/10 text-yellow-400 rounded-xl border border-yellow-500/20 backdrop-blur-xl text-sm md:text-base cursor-not-allowed">
                    <span className="font-medium">{t('common:cardProject.comingSoonLabel')}</span>
                  </div>
                ) : (
                  <a
                    href={project.Link}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="group relative inline-flex items-center space-x-1.5 md:space-x-2 px-4 md:px-8 py-2.5 md:py-4 bg-gradient-to-r from-blue-600/10 to-purple-600/10 hover:from-blue-600/20 hover:to-purple-600/20 text-blue-300 rounded-xl transition-all duration-300 border border-blue-500/20 hover:border-blue-500/40 backdrop-blur-xl overflow-hidden text-sm md:text-base"
                  >
                    <div className="absolute inset-0 translate-y-[100%] bg-gradient-to-r from-blue-600/10 to-purple-600/10 transition-transform duration-300 group-hover:translate-y-[0%]" />
                    <ExternalLink className="relative w-4 h-4 md:w-5 md:h-5 group-hover:rotate-12 transition-transform" />
                    <span className="relative font-medium">{t('projectDetail.liveDemo')}</span>
                  </a>
                )}

                <a
                  href={project.Github}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="group relative inline-flex items-center space-x-1.5 md:space-x-2 px-4 md:px-8 py-2.5 md:py-4 bg-gradient-to-r from-purple-600/10 to-pink-600/10 hover:from-purple-600/20 hover:to-pink-600/20 text-purple-300 rounded-xl transition-all duration-300 border border-purple-500/20 hover:border-purple-500/40 backdrop-blur-xl overflow-hidden text-sm md:text-base"
                  onClick={(e) => !handleGithubClick(project.Github, t) && e.preventDefault()}
                >
                  <div className="absolute inset-0 translate-y-[100%] bg-gradient-to-r from-purple-600/10 to-pink-600/10 transition-transform duration-300 group-hover:translate-y-[0%]" />
                  <Github className="relative w-4 h-4 md:w-5 md:h-5 group-hover:rotate-12 transition-transform" />
                  <span className="relative font-medium">{t('projectDetail.github')}</span>
                </a>
              </div>

              <div className="space-y-4 md:space-y-6">
                <h3 className="text-lg md:text-xl font-semibold text-white/90 mt-[3rem] md:mt-0 flex items-center gap-2 md:gap-3">
                  <Code2 className="w-4 h-4 md:w-5 md:h-5 text-blue-400" />
                  {t('projectDetail.technologiesUsed')}
                </h3>
                {project.TechStack && typeof project.TechStack === 'object' ? (
                  <div className="space-y-4">
                    {Object.entries(project.TechStack).map(([catKey, techs]) => (
                      techs && techs.length > 0 && (
                        <TechCategory
                          key={catKey}
                          label={t(`projectDetail.techCategories.${catKey}`)}
                          techs={techs}
                          categoryKey={catKey}
                        />
                      )
                    ))}
                  </div>
                ) : (
                  <p className="text-sm md:text-base text-gray-400 opacity-50">{t('projectDetail.noTechnologies')}</p>
                )}
              </div>
            </div>

            <div className="space-y-6 md:space-y-10 animate-slideInRight">
              <ScreenshotCarousel screenshots={project.screenshots} projectTitle={project.Title} />

              {/* Fonctionnalités Clés */}
              <div className="bg-white/[0.02] backdrop-blur-xl rounded-2xl p-8 border border-white/10 space-y-6 hover:border-white/20 transition-colors duration-300 group">
                <h3 className="text-xl font-semibold text-white/90 flex items-center gap-3">
                  <Star className="w-5 h-5 text-yellow-400 group-hover:rotate-[20deg] transition-transform duration-300" />
                  {t('projectDetail.keyFeatures')}
                </h3>
                {project.Features.length > 0 ? (
                  <ul className="list-none space-y-2">
                    {project.Features.map((feature, index) => (
                      <FeatureItem key={index} feature={feature} />
                    ))}
                  </ul>
                ) : (
                  <p className="text-gray-400 opacity-50">{t('projectDetail.noFeatures')}</p>
                )}
              </div>

              {/* Architecture */}
              {project.architectureImg && (
                <div className="bg-white/[0.02] backdrop-blur-xl rounded-2xl p-6 md:p-8 border border-white/10 space-y-4 md:space-y-6 hover:border-white/20 transition-colors duration-300 group">
                  <h3 className="text-lg md:text-xl font-semibold text-white/90 flex items-center gap-2 md:gap-3">
                    <Network className="w-4 h-4 md:w-5 md:h-5 text-green-400 group-hover:rotate-[20deg] transition-transform duration-300" />
                    {t('projectDetail.architecture')}
                  </h3>
                  <div
                    className="relative rounded-xl overflow-hidden border border-white/10 cursor-pointer group/arch"
                    onClick={() => setIsArchFullscreen(true)}
                  >
                    <img
                      src={project.architectureImg}
                      alt={`${project.Title} Architecture`}
                      className="w-full object-contain bg-slate-900/50"
                    />
                    <div className="absolute inset-0 bg-black/0 group-hover/arch:bg-black/20 transition-all duration-300 flex items-center justify-center">
                      <ZoomIn className="w-8 h-8 text-white opacity-0 group-hover/arch:opacity-100 transition-opacity drop-shadow-lg" />
                    </div>
                  </div>
                  {project.architectureDesc && (
                    <p className="text-sm md:text-base text-gray-300/80 leading-relaxed">
                      {project.architectureDesc}
                    </p>
                  )}
                </div>
              )}

              {/* Architecture fullscreen modal */}
              {isArchFullscreen && project.architectureImg && (
                <div
                  className="fixed inset-0 z-50 bg-black/95 backdrop-blur-xl flex items-center justify-center p-4"
                  onClick={() => setIsArchFullscreen(false)}
                >
                  <button
                    className="absolute top-4 right-4 p-3 bg-white/10 rounded-full text-white hover:bg-white/20 transition-all z-10"
                    onClick={() => setIsArchFullscreen(false)}
                  >
                    <span className="text-lg">✕</span>
                  </button>
                  <img
                    src={project.architectureImg}
                    alt={`${project.Title} Architecture`}
                    className="max-w-[95vw] max-h-[90vh] object-contain"
                    onClick={(e) => e.stopPropagation()}
                  />
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      <style>{`
        @keyframes blob {
          0% {
            transform: translate(0px, 0px) scale(1);
          }
          33% {
            transform: translate(30px, -50px) scale(1.1);
          }
          66% {
            transform: translate(-20px, 20px) scale(0.9);
          }
          100% {
            transform: translate(0px, 0px) scale(1);
          }
        }
        .animate-blob {
          animation: blob 10s infinite;
        }
        .animation-delay-2000 {
          animation-delay: 2s;
        }
        .animation-delay-4000 {
          animation-delay: 4s;
        }
        .animate-fadeIn {
          animation: fadeIn 0.7s ease-out;
        }
        .animate-slideInLeft {
          animation: slideInLeft 0.7s ease-out;
        }
        .animate-slideInRight {
          animation: slideInRight 0.7s ease-out;
        }
        @keyframes fadeIn {
          from {
            opacity: 0;
          }
          to {
            opacity: 1;
          }
        }
        @keyframes slideInLeft {
          from {
            opacity: 0;
            transform: translateX(-30px);
          }
          to {
            opacity: 1;
            transform: translateX(0);
          }
        }
        @keyframes slideInRight {
          from {
            opacity: 0;
            transform: translateX(30px);
          }
          to {
            opacity: 1;
            transform: translateX(0);
          }
        }
      `}</style>
    </div>
  );
};

export default ProjectDetails;
