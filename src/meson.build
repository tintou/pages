executable(
    'com.github.tintou.pages',
    'Application.vala',
    'MainWindow.vala',
    'HeaderBar.vala',
    'DocumentView.vala',
    'JsonUtils.vala',
    'lok-helpers.c',
    'lok-helpers.h',
    dependencies: [
        gtk_dep,
        granite_dep,
        libreofficekitgtk_dep,
        json_dep,
        meson.get_compiler('vala').find_library('lok-helpers', dirs: meson.current_source_dir())
    ]
)
