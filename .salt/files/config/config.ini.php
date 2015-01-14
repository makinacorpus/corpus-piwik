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
; maximum number of rows for any of the Referers tables (keywords, search engines, campaigns, etc.), and Custom variables names
datatable_archiving_maximum_rows_referers = 1000
; maximum number of rows for any of the Referers subtable (search engines by keyword, keyword by campaign, etc.), and Custom variables values
datatable_archiving_maximum_rows_subtable_referers = 1000
; maximum number of rows for any of the Actions tables (pages, downloads, outlinks)
datatable_archiving_maximum_rows_actions = 1000
; maximum number of rows for pages in categories (sub pages, when clicking on the + for a page category)
datatable_archiving_maximum_rows_subtable_actions = 1000
; maximum number of rows for any of the Events tables (Categories, Actions, Names)
datatable_archiving_maximum_rows_events = 1000
; maximum number of rows for sub-tables of the Events tables (eg. for the subtables Categories>Actions or Categories>Names).
datatable_archiving_maximum_rows_subtable_events = 1000
; maximum number of rows for the Custom Variables names report
datatable_archiving_maximum_rows_custom_variables = 1000
; maximum number of rows for the Custom Variables values reports
datatable_archiving_maximum_rows_subtable_custom_variables = 1000
 

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
