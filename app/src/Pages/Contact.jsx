import React, { useState, useEffect } from "react";
import { Share2, User, Mail, MessageSquare, Send, Linkedin, Github, MapPin } from "lucide-react";
import { Link } from "react-router-dom";
import SocialLinks from "../components/SocialLinks";
import Swal from "sweetalert2";
import AOS from "aos";
import "aos/dist/aos.css";
import axios from "axios";

const ContactPage = () => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    message: "",
  });
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    AOS.init({
      once: false,
    });

    // Vérifier si on revient après un envoi réussi
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('sent') === 'true') {
      Swal.fire({
        title: 'Succès !',
        text: 'Votre message a été envoyé avec succès !',
        icon: 'success',
        confirmButtonColor: '#6366f1',
        timer: 3000,
        timerProgressBar: true
      });
      // Nettoyer l'URL
      window.history.replaceState({}, document.title, window.location.pathname);
    }
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Validation des champs
    if (!formData.name || !formData.email || !formData.message) {
      Swal.fire({
        title: 'Attention !',
        text: 'Veuillez remplir tous les champs',
        icon: 'warning',
        confirmButtonColor: '#6366f1'
      });
      return;
    }

    setIsSubmitting(true);

    Swal.fire({
      title: 'Envoi en cours...',
      html: 'Veuillez patienter pendant l\'envoi de votre message',
      allowOutsideClick: false,
      didOpen: () => {
        Swal.showLoading();
      }
    });

    try {
      // Créer un formulaire HTML pour FormSubmit
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = 'https://formsubmit.co/djossou628@gmail.com';
      form.style.display = 'none';
      
      // Champs du formulaire
      const fields = {
        name: formData.name,
        email: formData.email,
        message: formData.message,
        _subject: 'Nouveau message depuis le Portfolio',
        _captcha: 'false',
        _template: 'table',
        _next: `${window.location.origin}${window.location.pathname}?sent=true#Contact` // Redirection après envoi
      };

      // Ajouter les champs au formulaire
      Object.keys(fields).forEach(key => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = key;
        input.value = fields[key];
        form.appendChild(input);
      });

      // Ajouter et soumettre le formulaire
      document.body.appendChild(form);
      form.submit();
      
      // Note: La page sera redirigée par FormSubmit
      // Le message de succès s'affichera après le retour

    } catch (error) {
      console.error('Erreur:', error);
      Swal.fire({
        title: 'Erreur !',
        text: 'Une erreur est survenue. Veuillez réessayer plus tard.',
        icon: 'error',
        confirmButtonColor: '#6366f1'
      });
      setIsSubmitting(false);
    }
  };

  return (
    <div className="px-[5%] sm:px-[5%] lg:px-[10%] " >
      <div className="text-center lg:mt-[5%] mt-10 mb-2 sm:px-0 px-[5%]">
        <h2
          data-aos="fade-down"
          data-aos-duration="1000"
          className="inline-block text-3xl md:text-5xl font-bold text-center mx-auto text-transparent bg-clip-text bg-gradient-to-r from-[#6366f1] to-[#a855f7]"
        >
          <span
            style={{
              color: "#6366f1",
              backgroundImage:
                "linear-gradient(45deg, #6366f1 10%, #a855f7 93%)",
              WebkitBackgroundClip: "text",
              backgroundClip: "text",
              WebkitTextFillColor: "transparent",
            }}
          >
            Contactez-moi
          </span>
        </h2>
        <p
          data-aos="fade-up"
          data-aos-duration="1100"
          className="text-slate-400 max-w-2xl mx-auto text-sm md:text-base mt-2"
        >
          Une question ? Envoyez-moi un message et je vous répondrai rapidement.
        </p>
      </div>

      <div
        className="h-auto py-10 flex items-center justify-center 2xl:pr-[3.1%] lg:pr-[3.8%]  md:px-0"
        id="Contact"
      >
        <div className="container px-[1%] grid grid-cols-1 sm:grid-cols-1 md:grid-cols-1 lg:grid-cols-[45%_55%] 2xl:grid-cols-[35%_65%] gap-12" >
          <div
        
            className="bg-white/5 backdrop-blur-xl rounded-3xl shadow-2xl p-5 py-10 sm:p-10 transform transition-all duration-500 hover:shadow-[#6366f1]/10"
          >
            <div className="flex justify-between items-start mb-8">
              <div>
                <h2 className="text-4xl font-bold mb-3 text-transparent bg-clip-text bg-gradient-to-r from-[#6366f1] to-[#a855f7]">
                  Contact
                </h2>
                <p className="text-gray-400">
                  Envie d'échanger ? Envoyez-moi un message et discutons ensemble.
                </p>
              </div>
              <Share2 className="w-10 h-10 text-[#6366f1] opacity-50" />
            </div>

            <form 
              onSubmit={handleSubmit}
              className="space-y-6"
            >
              <div
                data-aos="fade-up"
                data-aos-delay="100"
                className="relative group"
              >
                <User className="absolute left-4 top-4 w-5 h-5 text-gray-400 group-focus-within:text-[#6366f1] transition-colors" />
                <input
                  type="text"
                  name="name"
                  placeholder="Votre nom"
                  value={formData.name}
                  onChange={handleChange}
                  disabled={isSubmitting}
                  className="w-full p-4 pl-12 bg-white/10 rounded-xl border border-white/20 placeholder-gray-500 text-white focus:outline-none focus:ring-2 focus:ring-[#6366f1]/30 transition-all duration-300 hover:border-[#6366f1]/30 disabled:opacity-50"
                  required
                />
              </div>
              <div
                data-aos="fade-up"
                data-aos-delay="200"
                className="relative group"
              >
                <Mail className="absolute left-4 top-4 w-5 h-5 text-gray-400 group-focus-within:text-[#6366f1] transition-colors" />
                <input
                  type="email"
                  name="email"
                  placeholder="Votre email"
                  value={formData.email}
                  onChange={handleChange}
                  disabled={isSubmitting}
                  className="w-full p-4 pl-12 bg-white/10 rounded-xl border border-white/20 placeholder-gray-500 text-white focus:outline-none focus:ring-2 focus:ring-[#6366f1]/30 transition-all duration-300 hover:border-[#6366f1]/30 disabled:opacity-50"
                  required
                />
              </div>
              <div
                data-aos="fade-up"
                data-aos-delay="300"
                className="relative group"
              >
                <MessageSquare className="absolute left-4 top-4 w-5 h-5 text-gray-400 group-focus-within:text-[#6366f1] transition-colors" />
                <textarea
                  name="message"
                  placeholder="Votre message"
                  value={formData.message}
                  onChange={handleChange}
                  disabled={isSubmitting}
                  className="w-full resize-none p-4 pl-12 bg-white/10 rounded-xl border border-white/20 placeholder-gray-500 text-white focus:outline-none focus:ring-2 focus:ring-[#6366f1]/30 transition-all duration-300 hover:border-[#6366f1]/30 h-[9.9rem] disabled:opacity-50"
                  required
                />
              </div>
              <button
                data-aos="fade-up"
                data-aos-delay="400"
                type="submit"
                disabled={isSubmitting}
                className="w-full bg-gradient-to-r from-[#6366f1] to-[#a855f7] text-white py-4 rounded-xl font-semibold transition-all duration-300 hover:scale-[1.02] hover:shadow-lg hover:shadow-[#6366f1]/20 active:scale-[0.98] flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100"
              >
                <Send className="w-5 h-5" />
                {isSubmitting ? 'Envoi...' : 'Envoyer'}
              </button>
            </form>

          </div>

          {/* Colonne de droite - Informations de contact améliorée */}
          <div className="hidden lg:flex flex-col gap-6">
            {/* Carte principale avec design moderne */}
            <div 
              data-aos="fade-left"
              data-aos-duration="1000"
              className="relative bg-gradient-to-br from-slate-900/90 to-slate-800/90 backdrop-blur-xl rounded-3xl p-8 border border-white/10 h-full flex flex-col justify-between overflow-hidden"
            >
              {/* Background decoratif */}
              <div className="absolute inset-0 bg-gradient-to-br from-[#6366f1]/5 to-[#a855f7]/5"></div>
              <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-bl from-[#6366f1]/10 to-transparent rounded-full blur-2xl"></div>
              <div className="absolute bottom-0 left-0 w-24 h-24 bg-gradient-to-tr from-[#a855f7]/10 to-transparent rounded-full blur-2xl"></div>
              
              <div className="relative z-10">
                <div className="flex items-center gap-4 mb-8">
                  <div className="w-14 h-14 rounded-2xl bg-gradient-to-r from-[#6366f1] to-[#a855f7] flex items-center justify-center shadow-lg shadow-[#6366f1]/25">
                    <User className="w-7 h-7 text-white" />
                  </div>
                  <div>
                    <h3 className="text-2xl font-bold bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">
                      Laurent DJOSSOU
                    </h3>
                    <p className="text-gray-400 text-sm">DevOps & Cloud Engineer</p>
                  </div>
                </div>

                <div className="space-y-5 mb-8">
                  {/* Email avec effet hover amélioré */}
                  <a 
                    href="mailto:djossou628@gmail.com" 
                    className="flex items-center gap-4 group p-4 rounded-xl bg-gradient-to-r from-white/5 to-white/0 hover:from-[#6366f1]/10 hover:to-[#6366f1]/5 transition-all duration-300 border border-transparent hover:border-[#6366f1]/20"
                  >
                    <div className="w-12 h-12 rounded-xl bg-gradient-to-r from-[#6366f1]/20 to-[#6366f1]/10 flex items-center justify-center group-hover:scale-110 transition-transform">
                      <Mail className="w-6 h-6 text-[#6366f1]" />
                    </div>
                    <div>
                      <p className="text-gray-400 text-xs uppercase tracking-wider">Email</p>
                      <p className="text-white font-medium group-hover:text-[#6366f1] transition-colors">
                        djossou628@gmail.com
                      </p>
                    </div>
                  </a>

                  {/* LinkedIn avec effet hover amélioré */}
                  <a 
                    href="https://www.linkedin.com/in/laurent-djossou-ab2493240" 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="flex items-center gap-4 group p-4 rounded-xl bg-gradient-to-r from-white/5 to-white/0 hover:from-[#0077b5]/10 hover:to-[#0077b5]/5 transition-all duration-300 border border-transparent hover:border-[#0077b5]/20"
                  >
                    <div className="w-12 h-12 rounded-xl bg-gradient-to-r from-[#0077b5]/20 to-[#0077b5]/10 flex items-center justify-center group-hover:scale-110 transition-transform">
                      <Linkedin className="w-6 h-6 text-[#0077b5]" />
                    </div>
                    <div>
                      <p className="text-gray-400 text-xs uppercase tracking-wider">LinkedIn</p>
                      <p className="text-white font-medium group-hover:text-[#0077b5] transition-colors">
                        Laurent DJOSSOU
                      </p>
                    </div>
                  </a>

                  {/* GitHub avec effet hover amélioré */}
                  <a 
                    href="https://github.com/Linerror99" 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="flex items-center gap-4 group p-4 rounded-xl bg-gradient-to-r from-white/5 to-white/0 hover:from-white/10 hover:to-white/5 transition-all duration-300 border border-transparent hover:border-white/20"
                  >
                    <div className="w-12 h-12 rounded-xl bg-gradient-to-r from-white/20 to-white/10 flex items-center justify-center group-hover:scale-110 transition-transform">
                      <Github className="w-6 h-6 text-white" />
                    </div>
                    <div>
                      <p className="text-gray-400 text-xs uppercase tracking-wider">GitHub</p>
                      <p className="text-white font-medium group-hover:text-gray-300 transition-colors">
                        @Linerror99
                      </p>
                    </div>
                  </a>

                  {/* Localisation */}
                  <div className="flex items-center gap-4 p-4 rounded-xl bg-gradient-to-r from-white/5 to-white/0 border border-white/10">
                    <div className="w-12 h-12 rounded-xl bg-gradient-to-r from-[#a855f7]/20 to-[#a855f7]/10 flex items-center justify-center">
                      <MapPin className="w-6 h-6 text-[#a855f7]" />
                    </div>
                    <div>
                      <p className="text-gray-400 text-xs uppercase tracking-wider">Localisation</p>
                      <p className="text-white font-medium">France</p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Section du bas avec statut amélioré */}
              <div className="relative pt-6 border-t border-white/10">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="relative">
                      <div className="w-3 h-3 rounded-full bg-green-400 animate-pulse"></div>
                      <div className="absolute inset-0 w-3 h-3 rounded-full bg-green-400 animate-ping opacity-75"></div>
                    </div>
                    <div>
                      <p className="text-white font-semibold text-sm">Disponible</p>
                      <p className="text-gray-400 text-xs">Réponse rapide </p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-xs text-gray-400">Temps de réponse</p>
                    <p className="text-white font-semibold text-sm">{"< 48h"}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ContactPage;