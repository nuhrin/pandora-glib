using Gee;
using pnd.apps;
using pnd.conf;

namespace Pandora.Apps
{
	public class App
	{
		internal PndAppInfo info;
		internal App(PndAppInfo app) {
			this.info = app;
		}

		public unowned string id { get { return info.unique_id; } }
		public unowned string package_id { get { return info.package_id; } }
		public uint subapp_number { get { return info.subapp_number; } }
		public unowned string title { get { return info.title_en; } }
		public unowned string description { get { return info.desc_en; } }
		public unowned string filename { get { return info.object_filename; } }
		public unowned string path { get { return info.object_path; } }
		public string get_fullpath() { return path + filename; }

		public uint clockspeed {
			get {
				if (info.clockspeed == null)
					return 0;
				return (uint)int.parse(info.clockspeed);
			}
		}

		public uint pnd_icon_pos { get { return info.pnd_icon_pos; } }
		public unowned string appdata_dirname { get { return info.appdata_dirname; } }
		public unowned string icon { get { return info.icon; } }
		public unowned string exec_command { get { return info.exec; } }
		public unowned string exec_arguments { get { return info.execargs; } }
		public ExecOptionX11 exec_option_x11 {
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
		public unowned string version_major { get { return info.version_major; } }
		public unowned string version_minor { get { return info.version_minor; } }
		public unowned string version_release { get { return info.version_release; } }
		public unowned string version_build { get { return info.version_build; } }
		public unowned string package_version_major { get { return info.package_version_major; } }
		public unowned string package_version_minor { get { return info.package_version_minor; } }
		public unowned string package_version_release { get { return info.package_version_release; } }
		public unowned string package_version_build { get { return info.package_version_build; } }

		public ObjectFlags flags { get { return (ObjectFlags)info.object_flags; } }

		// execute methods
		public uint execute(ExecOption options=ExecOption.NONE) {
			var pndrun = Apps.get_pndrun_path();
			if (pndrun == null)
				return -1;
			return exec_disco(pndrun, info, (uint)options);
		}
		public uint execute_viewer(string viewer, string? args=null, ExecOption options=ExecOption.NONE) {
			var pndrun = Apps.get_pndrun_path();
			if (pndrun == null)
				return -1;
			uint real_options = ((uint)options) | pnd.apps.ExecOption.INFO;
			var exec_info = pnd.apps.ExecInfo();
			exec_info.viewer = viewer;
			exec_info.args = args;
			return exec_disco(pndrun, info, real_options, &exec_info);
		}
		public uint execute_full(string? rel_exe=null, string? rel_startdir=null, string? args=null, uint clockspeed=0, ExecOption options=ExecOption.NONE) {
			var pndrun = Apps.get_pndrun_path();
			if (pndrun == null)
				return -1;
			return exec(pndrun, get_fullpath(), id, rel_exe ?? exec_command, rel_startdir ?? startdir, args ?? exec_arguments,
				(clockspeed > 0) ? clockspeed : this.clockspeed, (uint)options);
		}

		// get runline methods
		public unowned string? get_runline(ExecOption options=ExecOption.NONE) {
			var pndrun = Apps.get_pndrun_path();
			if (pndrun == null)
				return null;
			uint real_options = ((uint)options) | pnd.apps.ExecOption.NO_RUN;
			exec_disco(pndrun, info, real_options);
			return exec_runline();
		}
		public unowned string? get_runline_viewer(string viewer, string? args=null, ExecOption options=ExecOption.NONE) {
			var pndrun = Apps.get_pndrun_path();
			if (pndrun == null)
				return null;
			uint real_options = ((uint)options) | pnd.apps.ExecOption.INFO | pnd.apps.ExecOption.NO_RUN;
			var exec_info = pnd.apps.ExecInfo();
			exec_info.viewer = viewer;
			exec_info.args = args;
			exec_disco(pndrun, info, real_options, &exec_info);
			return exec_runline();
		}
		public unowned string? get_runline_full(string? rel_exe=null, string? rel_startdir=null, string? args=null, uint clockspeed=0, ExecOption options=ExecOption.NONE) {
			var pndrun = Apps.get_pndrun_path();
			if (pndrun == null)
				return null;
			uint real_options = ((uint)options) | pnd.apps.ExecOption.NO_RUN;
			exec(pndrun, get_fullpath(), id, rel_exe ?? exec_command, rel_startdir ?? startdir, args ?? exec_arguments,
				(clockspeed > 0) ? clockspeed : this.clockspeed, real_options);
			return exec_runline();
		}
	}
}
