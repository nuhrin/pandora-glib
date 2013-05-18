/* ConfigFile.vala
 * 
 * Copyright (C) 2012 nuhrin
 * 
 * This file is part of pandora-glib.
 * 
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 *      nuhrin <nuhrin@oceanic.to>
 */

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

			public bool has_changes { get { return is_dirty; } }
			public bool was_written { get; private set; }
			
			public bool write() {
				if (handle == null)
					return false;
				if (is_dirty == false)
					return true;

				if (handle.write(fullpath) == 0)
					return false;
				was_written = true;
				is_dirty = false;
				return true;
			}

			protected unowned string get_fullpath() { return fullpath; }

			protected unowned string? get_string(string key, string? default_value=null) {
				if (handle == null)
					return default_value;
				unowned string value = handle.get_string(key);
				if (value == null || value == "")
					return default_value;
				return value;
			}
			protected void set_string(string key, string? value) {
				if (handle == null)
					return;
					
				if (value == null || value.strip() == "") {
					if (handle.unset(key) == true)
						is_dirty = true;
					return;
				}
				
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
				handle.set_string(key, value.to_string());
				is_dirty = true;
			}

			protected bool unset(string key) {
				if (handle == null)
					return false;
				return handle.unset(key);
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
