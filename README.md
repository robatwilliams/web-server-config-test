# Web server config tests
Makes requests against a web server, and verifies that the expected headers are returned.

Created to avoid accidental breakages and repetitive manual checking while creating an Apache configuration to serve a single-page application using Multiviews and pre-compressed assets. The test cases in the `specs` folder, and the sample files in `fixture` reflect that.

Tests are implemented and run using the [BATS](https://github.com/bats-core/bats-core/) framework; each one is a small shell script. Requests are made using `curl`.

## Preparation
1. Configure server with your configuration
1. Deploy fixture files to site's document root
1. Update base urls in `helpers.sh`

## Running
```bash
# Install BATS
git clone https://github.com/bats-core/bats-core.git

# Run tests
./run.sh
```
