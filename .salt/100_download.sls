{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% set ver = data.ver %}
{% set download_name = data.download_name%}
{% set download_archive = data.download_archive%}
{% set download_url = data.download_url%}
{% set download_inner_dir = data.download_inner_dir%}
{{cfg.name}}-download:
  cmd.run:
    - user: {{cfg.user}}
    - cwd: {{ cfg.project_root}}
    - unless: test -e "{{download_name}}/{{download_inner_dir}}" && test -e "www"
    - name: >
            wget -c "{{download_url}}" -O "{{download_archive}}" &&
            unzip -o -qq -d "{{download_name}}" "{{download_archive}}" &&
            ln -sf "$PWD/{{download_name}}/{{download_inner_dir}}" "$PWD/www"

{{cfg.name}}-download-plugins:
  file.directory:
    - name: {{cfg.project_root}}/plugins
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - mode: 750
    - makedirs: true

{% for plugins in data.get('download_plugins', []) %}
{% for plugin, pdata in plugins.items() %}
{% set download_name = pdata.download_name%}
{% set download_archive = pdata.download_archive%}
{% set download_url = pdata.download_url%}
{% set download_inner_dir = pdata.download_inner_dir%}
{{cfg.name}}-download-{{plugin}}:
  cmd.run:
    - user: {{cfg.user}}
    - cwd: {{ cfg.project_root}}
    - unless: test -e "plugins/{{download_name}}/{{download_inner_dir}}" && test -e "www/plugins/{{plugin}}"
    - watch:
      - cmd: {{cfg.name}}-download
      - file: {{cfg.name}}-download-plugins
    - name: >
            wget -c "{{download_url}}" -O "{{download_archive}}" &&
            unzip -o -qq -d "plugins/{{download_name}}" "{{download_archive}}" && 
            if [ -h "www/plugins/{{plugin}}" ];then rm -f "www/plugins/{{plugin}}";fi &&
            ln -sf "$PWD/plugins/{{download_name}}/{{download_inner_dir}}" "www/plugins/{{plugin}}"
{% endfor %}
{% endfor %}
