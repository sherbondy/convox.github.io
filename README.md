# Convox Docs

This repo contains the source files for [http://docs.convox.com/](http://docs.convox.com/).

Documentation is written in Markdown (with options similar to [Github's Flavor](https://help.github.com/articles/github-flavored-markdown/)).

[Jekyll](https://http://jekyllrb.com//) is used to generate static HTML files.

Please let us know about any issues, either via [issues](/issues) or by emailing [support@convox.com](mailto:support@convox.com)

Pull Requests are also welcome!

## Usage

Ruby and bundler are required.

```shell
$ bundle install
$ jekyll serve
==    Server address: http://127.0.0.1:4000/
```

Please send updates to documentation as [Pull Requests](/pulls).


### Frontmatter

Each page in the documentation has a header, called frontmatter, this controls where it's displayed and it's title.

e.g.

```
---
title: "Custom Domains"
sort: 40
---
```

### Project Structure

```
.
├── Gemfile
├── Gemfile.lock
├── README.md
├── _site
│   └── # .gitignored; contains compiled site
├── _config.yml
├── assets # contains all css, javascript and static images.
│   ├── images # static images
│   └── docs # docs images namespaced by page
│       ├── creating-an-iam-user-and-credentials
│       │   └── get_started_iam.png
│       └── deleting-an-iam-user
│           └── delete_user.png
├── _layouts #  contains layouts and partials
├── _getting_started
│   ├── getting-started-with-convox.md
│   ├── deploying-an-application.md
│   ├── environment-variables.md
│   ├── custom-domains.md
├── _documentation
│   ├── concepts.md
│   ├── creating-an-iam-user-and-credentials.md
│   ├── deleting-an-iam-user.md
│   ├── troubleshooting-apps.md
│   ├── troubleshooting-install.md
│   ├── uninstall-convox.md
│   └── updating-convox.md
└── index.md # top level pages
```

# Publishing

Docs are published automatically by Github Pages.

