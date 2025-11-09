import React, { useEffect, useState, useCallback } from "react";

import PropTypes from "prop-types";
import { useTheme } from "@mui/material/styles";
import AppBar from "@mui/material/AppBar";
import Tabs from "@mui/material/Tabs";
import Tab from "@mui/material/Tab";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import CardProject from "../components/CardProject";
import TechStackIcon from "../components/TechStackIcon";
import AOS from "aos";
import "aos/dist/aos.css";
import Certificate from "../components/Certificate";
import { Code, Award, Boxes } from "lucide-react";


const ToggleButton = ({ onClick, isShowingMore }) => (
  <button
    onClick={onClick}
    className="
      px-3 py-1.5
      text-slate-300 
      hover:text-white 
      text-sm 
      font-medium 
      transition-all 
      duration-300 
      ease-in-out
      flex 
      items-center 
      gap-2
      bg-white/5 
      hover:bg-white/10
      rounded-md
      border 
      border-white/10
      hover:border-white/20
      backdrop-blur-sm
      group
      relative
      overflow-hidden
    "
  >
    <span className="relative z-10 flex items-center gap-2">
      {isShowingMore ? "Voir Moins" : "Voir Plus"}
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="16"
        height="16"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
        className={`
          transition-transform 
          duration-300 
          ${isShowingMore ? "group-hover:-translate-y-0.5" : "group-hover:translate-y-0.5"}
        `}
      >
        <polyline points={isShowingMore ? "18 15 12 9 6 15" : "6 9 12 15 18 9"}></polyline>
      </svg>
    </span>
    <span className="absolute bottom-0 left-0 w-0 h-0.5 bg-purple-500/50 transition-all duration-300 group-hover:w-full"></span>
  </button>
);


