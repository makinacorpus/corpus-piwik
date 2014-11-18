{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% import "makina-states/services/http/nginx/init.sls" as nginx with context %}
{% import "makina-states/services/php/init.sls" as php with context %}
include:
  - makina-states.services.php.phpfpm_with_nginx

# the fcgi sock is meaned to be at docroot/../var/fcgi/fpm.sock;

# incondentionnaly reboot nginx & fpm upon deployments
echo reboot:
  cmd.run:
    - watch_in:
      - mc_proxy: nginx-pre-restart-hook
      - mc_proxy: nginx-pre-hardrestart-hook
      - mc_proxy: makina-php-pre-restart

{{nginx.virtualhost(data.domain,
                    data.www_dir,
                    vhost_basename=cfg.name,
                    server_aliases=data.aliases,
                    vh_top_source=data.nginx_top,
                    vh_content_source=data.nginx_vhost,
                    cfg=cfg) }}

{{php.fpm_pool(cfg.data.domain,
               cfg.data.www_dir,
               cfg=cfg,
               **cfg.data.fpm_pool)}}

{{cfg.name}}-htaccess:
  file.managed:
    - name: {{data.htaccess}}
    - source: ''
    - user: www-data
    - group: www-data
    - mode: 770
    - watch_in:
      - mc_proxy: nginx-pre-conf-hook

{% if data.get('http_users', {}) %}
{% for userrow in data.http_users %}
{% for user, passwd in userrow.items() %}
{{cfg.name}}-{{user}}-htaccess:
  webutil.user_exists:
    - name: {{user}}
    - password: {{passwd}}
    - htpasswd_file: {{data.htaccess}}
    - options: m
    - force: true
    - watch:
      - file: {{cfg.name}}-htaccess
    - watch_in:
      - mc_proxy: nginx-pre-conf-hook
{% endfor %}
{% endfor %}
{% endif %}
