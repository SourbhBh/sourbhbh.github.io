# Base image: Ruby with necessary dependencies for Jekyll
FROM ruby:3.2

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /usr/src/app

# Copy Gemfile and Gemfile.lock into the container so `bundle install`
# installs the exact versions the mounted lockfile expects at runtime
COPY Gemfile Gemfile.lock ./

# Install bundler (matching "BUNDLED WITH" in Gemfile.lock) and dependencies.
# BUNDLE_FROZEN makes bundler install exactly what Gemfile.lock lists and
# fail rather than modify it.
RUN gem install connection_pool:2.5.0
RUN gem install bundler:2.7.2
RUN BUNDLE_FROZEN=true bundle install

# Command to serve the Jekyll site
CMD ["jekyll", "serve", "-H", "0.0.0.0", "-w", "--config", "_config.yml,_config_docker.yml"]
