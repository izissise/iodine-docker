# Changelog

### v1.4
* Use debian as a base image
* Add iptable rule to forward client traffic
* Build iodine at image build

### v1.3
* Remove copying of `authorized_keys` into image
* Use `passenger/baseimage` v0.9.16
* Run `apt-get update` before installing `net-tools` and `iodine`
* Add ENV variable to configure tunnel IP

### v1.2
* Initial import of [FiloSottile/Dockerfiles/iodine](https://github.com/FiloSottile/Dockerfiles/tree/master/iodine)
