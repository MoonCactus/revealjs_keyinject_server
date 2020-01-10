# revealjs_keyinject_server

### What it does

This single Unix bash script helps you handle [Reveal.js](https://revealjs.com) presentations via your
smartphone, if ike me, you like to stand and move around (i.e. end up far from your keyboad).

It works on X windows and it requires `xdotool` and `nc` (netcat), with the modern `-q 0` option.
I doubt it would work on iOS, please tell me if it does or if you ported it.

### How to run

1) Make sure your laptop and smarphone are on the same local network (and read the Disclaimer below!)

2) Run the script on the machine that is going to show the presentation ("laptop"):

```
./revealjs_keyinject_server.sh
```

Default port is `4444` but you can set a non-default port with `./revealjs_keyinject_server.sh 1234`, e.g.

3) Point your smartphone web browser to the URL shown by the script, it should show a basic UI

4) Then, on the laptop
  * launch your web browser
  * point it to your Reveal.js URL (it can be remote or local, this will not matter)
  * make it the active window (like in fullscreen with F11)

5) On your smartphone you can press the left or right part to move within your presentation.

The script will emulate `Page Up` / `Page Down` events, which makes it possible to parse *all* the slides
(as done with `Space` and `Shift+Space`, and contrary to the cursor keys).

### Bugs and improvements

None known. The script shows the actions with a date to help check if everything is OK.

It would be trivial to change or add other keys.

Feel free to send pull requests, or to enhance the user interface ;)

### Disclaimer

**Anyone who has access to your laptop IP and port will be able to disrupt your presentation**

  * Your laptop and smartphone must be on the same local network so they can talk
  * There is NO SECURITY AT ALL. So you probably want to keep your LAN a *private area*.
  * One cheap way to do so is to have your laptop connect to  your smartphone shared wifi,
  or use a non default port. Of course you could set a firewall up but meh.

### How it works

What is does is to reinterpret the action you do on the webpage as key presses.

How it does it is:
  * create a listening socket
  * send an HTML page that contains two clickable div that cover the screen (one on the left, one on the right)
  * when you press one of them, the page calls the server back with the corresponding ?BKW or ?FWD argument
    * the bash script then extracts the argument (HTTP GET request)
    * and according to the parameter, it injects a PageUp or PageDown key event locally, via `xdotool`

Hence, *if the currently active windows is your browser*, it will behave exactly as if you pressed
the corresponding key on your laptop. If any another app is active, it will get a page up or page down as well!
