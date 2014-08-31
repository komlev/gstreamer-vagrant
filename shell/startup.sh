#!/bin/bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update
sudo apt-get install make git curl mongodb-org bison flex libglib2.0-dev libtheora-dev libvorbis-dev g++ libpng-dev libflac-dev libspeex-dev yasm nettle-dev libgcrypt-dev libmp3lame-dev python3 python3-dev python-gobject-dev -y
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install nodejs -y

#gstreamer part
sudo mkdir /usr/local/src/gstreamer
cd /usr/local/src/gstreamer

sudo git clone https://chromium.googlesource.com/webm/libvpx
cd libvpx
sudo ./configure && sudo make && sudo make install && sudo make clean
cd ../

sudo git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump
sudo make && sudo make install && sudo make clean
cd ../

#!/bin/bash
# downloading gstreamer
mirror=http://gstreamer.freedesktop.org/src

version=1.4.1

file[0]=orc-0.4.22
file[1]=gstreamer-$version
file[2]=gst-plugins-base-$version
file[3]=gst-plugins-good-$version
file[4]=gst-plugins-bad-$version
file[5]=gst-plugins-ugly-$version
file[6]=gst-libav-$version
file[7]=gst-python-1.2.1

wgetfile[0]=orc/${file[0]}.tar.xz
wgetfile[1]=gstreamer/${file[1]}.tar.xz
wgetfile[2]=gst-plugins-base/${file[2]}.tar.xz
wgetfile[3]=gst-plugins-good/${file[3]}.tar.xz
wgetfile[4]=gst-plugins-bad/${file[4]}.tar.xz
wgetfile[5]=gst-plugins-ugly/${file[5]}.tar.xz
wgetfile[6]=gst-libav/${file[6]}.tar.xz
wgetfile[7]=gst-python/${file[7]}.tar.gz

for (( i = 0 ; i < ${#wgetfile[@]} ; i++ )) 
do 
  echo ${wgetfile[$i]}
  sudo wget $mirror/${wgetfile[$i]} -nv
done 

unset wgetfile 
unset mirror 

for f in ./*.tar.*; do tar xf "$f" && rm "$f"; done
export LD_LIBRARY_PATH=/usr/local/lib
for (( i = 0 ; i < ${#file[@]} ; i++ )) 
do
  f=${file[$i]}
  echo $f
  cd "$f"
  sudo ./configure && sudo make && sudo make install && sudo make clean
  sudo ldconfig
  cd ../
done 
unset file
unset f

cd ~
rm -r /usr/local/src/gstreamer