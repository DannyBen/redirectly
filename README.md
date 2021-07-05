# Redirectly - Redirect server with dynamic URL and hostname support

[![Gem Version](https://badge.fury.io/rb/redirectly.svg)](https://badge.fury.io/rb/redirectly)
[![Build Status](https://github.com/DannyBen/redirectly/workflows/Test/badge.svg)](https://github.com/DannyBen/redirectly/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/094281e5b8e90b8ff85f/maintainability)](https://codeclimate.com/github/DannyBen/redirectly/maintainability)

---

Redirectly is a simple URL redirect server that uses a simple INI file for 
defining dynamic redirects.

---

## Install

```
$ gem install redirectly
```

## Docker Image

SOON


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
:sub.lvh.me/* = http://it-works.com/%{sub}
```

The configuration file is built of `pattern = target` pairs, where:

- `pattern` - is any URL pattern that is supported by [Mustermann][mustermann].
- `target` - is the target URL to redirect to.

Notes:

- If `target` starts with an exclamation mark, it will be a permanent
  redirect (301), otherwise it will be a temporary redirect (302).
- If `pattern` includes named arguments (e.g. `example.com/:something`), they
  will be available to the `target` as Ruby string substitution variables
  (e.g. `%{something}`).


## Common Patterns

SOON


## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].


---

[issues]: https://github.com/DannyBen/redirectly/issues
[mustermann]: https://github.com/sinatra/mustermann/blob/master/mustermann/README.md