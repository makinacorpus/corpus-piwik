{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}
{% set php = salt['mc_php.settings']() %}

include:
  - makina-states.services.php.phpfpm_with_nginx

prepreqs-{{cfg.name}}:
  pkg.installed:
    - pkgs:
      - unzip
      - python-docutils
      - xsltproc
      - curl
      - {{ php.packages.mysql }}
      - {{ php.packages.gd }}
      - {{ php.packages.cli }}
      - {{ php.packages.curl }}
      - {{ php.packages.ldap }}
      - {{ php.packages.dev }}
      - {{ php.packages.json }}
      - sqlite3
      - libsqlite3-dev
      - mysql-client
      - apache2-utils
      - autoconf
      - automake
      - build-essential
      - bzip2
      - gettext
      - git
      - groff
      - libbz2-dev
      - libcurl4-openssl-dev
      - libdb-dev
      - libgdbm-dev
      - libreadline-dev
      - libfreetype6-dev
      - libsigc++-2.0-dev
      - libsqlite0-dev
      - libsqlite3-dev
      - libtiff5
      - libtiff5-dev
      - libwebp5
      - libwebp-dev
      - libssl-dev
      - libtool
      - libxml2-dev
      - libxslt1-dev
      - libopenjpeg-dev
      - libopenjpeg2
      - m4
      - man-db
      - pkg-config
      - poppler-utils
      - python-dev
      - python-imaging
      - python-setuptools
      - tcl8.4
      - tcl8.4-dev
      - tcl8.5
      - tcl8.5-dev
      - tk8.5-dev
      - wv
      - zlib1g-dev

{#
This produce the default layout

  /project     : sources
    bin/       : binaries
    lib/       : extra libs
    var        link --> ../data/var
    tmp        link --> ../data/var/tmp
  /data    : persistent data
    bin    link --> ../project/bin
    lib    link --> ../project/lib
    var/   : runtime files (sockets, logs, session, tempfiles)
    var/sites/ : sites files

#}
{{cfg.name}}-dirs:
  file.directory:
    - makedirs: true
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - mode: 770
    - watch:
      - pkg: prepreqs-{{cfg.name}}
    - names:
      - {{cfg.project_root}}/lib
      - {{cfg.project_root}}/bin
      - {{cfg.data_root}}/images
      - {{cfg.data_root}}/var
      - {{cfg.data_root}}/var/log
      - {{cfg.data_root}}/var/tmp
      - {{cfg.data_root}}/var/tmp/upload
      - {{cfg.data_root}}/var/run
      - {{cfg.data_root}}/var/private

{% for d in ['lib', 'bin', 'www'] %}
{{cfg.name}}-dirs{{d}}:
  file.symlink:
    - target: {{cfg.project_root}}/{{d}}
    - name: {{cfg.data_root}}/{{d}}
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - watch:
      - file: {{cfg.name}}-dirs
    - watch_in:
      - mc_proxy: makina-apache-pre-inst
      - mc_proxy: makina-php-pre-inst
      - mc_proxy: nginx-pre-install-hook
{% endfor %}


{% for d in ['var'] %}
{{cfg.name}}-l-dirs{{d}}:
  file.symlink:
    - name: {{cfg.project_root}}/{{d}}
    - target: {{cfg.data_root}}/{{d}}
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - watch:
      - file: {{cfg.name}}-dirs
    - watch_in:
      - mc_proxy: makina-apache-pre-inst
      - mc_proxy: makina-php-pre-inst
      - mc_proxy: nginx-pre-install-hook
{% endfor %}

{% for d in ['log', 'private', 'tmp'] %}
{{cfg.name}}-l-var-dirs{{d}}:
  file.symlink:
    - name: {{cfg.project_root}}/{{d}}
    - target: {{cfg.data_root}}/var/{{d}}
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - watch:
      - file: {{cfg.name}}-dirs
    - watch_in:
      - mc_proxy: makina-apache-pre-inst
      - mc_proxy: makina-php-pre-inst
      - mc_proxy: nginx-pre-install-hook
{% endfor %}
