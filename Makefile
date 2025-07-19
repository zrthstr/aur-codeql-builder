bumpversion:
	bash check.sh

docker-build:
	docker run --rm -v "$$PWD/codeql:/build" -w /build archlinux:latest /bin/bash -c "\
		pacman -Sy --noconfirm base-devel git && \
		chown -R nobody:nobody /build && \
		usermod -s /bin/bash nobody && \
		chage -E -1 nobody && \
		su nobody -s /bin/bash -c 'cd /build && makepkg --printsrcinfo > .SRCINFO && makepkg -s --noconfirm' && \
		pacman -U --noconfirm /build/codeql-*.pkg.tar.zst && \
		codeql version"


fix-folder-permissions-from-docker:
	id
	UID=$$(id -u) GID=$$(id -g) sudo chown runner:runner -R /home/runner/work/aur-codeql-builder/aur-codeql-builder/codeql/
	ls -alh /home/runner/work/aur-codeql-builder/aur-codeql-builder/codeql/

commit:
	cd codeql && \
	git add PKGBUILD .SRCINFO && \
	if [ -n \"$(git status --porcelain)\" ]; then \
	  git commit -m \"Version bump\" && \
	  git push; \
	else \
	  echo \"No changes to commit\"; \
	fi
