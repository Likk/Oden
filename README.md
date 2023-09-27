# DESCRIPTION

  Oden is discord bot client.

# SET UP

## install perl lib
require anyenv, gcc, libssl-dev or libcrypt-ssleay-perl.

```
$ git clone git@github.com:Likk/Oden.git ./Oden
$ cd ./Oden
$ anyenv install plenv
$ cat .perl-version | xargs plenv install
$ ./env.sh plenv install-cpanm
$ ./env.sh cpanm Carton
$ ./env.sh carton install
```

## edit your bot configure

vim ./.pit/default.yaml
```
"discord":-
  "token": 'Your Bot Token'
  "information_channel_id": 'create thread announce channel on your guild'
  "webhook_endpoint": 'your webhook endoiunt url on your guild'
```

# LUNCH YOUR BOT
./env.sh perl bot.pl

# Bot Slash Command List
- ayt
- itemsearch
- fishing
- market
- dict
- place
- dice

## ayt
ping. like AYT command on telnet. its means 'are you there?'.

## itemsearch ${item_name}
returns lodestone url. 

## fishing ${item_name}
retruns teamcraft url.

## market ${server_or_DC} ${item_name}
returns market board from universalis

## dict
### dict add ${key} ${word}
### dict overwrite ${key} ${word}
### dict get ${key}
### dict move ${old_key} ${new_key}
### dict delete ${key}

# choice [list]
returns random choice from list

# dice
roll dice. default 1d6.
The dice string uses the following format: [0-9]+d[F0-9]+
examples: 1d20, 2d10, 1dF
see also: [Games::Dice](https://metacpan.org/dist/Games-Dice)
