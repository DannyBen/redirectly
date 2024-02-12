# Testing Unreleased (Edge) Redirectly Versions

If you wish to try a version of redirectly straight from GitHub before it is
released, you can use one of these methods:

## Using Docker

```bash
$ docker pull dannyben/redirectly:edge
```

## Using Ruby

```bash
git clone --depth 1 https://github.com/DannyBen/redirectly.git
cd redirectly
gem build redirectly.gemspec --output redirectly.gem
gem install redirectly.gem
cd ..
```
