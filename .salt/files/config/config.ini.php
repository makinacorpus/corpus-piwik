; <?php exit; ?> DO NOT REMOVE THIS LINE
{% set cfg=salt['mc_project.get_configuration'](project) %}
{% set data= cfg.data%}
; file automatically generated or modified by Piwik; you can manually override the default values in global.ini.php by redefining them in this file.
[database]
host = "{{data.db_host}}"
username = "{{data.db_user}}"
password = "{{data.db_password}}"
dbname = "{{data.db_name}}"
charset = "{{data.db_charset}}"
schema = "{{data.db_schema}}"

[General]
{% for i in data.trusted_hosts -%}
trusted_hosts[] = {{i}}
{% endfor %}

[Plugins]
{% for i in data.plugins -%}
Plugins[] = {{i}}
{% endfor%}

[PluginsInstalled]
{% for i in data.plugins_installed -%}
PluginsInstalled[] = {{i}}
{% endfor %}

[Plugins_Tracker]
{% for i in data.plugins_tracker -%}
Plugins_Tracker[] = {{i}}
{% endfor %}

{% for sections in data.get('extra_config', []) -%}
{%- for name, configs in sections.items() -%}
[{{name}}]
{% for config in configs -%}
{%- for param, val in config.items() -%}
{{param}} = {{val}}
{%- endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
