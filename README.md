Intro
========================

This is a vagrant deployment skeleton to quickly bootstrap web development.

It can quickly install and configure for you the following services:

 - CentOS 7 OS
 - PHP 7 + XDebug
 - Nginx
 - PostgreSQL
 - Redis
 - RabbitMQ
 - ElasticSearch


Installation
========================

The intended folder structure is as such:

```
 - <root folder>
 |______ vagrant-bootstrap
 |______ <project_sources_folder>
```

So, to quickly bootstrap your project you should do the following:

 - Go to your projects directory
 - Create project directory
 - Execute `git clone --recursive https://github.com/FractalizeR/vagrant-bootstrap.git`. Mind `--recursive` switch to clone with submodules!
 - Execute `git clone --recursive https://github.com/<YOUR_PROJECT>/<YOUR_REPO>`
 - Go to `vagrant-bootstrap` directory and make copies of `*.example.*` files, removing `.example` part from the name (`hosts.example.txt` => `hosts.txt`, `site.example.yml` => `site.yml` etc).
 - Edit renamed files making adjustments suitable for your project
 - Execute `vagrant up`.

Now your project is alive and kicking!

Details
========================
If you change something in your previously `.example.*` files, you will have to run `vagrant provision` for changes to make effect