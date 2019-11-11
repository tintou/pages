namespace Pages.JsonUtils {
    public static void add_long_value (Json.Builder builder, string name, long val) {
        builder.set_member_name (name);
        builder.begin_object ();
        builder.set_member_name ("type");
        builder.add_string_value ("long");
        builder.set_member_name ("value");
        builder.add_string_value ("%ld".printf (val));
        builder.end_object ();
    }

    public static void add_string_value (Json.Builder builder, string name, string val) {
        builder.set_member_name (name);
        builder.begin_object ();
        builder.set_member_name ("type");
        builder.add_string_value ("string");
        builder.set_member_name ("value");
        builder.add_string_value (val);
        builder.end_object ();
    }

    public static string builder_to_string (Json.Builder builder) {
        var generator = new Json.Generator ();
        generator.root = builder.get_root ();
        size_t length;
        return generator.to_data (out length);
    }
}
