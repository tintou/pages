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

public class Pages.DocumentView : Gtk.Grid {
    LOKDoc.View? doc;

    public signal void load_changed (double percent);
    public signal void zoom_changed (double percent);

    public bool has_document {
        get {
            return doc != null;
        }
    }

    [CCode (cname="lok_doc_view_get_command_values", cheader_filename = "lok-helpers.h")]
    public static extern string get_command_values (LOKDoc.View doc, string command);

    construct {
        
    }

    public void open_document (string path) {
        try {
            doc = new LOKDoc.View (null, null);
            doc.expand = true;
            add (doc);
            show_all ();
            notify_property ("has-document");
        } catch (Error e) {
            critical (e.message);
            return;
        }

        doc.command_result.connect ((res) => { critical (res); });
        doc.command_changed.connect (parse_command_changed);
        doc.window.connect ((res) => { critical (res); });
        doc.load_changed.connect ((progress) => load_changed (progress));
        doc.button_press_event.connect ((event) => { return show_menu (event); });
        
        doc.notify["zoom-level"].connect (() => zoom_changed (doc.zoom_level));
        doc.open_document.begin (path, "{}", null, (obj, res) => {
            try {
                doc.open_document.end (res);
                doc.set_edit (true);
            } catch (Error e) {
                critical (e.message);
            }
        });
    }

    public bool show_menu (Gdk.EventButton event) {
        if (event.button != Gdk.BUTTON_SECONDARY)
            return false;

        var menu = new Gtk.Menu ();
        menu.attach_widget = this;
        var undo_item = new Gtk.MenuItem.with_label ("Undo");
        undo_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_UNDO;
        var redo_item = new Gtk.MenuItem.with_label ("Redo");
        redo_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_REDO;
        var cut_item = new Gtk.MenuItem.with_label ("Cut");
        cut_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_CUT;
        var copy_item = new Gtk.MenuItem.with_label ("Copy");
        copy_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_COPY;
        var paste_item = new Gtk.MenuItem.with_label ("Paste");
        paste_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_PASTE;
        menu.add (undo_item);
        menu.add (redo_item);
        menu.add (new Gtk.SeparatorMenuItem ());
        menu.add (cut_item);
        menu.add (copy_item);
        menu.add (paste_item);
        menu.show_all ();
        menu.popup_at_pointer (event);
        return true;
    }

    private static bool parse_enabled (string val) {
        if (val == "enabled") {
            return true;
        } else {
            return false;
        }
    }

    private void parse_command_changed (string command) {
        string[] parts = command.split("=", 2);

        return_if_fail (parts.length >= 2);

        unowned Gtk.ApplicationWindow? window = (Gtk.ApplicationWindow) get_ancestor (typeof (Gtk.ApplicationWindow)) ;
        switch (parts[0]) {
            case ".uno:Redo":
                unowned GLib.Action action = window.lookup_action (MainWindow.ACTION_REDO);
                ((GLib.SimpleAction) action).set_enabled (parse_enabled (parts[1]));
                break;
            case ".uno:Undo":
                unowned GLib.Action action = window.lookup_action (MainWindow.ACTION_UNDO);
                ((GLib.SimpleAction) action).set_enabled (parse_enabled (parts[1]));
                break;
            case ".uno:Cut":
                unowned GLib.Action action = window.lookup_action (MainWindow.ACTION_CUT);
                ((GLib.SimpleAction) action).set_enabled (parse_enabled (parts[1]));
                break;
            case ".uno:Copy":
                unowned GLib.Action action = window.lookup_action (MainWindow.ACTION_COPY);
                ((GLib.SimpleAction) action).set_enabled (parse_enabled (parts[1]));
                break;
            case ".uno:Paste":
                unowned GLib.Action action = window.lookup_action (MainWindow.ACTION_PASTE);
                ((GLib.SimpleAction) action).set_enabled (parse_enabled (parts[1]));
                break;
            default:
                message (command);
                break;
        }
    }

    public void zoom_default () {
        doc.zoom_level = 1.0f;
    }

    public void zoom_in () {
        doc.zoom_level = float.min (doc.zoom_level + 0.20f, 6);
        doc.zoom_level += 0.20f;
    }

    public void zoom_out () {
        doc.zoom_level = float.max (doc.zoom_level - 0.20f, 0.2f);
    }

    public void undo () {
        doc.post_command (".uno:Undo", "{}", false);
    }

    public void redo () {
        doc.post_command (".uno:Redo", "{}", false);
    }

    public void copy () {
        doc.post_command (".uno:Copy", "{}", false);
    }

    public void cut () {
        doc.post_command (".uno:Cut", "{}", false);
    }

    public void paste () {
        doc.post_command (".uno:Paste", "{}", false);
    }
}