function TabPanel({ children, value, index, ...other }) {
  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`full-width-tabpanel-${index}`}
      aria-labelledby={`full-width-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: { xs: 1, sm: 3 } }}>
          <Typography component="div">{children}</Typography>
        </Box>
      )}
    </div>
  );
}

TabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
};

function a11yProps(index) {
  return {
    id: `full-width-tab-${index}`,
    "aria-controls": `full-width-tabpanel-${index}`,
  };
}

// Tech Stack - adapté à ton stack réel
// Organisation du stack technique par catégories
const techStackCategories = [
  {
    title: "Langages de Programmation",
    items: [
      { icon: "/icons/javascript.svg", language: "JavaScript" },
      { icon: "/icons/python.svg", language: "Python" },
      { icon: "/icons/java.svg", language: "Java" },
      { icon: "/icons/C.svg", language: "C" },
      { icon: "/icons/sql.svg", language: "SQL" },
    ]
  },
  {
    title: "Frameworks & Technologies Web",
    items: [
      { icon: "/icons/reactjs.svg", language: "React" },
      { icon: "/icons/nodejs.svg", language: "Node.js" },
      { icon: "/icons/spring.svg", language: "Spring" },
      { icon: "/icons/html.svg", language: "HTML" },
      { icon: "/icons/css.svg", language: "CSS" },
      { icon: "/icons/tailwind.svg", language: "Tailwind" },
    ]
  },
  {
    title: "Cloud & DevOps",
    items: [
      { icon: "/icons/aws.svg", language: "AWS" },
      { icon: "/icons/gcp.svg", language: "GCP" },
      { icon: "/icons/docker.svg", language: "Docker" },
      { icon: "/icons/terraform.svg", language: "Terraform" },
    ]
  },
  {
    title: "Outils & Quality Assurance",
    items: [
      { icon: "/icons/sonarqube.svg", language: "SonarQube" },
      { icon: "/icons/maven.svg", language: "Maven" },
      { icon: "/icons/selenium.svg", language: "Selenium" },
    ]
  },
  {
    title: "Environnements de Développement",
    items: [
      { icon: "/icons/vscode.svg", language: "VS Code" },
      { icon: "/icons/eclipse.svg", language: "Eclipse" },
      { icon: "/icons/pycharm.svg", language: "PyCharm" },
    ]
  }
];

// Tableau plat pour compatibilité
const techStacks = techStackCategories.flatMap(category => category.items);

export default function FullWidthTabs() {
  const theme = useTheme();
  const [value, setValue] = useState(0);
  const [projects, setProjects] = useState([]);
  const [certificates, setCertificates] = useState([]);
  const [showAllProjects, setShowAllProjects] = useState(false);
  const [showAllCertificates, setShowAllCertificates] = useState(false);
  const [showAllTechStack, setShowAllTechStack] = useState(false);
  const isMobile = window.innerWidth < 768;
  const initialItems = isMobile ? 4 : 6;
  const techStackLimit = 3; // Montrer seulement les 3 premières catégories initialement

  useEffect(() => {
    AOS.init({
      once: false,
    });
  }, []);

  // Données initiales (tu les remplaceras avec tes vraies données)
  const initialProjects = [
    {
      id: 1,
      Img: "/projects/project-portfolio.jpg",
      Title: "Infrastructure Multi-Cloud Portfolio",
      Description: "Portfolio déployé sur AWS ECS et GCP Cloud Run avec Terraform pour l'IaC",
      Link: "https://ldjossou.com",
      Github: "https://github.com/Linerror99/portofolio",
      Features: [
        "Déploiement multi-cloud (AWS ECS Fargate + GCP Cloud Run)",
        "Infrastructure as Code avec Terraform (modules réutilisables)",
        "CI/CD automatisé avec GitHub Actions",
        "Container Registry (AWS ECR + GCP Artifact Registry)",
        "Lifecycle policies pour optimisation des coûts (~$15/mois)",
        "Architecture serverless avec scale-to-zero"
      ],
      TechStack: [
        "React + Vite",
        "Tailwind CSS",
        "Terraform",
        "Docker",
        "AWS ECS Fargate",
        "GCP Cloud Run",
        "GitHub Actions",
        "Nginx"
      ]
    },
    {
      id: 2,
      Img: "/projects/project-tiktok-pipeline.jpg",
      Title: "Pipeline Vidéo IA TikTok - Génération Automatisée",
      Description: "Pipeline complète de génération automatique de vidéos TikTok/Shorts virales à partir d'un simple thème. Utilise Gemini 2.5 Pro, Veo 3.0, Google TTS Premium, et Whisper.",
      Link: "https://pipeline-frontend-354616212471.us-central1.run.app/",
      Github: "https://github.com/Linerror99Su/pipeline-video-tiktok",
      Features: [
        "Génération de script IA avec Gemini 2.5 Pro",
        "Voix off premium (voix Gemini naturelle via Google TTS)",
        "Clips vidéo créatifs générés par Veo 3.0 (meilleur modèle vidéo IA)",
        "Sous-titres style TikTok synchronisés (Whisper + ASS)",
        "Format optimisé 9:16, durée 64-80 secondes",
        "Pipeline entièrement automatisée : 1 thème → vidéo complète en 6-10 min",
        "4 Cloud Functions déclenchées en cascade via Cloud Storage Events",
        "Génération parallèle de 8 clips vidéo pour optimisation"
      ],
      TechStack: [
        "Gemini 2.5 Pro",
        "Veo 3.0",
        "Google TTS Premium",
        "OpenAI Whisper",
        "FFmpeg",
        "Python 3.12",
        "Google Cloud Functions Gen2",
        "Cloud Storage",
        "Vertex AI"
      ]
    }
  ];

  const initialCertificates = [
    { id: 1, Img: "/certificates/cert1.jpg" },
    { id: 2, Img: "/certificates/cert2.jpg" },
    { id: 3, Img: "/certificates/cert3.jpg" }
  ];

  useEffect(() => {
    // Version du portfolio pour forcer le refresh si les données changent
    const PORTFOLIO_VERSION = "2.0"; // Incrémenter pour forcer un refresh
    const cachedVersion = localStorage.getItem('portfolioVersion');
    
    // Si la version a changé, vider le cache
    if (cachedVersion !== PORTFOLIO_VERSION) {
      localStorage.removeItem('projects');
      localStorage.removeItem('certificates');
      localStorage.setItem('portfolioVersion', PORTFOLIO_VERSION);
    }
    
    // Charger depuis localStorage ou utiliser les données initiales
    const cachedProjects = localStorage.getItem('projects');
    const cachedCertificates = localStorage.getItem('certificates');

    if (cachedProjects && cachedCertificates) {
      setProjects(JSON.parse(cachedProjects));
      setCertificates(JSON.parse(cachedCertificates));
    } else {
      // Première visite - utiliser les données initiales
      setProjects(initialProjects);
      setCertificates(initialCertificates);
      localStorage.setItem("projects", JSON.stringify(initialProjects));
      localStorage.setItem("certificates", JSON.stringify(initialCertificates));
    }
  }, []);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const toggleShowMore = useCallback((type) => {
    if (type === 'projects') {
      setShowAllProjects(prev => !prev);
    } else if (type === 'certificates') {
      setShowAllCertificates(prev => !prev);
    } else if (type === 'techstack') {
      setShowAllTechStack(prev => !prev);
    }
  }, []);

  const displayedProjects = showAllProjects ? projects : projects.slice(0, initialItems);
  const displayedCertificates = showAllCertificates ? certificates : certificates.slice(0, initialItems);
  const displayedTechCategories = showAllTechStack ? techStackCategories : techStackCategories.slice(0, techStackLimit);

  // Sisa dari komponen (return statement) tidak ada perubahan
  return (
    <div className="md:px-[10%] px-[5%] w-full sm:mt-0 mt-[3rem] bg-[#030014] overflow-hidden" id="Portofolio">
      {/* Header section */}
      <div className="text-center pb-10" data-aos="fade-up" data-aos-duration="1000">
        <h2 className="inline-block text-3xl md:text-5xl font-bold text-center mx-auto text-transparent bg-clip-text bg-gradient-to-r from-[#6366f1] to-[#a855f7]">
          <span style={{
            color: '#6366f1',
            backgroundImage: 'linear-gradient(45deg, #6366f1 10%, #a855f7 93%)',
            WebkitBackgroundClip: 'text',
            backgroundClip: 'text',
            WebkitTextFillColor: 'transparent'
          }}>
            Vitrine Portfolio
          </span>
        </h2>
        <p className="text-slate-400 max-w-2xl mx-auto text-sm md:text-base mt-2">
          Découvrez mon parcours à travers mes projets, certifications et expertises techniques. 
          Chaque section représente une étape de mon apprentissage continu.
        </p>
      </div>

      <Box sx={{ width: "100%" }}>
        {/* AppBar and Tabs section - unchanged */}
        <AppBar
          position="static"
          elevation={0}
          sx={{
            bgcolor: "transparent",
            border: "1px solid rgba(255, 255, 255, 0.1)",
            borderRadius: "20px",
            position: "relative",
            overflow: "hidden",
            "&::before": {
              content: '""',
              position: "absolute",
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              background: "linear-gradient(180deg, rgba(139, 92, 246, 0.03) 0%, rgba(59, 130, 246, 0.03) 100%)",
              backdropFilter: "blur(10px)",
              zIndex: 0,
            },
          }}
          className="md:px-4"
        >
          {/* Tabs */}
          <Tabs
            value={value}
            onChange={handleChange}
            textColor="secondary"
            indicatorColor="secondary"
            variant="fullWidth"
            sx={{
              minHeight: "70px",
              "& .MuiTab-root": {
                fontSize: { xs: "0.9rem", md: "1rem" },
                fontWeight: "600",
                color: "#94a3b8",
                textTransform: "none",
                transition: "all 0.4s cubic-bezier(0.4, 0, 0.2, 1)",
                padding: "20px 0",
                zIndex: 1,
                margin: "8px",
                borderRadius: "12px",
                "&:hover": {
                  color: "#ffffff",
                  backgroundColor: "rgba(139, 92, 246, 0.1)",
                  transform: "translateY(-2px)",
                  "& .lucide": {
                    transform: "scale(1.1) rotate(5deg)",
                  },
                },
                "&.Mui-selected": {
                  color: "#fff",
                  background: "linear-gradient(135deg, rgba(139, 92, 246, 0.2), rgba(59, 130, 246, 0.2))",
                  boxShadow: "0 4px 15px -3px rgba(139, 92, 246, 0.2)",
                  "& .lucide": {
                    color: "#a78bfa",
                  },
                },
              },
              "& .MuiTabs-indicator": {
                height: 0,
              },
              "& .MuiTabs-flexContainer": {
                gap: "8px",
              },
            }}
          >
            <Tab
              icon={<Code className="mb-2 w-5 h-5 transition-all duration-300" />}
              label="Projets"
              {...a11yProps(0)}
            />
            <Tab
              icon={<Award className="mb-2 w-5 h-5 transition-all duration-300" />}
              label="Certifications"
              {...a11yProps(1)}
            />
            <Tab
              icon={<Boxes className="mb-2 w-5 h-5 transition-all duration-300" />}
              label="Stack Technique"
              {...a11yProps(2)}
            />
          </Tabs>
        </AppBar>

        {/* Tab Panels - sans SwipeableViews */}
        <TabPanel value={value} index={0} dir={theme.direction}>
          <div className="container mx-auto flex justify-center items-center overflow-hidden">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 2xl:grid-cols-3 gap-5">
              {displayedProjects.map((project, index) => (
                <div
                  key={project.id || index}
                  data-aos={index % 3 === 0 ? "fade-up-right" : index % 3 === 1 ? "fade-up" : "fade-up-left"}
                  data-aos-duration={index % 3 === 0 ? "1000" : index % 3 === 1 ? "1200" : "1000"}
                >
                  <CardProject
                    Img={project.Img}
                    Title={project.Title}
                    Description={project.Description}
                    Link={project.Link}
                    id={project.id}
                  />
                </div>
              ))}
            </div>
          </div>
          {projects.length > initialItems && (
            <div className="mt-6 w-full flex justify-start">
              <ToggleButton
                onClick={() => toggleShowMore('projects')}
                isShowingMore={showAllProjects}
              />
            </div>
          )}
        </TabPanel>

        <TabPanel value={value} index={1} dir={theme.direction}>
          <div className="container mx-auto flex justify-center items-center overflow-hidden">
            <div className="grid grid-cols-1 md:grid-cols-3 md:gap-5 gap-4">
              {displayedCertificates.map((certificate, index) => (
                <div
                  key={certificate.id || index}
                  data-aos={index % 3 === 0 ? "fade-up-right" : index % 3 === 1 ? "fade-up" : "fade-up-left"}
                  data-aos-duration={index % 3 === 0 ? "1000" : index % 3 === 1 ? "1200" : "1000"}
                >
                  <Certificate ImgSertif={certificate.Img} />
                </div>
              ))}
            </div>
          </div>
          {certificates.length > initialItems && (
            <div className="mt-6 w-full flex justify-start">
              <ToggleButton
                onClick={() => toggleShowMore('certificates')}
                isShowingMore={showAllCertificates}
              />
            </div>
          )}
        </TabPanel>

        <TabPanel value={value} index={2} dir={theme.direction}>
          <div className="container mx-auto flex flex-col justify-center items-center overflow-hidden pb-[5%]">
            <div className="space-y-12 w-full">
              {displayedTechCategories.map((category, categoryIndex) => (
                <div key={categoryIndex} className="space-y-6">
                  {/* Titre de la catégorie */}
                  <div className="text-center" data-aos="fade-up" data-aos-duration="800">
                    <h3 className="text-xl md:text-2xl font-bold text-white mb-2">
                      {category.title}
                    </h3>
                    <div className="w-16 h-0.5 bg-gradient-to-r from-[#6366f1] to-[#a855f7] mx-auto rounded-full"></div>
                  </div>
                  
                  {/* Icônes de la catégorie */}
                  <div className="flex justify-center">
                    <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-6 max-w-4xl">
                      {category.items.map((stack, index) => (
                        <div
                          key={index}
                          data-aos={index % 3 === 0 ? "fade-up-right" : index % 3 === 1 ? "fade-up" : "fade-up-left"}
                          data-aos-duration={index % 3 === 0 ? "1000" : index % 3 === 1 ? "1200" : "1000"}
                          data-aos-delay={categoryIndex * 200 + index * 100}
                        >
                          <TechStackIcon TechStackIcon={stack.icon} Language={stack.language} />
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              ))}
            </div>
            
            {/* Bouton Voir Plus/Voir Moins pour le Tech Stack */}
            {techStackCategories.length > techStackLimit && (
              <div className="mt-8 w-full flex justify-center">
                <ToggleButton
                  onClick={() => toggleShowMore('techstack')}
                  isShowingMore={showAllTechStack}
                />
              </div>
            )}
          </div>
        </TabPanel>
      </Box>
    </div>
  );
}