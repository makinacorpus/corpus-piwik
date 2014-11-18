{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}

{{cfg.name}}-cron:
  cmd.run:
    - name: /usr/bin/php5 ./console core:archive --url=https://{{data.domain}} 1>/dev/null 2>&1 
    - cwd: {{cfg.project_root}}/www
    - user: {{cfg.user}}
    - use_vt: true
