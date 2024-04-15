# Use a imagem base do Ruby
FROM ruby:3.0

# Instala as dependências necessárias, incluindo Node.js e Yarn
RUN apt-get update -qq && apt-get install -y nodejs npm && npm install --global yarn

# Instala o cliente do PostgreSQL, caso ainda não tenha feito
RUN apt-get install -y postgresql-client

# Instala o dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Define o diretório de trabalho no container
WORKDIR /app

# Copia o Gemfile e Gemfile.lock para o container
COPY Gemfile Gemfile.lock ./

# Instala as gems
RUN bundle install

# Agora, copia o restante dos arquivos do projeto para o container
COPY . .

# Expõe a porta 3000
EXPOSE 3000

# Define um comando de entrada que configura corretamente o ambiente Rails
# antes de iniciar o servidor Rails
ENTRYPOINT ["sh", "-c", "rm -f tmp/pids/server.pid && dockerize -wait tcp://rabbitmq:5672 -timeout 60s && rails server -b '0.0.0.0'"]
