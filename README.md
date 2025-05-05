# Messenger Service

A real-time messaging application built with Ruby on Rails, featuring instant messaging, file sharing, and read receipts.

## Features

- Real-time messaging using Action Cable
- File attachments (images, documents)
- Read receipts and message status tracking
- User authentication with Devise
- Responsive design
- Docker support for development and production

## Future Enhancements

- **Rich Media Support**
  - Image gallery view within messages
  - Audio message support
  - GIF and sticker support

- **User Experience**
  - Message reactions (emojis)
  - Message editing and deletion
  - Message search functionality
  - Message pinning
  - Typing indicators
  - Online/offline status

- **Internationalization**
  - Multi-language support (I18n)
  - RTL language support
  - Timezone handling
  - Date/time localization

- **Advanced Features**
  - Group conversations
  - Message threading
  - Voice and video calls
  - Screen sharing
  - End-to-end encryption
  - Message backup and restore

- **Integration**
  - Third-party service integration (Google Drive, Dropbox)
  - Webhook support
  - API documentation
  - Mobile app support

- **Administration**
  - Admin dashboard
  - User management
  - Content moderation
  - Analytics and reporting

## Prerequisites

- Ruby 3.2.4
- PostgreSQL 15
- Redis 7
- Node.js (for asset compilation)
- Yarn (for JavaScript dependencies)

## Setup Without Docker

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd messenger_service
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   ```

4. Start Redis server:
   ```bash
   redis-server
   ```

5. Start the Rails server:
   ```bash
   rails server
   ```

6. Visit `http://localhost:3000` in your browser

## Setup With Docker

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd messenger_service
   ```

2. Build and start the containers:
   ```bash
   docker-compose build
   docker-compose up
   ```

3. Set up the database:
   ```bash
   docker-compose run web rails db:create db:migrate
   ```

4. Visit `http://localhost:3000` in your browser

## Development

### Running Tests

Without Docker:
```bash
rails test
```

With Docker:
```bash
docker-compose run web rails test
```

### Environment Variables

The application uses the following environment variables:

- `DATABASE_URL`: PostgreSQL connection URL
- `REDIS_URL`: Redis connection URL
- `RAILS_ENV`: Rails environment (development, test, production)
- `POSTGRES_HOST`: PostgreSQL host (default: localhost)
- `POSTGRES_USER`: PostgreSQL username (default: postgres)
- `POSTGRES_PASSWORD`: PostgreSQL password (default: password)

### Database Configuration

The application uses PostgreSQL as its database. Configuration can be found in `config/database.yml`.

### Redis Configuration

Redis is used for Action Cable and background jobs. Configuration can be found in `config/cable.yml`.

## Deployment

The application is configured for deployment with Docker. The `Dockerfile` is optimized for production use with:

- Multi-stage builds to minimize image size
- Proper security practices (non-root user)
- Asset precompilation
- Database initialization

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
