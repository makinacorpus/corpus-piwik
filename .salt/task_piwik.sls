{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}

{{cfg.name}}-cron:
  cmd.run:
    - name: {{cfg.project_root}}/www/misc/cron/archive.sh
    - cwd: {{cfg.project_root}}/www/misc/cron
    - user: {{cfg.user}}
    - use_vt: true
