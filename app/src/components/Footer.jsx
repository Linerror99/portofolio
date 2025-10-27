import { Github, Linkedin, Mail } from 'lucide-react'

function Footer() {
  const currentYear = new Date().getFullYear()

  const socialLinks = [
    { icon: Github, href: 'https://github.com/Linerror99', label: 'GitHub' },
    { icon: Linkedin, href: 'https://www.linkedin.com/in/laurent-djossou-ab2493240', label: 'LinkedIn' },
    { icon: Mail, href: 'mailto:djossou628@gmail.com', label: 'Email' },
  ]

  return (
    <footer className="bg-black/20 border-t border-white/10">
      <div className="container-custom py-8">
        <div className="flex flex-col md:flex-row items-center justify-between gap-4">
          {/* Copyright */}
          <p className="text-sm text-gray-400">
            © {currentYear} Laurent DJOSSOU - Portfolio DevOps. Propulsé par AWS, GCP & Terraform.
          </p>

          {/* Social Links */}
          <div className="flex items-center space-x-6">
            {socialLinks.map((link) => {
              const Icon = link.icon
              return (
                <a
                  key={link.label}
                  href={link.href}
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label={link.label}
                  className="p-2 rounded-lg bg-white/5 hover:bg-white/10 transition-all duration-300 group"
                >
                  <Icon className="w-5 h-5 text-gray-400 group-hover:text-primary-500 transition-colors" />
                </a>
              )
            })}
          </div>
        </div>
      </div>
    </footer>
  )
}

export default Footer
