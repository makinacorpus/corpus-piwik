{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}
{% set php = salt['mc_php.settings']() %}
{% for f in ['config/config.ini.php'] %}
{{cfg.name}}-drupal-settings-{{f}}:
  file.managed:
    - makedirs: true
    - source: salt://makina-projects/{{cfg.name}}/files/{{f}}
    - name: {{cfg.project_root}}/www/{{f}}
    - template: jinja
    - mode: 770
    - user: "{{cfg.user}}"
    - group: "root"
    - defaults:
        project: {{cfg.name}}
{% endfor %}

{{cfg.name}}-cron-cmd:
  file.managed:
    - name: "{{cfg.data_root}}/bin/piwik_cron.sh"
    - makedirs: true
    - contents: |
                #!/usr/bin/env bash
                LOG="{{cfg.data_root}}/cron.log"
                lock="${0}.lock"
                if [ -e "${lock}" ];then
                  echo "Locked ${0}";exit 1
                fi
                touch "${lock}"
                salt-call --out-file="${LOG}" --retcode-passthrough -lall --local mc_project.run_task {{cfg.name}} task_piwik 1>/dev/null 2>/dev/null
                ret="${?}"
                rm -f "${lock}"
                if [ "x${ret}" != "x0" ];then
                  cat "${LOG}"
                fi
                exit "${ret}"
    - user: {{cfg.user}}
    - use_vt: true

{{cfg.name}}-cron:
  file.managed:
    - name: "/etc/cron.d/{{cfg.name}}piwik_cron"
    - contents: |
                #!/usr/bin/env bash
                MAILTO="{{data.admins}}"
                {{data.cron_a_periodicity}} root "{{cfg.data_root}}/bin/piwik_cron.sh"
    - user: {{cfg.user}}
    - makedirs: true
    - use_vt: true
    - require:
      - file: {{cfg.name}}-cron-cmd

{{cfg.name}}-l-var-dirs:
  file.symlink:
    - name: {{cfg.project_root}}/{{data.download_name}}/var
    - target: {{cfg.data_root}}/var
    - user: {{cfg.user}}
    - group: {{cfg.group}}

