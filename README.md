Consul Health Checks
===========

Docker Image used to manage and deploy Consul check scripts and check definitions

This image contains three dummy checks, docker-test, docker-test-warning, and docker-test-critical which are useful for testing.

Tests are deployed by passing the CHECKS env var into the container. `-e CHECKS='["docker-test", "docker-test-warning"]'`

This deploys the check definition into a local `/consul_check_definitions` directory which should be cross mounted onto the running consul agent. (See docker-compose.yml for details)


----------------------
#### Required
- `/var/run/docker.sock` - This container expects to mount `/var/run/docker.sock`

#### Optional

- `CHECKS` - A JSON list of check names to activate.  

Usage
-----

```shell

docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -e CHECKS='["docker-test", "docker-test-warning"]' fitnesskeeeper/consul-healthchecks:latest

```

Authors
=======

[Tim Hartmann](https://github.com/tfhartmann)

License
=======

[MIT License](LICENSE)
