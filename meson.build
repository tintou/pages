project('com.github.tintou.pages', 'c', 'cpp', 'vala', version: '0.0.1')


add_project_arguments('-DLOK_USE_UNSTABLE_API=1', language: 'c')

add_project_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language: 'c')

gtk_dep = dependency('gtk+-3.0')
granite_dep = dependency('granite')
libreofficekitgtk_dep = [
    meson.get_compiler('c').find_library('libreofficekitgtk'),
    meson.get_compiler('vala').find_library('libreofficekitgtk', dirs: meson.source_root() / 'vapi')
]
json_dep = dependency('json-glib-1.0')

subdir('src')
