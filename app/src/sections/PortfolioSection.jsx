import { motion } from 'framer-motion'
import { Code, Award, Globe, ExternalLink, Github } from 'lucide-react'

function PortfolioSection() {
  const portfolioTabs = [
    { id: 'projects', label: 'Projets', icon: Code },
    { id: 'certificates', label: 'Certifications', icon: Award },
    { id: 'techstack', label: 'Stack Technique', icon: Globe },
  ]

  const projects = [
    {
      title: 'Infrastructure Multi-Cloud',
      description: 'Déploiement automatisé d\'une application containerisée sur AWS et GCP avec Terraform et GitHub Actions.',
      image: null,
      tech: ['Terraform', 'Docker', 'AWS', 'GCP'],
      liveUrl: '#',
      githubUrl: '#',
    },
    {
      title: 'Pipeline CI/CD Enterprise',
      description: 'Mise en place d\'un pipeline CI/CD complet avec tests automatisés, scan de sécurité et déploiement blue-green.',
      image: null,
      tech: ['GitHub Actions', 'Kubernetes', 'ArgoCD', 'Helm'],
      liveUrl: '#',
      githubUrl: '#',
    },
  ]

  return (
    <section id="portfolio" className="min-h-screen section-padding">
      <div className="container-custom">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-5xl md:text-6xl font-bold mb-4">
            <span className="gradient-text">Vitrine Portfolio</span>
          </h2>
          <p className="text-xl text-gray-400 max-w-4xl mx-auto">
            Explorez mon parcours à travers mes projets, certifications et expertise technique.
            Chaque section représente une étape importante dans mon apprentissage continu.
          </p>
        </motion.div>

        {/* Tabs Navigation */}
        <div className="grid md:grid-cols-3 gap-6 mb-16">
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

        {/* Projects Grid */}
        <div className="mb-16">
          <h3 className="text-3xl font-bold mb-8 text-center">
            Projets <span className="gradient-text">Récents</span>
          </h3>
          <div className="grid md:grid-cols-2 gap-8">
            {projects.map((project, index) => (
              <motion.div
                key={project.title}
                initial={{ opacity: 0, scale: 0.95 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                transition={{ delay: 0.1 * index }}
                className="glass rounded-xl overflow-hidden group hover:glow transition-all duration-300"
              >
                <div className="h-48 bg-gradient-to-br from-primary-500 to-primary-800 flex items-center justify-center">
                  <Code className="w-20 h-20 text-white opacity-50" />
                </div>
                <div className="p-6">
                  <h4 className="text-xl font-bold mb-2">{project.title}</h4>
                  <p className="text-gray-400 mb-4 text-sm">
                    {project.description}
                  </p>
                  <div className="flex flex-wrap gap-2 mb-4">
                    {project.tech.map((tech) => (
                      <span
                        key={tech}
                        className="px-3 py-1 bg-primary-500/20 text-primary-400 rounded-full text-xs font-medium"
                      >
                        {tech}
                      </span>
                    ))}
                  </div>
                  <div className="flex gap-3">
                    <a
                      href={project.liveUrl}
                      className="text-primary-500 hover:text-primary-400 text-sm font-medium inline-flex items-center gap-1"
                    >
                      <ExternalLink className="w-4 h-4" />
                      Voir le projet
                    </a>
                    <a
                      href={project.githubUrl}
                      className="text-primary-500 hover:text-primary-400 text-sm font-medium inline-flex items-center gap-1"
                    >
                      <Github className="w-4 h-4" />
                      Code source
                    </a>
                  </div>
                </div>
              </motion.div>
            ))}

            {/* Placeholder */}
            <motion.div
              initial={{ opacity: 0, scale: 0.95 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              transition={{ delay: 0.2 }}
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
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="text-center glass p-12 rounded-xl"
        >
          <Award className="w-16 h-16 mx-auto mb-4 text-primary-500" />
          <h3 className="text-2xl font-bold mb-2">Certifications</h3>
          <p className="text-gray-400">
            AWS Solutions Architect • Terraform Associate • GCP Cloud Engineer
          </p>
        </motion.div>
      </div>
    </section>
  )
}

export default PortfolioSection
