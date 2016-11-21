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
stream_port 808{{$data.id}}
width {{$data.width}}
height {{$data.height}}
target_dir /tmp/
END
{{end}}

sv restart /service/motion
