import { motion } from 'framer-motion'
import { ArrowRight, Cloud, Container, Code2 } from 'lucide-react'
import { Link } from 'react-router-dom'

function Home() {
  const techStack = [
    { name: 'AWS', icon: Cloud },
    { name: 'GCP', icon: Cloud },
    { name: 'Terraform', icon: Code2 },
    { name: 'Docker', icon: Container },
  ]

  return (
    <div className="min-h-screen pt-20">
      {/* Hero Section */}
      <section className="section-padding">
        <div className="container-custom">
          <div className="grid md:grid-cols-2 gap-12 items-center">
            {/* Texte */}
            <motion.div
              initial={{ opacity: 0, x: -50 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.8 }}
            >
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
                      transition={{ delay: 0.2 * index, duration: 0.5 }}
                      className="glass px-4 py-2 rounded-full flex items-center gap-2"
                    >
                      <Icon className="w-4 h-4 text-primary-500" />
                      <span className="text-sm font-medium">{tech.name}</span>
                    </motion.div>
                  )
                })}
              </div>

              {/* CTA Buttons */}
              <div className="flex flex-wrap gap-4">
                <Link to="/portfolio" className="btn-primary inline-flex items-center gap-2">
                  Voir mes projets
                  <ArrowRight className="w-5 h-5" />
                </Link>
                <Link to="/contact" className="btn-secondary">
                  Me contacter
                </Link>
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
        </div>
      </section>

      {/* Stats Section */}
      <section className="section-padding bg-black/20">
        <div className="container-custom">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            {[
              { number: '3+', label: 'Années d\'expérience' },
              { number: '10+', label: 'Projets réalisés' },
              { number: '5+', label: 'Certifications' },
              { number: '2', label: 'Cloud Providers' },
            ].map((stat, index) => (
              <motion.div
                key={stat.label}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: 0.1 * index }}
                className="text-center"
              >
                <h3 className="text-4xl md:text-5xl font-bold gradient-text mb-2">
                  {stat.number}
                </h3>
                <p className="text-gray-400">{stat.label}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>
    </div>
  )
}

export default Home
