# boobbot

> backronym ordaining & originating bot

comes up with a new backronym once a day

## How to install / update


```bash
cd ~; mkdir -p boobbot; (cd boobbot; curl -L https://github.com/nea89o/boobbot/releases/download/nightly/dist.zip > dist.zip; unzip -o dist.zip; sudo ./install.sh)
```

Instead of `cd ~` you can use wherever else you would like the boobbot directory to lie. Installs a systemd service and timer that you can enable or invoke directly using 

```bash
# To post a boob joke daily
systemctl enable boobjob.timer

# To post a boob joke once
systemctl start boobbot.service
```

Add a .env file to `boobbot/rt/.env` containing your misskey instance and id:

```env
MISSKEY_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXX
MISSKEY_INSTANCE=https://sk.amy.rip
```
