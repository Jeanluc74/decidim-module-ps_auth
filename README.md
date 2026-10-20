# Decidim::PsAuth

Modulo per aggiungere autorizzazioni basate sul codice fiscale agli spazi partecipativi di Decidim.

Consente agli amministratori di caricare elenchi CSV di codici fiscali e di associarli a processi partecipativi, assemblee o iniziative. Solo i partecipanti il cui codice fiscale è presente in uno degli elenchi abilitati possono ottenere l'autorizzazione a votare nello spazio configurato.

## Utilizzo

Una volta installato, abilita l'autorizzazione all'interno di **System**. Successivamente, nella sezione **Amministrazione** sarà disponibile la voce **Elenchi CF** per gestire i file CSV dei codici fiscali autorizzati e associarli agli spazi partecipativi.

Il modulo espone un handler di autorizzazione (`ps_auth`) che può essere abilitato sui singoli spazi partecipativi tramite **Partecipanti** -> **Autorizzazioni** -> **Autorizzazione CF**.

Una volta creato l'elenco dei codici fiscali e abilitata l'autorizzazione, solo i partecipanti il cui codice fiscale è presente nell'elenco associato allo spazio partecipativo potranno ottenere l'autorizzazione a votare.

## Installazione

Aggiungi questa riga al `Gemfile` della tua applicazione:

```ruby
gem "decidim-ps_auth"
```

Poi esegui:

```bash
bundle
bundle exec rails decidim_ps_auth:install:migrations
bundle exec rails db:migrate
bundle exec rails generate decidim:ps_auth:install
```

Questo installa la migrazione (ad esempio `create_decidim_ps_auth_settings`) e la applica al database.

Il generatore di installazione crea anche un initializer in `config/initializers/decidim-ps_auth.rb` che **devi** configurare per indicare al modulo come recuperare il codice fiscale di ciascun utente:

```ruby
# frozen_string_literal: true

Decidim::PsAuth.configure do |config|

  config.cf_lookup = ->(organization, user_id) {
    # `organization` can be used to differentiate lookup logic per tenant.
    # Examples:
    # Decidim::User.find_by(id: user_id, organization: organization)&.fiscal_code
    # Decidim::Authorization.find_by(decidim_user_id: user_id)
    #   &.metadata&.dig("fiscal_code")
  }

end
```

La lambda `cf_lookup` riceve l'`organization` corrente (un'istanza di `Decidim::Organization`) e il `user_id`, e deve restituire la stringa del codice fiscale per quell'utente, oppure `nil` se non disponibile.

## Contributi

I contributi sono benvenuti!

Ci aspettiamo che i contributi seguano la [guida ai contributi di Decidim](https://github.com/decidim/decidim/blob/develop/CONTRIBUTING.adoc).

## Sicurezza

La sicurezza è molto importante per noi. Se riscontri un problema di sicurezza, ti chiediamo di segnalarlo responsabilmente inviando una email a gianlucacorso@tiscali.it  e non aprendo una issue su GitHub.

## Licenza

Questo modulo è distribuito con licenza GNU AFFERO GENERAL PUBLIC LICENSE.
