# Convox Docs

This repo contains the source files for [http://docs.convox.com/](http://docs.convox.com/).

Documentation is written in Markdown (with options similar to [Github's Flavor](https://help.github.com/articles/github-flavored-markdown/)).

[Middleman](https://middlemanapp.com/) is used to generate static HTML files.

Please let us know about any issues, either via [issues](/issues) or by emailing [support@convox.com](mailto:support@convox.com)

Pull Requests are also welcome!

## Usage

Ruby and bundler are required to run Middleman.

```shell
$ bundle install
$ bundle exec middleman
== The Middleman is standing watch at http://localhost:4567/ (http://127.0.0.1:4567/)
```

Please send updates to documentation as [Pull Requests](/pulls).


### Frontmatter

Each page in the documentation has a header, called frontmatter, this controls where it's displayed and it's title.

e.g.

```
---
title: "Custom Domains"
sort: 40
group: "Getting Started"
---
```

### TOC

All pages are in groups, as specified in the frontmatter, groups are shown in the sidebar navigation in the order they exist in `source/data/toc.yml`.


### Project Structure

```
.
├── Gemfile
├── Gemfile.lock
├── Procfile
├── README.md
├── Rakefile
├── build
│   └── # .gitignored; contains compiled site
├── config.rb
├── data
│   └── toc.yml # table of contents for side navigation
└── source
    ├── assets # contains all css, javascript and static images.
    │   ├── images # static images
    │   └── docs # docs images namespaced by page
    │       ├── creating-an-iam-user-and-credentials
    │       │   └── get_started_iam.png
    │       └── deleting-an-iam-user
    │           └── delete_user.png
    ├── layouts #  contains layouts and partials
    ├── docs # contains all docs
    │   ├── concepts.md
    │   ├── creating-an-iam-user-and-credentials.md
    │   ├── custom-domains.md
    │   ├── deleting-an-iam-user.md
    │   ├── deploying-an-application.md
    │   ├── environment-variables.md
    │   ├── getting-started-with-convox.md
    │   ├── troubleshooting-apps.md
    │   ├── troubleshooting-install.md
    │   ├── uninstall-convox.md
    │   └── updating-convox.md
    └── index.md # top level pages
```

# Publishing

These Docs are designed to be `built` as a static site and deployed to the `gh-pages` branch of this repo by the Convox team.

Several environment variables are required, as per `.env.example`

```
$ bundle exec middleman build # this builds the static content
```

There is a rake task to automate build and publish (commit to branch, push branch) for you.

```
$ bundle exec rake publish
```
