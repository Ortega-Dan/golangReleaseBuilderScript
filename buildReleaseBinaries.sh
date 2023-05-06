#! /bin/bash
if [ -z "$1" ]; then
    echo "Please provide the version number as an argument (e.g: 1.11.23)."
    exit
else
    echo "Building release binaries for: v$1"
    echo
fi

binaryname=$(cat go.mod | grep module | head -n 1 | cut -d" " -f2 | rev | cut -d/ -f1 | rev)

rm -rf uploader-binaries
mkdir uploader-binaries

# building
echo "Building Linux amd64 ..."
GOOS=linux GOARCH=amd64 go build -ldflags "-s -w -extldflags=-static" -gcflags=-trimpath=x/y -o uploader-binaries/linux-amd64/

echo "Building macOS amd64 ..."
GOOS=darwin GOARCH=amd64 go build -ldflags "-s -w -extldflags=-static" -gcflags=-trimpath=x/y -o uploader-binaries/mac-Intel-amd64/

echo "Building macOS arm64 ..."
GOOS=darwin GOARCH=arm64 go build -ldflags "-s -w -extldflags=-static" -gcflags=-trimpath=x/y -o uploader-binaries/mac-M1-arm64/

echo "Building Windows amd64 ..."
GOOS=windows GOARCH=amd64 go build -ldflags "-s -w -extldflags=-static" -gcflags=-trimpath=x/y -o uploader-binaries/windows-amd64/

cd uploader-binaries

echo 
echo "Reviewing binaries:"
echo

# visual verifying
for i in *
do
cd $i
echo $i
file *
echo
cd ..
done

echo
echo "Zipping binaries:"
# zipping
zip ../binaries-$binaryname-v$1.zip -r *
cd ..
rm -rf uploader-binaries

cd ..
echo
echo "Binaries file:"
echo ./binaries-$binaryname-v$1.zip
echo "is ready in current directory for upload."
