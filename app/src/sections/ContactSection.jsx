import { motion } from 'framer-motion'
import { Mail, MessageSquare, Send, User, Clock, AlertCircle } from 'lucide-react'
import { useState } from 'react'

function ContactSection() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    message: '',
  })

  const handleSubmit = (e) => {
    e.preventDefault()
    // TODO: Implémenter l'envoi du formulaire
    console.log('Form submitted:', formData)
    alert('Merci pour votre message ! (Fonctionnalité à implémenter)')
  }

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    })
  }

  return (
    <section id="contact" className="min-h-screen section-padding bg-black/20">
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
            <span className="gradient-text">Contactez-moi</span>
          </h2>
          <p className="text-xl text-gray-400 max-w-2xl mx-auto">
            Une question ? Envoyez-moi un message, et je vous répondrai dès que possible.
          </p>
        </motion.div>

        {/* Contact Form & Info */}
        <div className="max-w-5xl mx-auto">
          <div className="grid md:grid-cols-2 gap-12">
            {/* Form */}
            <motion.div
              initial={{ opacity: 0, x: -50 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.8 }}
            >
              <div className="glass p-8 rounded-xl">
                <h3 className="text-3xl font-bold mb-6 gradient-text">Envoyez un message</h3>
                <form onSubmit={handleSubmit} className="space-y-6">
                  {/* Name */}
                  <div>
                    <label htmlFor="name" className="block text-sm font-medium mb-2 text-gray-300">
                      Nom *
                    </label>
                    <div className="relative">
                      <User className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500" />
                      <input
                        type="text"
                        id="name"
                        name="name"
                        required
                        value={formData.name}
                        onChange={handleChange}
                        placeholder="Votre nom"
                        className="w-full pl-12 pr-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 transition-all text-white placeholder-gray-500"
                      />
                    </div>
                  </div>

                  {/* Email */}
                  <div>
                    <label htmlFor="email" className="block text-sm font-medium mb-2 text-gray-300">
                      Email *
                    </label>
                    <div className="relative">
                      <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500" />
                      <input
                        type="email"
                        id="email"
                        name="email"
                        required
                        value={formData.email}
                        onChange={handleChange}
                        placeholder="votre@email.com"
                        className="w-full pl-12 pr-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 transition-all text-white placeholder-gray-500"
                      />
                    </div>
                  </div>

                  {/* Message */}
                  <div>
                    <label htmlFor="message" className="block text-sm font-medium mb-2 text-gray-300">
                      Message *
                    </label>
                    <div className="relative">
                      <MessageSquare className="absolute left-3 top-3 w-5 h-5 text-gray-500" />
                      <textarea
                        id="message"
                        name="message"
                        required
                        value={formData.message}
                        onChange={handleChange}
                        rows="5"
                        placeholder="Écrivez votre message ici..."
                        className="w-full pl-12 pr-4 py-3 bg-white/5 border border-white/10 rounded-lg focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 transition-all text-white placeholder-gray-500 resize-none"
                      />
                    </div>
                  </div>

                  {/* Submit Button */}
                  <button type="submit" className="btn-primary w-full flex items-center justify-center gap-2">
                    <Send className="w-5 h-5" />
                    Envoyer le message
                  </button>
                </form>
              </div>
            </motion.div>

            {/* Info Cards */}
            <motion.div
              initial={{ opacity: 0, x: 50 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.8 }}
              className="space-y-6"
            >
              <div className="glass p-6 rounded-xl">
                <h4 className="text-xl font-bold mb-4 flex items-center gap-2">
                  <Mail className="w-5 h-5 text-primary-500" />
                  Informations de contact
                </h4>
                <div className="space-y-3">
                  <div>
                    <p className="text-sm text-gray-400 mb-1">Email</p>
                    <a href="mailto:contact@example.com" className="text-white hover:text-primary-500 transition-colors">
                      contact@example.com
                    </a>
                  </div>
                </div>
              </div>

              <div className="glass p-6 rounded-xl">
                <h4 className="text-xl font-bold mb-4 flex items-center gap-2">
                  <Clock className="w-5 h-5 text-primary-500" />
                  Temps de réponse
                </h4>
                <p className="text-gray-400 leading-relaxed">
                  Je m'efforce de répondre à tous les messages dans les <strong className="text-white">24-48 heures</strong>.
                  Pour les demandes urgentes, n'hésitez pas à me contacter via LinkedIn.
                </p>
              </div>

              <div className="glass p-6 rounded-xl bg-primary-500/10 border border-primary-500/30">
                <h4 className="text-xl font-bold mb-2 flex items-center gap-2 text-primary-400">
                  <AlertCircle className="w-5 h-5" />
                  Note
                </h4>
                <p className="text-gray-300 text-sm">
                  Ce formulaire est actuellement en développement. Pour me contacter immédiatement,
                  utilisez les liens sociaux dans le footer.
                </p>
              </div>

              {/* Comments Section Teaser */}
              <div className="glass p-6 rounded-xl">
                <h4 className="text-xl font-bold mb-3">
                  <span className="gradient-text">Commentaires (129)</span>
                </h4>
                <p className="text-gray-400 text-sm mb-4">
                  Voir ce que les autres disent ou laissez votre propre commentaire !
                </p>
                <button className="btn-secondary w-full text-sm">
                  Voir les commentaires
                </button>
              </div>
            </motion.div>
          </div>
        </div>
      </div>
    </section>
  )
}

export default ContactSection
