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
			_app_list = new ArrayList<App>();
			_app_id_hash = new HashMap<string, App>();
			_pnd_list = new ArrayList<Pnd>();
			_pnd_id_hash = new Gee.HashMap<string, Pnd>();
			_apps_config = null;

			try {
				_apps_config = Config.get_config_apps();
			} catch(KeyFileError e) {
				warning("Error loading apps config file: %s", e.message);
				return;
			}

			// scan for app info
			var results = discovery_search(_apps_config.searchpath, _apps_config.overrides_searchpath);
			var head = results.get_head();
			if (head == null)
				return;

			// create app objects
			var appList = new ArrayList<App>();
			var currentAppInfo = head;
			do
			{
				var app = new App(currentAppInfo);
				appList.add(app);

				var kill = currentAppInfo;
				currentAppInfo = currentAppInfo.get_next();
				PndAppInfo.destroy(kill);
			} while(currentAppInfo != null);

			// reverse app list (due to the way discovery works) and cache
			for(int index=appList.size-1;index>=0;index--) {
				var app = appList[index];
				_app_list.add(app);
				_app_id_hash[app.id] = app;
			}

			// populate Pnd cache
			var pndAppMap = new Gee.HashMap<string, Gee.ArrayList<App>>();
			var pndAppIdFileHash = new Gee.HashSet<string>();
			var pndIdList = new Gee.ArrayList<string>();
			// group apps by pnd
			foreach(var app in _app_list) {
				string pndId = (app.package_id != null) ? app.package_id : app.id;
				if (pndAppMap.has_key(pndId) == false) {
					pndAppMap[pndId] = new Gee.ArrayList<App>();
					pndIdList.add(pndId);
				}
				var apphash = app.filename + app.id;
				if (pndAppIdFileHash.contains(apphash) == false) {
					pndAppIdFileHash.add(apphash);
					pndAppMap[pndId].add(app);
				}
			}
			foreach(var id in pndIdList) {
				var pnd = new Pnd(pndAppMap[id]);
				_pnd_list.add(pnd);
				_pnd_id_hash[id] = pnd;
			}
		}
		internal static void clear() {
			_app_list = null;
			_app_id_hash = null;
			_pnd_list = null;
			_pnd_id_hash = null;
			_apps_config = null;
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
