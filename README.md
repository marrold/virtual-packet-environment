
# Virtual Packet Environment

The "Virtual Packet Environment" is a collection of Docker containers and configs that allow you to create a virtualised packet radio environment on a single machine that can consist of multiple [Dire Wolf](https://github.com/wb2osz/direwolf) instances talking to each other over multiple "RF" links, but instead of using physical radios we interconnect the instances using audio loopbacks. This allows you to test various scenarios without needing multiple radios.

APRS can be emulated using Dire Wolfs native support, and traditional packet radio can be emulated using [BPQ](https://www.cantab.net/users/john.wiseman/Documents/) instances. Additional tools allow you simulate moving stations and see APRS stations on a [Track Direct Map](https://github.com/qvarforth/trackdirect/tree/main/config)

## Caveats

The Virtual Packet Environment is developed and tested on Debian, and whilst it will likely work on other Linux machines, it will not work on Windows, MacOS etc due to its tight integration with the Advanced Linux Sound Architecture (ALSA). You may be able to run it on Windows/MacOS inside a virtualised Linux machine but this isn't officially supported.

It's *highly* recommended you run the environment on a dedicated machine, or a machine that you're not using audio on. The audio stack on Linux is notoriously painful to configure and a mistake could mean breaking your audio chain, or sending packet data screeching out of your speakers.

There are also some caveats with using audio loopbacks rather than real RF:
- No [Capture Effect](https://en.wikipedia.org/wiki/Capture_effect) so any kind of collision will *always* result in failure.
- No variation of atmospheric conditions, unusual propagation etc.
- They represent a near perfect channel without audio filtering, pre-emphasis etc.
- When using a shared loop back Dire Wolf will receive packets from itself. This is mostly a cosmetic issue.


## How does it work?

Dire Wolf uses ALSA sound devices to receive and transmit audio to/from an attached radio. Instead of messing around with physical hardware we can use ALSA plugins to loop audio between instances. Several instances can be connected to a single loopback to simulate them all being within range of each other, or two instances can be connected to a loop back to simulate a direct link. We can also go a step further and use the *multi* and *route* plugins to mix audio from different loopbacks into another device. Combining it all together we can create isolated zones where stations can hear each other but not stations in another zone, and then use a mixer to attach a Digipeater between them.

To keep things clean and to make it easier for multiple instances to co-exist on a single machine, everything exists in Docker containers. A helper script exists to configure Dire Wolf instances from environment variables, but due to BPQ being slightly more complex it's files still need configuring manually. Fortunately several scenarios are included so you can quickly get started.

## A note on Docker

If you've not used Docker before it can seem complex but generally the hard part is tailoring your applications and build processes to suit it.

Fortunately the hard work is already done here so you should just be able to run `docker compose up -d` to get started.

For more help with starting and stopping containers, and hints on firewalling your machine, see the cheat sheet.

## Configuring your machine

The following instructions assume you're running a fresh install of Debian 11.

### Install prerequisites

    apt-get install foo

### Install Docker

Follow [Docker's instructions](https://docs.docker.com/engine/install/debian/) to install it on your machine.

### Pull this repo

        cd /opt
    git clone https://github.com/marrold/virtual-packet-environment.git
    cd virtual-packet-environment

### Configure the audio devices

First of all we need tell ALSA how many loop backs devices we need:

     sudo cat /opt/virtual-packet-environment/alsa-base.conf  >> /etc/modprobe.d/alsa-base.conf

Then we load the loopback module into the kernel, and make it persistent:

    sudo modprobe snd-aloop
    sudo echo snd-aloop >> /etc/modules

Next we configure the various loopbacks and mixers by appending the included `asound.conf` file to `/etc/asound.conf`

    sudo cat /opt/virtual-packet-environment/asound.conf >> /etc/asound.conf


## Setting Volume Levels

Whilst in my experience Dire Wolf will reliably decode packets without touching the volume settings, it will complain that levels are too high unless you adjust them with `alsamixer`. Unfortunately this process isn't particularly slick.

Firstly, the sound devices won't show up until they've been used at least once. There's a script included that will do this quickly:

    bash init_snd.sh

Now you can set the levels. There are actually two loopback "sound cards" with 8 sub-devices, so we have to do it twice. Set the playback device for each zone to 75%, using the arrow keys to move to the next. Exit with *Ctrl + C*

    alsamixer -c 11
    alsamixer -c 12

## Contributing
It'd be great if we could get some additional scenarios added, and documentation can always be improved.

Please submit a PR!

## License

This project is released under the MIT license
