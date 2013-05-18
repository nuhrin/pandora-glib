/* PndOvrAppFile.vala
 * 
 * Copyright (C) 2013 nuhrin
 * 
 * This file is part of Pandafe.
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
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 *      nuhrin <nuhrin@oceanic.to>
 */

namespace Pandora
{
	namespace Config
	{
		public class PndOvrAppFile : ConfigFile
		{
			uint subapp_number;
			bool is_new;
			
			internal PndOvrAppFile(string fullpath, uint subapp_number) throws KeyFileError {
				base(fullpath);
				this.subapp_number = subapp_number;
			}
			internal PndOvrAppFile.new_file(string fullpath, uint subapp_number) throws KeyFileError {
				this(fullpath, subapp_number);
				is_new = true;
			}
			~PndOvrAppFile() {
				if (is_new == true && was_written == false) {
					// remove the ovr file, since it was newly created but not written to
					if (FileUtils.test(get_fullpath(), FileTest.EXISTS) == true)
						FileUtils.remove(get_fullpath());
				}
			}
			
			public string? title {
				get { return get_string(resolve_key("title")); }
				set { set_string(resolve_key("title"), value); }
			}			
			public uint? clockspeed {
				get {
					int cs = get_int(resolve_key("clockspeed"), -1);
					if (cs >= 0) 
						return (uint)cs;
					return null;
				}
				set { 
					if (value == null)
						unset(resolve_key("clockspeed"));
					else
						set_int(resolve_key("clockspeed"), (int)value); 
				}
			}
			public string? appdata {
				get { return get_string(resolve_key("appdata")); }
				set { set_string(resolve_key("appdata"), value); }
			}
			public string? main_category
			{
				get { return get_string(resolve_key("maincategory")); }
				set { set_string(resolve_key("maincategory"), value); }
			}
			public string? sub_category
			{
				get { return get_string(resolve_key("maincategorysub1")); }
				set { set_string(resolve_key("maincategorysub1"), value); }
			}
			
			string resolve_key(string key) { return "Application-%u.%s".printf(subapp_number, key); }			
		}		
	}
}

