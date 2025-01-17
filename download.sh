#!/bin/bash
check_tar() {
  if ! command -v tar > /dev/null; then
      echo "tar is not installed!"
      echo "In order to use this script please install tar from your package manager"
      exit
  fi
}
check_unzip() {
  if ! command -v unzip > /dev/null; then
      echo "unzip is not installed!"
      echo "In order to use this script please install unzip from your package manager"
      exit
  fi
}
check_wget() {
  if ! command -v wget > /dev/null; then
      echo "wget is not installed!"
      echo "In order to use this script please install wget from your package manager"
      exit
  fi
}
check_adb() {
  if ! command -v fastboot > /dev/null; then
      echo "Android Platform Tools are not installed!"
      echo "In order to use this script please install the android platform tools from your package manager"
      exit
  fi
}
clean() {
    echo "Cleaning..."
    rm -rf extracted*
    rm -rf META-INF
    rm payload_properties.txt
    rm payload-dumper-go.tar.gz
    rm payload-dumper-go
    rm fw.zip
    rm payload.bin
    rm apex_info.pb
    rm care_map.pb
}
echo "Nothing firmware downloader by @sh4ttered V1.1.2"
check_wget;
check_adb;
check_tar;
check_unzip;

rm -rf images/ #clean from previous downloads
#if [ -f "payload-dumper-go.tar.gz" ]; then
#    rm payload-dumper-go.tar.gz #clean from previous downloads // stupid check(?)
#fi
if [[ $(uname -m) == 'arm64' ]]; then #check if arch is arm64
  arm="1"
fi
if [[ $(uname) == 'Linux' ]]; then #GNU/Linux
    linux="1"
elif [[ $(uname) == 'Darwin' ]]; then #macOS
    mac="1"
else
    echo "OS Unsupported"
    exit 1
fi

read -p "Do you need the [G]lobal firmware or the [E]uropean firmware (G/E)? " ge 
case $ge in 
	G | g)  echo "Downloading the global firmware v1.1.2";
            echo "This may take a while depending on your internet speed";
            echo " ";
            wget -q --show-progress -O fw.zip https://android.googleapis.com/packages/ota-api/package/a244285dfb5aef198999463c2d55f353ed0e7b1b.zip;;
	E | e)  echo "Downloading the EU firmware v1.1.2";
            echo "This may take a while depending on your internet speed";
            echo " ";
            wget -q --show-progress -O fw.zip https://android.googleapis.com/packages/ota-api/package/0f77244380edcc46a4d60397f5c22ea911352bfe.zip;;
    * )     echo "Invalid input!";
		    exit 1;;
esac

if [[ $linux -eq "1" ]]; then #GNU/Linux
    if [[ $arm -eq 1 ]]; then #download arm64 version if needed
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_arm64.tar.gz
    else
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_amd64.tar.gz
    fi
elif [[ $mac -eq "1" ]]; then #macOS
    if [[ $arm -eq 1 ]]; then #download arm64 version if needed
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_darwin_arm64.tar.gz
    else
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_darwin_amd64.tar.gz
    fi
fi

tar -zxf payload-dumper-go.tar.gz payload-dumper-go
unzip -q fw.zip
./payload-dumper-go payload.bin
echo " "
mkdir images
mv extracted*/* images/
clean;
