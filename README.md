# Palo Alto Let's Encrypt Certificate Manager

Automated Let's Encrypt certificate generation and deployment for Palo Alto Networks firewalls using DNS challenges.

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Palo Alto](https://img.shields.io/badge/Palo%20Alto-FA4616?style=for-the-badge&logo=paloaltonetworks&logoColor=white)
![Let's Encrypt](https://img.shields.io/badge/Let's%20Encrypt-003A70?style=for-the-badge&logo=letsencrypt&logoColor=white)
![Cloudflare DNS](https://img.shields.io/badge/Cloudflare%20DNS-F38020?style=for-the-badge&logo=cloudflare&logoColor=white&labelColor=%23F38020)


## 🚀 Quick Start

### 1. Clone the repository:

```bash
git clone https://github.com/yourusername/paloalto-letsencrypt.git
cd paloalto-letsencrypt
```

### 2. Copy and configure environment variables

```bash
cp .env.example .env
nano .env  # Edit with your values
```

### 3. Start the container

```bash
docker-compose up -d --build
```

## 📋 Prerequisites

- Docker and Docker Compose
- CloudFlare DNS management
- Palo Alto Networks firewall with API access
- Network connectivity to Palo Alto management interface

## 🔧 Configuration

See `.env.example` for all required environment variables.

## 📚 Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [Configuration Reference](docs/CONFIGURATION.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions welcome! Please read our contributing guidelines.

### .env.example:

```bash
# Domain Configuration
DOMAIN=example.com
EMAIL=admin@example.com

# CloudFlare Configuration
CLOUDFLARE_EMAIL=your-cloudflare-email@example.com
CLOUDFLARE_API_KEY=your-cloudflare-global-api-key

# Palo Alto Configuration
PALO_HOST=192.168.1.100
PALO_USER=admin
PALO_PASS=your-secure-password
```
