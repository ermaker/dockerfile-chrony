# Docker in Production using AWS Chrony Docker Image

This repository defines a Docker Image for running [Chrony](https://chrony.tuxfamily.org) as an NTP server in AWS environments.

## Building the Image

To build this image the following prerequisites are required:

- Docker Client with access to a Docker Engine (1.12 or higher)
- Docker Compose 1.10 or higher
- GNU Make 3.82 or higher
- AWS CLI 1.10 or higher
- AWS profile/environment configured with privileges to push images to the ECR repository

To build the image use the `make release` command:

```
$ make release
=> Building images...
Building ntp
Step 1/10 : FROM alpine
latest: Pulling from library/alpine
Digest: sha256:58e1a1bb75db1b5a24a462dd5e2915277ea06438c3f105138f97eb53149673c4
Status: Image is up to date for alpine:latest
 ---> 4a415e366388
...
...
Step 10/10 : CMD chronyd -d -f /etc/chrony.conf
 ---> Running in 7719997247f9
 ---> f9f16b034ea0
Removing intermediate container 7719997247f9
Successfully built f9f16b034ea0
=> Build complete
=> Starting ntp service...
Creating ntp_ntp_1
=> Release environment created
=> NTP service is running - ntpdate -q 172.16.154.128
```

After building the image, you can test the image locally by running the command on the last line of output from `make release`:

```
$ ntpdate -q 172.16.154.128
server 172.16.154.128, stratum 5, offset 0.023510, delay 0.02579
10 Mar 21:59:02 ntpdate[70372]: adjust time server 172.16.154.128 offset 0.023510 sec
```

### Tagging the Image

After building the image, you can tag the image using the `make tag` or `make tag [<tag>...]` command:

```
$ make tag
=> Tagging release image with tags latest 20161211161608.52ce7ab 52ce7ab...
=> Tagging complete
```

### Publishing the Image

With the image tagged, you can login to the AWS EC2 Container Service Registry (ECR) and publish the image:

```
$ make login
=> Logging in to Docker registry ...
Enter MFA code: xxxxxx
Login Succeeded
=> Logged in to Docker registry
$ make publish
=> Publishing release image to 543279062384.dkr.ecr.us-west-2.amazonaws.com/dockerproductionaws/ntp...
The push refers to a repository [543279062384.dkr.ecr.us-west-2.amazonaws.com/dockerproductionaws/ntp]
eb40ed4586e2: Pushed
d93c9b2eda1f: Pushed
66fb5c668a31: Pushed
02535d447192: Pushed
011b303988d2: Pushed
20161211161608.52ce7ab: digest: sha256:f347746ec71c7a1fc00f534af27392b0eec5b8d300c191bb87e74753f7b9bcd6 size: 7708
...
...
=> Publish complete
```

### Cleaning up

To clean up after building, tagging and publishing the image, use the `make clean` command:

```
$ make clean
=> Destroying release environment...
Stopping ntp_ntp_1 ... done
Removing ntp_ntp_1 ... done
=> Removing dangling images...
Deleted: sha256:99bfa7a225007b4efe9656605da28d10fa08a7b6dcf861280a14c9c16496cd41
Deleted: sha256:648397f6d095e3ca07f4f9f0d962abc3c82e4f1cffabd0b1de1b48c6158040c5
Deleted: sha256:ce7d0339a1f6a587d7d032c4009cae9761d764821c4c94b0f9880c3c4fddc0b9
Deleted: sha256:7063a174eb249ebece8e9c57bcf17f6ac5e13ac953469621790a42055a6a0d81
Deleted: sha256:772816a8c40cab83115e705b477cfd94760f59eb903ab10c856943c8159b2efd
Deleted: sha256:4cbdbfddc3e8f74899aaf85cf1f3a48e9a872e41a875a8f0fe796c0c18e67316
Deleted: sha256:387350a82c7364359b155fe243fef9bc7b13af1017dc29e3825100a091f4fbcd
Deleted: sha256:dc1d972c5472ea1e0de78029831ad6783c677a31e642409233423d7ca0d5876f
Deleted: sha256:eb91001b9860af4297bdae6b0ba7d9dc1cf02b8baad89a893fb98bdd51476a3f
Deleted: sha256:c72ec3d0e172f09cf652615c82c8e6960942a6cb17415cf07327806806ddee34
=> Clean complete
```

## Runtime Configuration

The following table defines environment variables control the configuration of containers created from this image.

| Environment Variable | Required | Description                                                                    | Default Value                                                                           |
|----------------------|----------|--------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| CHRONY_SERVERS       | No       | Comma separated list of NTP Servers.                                           | 0.amazon.pool.ntp.org,1.amazon.pool.ntp.org,2.amazon.pool.ntp.org,3.amazon.pool.ntp.org |
| CHRONY_ALLOWED       | No       | Comma separated list of client IP addresses permitted access to the NTP server | 10/8,172.16/12,192.168/16                                                               |