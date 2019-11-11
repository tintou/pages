/*-
 * Copyright 2019 Corentin Noël
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Corentin Noël <corentin@elementary.io>
 */

public class Pages.HeaderBar : Gtk.HeaderBar {
    private Gtk.Button zoom_default_button;

    public HeaderBar () {
        Object (show_close_button: true);
    }

    construct {
        var open_button = new Gtk.Button.from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR);
        var save_button = new Gtk.Button.from_icon_name ("document-save", Gtk.IconSize.LARGE_TOOLBAR);

        weak Gtk.Application app = (Gtk.Application) GLib.Application.get_default ();
        var zoom_out_button = new Gtk.Button.from_icon_name ("zoom-out-symbolic", Gtk.IconSize.MENU);
        zoom_out_button.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_ZOOM_OUT;
        zoom_out_button.tooltip_markup = Granite.markup_accel_tooltip (
            app.get_accels_for_action (zoom_out_button.action_name),
            _("Zoom Out")
        );

        zoom_default_button = new Gtk.Button.with_label ("100%");
        zoom_default_button.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_ZOOM_DEFAULT;
        zoom_default_button.tooltip_markup = Granite.markup_accel_tooltip (
            app.get_accels_for_action (zoom_default_button.action_name),
            _("Zoom 1:1")
        );

        var zoom_in_button = new Gtk.Button.from_icon_name ("zoom-in-symbolic", Gtk.IconSize.MENU);
        zoom_in_button.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_ZOOM_IN;
        zoom_in_button.tooltip_markup = Granite.markup_accel_tooltip (
            app.get_accels_for_action (zoom_in_button.action_name),
            _("Zoom In")
        );

        var doc_size_grid = new Gtk.Grid ();
        doc_size_grid.column_homogeneous = true;
        doc_size_grid.hexpand = true;
        doc_size_grid.margin = 12;
        doc_size_grid.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
        doc_size_grid.add (zoom_out_button);
        doc_size_grid.add (zoom_default_button);
        doc_size_grid.add (zoom_in_button);

        var menu_grid = new Gtk.Grid ();
        menu_grid.margin_bottom = 3;
        menu_grid.orientation = Gtk.Orientation.VERTICAL;
        menu_grid.width_request = 200;
        menu_grid.attach (doc_size_grid, 0, 0);
        menu_grid.show_all ();

        var menu = new Gtk.Popover (null);
        menu.add (menu_grid);

        var app_menu = new Gtk.MenuButton ();
        app_menu.image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
        app_menu.tooltip_text = _("Menu");
        app_menu.popover = menu;

        pack_start (open_button);
        pack_start (save_button);
        pack_end (app_menu);
    }

    public void set_zoom_level (int zoom) {
        zoom_default_button.label = "%d%%".printf (zoom);
    }
}
