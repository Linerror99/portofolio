import React, { useState, useEffect } from "react";
import { Menu, X, Globe } from "lucide-react";
import { useTranslation } from "react-i18next";

const Navbar = () => {
    const { t, i18n } = useTranslation('common');
    const [isOpen, setIsOpen] = useState(false);
    const [scrolled, setScrolled] = useState(false);
    const [activeSection, setActiveSection] = useState("Home");
    const [showLangMenu, setShowLangMenu] = useState(false);
    
    const navItems = [
        { href: "#Home", label: t('nav.home') },
        { href: "#About", label: t('nav.about') },
        { href: "#Formation", label: t('nav.formation') },
        { href: "#Portofolio", label: t('nav.portfolio') },
        { href: "#Contact", label: t('nav.contact') },
    ];

    useEffect(() => {
        const handleScroll = () => {
            setScrolled(window.scrollY > 20);
            const sections = navItems.map(item => {
                const section = document.querySelector(item.href);
                if (section) {
                    return {
                        id: item.href.replace("#", ""),
                        offset: section.offsetTop - 550,
                        height: section.offsetHeight
                    };
                }
                return null;
            }).filter(Boolean);

            const currentPosition = window.scrollY;
            const active = sections.find(section => 
                currentPosition >= section.offset && 
                currentPosition < section.offset + section.height
            );

            if (active) {
                setActiveSection(active.id);
            }
        };

        window.addEventListener("scroll", handleScroll);
        handleScroll();
        return () => window.removeEventListener("scroll", handleScroll);
    }, []);

    useEffect(() => {
        if (isOpen) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = 'unset';
        }
    }, [isOpen]);

    const scrollToSection = (e, href) => {
        e.preventDefault();
        const section = document.querySelector(href);
        if (section) {
            const top = section.offsetTop - 100;
            window.scrollTo({
                top: top,
                behavior: "smooth"
            });
        }
        setIsOpen(false);
    };

    return (
        <nav
            className={`fixed w-full top-0 z-50 transition-all duration-500 ${
                isOpen
                    ? "bg-[#030014]"
                    : scrolled
                    ? "bg-[#030014]/50 backdrop-blur-xl"
                    : "bg-transparent"
            }`}
        >
            <div className="mx-auto px-[5%] sm:px-[5%] lg:px-[10%]">
                <div className="flex items-center justify-between h-16">
                    {/* Logo */}
                    <div className="flex-shrink-0">
                        <a
                            href="#Home"
                            onClick={(e) => scrollToSection(e, "#Home")}
                            className="text-xl font-bold bg-gradient-to-r from-[#a855f7] to-[#6366f1] bg-clip-text text-transparent"
                        >
                            Laurent D.
                        </a>
                    </div>
        
                    {/* Desktop Navigation */}
                    <div className="hidden md:block">
                        <div className="ml-8 flex items-center space-x-8">
                            {navItems.map((item) => (
                                <a
                                    key={item.label}
                                    href={item.href}
                                    onClick={(e) => scrollToSection(e, item.href)}
                                    className="group relative px-1 py-2 text-sm font-medium"
                                >
                                    <span
                                        className={`relative z-10 transition-colors duration-300 ${
                                            activeSection === item.href.substring(1)
                                                ? "bg-gradient-to-r from-[#6366f1] to-[#a855f7] bg-clip-text text-transparent font-semibold"
                                                : "text-[#e2d3fd] group-hover:text-white"
                                        }`}
                                    >
                                        {item.label}
                                    </span>
                                    <span
                                        className={`absolute bottom-0 left-0 w-full h-0.5 bg-gradient-to-r from-[#6366f1] to-[#a855f7] transform origin-left transition-transform duration-300 ${
                                            activeSection === item.href.substring(1)
                                                ? "scale-x-100"
                                                : "scale-x-0 group-hover:scale-x-100"
                                        }`}
                                    />
                                </a>
                            ))}
                            
                            {/* Language Switcher */}
                            <div className="relative">
                                <button
                                    onClick={() => setShowLangMenu(!showLangMenu)}
                                    className="flex items-center gap-2 px-3 py-2 text-sm font-medium text-[#e2d3fd] hover:text-white transition-colors rounded-lg hover:bg-white/5"
                                >
                                    <Globe className="w-4 h-4" />
                                    <span className="uppercase">{i18n.language}</span>
                                </button>
                                
                                {showLangMenu && (
                                    <div className="absolute right-0 mt-2 w-32 bg-[#0a0a1a] border border-white/10 rounded-lg shadow-xl overflow-hidden">
                                        <button
                                            onClick={() => {
                                                i18n.changeLanguage('fr');
                                                setShowLangMenu(false);
                                            }}
                                            className={`w-full px-4 py-2 text-left text-sm transition-colors ${
                                                i18n.language === 'fr'
                                                    ? 'bg-gradient-to-r from-[#6366f1]/20 to-[#a855f7]/20 text-white font-medium'
                                                    : 'text-[#e2d3fd] hover:bg-white/5'
                                            }`}
                                        >
                                            🇫🇷 Français
                                        </button>
                                        <button
                                            onClick={() => {
                                                i18n.changeLanguage('en');
                                                setShowLangMenu(false);
                                            }}
                                            className={`w-full px-4 py-2 text-left text-sm transition-colors ${
                                                i18n.language === 'en'
                                                    ? 'bg-gradient-to-r from-[#6366f1]/20 to-[#a855f7]/20 text-white font-medium'
                                                    : 'text-[#e2d3fd] hover:bg-white/5'
                                            }`}
                                        >
                                            🇬🇧 English
                                        </button>
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>
        
                    {/* Mobile Menu Button */}
                    <div className="md:hidden">
                        <button
                            onClick={() => setIsOpen(!isOpen)}
                            className={`relative p-2 text-[#e2d3fd] hover:text-white transition-transform duration-300 ease-in-out transform ${
                                isOpen ? "rotate-90 scale-125" : "rotate-0 scale-100"
                            }`}
                        >
                            {isOpen ? (
                                <X className="w-6 h-6" />
                            ) : (
                                <Menu className="w-6 h-6" />
                            )}
                        </button>
                    </div>
                </div>
            </div>
        
            {/* Mobile Menu */}
            <div
                className={`md:hidden transition-all duration-300 ease-in-out ${
                    isOpen
                        ? "max-h-screen opacity-100"
                        : "max-h-0 opacity-0 overflow-hidden"
                }`}
            >
                <div className="px-4 py-6 space-y-4">
                    {navItems.map((item, index) => (
                        <a
                            key={item.label}
                            href={item.href}
                            onClick={(e) => scrollToSection(e, item.href)}
                            className={`block px-4 py-3 text-lg font-medium transition-all duration-300 ease ${
                                activeSection === item.href.substring(1)
                                    ? "bg-gradient-to-r from-[#6366f1] to-[#a855f7] bg-clip-text text-transparent font-semibold"
                                    : "text-[#e2d3fd] hover:text-white"
                            }`}
                            style={{
                                transitionDelay: `${index * 100}ms`,
                                transform: isOpen ? "translateX(0)" : "translateX(50px)",
                                opacity: isOpen ? 1 : 0,
                            }}
                        >
                            {item.label}
                        </a>
                    ))}
                    
                    {/* Mobile Language Switcher */}
                    <div className="flex gap-2 px-4 pt-4 border-t border-white/10">
                        <button
                            onClick={() => {
                                i18n.changeLanguage('fr');
                                setIsOpen(false);
                            }}
                            className={`flex-1 px-3 py-2 text-sm font-medium rounded-lg transition-all ${
                                i18n.language === 'fr'
                                    ? 'bg-gradient-to-r from-[#6366f1] to-[#a855f7] text-white'
                                    : 'bg-white/5 text-[#e2d3fd] hover:bg-white/10'
                            }`}
                        >
                            🇫🇷 FR
                        </button>
                        <button
                            onClick={() => {
                                i18n.changeLanguage('en');
                                setIsOpen(false);
                            }}
                            className={`flex-1 px-3 py-2 text-sm font-medium rounded-lg transition-all ${
                                i18n.language === 'en'
                                    ? 'bg-gradient-to-r from-[#6366f1] to-[#a855f7] text-white'
                                    : 'bg-white/5 text-[#e2d3fd] hover:bg-white/10'
                            }`}
                        >
                            🇬🇧 EN
                        </button>
                    </div>
                </div>
            </div>
        </nav>
    );
};

export default Navbar;