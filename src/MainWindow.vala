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

public class Pages.MainWindow : Gtk.ApplicationWindow {

    public const string ACTION_PREFIX = "win.";
    public const string ACTION_QUIT = "quit";
    public const string ACTION_ZOOM_DEFAULT = "zoom_default";
    public const string ACTION_ZOOM_IN = "zoom_in";
    public const string ACTION_ZOOM_OUT = "zoom_out";
    public const string ACTION_UNDO = "undo";
    public const string ACTION_REDO = "redo";
    public const string ACTION_COPY = "copy";
    public const string ACTION_CUT = "cut";
    public const string ACTION_PASTE = "paste";

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_QUIT, action_quit },
        { ACTION_ZOOM_DEFAULT, action_zoom_default },
        { ACTION_ZOOM_IN, action_zoom_in },
        { ACTION_ZOOM_OUT, action_zoom_out },
        { ACTION_UNDO, action_undo },
        { ACTION_REDO, action_redo },
        { ACTION_COPY, action_copy },
        { ACTION_CUT, action_cut },
        { ACTION_PASTE, action_paste }
    };

    private Gtk.ProgressBar progress_bar;
    private Pages.DocumentView doc;
    private Granite.Widgets.Welcome welcome;

    construct {
        set_default_size (400, 400);
        title = _("Pages");

        var headerbar = new Pages.HeaderBar ();
        set_titlebar (headerbar);
        welcome = new Granite.Widgets.Welcome (_("Pages"), _("Writing Documents with Style."));
        welcome.append ("document-new", _("New Document"), _("Create a new empty document."));
        welcome.append ("document-open", _("Open a Document"), _("Open an existing document."));

        progress_bar = new Gtk.ProgressBar ();
        progress_bar.no_show_all = true;

        doc = new Pages.DocumentView ();
        var scrolled = new Gtk.ScrolledWindow (null, null);
        scrolled.add (doc);

        var grid = new Gtk.Grid ();
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.add (progress_bar);
        grid.add (scrolled);

        var stack = new Gtk.Stack ();
        stack.add_named (welcome, "welcome");
        stack.add_named (grid, "document");
        add (stack);

        doc.notify["has-document"].connect (() => {
            if (doc.has_document) {
                stack.visible_child_name = "document";
            } else {
                stack.visible_child_name = "welcome";
            }
        });

        show_all ();
        add_action_entries (ACTION_ENTRIES, this);
        weak Gtk.Application app = (Gtk.Application) GLib.Application.get_default ();
        app.set_accels_for_action (ACTION_PREFIX + ACTION_QUIT, { "<Control>q" });
        app.set_accels_for_action (ACTION_PREFIX + ACTION_ZOOM_DEFAULT, { "<Control>0", "<Control>KP_0", "<Control>KP_Equal" });
        app.set_accels_for_action (ACTION_PREFIX + ACTION_ZOOM_IN, { "<Control>plus", "<Control>KP_Add" });
        app.set_accels_for_action (ACTION_PREFIX + ACTION_ZOOM_OUT, { "<Control>minus", "<Control>KP_Subtract" });
        app.set_accels_for_action (ACTION_PREFIX + ACTION_UNDO, { "<Control>z" });
        app.set_accels_for_action (ACTION_PREFIX + ACTION_REDO, { "<Control><Shift>z" });

        doc.zoom_changed.connect ((zoom_level) => headerbar.set_zoom_level ((int) (zoom_level * 100)));
        doc.load_changed.connect ((progress) => {
            progress_bar.fraction = progress;
            progress_bar.visible = progress > 0.0 && progress < 1.0;
        });

        welcome.activated.connect ((item) => {
            if (item == 0) {
                doc.open_document ("/home/tintou/test.odt");
            } else {
                var dialog = new Gtk.FileChooserNative (_("Open a document"), this, Gtk.FileChooserAction.OPEN, _("Open document"), _("Cancel"));
                if (dialog.run () == Gtk.ResponseType.ACCEPT) {
                    doc.open_document (dialog.get_filename ());
                }

                dialog.destroy ();
            }
        });
    }

    private void action_quit (GLib.SimpleAction action, GLib.Variant? parameter) {
        destroy ();
    }

    private void action_zoom_default (GLib.SimpleAction action, GLib.Variant? parameter) {
        doc.zoom_default ();
    }

    private void action_zoom_in (GLib.SimpleAction action, GLib.Variant? parameter) {
        doc.zoom_in ();
    }

    private void action_zoom_out (GLib.SimpleAction action, GLib.Variant? parameter) {
        doc.zoom_out ();
    }

    private void action_undo (GLib.SimpleAction action, GLib.Variant? parameter) {
        doc.undo ();
    }

    private void action_redo (GLib.SimpleAction action, GLib.Variant? parameter) {
        doc.redo ();
    }

    private void action_copy (GLib.SimpleAction action, GLib.Variant? parameter) {
        doc.copy ();
    }

    private void action_cut (GLib.SimpleAction action, GLib.Variant? parameter) {
        doc.cut ();
    }

    private void action_paste (GLib.SimpleAction action, GLib.Variant? parameter) {
        doc.paste ();
    }
}
