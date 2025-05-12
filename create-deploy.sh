#!/usr/bin/env bash

rm -fr dist
dub build -b release
install -Dm755 boobbot -t dist/bin
mkdir -p dist/rt
cp -r systemd dist/

cat >dist/install.sh <<"EOF"
#!/usr/bin/env bash
(
cd "$(dirname -- "$0")"
root="$PWD"
echo "Switched to $root"
(cd systemd
	for f in *; do
		sed -e "s|SOURCE|$root|g" < "$f" > "/etc/systemd/system/$f"
	done
)
(cd rt
	if ! [[ -d "$root"/rt/SimpleWordlists ]]; then
		curl -L https://github.com/taikuukaits/SimpleWordlists/archive/master.tar.gz | tar -xzf-
		mv SimpleWordlists{-master,}
	fi
)
)

EOF
chmod +x dist/install.sh
