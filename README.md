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

- `CHECKS` - A JSON list of check names to activate. in the form of `CHECKS="foo bar"`

#### Supported checks

- `backup` - This check adds a backup job to the local container that backs up the consul node to an s3 bucket. This check requires that `S3_BUCKET` env var is passed and that the ECS Task has permissions to write to the bucket. It adds the check to the ECS Cluster. If the script can't find an ECS Cluster, it will create a service called default.

- `ecs-cluster` - this check creates a service in Consul with the ECS Cluster name, and adds a number of checks, AMI Status, to validate that the AMI is the latest AMI. ECS CloudWatch, which is a cloudwatch metric used for tracking Cluster availibility, and Instance Status, a check used to terminate the consul process in the case of the underlying instance terminating.


Usage
-----

```shell

docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -e CHECKS='docker-test docker-test-warning' fitnesskeeeper/consul-healthchecks:latest

```

Authors
=======

[Tim Hartmann](https://github.com/tfhartmann)

License
=======

[MIT License](LICENSE)
