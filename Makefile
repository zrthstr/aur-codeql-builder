bumpversion:
	bash check.sh

update:
	cd codeql && makepkg --printsrcinfo > .SRCINFO

docker-build:
	docker run --rm -v "$(PWD)/codeql:/pkg" -w /pkg archlinux:base bash -c "\
		pacman -Sy --noconfirm base-devel unzip git && \
		useradd -m builduser && \
		chown -R builduser /pkg && \
		su builduser -c 'makepkg -si --noconfirm' && \
		codeql -V \
	"

commit:
	cd codeql && git add PKGBUILD .SRCINFO && git commit -m "Auto bump version and checksum" && git push

