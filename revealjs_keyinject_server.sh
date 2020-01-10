#!/bin/sh
# Creates a minimalist web server on port 4444 (by default) with two buttons,
# that in turn injects PageUp/Down keyboard events on the active (X) window.
# This way, you can use your phone web browser to navigate in reveal.js.

port=${1-4444}
contact=$(hostname -I | awk '{printf($1)}'; echo ":$port")

html=$(cat << EOF
HTTP/1.1 200 OK

<html>
	<style type="text/css">
		body   { text-align: center; font-family: sans; background-color: black; color: white; }
		.Arrow { position: absolute; left: 0; top: 0; bottom: 0; }
		.Left  { top: 4em; width: 50%; background:linear-gradient(to right, #000, #666);}
		.Right { left: 50%; top: 4em;  background:linear-gradient(to right, #888, #000); width:50%}
		.Bott  { color: black; position: fixed; bottom: 0; width: 50%; font-size:200px; }
	</style>
	<body>
		<div> Reveal.js remote control <br/> jeremie@obi2b.com <br/> $contact </div>
		<div class="Arrow Left"  onclick="move('BCK')"> <div class="Bott"> &lArr; </div> </div>
		<div class="Arrow Right" onclick="move('FWD')"> <div class="Bott"> &rArr; </div> </div>
	</body>
	<script>
		function move(param) {
			console.log("move", param);
			window.location = window.location.href.split(/[?#]/)[0] + "?" + param;
		}
	</script>
</html>
EOF
)

echo "Reveal.js controlling web server is listening on $port..."
while true; do

	action=$(
		echo "$html" |
			timeout 0.5 netcat -l "$port" |
				sed -n 's|GET /?\([A-Za-z0-1]*\).*|\1|p'
	)
		
	if [ "$action" = 'BCK' ]; then
		echo "$action on $(date)"
		xdotool key Page_Up
	elif [ "$action" = 'FWD' ]; then
		echo "$action on $(date)"
		xdotool key Page_Down
	fi
done
