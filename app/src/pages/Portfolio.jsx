import { motion } from 'framer-motion'
import { Code, Award, Globe } from 'lucide-react'

function Portfolio() {
  const portfolioTabs = [
    { id: 'projects', label: 'Projets', icon: Code },
    { id: 'certificates', label: 'Certifications', icon: Award },
    { id: 'techstack', label: 'Stack Technique', icon: Globe },
  ]

  return (
    <div className="min-h-screen pt-20">
      {/* Header */}
      <section className="section-padding">
        <div className="container-custom text-center">
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <h1 className="text-5xl md:text-6xl font-bold mb-4">
              <span className="gradient-text">Vitrine Portfolio</span>
            </h1>
            <p className="text-xl text-gray-400 max-w-4xl mx-auto">
              Explorez mon parcours à travers mes projets, certifications et expertise technique.
              Chaque section représente une étape importante dans mon apprentissage continu.
            </p>
          </motion.div>
        </div>
      </section>

      {/* Tabs Navigation */}
      <section className="section-padding bg-black/20">
        <div className="container-custom">
          <div className="grid md:grid-cols-3 gap-6 mb-12">
            {portfolioTabs.map((tab, index) => {
              const Icon = tab.icon
              return (
                <motion.div
                  key={tab.id}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: 0.1 * index }}
                  className="glass p-8 rounded-xl text-center cursor-pointer hover:glow transition-all duration-300 group"
                >
                  <div className="w-16 h-16 mx-auto mb-4 rounded-full bg-primary-500/20 flex items-center justify-center group-hover:scale-110 transition-transform">
                    <Icon className="w-8 h-8 text-primary-500" />
                  </div>
                  <h3 className="text-2xl font-bold text-white mb-2">{tab.label}</h3>
                </motion.div>
              )
            })}
          </div>

          {/* Projects Section */}
          <div className="mb-16">
            <h2 className="text-3xl font-bold mb-8 text-center">
              Projets <span className="gradient-text">Récents</span>
            </h2>
            <div className="grid md:grid-cols-2 gap-8">
              {/* Project Card Example */}
              <motion.div
                initial={{ opacity: 0, scale: 0.95 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                className="glass rounded-xl overflow-hidden group hover:glow transition-all duration-300"
              >
                <div className="h-48 bg-gradient-to-br from-primary-500 to-primary-800 flex items-center justify-center">
                  <Code className="w-20 h-20 text-white opacity-50" />
                </div>
                <div className="p-6">
                  <h3 className="text-xl font-bold mb-2">Infrastructure Multi-Cloud</h3>
                  <p className="text-gray-400 mb-4 text-sm">
                    Déploiement automatisé d'une application containerisée sur AWS et GCP
                    avec Terraform et GitHub Actions.
                  </p>
                  <div className="flex flex-wrap gap-2 mb-4">
                    {['Terraform', 'Docker', 'AWS', 'GCP'].map((tech) => (
                      <span
                        key={tech}
                        className="px-3 py-1 bg-primary-500/20 text-primary-400 rounded-full text-xs font-medium"
                      >
                        {tech}
                      </span>
                    ))}
                  </div>
                  <div className="flex gap-3">
                    <a href="#" className="text-primary-500 hover:text-primary-400 text-sm font-medium">
                      Voir le projet →
                    </a>
                    <a href="#" className="text-primary-500 hover:text-primary-400 text-sm font-medium">
                      GitHub →
                    </a>
                  </div>
                </div>
              </motion.div>

              {/* Add more project cards */}
              <motion.div
                initial={{ opacity: 0, scale: 0.95 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                transition={{ delay: 0.1 }}
                className="glass rounded-xl p-12 flex items-center justify-center text-center border-2 border-dashed border-gray-600 hover:border-primary-500 transition-colors cursor-pointer"
              >
                <div>
                  <Code className="w-12 h-12 mx-auto mb-4 text-gray-500" />
                  <p className="text-gray-400">Plus de projets à venir...</p>
                </div>
              </motion.div>
            </div>
          </div>

          {/* Certifications Placeholder */}
          <div className="text-center glass p-12 rounded-xl">
            <Award className="w-16 h-16 mx-auto mb-4 text-primary-500" />
            <h3 className="text-2xl font-bold mb-2">Certifications à venir</h3>
            <p className="text-gray-400">
              Section en développement - AWS Solutions Architect, Terraform Associate, etc.
            </p>
          </div>
        </div>
      </section>
    </div>
  )
}

export default Portfolio
