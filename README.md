# Redirectly - Redirect server with dynamic URL and hostname support

![repocard](https://repocard.dannyben.com/svg/redirectly.svg)

Redirectly is a simple URL redirect server that uses a simple INI file for 
defining dynamic redirects.

## Install

```
$ gem install redirectly
```

## Docker Image

Redirectly is also available as a [docker image][docker]:

```shell
# Pull the image
$ docker pull dannyben/redirectly

# Run the redirectly command line
$ docker run --rm -it dannyben/redirectly --help

# Start the server with your local configuration file
$ docker run --rm -it \
    -p 3000:3000 \
    -v $PWD/redirects.ini:/app/redirects.ini \
    dannyben/redirectly 
```

### Using with docker-compose

```yaml
# docker-compose.yml
services:
  redirectly:
    image: dannyben/redirectly
    ports:
      - 3000:3000
    volumes:
      - ./redirects.ini:/app/redirects.ini
```

### Using as an alias

```shell
$ alias redirectly='docker run --rm -it -p 3000:3000 -v $PWD/redirects.ini:/app/redirects.ini dannyben/redirectly'
```

## Quick Start

```shell
# In an empty directory, create a sample configuration file
$ redirectly --init

# Start the server
$ redirectly

# In another terminal, access the server using one of the configured rules
$ curl -v something.localhost:3000
```

You should receive a redirect header:

```shell
# ...
< HTTP/1.1 302 Found
< Location: http://it-works.com/something
# ...
```


## Usage 

Redirectly requires a simple INI file with redirect configuration details.

You can create a sample configuration file by running:

```shell
$ redirectly --init
```

This will create a sample `redirects.ini` file:

```ini
example.com = https://other-site.com/
*.mygoogle.com/:anything = https://google.com/?q=%{anything}
example.org/* = https://other-site.com/
*.old-site.com = !https://permanent.redirect.com
:sub.app.localhost/* = http://it-works.com/%{sub}
proxy.localhost/*rest = @https://proxy.target.com/base/*rest
internal.localhost/reload = :reload
(*)old-domain.com/*rest = http://new-domain.com/%{rest}
```

For additional server options, see:

```shell
$ redirectly --help
```

The configuration file is built of `pattern = target` pairs, where:

- `pattern` - is any URL pattern that is supported by [Mustermann][mustermann].
- `target` - is the target URL to redirect to.

### Special INI Notation

#### Redirect type

If the target starts with `!`, a permanent redirect (301) will be performed.  
If it does not, a temporary redirect (302) will be performed by default:

```ini
test.localhost/temporary = http://example.com
test.localhost/permanent = !http://example.com
```

#### Proxying

If the target starts with `@`, the content will be proxied instead of being
redirected:

```ini
test.localhost = @http://example.com
```

#### Named arguments

Patterns that include strings starting with a colon `:` will expose those
strings as Ruby substitution variables in the target:

```ini
test.localhost/:anything = http://example.com/path/%{anything}
```

#### Splats

You can use a splat `*` or a named splat `*name` in the pattern.  
Named splats will also be exposed as Ruby substitution variables in the target:

```ini
(*)test.localhost/*rest = http://example.com/%{rest}
```

## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].


---

[issues]: https://github.com/DannyBen/redirectly/issues
[mustermann]: https://github.com/sinatra/mustermann/blob/master/mustermann/README.md
[docker]: https://hub.docker.com/r/dannyben/redirectly
