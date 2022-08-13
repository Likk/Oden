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
