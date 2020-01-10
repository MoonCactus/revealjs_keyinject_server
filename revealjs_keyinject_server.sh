#!/bin/sh
# Creates a minimalist web server on port 4444 (by default) with two buttons,
# that in turn injects PageUp/Down keyboard events on the active (X) window.
# This way, you can use your phone webbrowser to navigate in reveal.js.

port=${1-4444}
html='HTTP/1.1 200 OK

<html>
	<style type="text/css">
		body   { text-align: center; font-family: sans; background-color: black; color: white; }
		a      { width:100%; color: white; text-decoration: none; font-size:300px; }
		.Arrow { position: absolute; left: 0; top: 0; bottom: 0; }
		.Left  { top: 4em; width: 50%; }
		.Right { left: 50%; top: 4em; background-color:#444; }
		.Bott  { position: fixed; bottom: 0; width: 50%; }
	</style>
	<body>
		<center>Reveal.js remote control<br/>jeremie@obi2b.com</center>
			<div class="Arrow Left">  <div class="Bott"> <a href="/?BKW"> &lArr; </a> </div> </div>
			<div class="Arrow Right"> <div class="Bott"> <a href="/?FWD"> &rArr; </a> </div> </div>
	</body>
</html>
'

echo "Reveal.js controlling web server is listening on $port..."
while true; do

	action=$(
		echo "$html" |
			timeout 0.5 netcat -l "$port" |
				sed -n 's|GET /?\([A-Za-z0-1]*\).*|\1|p'
	)

	if [ "$action" = 'BKW' ]; then
		echo "Back on $(date)"
		xdotool key Page_Up
	elif [ "$action" = 'FWD' ]; then
		echo "Forward on $(date)"
		xdotool key Page_Down
	fi
done
