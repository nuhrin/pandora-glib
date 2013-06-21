/* AppList.vala
 * 
 * Copyright (C) 2013 nuhrin
 * 
 * This file is part of pandora-glib.
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

using Gee;

namespace Pandora.Apps
{
	internal class AppList : ArrayList<App>
	{	
		public static AppList? discovery_file(string path, string filename) {
			var list = new AppList();
			list._disco_search_handle = pnd.apps.discovery_file(path, filename);
			if (add_discovered_apps(list) == false)
				return null;
			return list;
		}
		
		public static AppList? discovery_search(string searchpath, string? overrides_path) {
			var list = new AppList();
			list._disco_search_handle = pnd.apps.discovery_search(searchpath, overrides_path);
			if (add_discovered_apps(list) == false)
				return null;
			return list;
		}
		
		pnd.apps.DiscoverySearchHandle _disco_search_handle;		
		AppList() {
			base();
		}
		~AppList() {
			clear();
		}
		
		static bool add_discovered_apps(AppList list) {
			if (list._disco_search_handle == null)
				return false;
			
			var head = list._disco_search_handle.get_head();
			if (head == null) {
				list._disco_search_handle = null;
				return false;
			}

			// create app objects
			var appList = new ArrayList<App>();
			var currentAppInfo = head;
			do
			{
				var app = new App(currentAppInfo);
				appList.add(app);

				currentAppInfo = pnd.apps.DiscoverySearchHandle.get_next(currentAppInfo);
			} while(currentAppInfo != null);

			if (appList.size == 0) {
				list._disco_search_handle = null;
				return true;
			}

			// reverse app list (due to the way discovery works)
			for(int index=appList.size-1;index>=0;index--) {
				var app = appList[index];
				list.add(app);
			}
			return true;
		}
	}

}
