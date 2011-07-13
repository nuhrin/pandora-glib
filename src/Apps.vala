using Gee;
using pnd.apps;
using pnd.conf;

namespace Pandora.Apps
{
	public class Pnd {
		internal Pnd(Gee.List<App> apps) {
			this.apps = apps.read_only_view;
			this.first_app = apps[0];
		}
		App first_app;

		public unowned string id { get { return (first_app.package_id != null) ? first_app.package_id : first_app.id; } }
		public unowned string package_id { get { return first_app.package_id; } }
		public unowned string filename { get { return first_app.filename; } }
		public unowned string path { get { return first_app.path; } }

		public Gee.List<App> apps { get; private set; }
	}
	public class App {
		internal App(PndAppInfo app) {
			this.info = app;
		}
		internal PndAppInfo info { get; private set; }

		public unowned string id { get { return info.unique_id; } }
		public unowned string package_id { get { return info.package_id; } }
		public uint subapp_number { get { return info.subapp_number; } }
		public unowned string title { get { return info.title_en; } }
		public unowned string description { get { return info.desc_en; } }
		public unowned string filename { get { return info.object_filename; } }
		public unowned string path { get { return info.object_path; } }

		public int clockspeed {
			get {
				if (info.clockspeed == null)
					return 0;
				return int.parse(info.clockspeed);
			}
		}

		public uint pnd_icon_pos { get { return info.pnd_icon_pos; } }
		public unowned string appdata_dirname { get { return info.appdata_dirname; } }
		public unowned string icon { get { return info.icon; } }
		public unowned string exec_command { get { return info.exec; } }
		public unowned string exec_arguments { get { return info.execargs; } }
		public unowned ExecOptionX11 exec_option_x11 {
			get {
				if (info.option_no_x11 == "req")
					return ExecOptionX11.REQUIRED;
				else if (info.option_no_x11 == "stop")
					return ExecOptionX11.STOP;
				return ExecOptionX11.IGNORE;
			}
		}
		public unowned string startdir { get { return info.startdir; } }
		public unowned string main_category { get { return info.main_category; } }
		public unowned string main_category1 { get { return info.main_category1; } }
		public unowned string main_category2 { get { return info.main_category2; } }
		public unowned string alt_category { get { return info.alt_category; } }
		public unowned string alt_category1 { get { return info.alt_category1; } }
		public unowned string alt_category2 { get { return info.alt_category2; } }
		public unowned string preview_pic1 { get { return info.preview_pic1; } }
		public unowned string preview_pic2 { get { return info.preview_pic2; } }
		public unowned string mkdir_sp { get { return info.mkdir_sp; } }
		public unowned string info_name { get { return info.info_name; } }
		public unowned string info_filename { get { return info.info_filename; } }
		public unowned string info_type { get { return info.info_type; } }

		public ObjectFlags flags { get { return (ObjectFlags)info.object_flags; } }
	}
	[Flags]
	public enum ObjectFlags {
		NONE = 0,
		FLAG_OVR = 1,
		GENERATED = 2,
		CUSTOM1 = (1<<30),
		CUSTOM2 = (1<<31)
	}
	public enum ExecOptionX11 {
		IGNORE,
		REQUIRED,
		STOP
	}

	class DataCache {
		static Gee.Map<string, App> _app_id_hash;
		static Gee.List<App> _app_list;
		static Gee.Map<string, Pnd> _pnd_id_hash;
		static Gee.List<Pnd> _pnd_list;

		internal static void rescan(string? overrides_path) {
			_app_list = new ArrayList<App>();
			_app_id_hash = new HashMap<string, App>();
			_pnd_list = new ArrayList<Pnd>();
			_pnd_id_hash = new Gee.HashMap<string, Pnd>();

			// scan for app info
			var results = discovery_search(Config.apps_searchpath(), overrides_path);
			var head = results.get_head();
			if (head == null)
				return;

			// create app objects
			var appList = new ArrayList<App>();
			var currentAppInfo = head;
			do
			{
				var app = new App(*currentAppInfo);
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
			var pndAppFilenames = new Gee.HashSet<string>();
			var pndIdList = new Gee.ArrayList<string>();
			// group apps by pnd
			foreach(var app in _app_list) {
				string pndId = (app.package_id != null) ? app.package_id : app.id;
				if (pndAppMap.has_key(pndId) == false) {
					pndAppMap[pndId] = new Gee.ArrayList<App>();
					pndIdList.add(pndId);
				}
				if (pndAppFilenames.contains(app.filename) == false) {
					pndAppFilenames.add(app.filename);
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
		}

		internal static Pnd? get_pnd(string id) {
			if (_pnd_id_hash == null)
				rescan(null);
			if (_pnd_id_hash.has_key(id) == false)
				return null;
			return _pnd_id_hash[id];
		}
		internal static Gee.List<Pnd> get_all_pnds() {
			if (_pnd_list == null)
				rescan(null);
			return _pnd_list.read_only_view;
		}
		internal static App? get_app(string id) {
			if (_app_id_hash == null)
				rescan(null);
			if (_app_id_hash.has_key(id) == false)
				return null;
			return _app_id_hash[id];
		}
		internal static Gee.List<App> get_all_apps() {
			if (_app_list == null)
				rescan(null);
			return _app_list.read_only_view;
		}
	}

	public Pnd? get_pnd(string id) { return DataCache.get_pnd(id); }
	public App? get_pnd_app(string unique_id) { return DataCache.get_app(unique_id); }
	public Gee.List<Pnd> get_all_pnds() { return DataCache.get_all_pnds(); }
	public Gee.List<App> get_all_pnd_apps() { return DataCache.get_all_apps(); }

	public void scan_pnds(string? overrides_path) { DataCache.rescan(overrides_path); }
	public void clear_pnd_cache() { DataCache.clear(); }
}
