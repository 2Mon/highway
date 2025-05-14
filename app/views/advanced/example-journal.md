# Example journal entry
Here's an example journal entry - it's a little long so I put it on a separate page.

It's for a retro game console I'm building that runs on a Raspberry Pi Zero 2W!

*I find that writing journals like this can be pretty tedious, so one thing I recommend is just recording a vlog of what you did and then summarizing that instead. To that end though, you still need to include images and fairly detailed descriptions!*

---

#### June 8: Got the screen to work!!

I got the raspberry pi to actualy display on the LCD! Can't believe it actually works

I based the wiring off of the [pi-tin](https://github.com/jackw01/pi-tin) project originally, but they used an ili9341 display instead of the st7735r I was reusing from sprig. That meant that I had to figure out not only how they got it to display originally, but also how to modify that to use the ST7735R drivers instead

<img src="https://hc-cdn.hel1.your-objectstorage.com/s/v3/c48431039154826272fd3cc5fcc07abfdbc8dd84_image.png" style="max-width: 400px;"></img>

Fortunately for us, the pi-tin project actually documented how the software was set up! They actually cross-reference an adafruit script, which is a derivative of one from pimoroni. 

In short, here's how the original method worked:

- Install FBCP (framebuffer copy) drivers, which captures whatever would've been outputted to HDMI and allows you to redirect it somewhere else
- Modify the dtoverlays (device tree overlay) in /boot/config.txt to use the built-in kernel drivers for the ILI9341
- Reboot. The framebuffer should automatically redirect everything to the display.

The main problem was then figuring out what parameters I needed to add to /boot/config.txt to make it work with the new display. I wasn't even sure if there were the right drivers built into the linux kernel!

Here's how I figured that out:

- the original [rpi-fbcp](https://github.com/tasanakorn/rpi-fbcp) repository mentions some sort of FBTFT driver
- a quick search links to [this](https://github.com/notro/fbtft) repository, which then mentions that the drivers were now in staging on the [linux kernel](https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/tree/drivers/staging/fbtft?h=staging-testing)
- a bunch more digging eventually leads me to stumble to this file: [st7735r.c](https://github.com/torvalds/linux/blob/master/drivers/gpu/drm/tiny/st7735r.c)

Bingo. The drivers exist.

Anyhow, digging into the existing dtoverlays eventually led me to an st7735r generic overlay in the raspberrypi/linux repo! Using ChatGPT to then convert that to a dtparam, I eventually got video output:

<img src="https://hc-cdn.hel1.your-objectstorage.com/s/v3/47e8125f1950ef96977b173a2ed70ae04fae28c4_image.png" style="max-width: 400px;"></img>

*The tl;dr* is that raspberry pi provides the dtoverlay files for the ST7735R built in, so it's a matter of installing a framebuffer and redirecting that to the display in the /boot/config.txt file 

**Time spent this session: 6 hours**
