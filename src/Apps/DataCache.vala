/* DataCache.vala
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

using Gee;
using pnd.apps;
using pnd.conf;

namespace Pandora.Apps
{
	class DataCache {
		static Gee.Map<string, App> _app_id_hash;
		static Gee.List<App> _app_list;
		static Gee.Map<string, Pnd> _pnd_id_hash;
		static Gee.List<Pnd> _pnd_list;
		static Config.AppsConfigFile _apps_config;
		
		internal static void rescan() {
			_app_id_hash = new HashMap<string, App>(null, null, (a,b) => (a==b));
			_pnd_list = new ArrayList<Pnd>();
			_pnd_id_hash = new Gee.HashMap<string, Pnd>();
			_apps_config = null;
			_app_list = new ArrayList<App>();
			
			try {
				_apps_config = Config.get_config_apps();
			} catch(KeyFileError e) {
				warning("Error loading apps config file: %s", e.message);
				return;
			}

			// scan for app info
			var apps = AppList.discovery_search(_apps_config.searchpath, _apps_config.overrides_searchpath);
			if (apps == null)
				return;
			
			// and cache
			_app_list = apps;
			foreach(var app in apps)
				_app_id_hash[app.id] = app;

			// populate Pnd cache
			var pnd_path_apps_map = new Gee.HashMap<string, Gee.ArrayList<App>>();
			var pnd_path_list = new Gee.ArrayList<string>();
			// group apps by pnd
			foreach(var app in _app_list) {
				var path = app.get_fullpath();
				if (pnd_path_apps_map.has_key(path) == false) {
					pnd_path_apps_map[path] = new Gee.ArrayList<App>();
					pnd_path_list.add(path);
				}
				pnd_path_apps_map[path].add(app);
			}
			foreach(var path in pnd_path_list) {
				var pnd_apps = pnd_path_apps_map[path];
				if (pnd_apps.size == 0)
					continue;
				var pnd = new Pnd(pnd_apps);
				_pnd_list.add(pnd);
				_pnd_id_hash[pnd.id] = pnd;
			}			
		}
		internal static void clear() {
			_app_id_hash = null;
			_pnd_list = null;
			_pnd_id_hash = null;
			_apps_config = null;
			_app_list = null;			
		}

		internal static Pnd? get_pnd(string id) {
			if (_pnd_id_hash == null)
				rescan();
			if (_pnd_id_hash.has_key(id) == false)
				return null;
			return _pnd_id_hash[id];
		}
		internal static Gee.List<Pnd> get_all_pnds() {
			if (_pnd_list == null)
				rescan();
			return _pnd_list.read_only_view;
		}
		internal static App? get_app(string id) {
			if (_app_id_hash == null)
				rescan();
			if (_app_id_hash.has_key(id) == false)
				return null;
			return _app_id_hash[id];
		}
		internal static Gee.List<App> get_all_apps() {
			if (_app_list == null)
				rescan();
			return _app_list.read_only_view;
		}
		internal static string get_runscript_path() {
			if (_apps_config != null)
				return _apps_config.get_runscript_path();
			try {
				return Config.get_config_apps().get_runscript_path();
			} catch(KeyFileError e) {
				warning("Error loading apps config file: %s", e.message);
				return PNDRUN_DEFAULT;
			}
		}
		
	}
}
