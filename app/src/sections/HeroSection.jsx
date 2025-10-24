import { motion } from 'framer-motion'
import { ArrowDown, Cloud, Container, Code2 } from 'lucide-react'

function HeroSection() {
  const techStack = [
    { name: 'AWS', icon: Cloud },
    { name: 'GCP', icon: Cloud },
    { name: 'Terraform', icon: Code2 },
    { name: 'Docker', icon: Container },
  ]

  const scrollToSection = (sectionId) => {
    const element = document.getElementById(sectionId)
    element?.scrollIntoView({ behavior: 'smooth' })
  }

  return (
    <section id="home" className="min-h-screen flex items-center section-padding">
      <div className="container-custom w-full">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          {/* Texte */}
          <motion.div
            initial={{ opacity: 0, x: -50 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.8 }}
          >
            <motion.div
              initial={{ opacity: 0, y: -20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
              className="inline-flex items-center gap-2 glass px-4 py-2 rounded-full mb-6"
            >
              <span className="w-2 h-2 bg-green-500 rounded-full animate-pulse" />
              <span className="text-sm">Prêt à innover</span>
            </motion.div>

            <h1 className="text-5xl md:text-7xl font-bold mb-6">
              Ingénieur
              <br />
              <span className="gradient-text">DevOps & Cloud</span>
            </h1>
            <p className="text-xl text-gray-400 mb-8 leading-relaxed">
              Spécialisé en infrastructure multi-cloud, containerisation et automatisation.
              Passionné par l'innovation et les technologies modernes.
            </p>

            {/* Tech Stack */}
            <div className="flex flex-wrap gap-4 mb-8">
              {techStack.map((tech, index) => {
                const Icon = tech.icon
                return (
                  <motion.div
                    key={tech.name}
                    initial={{ opacity: 0, scale: 0.5 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: 0.4 + 0.1 * index, duration: 0.5 }}
                    className="glass px-4 py-2 rounded-full flex items-center gap-2 hover:glow transition-all duration-300"
                  >
                    <Icon className="w-4 h-4 text-primary-500" />
                    <span className="text-sm font-medium">{tech.name}</span>
                  </motion.div>
                )
              })}
            </div>

            {/* CTA Buttons */}
            <div className="flex flex-wrap gap-4">
              <button
                onClick={() => scrollToSection('portfolio')}
                className="btn-primary inline-flex items-center gap-2"
              >
                Voir mes projets
                <ArrowDown className="w-5 h-5" />
              </button>
              <button
                onClick={() => scrollToSection('contact')}
                className="btn-secondary"
              >
                Me contacter
              </button>
            </div>
          </motion.div>

          {/* Illustration */}
          <motion.div
            initial={{ opacity: 0, x: 50 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="relative"
          >
            <div className="relative w-full h-96 flex items-center justify-center">
              {/* Cercles animés */}
              <motion.div
                animate={{
                  scale: [1, 1.2, 1],
                  rotate: [0, 180, 360],
                }}
                transition={{
                  duration: 20,
                  repeat: Infinity,
                  ease: 'linear',
                }}
                className="absolute w-80 h-80 rounded-full border-2 border-primary-500/30"
              />
              <motion.div
                animate={{
                  scale: [1, 1.1, 1],
                  rotate: [360, 180, 0],
                }}
                transition={{
                  duration: 15,
                  repeat: Infinity,
                  ease: 'linear',
                }}
                className="absolute w-64 h-64 rounded-full border-2 border-primary-700/30"
              />
              
              {/* Centre */}
              <div className="relative z-10 glass w-48 h-48 rounded-full flex items-center justify-center glow">
                <Code2 className="w-24 h-24 text-primary-500" />
              </div>
            </div>
          </motion.div>
        </div>

        {/* Scroll indicator */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1.5 }}
          className="absolute bottom-10 left-1/2 -translate-x-1/2 cursor-pointer"
          onClick={() => scrollToSection('about')}
        >
          <motion.div
            animate={{ y: [0, 10, 0] }}
            transition={{ duration: 1.5, repeat: Infinity }}
            className="flex flex-col items-center gap-2 text-gray-400 hover:text-primary-500 transition-colors"
          >
            <span className="text-sm">Défiler vers le bas</span>
            <ArrowDown className="w-5 h-5" />
          </motion.div>
        </motion.div>
      </div>
    </section>
  )
}

export default HeroSection
