# OpenPress - High-Performance WordPress WebServer

A super fast, secure, and scalable web server setup for WordPress with built-in WAF, DDoS protection, and automatic HTTPS.

> **⚠️ Early Development Notice**: This project is in early development and has undergone limited testing. While designed with security and performance in mind, it should be thoroughly tested in your specific environment before production deployment. Use at your own discretion and consider additional security measures for production workloads.

## Features

- 🚀 **High Performance**: Optimized Nginx with OpenResty
- 🛡️ **Web Application Firewall**: ModSecurity with OWASP Core Rule Set
- 🛡️ **DDoS Protection**: Rate limiting, connection limiting, and Fail2Ban
- 🔒 **Automatic HTTPS**: Let's Encrypt integration with ACME protocol
- 📊 **Monitoring**: Health checks and comprehensive logging
- 🐳 **Docker Ready**: Easy deployment with Docker Compose

## Quick Start

1. **Clone and configure:**
   ```bash
   git clone <repository>
   cd openpress
   ```

2. **Configure your domain:**
   Edit `docker-compose.yml` and replace:
   - `yourdomain.com` with your actual domain
   - `admin@yourdomain.com` with your email

3. **Start the services:**
   ```bash
   docker-compose up -d
   ```

4. **Install WordPress:**
   - Access your domain
   - Follow the WordPress installation wizard
   - Database credentials are pre-configured in docker-compose.yml

## Configuration

### Environment Variables

Set these in your `docker-compose.yml`:

- `DOMAIN`: Your domain name
- `EMAIL`: Email for Let's Encrypt notifications

### SSL Certificates

- Automatic SSL certificate generation on first run
- Daily renewal checks via cron
- Fallback to self-signed certificates

### Security Features

#### WAF (Web Application Firewall)
- OWASP Core Rule Set integration
- Custom WordPress-specific rules
- SQL injection protection
- XSS prevention
- Brute force attack detection

#### DDoS Protection
- Rate limiting per IP
- Connection limiting
- Fail2Ban integration
- Suspicious request blocking

#### Performance Optimizations
- Gzip compression
- Static file caching
- FastCGI optimizations
- Keep-alive connections
- Worker process optimization

## File Structure

```
openpress/
├── Dockerfile              # Main container configuration
├── docker-compose.yml      # Service orchestration
├── nginx/                  # Nginx configuration
│   ├── nginx.conf         # Main nginx config
│   ├── sites-available/   # Site configurations
│   └── sites-enabled/     # Enabled sites
├── modsecurity/           # WAF configuration
│   ├── modsecurity.conf   # Main ModSecurity config
│   └── crs-setup.conf     # OWASP CRS setup
├── fail2ban/              # DDoS protection
│   ├── jail.local         # Fail2Ban jails
│   └── filter.d/          # Custom filters
├── scripts/               # Automation scripts
│   ├── start.sh          # Container startup script
│   ├── renew-ssl.sh      # SSL renewal script
│   └── cron-ssl-renewal  # Cron configuration
├── wordpress/             # WordPress files (mounted)
├── logs/                  # Log files (mounted)
└── ssl/                   # SSL certificates (mounted)
```

## Monitoring

### Health Checks
- HTTP endpoint: `http://yourdomain.com/health`
- Returns "healthy" when services are running

### Logs
- Nginx access/error logs: `./logs/nginx/`
- ModSecurity logs: Container logs
- Fail2Ban logs: Container logs

## Security Best Practices

1. **Keep Updated**: Regularly update Docker images
2. **Monitor Logs**: Check logs regularly for suspicious activity
3. **Firewall**: Configure host firewall to only allow necessary ports
4. **Backups**: Regular WordPress database and file backups
5. **SSL**: Monitor certificate expiry and renewal

## Troubleshooting

### Common Issues

1. **SSL Certificate Issues**
   - Check domain DNS configuration
   - Verify email address is valid
   - Check Let's Encrypt rate limits

2. **Performance Issues**
   - Monitor resource usage
   - Adjust rate limiting if too restrictive
   - Check PHP-FPM configuration

3. **WordPress Issues**
   - Verify database connection
   - Check file permissions
   - Review PHP error logs

### Logs and Debugging

```bash
# View container logs
docker-compose logs

# View specific service logs
docker-compose logs webserver

# Access container shell
docker-compose exec webserver sh
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

**Created by:** Chris Bunting

## Support

For issues and questions:
- Check the troubleshooting section
- Review Docker and Nginx documentation
- Open an issue on GitHub
