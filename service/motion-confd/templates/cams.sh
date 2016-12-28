#!/bin/bash
mkdir /etc/motion/conf.d
rm -rf /etc/motion/conf.d/*

{{range gets "/streams/*"}}
{{$data := json .Value}}

echo "====> Creating Config for {{$data.name}}"
TARGET="/etc/motion/conf.d/cam-{{$data.name}}.conf"

cat > ${TARGET} <<END

camera_id = {{$data.id}}
input -1
text_left {{$data.name}}
netcam_url "{{$data.src}}"
netcam_userpass admin:admin
width {{$data.width}}
height {{$data.height}}
despeckle_filter EedDl
lightswitch 80

#restream
stream_port 808{{$data.id}}
stream_maxrate 25
stream_quality 90
END
{{end}}

sv restart /service/motion
