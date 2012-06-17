/* DesktopConfigFile.vala
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
		public class DesktopConfigFile : ConfigFile
		{
			internal DesktopConfigFile() throws KeyFileError
			{
				base.for_id(ConfFilenameId.DESKTOP);
			}

			public string searchpath {
				get { return get_string(DESKTOP_SEARCH_KEY, DESKTOP_SEARCH_PATH_DEFAULT); }
				//set { set_string(DESKTOP_SEARCH_KEY, value);
			}
			public string dotdesktop_path {
				get { return get_string(DESKTOP_DOTDESKTOP_PATH_KEY, DESKTOP_DOTDESKTOP_PATH_DEFAULT); }
				//set { set_string(DESKTOP_DOTDESKTOP_PATH_KEY, value); }
			}
			public string icons_path {
				get { return get_string(DESKTOP_ICONS_PATH_KEY, DESKTOP_ICONS_PATH_DEFAULT); }
				//set { set_string(DESKTOP_ICONS_PATH_KEY, value); }
			}

			public string menu_searchpath {
				get { return get_string(MENU_SEARCH_KEY, ""); }
				//set { set_string(MENU_SEARCH_KEY, value); }
			}
			public string menu_dotdesktop_path {
				get { return get_string(MENU_DOTDESKTOP_PATH_KEY, ""); }
				//set { set_string(MENU_DOTDESKTOP_PATH_KEY, value); }
			}
			public string menu_icons_path {
				get { return get_string(MENU_ICONS_PATH_KEY, DESKTOP_ICONS_PATH_DEFAULT); }
				//set { set_string(MENU_ICONS_PATH_KEY, value); }
			}
		}
	}
}
