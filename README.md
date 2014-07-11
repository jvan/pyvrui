# pyvrui

Pyvrui is a python interface for [VRUI][vrui] library.

[vrui]: http://keckcaves.org/software/vrui


### Installation

On Ubuntu, pyvrui can be installed from the [KeckCAVES PPA][keckcave-ppa].

```sh
sudo add-apt-repository ppa:keckcaves/ppa
sudo apt-get update
sudo apt-get install python-pyvrui
```

To manually build and install pyvrui you will need to install [SWIG][swig]
along with some other dependencies. On Ubuntu, you can run the following
command

```sh
sudo apt-get install build-essential swig2.0
```

**NOTE:** You must install the 2.0 version of SWIG (`swig2.0`). The earlier
release (`swig`) will not work.

You will also need to have the VRUI library installed. This is also available in
[KeckCAVES PPA][keckcaves-ppa].

```sh
sudo apt-get install libvrui3.1-dev
```

To build and install the python module, simply run the following commands
in the project's root directory.

```sh
python ./setup.py build
sudo python ./setup.py install
```

[keckcaves-ppa]: https://launchpad.net/~keckcaves/+archive/ubuntu/ppa
[swig]: http://www.swig.org


### Usage

See the `examples/` directory in this repository for examples of using pyvrui.
