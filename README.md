# chicken_docker

A collection of Docker image recipes for Chicken compilers.
The final images are very minimal and contains just what is needed to use Chicken.
Very useful for CI platforms (tested with great success on Gitlab CI).

## Usage

Build an image:

```sh
cd glibc
docker build . --build-arg PREFIX=/some/path -t chicken-ready
```

Test the product:

```sh
docker run --rm -it chicken-ready csi
```

Extract the compiler:

```sh
mkdir out
cp ../extract.sh out
docker run --mount type=bind,source="$(pwd)"/out,target=/out --rm -it chicken-ready /out/extract.sh
```

Build and extract all compilers:

```sh
./collect_all.sh /tmp/chicken /tmp/chicken-rt
```
