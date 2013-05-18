/* OvrConfigFile.vala
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
		public class PndOvrFile : ConfigFile
		{
			bool is_new;
			
			internal PndOvrFile(string fullpath) throws KeyFileError {
				base(fullpath);
			}
			internal PndOvrFile.new_file(string fullpath) throws KeyFileError {
				this(fullpath);
				is_new = true;
			}
			~PndOvrFile() {
				if (is_new == true && was_written == false) {
					// remove the ovr file, since it was newly created but not written to
					if (FileUtils.test(get_fullpath(), FileTest.EXISTS) == true)
						FileUtils.remove(get_fullpath());
				}
			}
			
			public OvrApplicationSection application(uint subapp_number) {
				return new OvrApplicationSection(this, subapp_number);
			}
					
			unowned string? get_resolved_string(string key, uint subapp_number) { return get_string(resolve_key(subapp_number, key)); }
			void set_resolved_string(string key, string? value, uint subapp_number) { set_string(resolve_key(subapp_number, key), value); }
			int get_resolved_int(string key, int default_value, uint subapp_number) { return get_int(resolve_key(subapp_number, key), default_value); }
			void set_resolved_int(string key, int value, uint subapp_number) { set_int(resolve_key(subapp_number, key), value); }			
			bool unset_resolved(string key, uint subapp_number) { return unset(resolve_key(subapp_number, key)); }
			string resolve_key(uint subapp_number, string key) { return "Application-%u.%s".printf(subapp_number, key); }			
			
			public class OvrApplicationSection
			{
				PndOvrFile ovr_file;
				uint subapp_number;						
				internal OvrApplicationSection(PndOvrFile ovr_file, uint subapp_number) {
					this.ovr_file = ovr_file;
					this.subapp_number = subapp_number;
				}
				
				public string? title {
					get { return ovr_file.get_resolved_string("title", subapp_number); }
					set { ovr_file.set_resolved_string("title", value, subapp_number); }
				}
				public uint? clockspeed {
					get {
						int cs = ovr_file.get_resolved_int("clockspeed", -1, subapp_number);
						if (cs >= 0) 
							return (uint)cs;
						return null;
					}
					set { 
						if (value == null)
							ovr_file.unset_resolved("clockspeed", subapp_number);
						else
							ovr_file.set_resolved_int("clockspeed", (int)value, subapp_number); 
					}
				}
				public string? appdata {
					get { return ovr_file.get_resolved_string("appdata", subapp_number); }
					set { ovr_file.set_resolved_string("appdata", value, subapp_number); }
				}
				public string? main_category
				{
					get { return ovr_file.get_resolved_string("maincategory", subapp_number); }
					set { ovr_file.set_resolved_string("maincategory", value, subapp_number); }
				}
				public string? sub_category
				{
					get { return ovr_file.get_resolved_string("maincategorysub1", subapp_number); }
					set { ovr_file.set_resolved_string("maincategorysub1", value, subapp_number); }
				}
			}
			
			const string PND_PACKAGE_FILEEXT = ".pnd";
			const string PXML_SAMEPATH_OVERRIDE_FILEEXT = ".ovr";			
			internal static string get_pnd_ovr_path(string pnd_path) throws KeyFileError {
				if (FileUtils.test(pnd_path, FileTest.EXISTS) == false)
					throw new KeyFileError.NOT_FOUND("The pnd file '%s' was not found.".printf(pnd_path));
				if (pnd_path.has_suffix(PND_PACKAGE_FILEEXT) == false)
					throw new KeyFileError.INVALID_VALUE("The file '%s' is not a pnd.".printf(pnd_path));
					
				return pnd_path.replace(PND_PACKAGE_FILEEXT, PXML_SAMEPATH_OVERRIDE_FILEEXT);
			}						
		}		
	}
}

