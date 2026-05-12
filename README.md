# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Setup (development)

1. Install gems:

```bash
bundle install
```

2. Copy example env and edit if needed:

```bash
cp .env.example .env
# edit .env and set DB credentials if necessary
```

3. Create and migrate the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

4. Start the app (example):

```bash
bin/rails server
```

Notes:
- The app reads `DATABASE_URL` automatically if set; the `config/database.yml` is configured to prefer explicit env vars when provided.
- Do not commit your `.env` file to version control.
