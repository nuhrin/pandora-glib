using pnd.apps;
using pnd.conf;

namespace Pandora
{
	namespace Config
	{
		public abstract class ConfigFile
		{
			internal ConfHandle handle;
			string fullpath;
			bool is_dirty;

			internal ConfigFile.for_id(ConfFilenameId file_id) throws KeyFileError
			{
				var filename = get_filename_from_id(file_id);
				if (filename == null)
					throw new KeyFileError.KEY_NOT_FOUND("No config filename was found for the given file id.");
				this.for_filename(filename);
			}
			protected ConfigFile.for_filename(string filename) throws KeyFileError
			{
				var searchpath = conf_query_searchpath();
				foreach(var path in searchpath.split(":"))
				{
					var fullpath = path + "/" + filename;
					if (FileUtils.test(fullpath, FileTest.EXISTS) == true) {
						handle = conf_fetch_by_path(fullpath);
						if (handle != null) {
							this.fullpath = fullpath;
							return;
						}
						throw new KeyFileError.PARSE("Error parsing config file '"+fullpath+"'.");
					}
				}
				throw new KeyFileError.NOT_FOUND("No config file named '"+filename+"' was found in the searchpath '"+searchpath+"'.");
			}
			protected ConfigFile(string fullpath) throws KeyFileError
			{
				if (FileUtils.test(fullpath, FileTest.EXISTS) == false)
					throw new KeyFileError.NOT_FOUND("The config file '"+fullpath+"' was not found.");
				handle = conf_fetch_by_path(fullpath);
				if (handle == null)
					throw new KeyFileError.PARSE("Error parsing config file '"+fullpath+"'.");
				this.fullpath = fullpath;
			}

			public bool write() {
				if (handle == null)
					return false;
				if (is_dirty == false)
					return true;

				if (handle.write(fullpath) == 0)
					return false;
				is_dirty = false;
				return true;
			}

			protected unowned string get_string(string key, string default_value) {
				if (handle == null)
					return default_value;
				unowned string value = handle.get_string(key);
				if (value == null || value == "")
					return default_value;
				return value;
			}
			protected void set_string(string key, string value) {
				if (handle == null)
					return;
				handle.set_string(key, value);
				is_dirty = true;
			}
			protected int get_int(string key, int default_value) {
				if (handle == null)
					return default_value;
				return handle.get_int_or_default(key, default_value);
			}
			protected void set_int(string key, int value) {
				if (handle == null)
					return;
				handle.set_int(key, value);
				is_dirty = true;
			}

			private static unowned string? get_filename_from_id(ConfFilenameId file_id) {
				foreach(var file in conf_filenames) {
					if (file.id == file_id)
						return file.filename;
				}
				return null;
			}

		}
	}
}
