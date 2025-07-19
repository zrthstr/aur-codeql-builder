bumpversion:
	bash check.sh

docker-build:
	docker run --rm -v "$$PWD/codeql:/build" -w /build archlinux:latest /bin/bash -c "\
		pacman -Sy --noconfirm base-devel git && \
		makepkg --printsrcinfo > .SRCINFO && \
		makepkg -si --noconfirm"

commit:
	cd codeql && \
	git add PKGBUILD .SRCINFO && \
	if [ -n \"$(git status --porcelain)\" ]; then \
	  git commit -m \"Version bump\" && \
	  git push; \
	else \
	  echo \"No changes to commit\"; \
	fi

