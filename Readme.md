### Discord DAOC Phoenix Bot

Ruby Discord Bot that integrates with the DAOC Phoenix freeshard Herald

### Features:

- Guild RP alert (every 1M RP you get a message in the channel)
- Commands like `!rp-guild`, `!rp-realm` and `!who PLAYERNAME`, here's the full list:

```
!who NAME                - retrieves info about char - prende le info del PG nomepg
!stats NAME              - retrieves stats about char - Last week & 48h: RPs, Kills, Deaths + Deathblows
!rp-guild / !rp-gilda    - fetches the guild RPs - total (prende gli RP gilda in tempo reale - RP totali)
!rank-guild / !rank-bit  - List of guild (BIT) members
!rp-mid   / !rp-midgard  - RPs realm (Midgard, this week) (RP Reame - questa settimana)
!rp-total / !rp-tutti    - RPs overall (this week) (RP totali - questa settimana)
!help     / !comandi     - displays this message (mostra questo messaggio)
```

### Extra

Level up notification (levelup-notifier)

### Configure Env / Secrets

Rename `env_secret.default.rb` to `env_secret.rb` and fill the credentials for at least Discord (CLIENT_SECRET and BOT_TOKEN).

### Install

    gem install 

### Run

    ruby discord-bot.rb

---

Enjoy!

@makevoid
