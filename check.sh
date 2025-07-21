set -ex

OWNER="github"
REPO="codeql-cli-binaries"
PKGLOCATION="codeql/PKGBUILD"


### read info from local PKG file
LOCALVER=$(grep -ir pkgver= $PKGLOCATION | sed 's/pkgver=//g')
LOCALCHK=$(sed -nE "s/^sha256sums=\('([a-f0-9]+)'\).*/\1/p" $PKGLOCATION)
echo "Current version in ./codeql folder is: $LOCALVER with $LOCALCHK"


### read info from remote / gh
# chk=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/github/codeql-cli-binaries/releases | jq -r '.[0] | .assets[] | select(.name | test("linux64.zip.checksum.txt")) | .browser_download_url')
resp=$(curl -s -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/github/codeql-cli-binaries/releases/latest)
chk=$(jq -r '.assets[] | select(.name | test("linux64.zip.checksum.txt")) | .browser_download_url' <<< "$resp")


# https://github.com/github/codeql-cli-binaries/releases/download/v2.18.3/codeql-linux64.zip.checksum.txt
if [[ "$chk" =~ ^https://[a-zA-Z0-9._/-]+\.checksum\.txt$ ]]; then
    echo "Valid URL format: $chk"
else
    echo "Invalid or unsafe URL: $chk"
    exit 1
fi

NEWESTVER=$(echo $chk | sed -E  's/.*\/v([0-9]+\.[0-9]+\.[0-9]+)\/.*/\1/' )
NEWESTCHK=$(curl https://github.com/${OWNER}/${REPO}/releases/download/v${NEWESTVER}/codeql-linux64.zip.checksum.txt -L | awk '{print $1}')
if [[ "$NEWESTCHK" =~ ^[0-9a-fA-F]{64}$ ]]; then
    echo "Valid SHA-256 checksum: $NEWESTCHK"
else
    echo "Invalid or empty checksum: $NEWESTCHK"
    exit 1
fi

echo "Current newest release on GH is: $NEWESTVER with $NEWESTCHK"


#### patch PKG file if out of date
if [[ "$NEWESTVER" == "$LOCALVER" ]]
then
  echo "Up to date"
  exit
else
  echo "Out of date"
	echo "... patching"
	sed -i "s/pkgver=${LOCALVER}/pkgver=${NEWESTVER}/" $PKGLOCATION
	sed -i "s/${LOCALCHK}/${NEWESTCHK}/" $PKGLOCATION
  echo done ...
fi

