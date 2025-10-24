import { motion } from 'framer-motion'
import { Award, Code, Database, Server } from 'lucide-react'

function About() {
  const skills = [
    {
      icon: Server,
      title: 'Infrastructure Cloud',
      items: ['AWS (EC2, ECS, Lambda, S3)', 'GCP (Compute Engine, Cloud Run)', 'Architecture multi-cloud'],
    },
    {
      icon: Code,
      title: 'Infrastructure as Code',
      items: ['Terraform', 'CloudFormation', 'Ansible', 'Pulumi'],
    },
    {
      icon: Database,
      title: 'Containerisation',
      items: ['Docker', 'Kubernetes', 'ECS Fargate', 'Cloud Run'],
    },
    {
      icon: Award,
      title: 'CI/CD & DevOps',
      items: ['GitHub Actions', 'GitLab CI', 'Jenkins', 'ArgoCD'],
    },
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
              À propos de <span className="gradient-text">moi</span>
            </h1>
            <p className="text-xl text-gray-400 max-w-3xl mx-auto">
              ✨ Transformer les idées en expériences cloud modernes ✨
            </p>
          </motion.div>
        </div>
      </section>

      {/* Bio Section */}
      <section className="section-padding bg-black/20">
        <div className="container-custom">
          <div className="grid md:grid-cols-2 gap-12 items-center">
            <motion.div
              initial={{ opacity: 0, x: -50 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.8 }}
            >
              <h2 className="text-3xl font-bold mb-6">
                Bonjour, je suis
                <br />
                <span className="gradient-text text-4xl">Votre Nom</span>
              </h2>
              <p className="text-gray-400 mb-4 leading-relaxed">
                Ingénieur DevOps passionné par les technologies cloud et l'automatisation.
                Je me spécialise dans la conception et la mise en œuvre d'infrastructures
                scalables et résilientes sur AWS et GCP.
              </p>
              <p className="text-gray-400 mb-6 leading-relaxed">
                Mon objectif est de créer des solutions innovantes qui améliorent la
                productivité des équipes et garantissent des déploiements fiables et sécurisés.
              </p>

              <blockquote className="glass p-6 rounded-lg border-l-4 border-primary-500">
                <p className="italic text-gray-300">
                  "Tirer parti de l'IA comme outil professionnel, pas comme un remplacement."
                </p>
              </blockquote>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, x: 50 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.8 }}
              className="relative"
            >
              <div className="glass rounded-full w-80 h-80 mx-auto flex items-center justify-center glow">
                {/* Remplacer par votre photo */}
                <div className="w-72 h-72 rounded-full bg-gradient-to-br from-primary-500 to-primary-800 flex items-center justify-center text-6xl font-bold">
                  👨‍💻
                </div>
              </div>
            </motion.div>
          </div>
        </div>
      </section>

      {/* Skills Section */}
      <section className="section-padding">
        <div className="container-custom">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-12"
          >
            <h2 className="text-4xl font-bold mb-4">Compétences Techniques</h2>
            <p className="text-gray-400">Technologies et outils que je maîtrise</p>
          </motion.div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
            {skills.map((skill, index) => {
              const Icon = skill.icon
              return (
                <motion.div
                  key={skill.title}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: 0.1 * index }}
                  className="glass p-6 rounded-xl hover:scale-105 transition-transform duration-300"
                >
                  <div className="w-12 h-12 rounded-lg bg-primary-500/20 flex items-center justify-center mb-4">
                    <Icon className="w-6 h-6 text-primary-500" />
                  </div>
                  <h3 className="text-xl font-semibold mb-4">{skill.title}</h3>
                  <ul className="space-y-2">
                    {skill.items.map((item) => (
                      <li key={item} className="text-sm text-gray-400 flex items-center gap-2">
                        <span className="w-1.5 h-1.5 rounded-full bg-primary-500" />
                        {item}
                      </li>
                    ))}
                  </ul>
                </motion.div>
              )
            })}
          </div>
        </div>
      </section>

      {/* Stats Cards */}
      <section className="section-padding bg-black/20">
        <div className="container-custom">
          <div className="grid md:grid-cols-3 gap-8">
            {[
              { number: '10+', label: 'Projets réalisés', sublabel: 'Solutions web innovantes' },
              { number: '5', label: 'Certifications', sublabel: 'Compétences validées' },
              { number: '3', label: 'Années d\'expérience', sublabel: 'Apprentissage continu' },
            ].map((stat, index) => (
              <motion.div
                key={stat.label}
                initial={{ opacity: 0, scale: 0.9 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                transition={{ delay: 0.1 * index }}
                className="glass p-8 rounded-xl text-center group hover:glow transition-all duration-300"
              >
                <div className="w-16 h-16 mx-auto mb-4 rounded-full bg-primary-500/20 flex items-center justify-center">
                  <Award className="w-8 h-8 text-primary-500 group-hover:scale-110 transition-transform" />
                </div>
                <h3 className="text-5xl font-bold gradient-text mb-2">{stat.number}</h3>
                <p className="text-lg font-semibold text-white mb-1">{stat.label}</p>
                <p className="text-sm text-gray-400">{stat.sublabel}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>
    </div>
  )
}

export default About
