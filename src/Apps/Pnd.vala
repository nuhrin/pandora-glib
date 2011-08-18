using Gee;
using pnd.apps;
using pnd.conf;

namespace Pandora.Apps
{
	public class Pnd
	{
		internal Pnd(Gee.List<App> apps) {
			this.apps = apps.read_only_view;
			this.first_app = apps[0];
		}
		App first_app;

		public unowned string id { get { return (first_app.package_id != null) ? first_app.package_id : first_app.id; } }
		public unowned string package_id { get { return first_app.package_id; } }
		public unowned string filename { get { return first_app.filename; } }
		public unowned string path { get { return first_app.path; } }
		public string get_fullpath() { return path + filename; }

		public Gee.List<App> apps { get; private set; }

		public bool mount() { return (pnd.pndfiles.pnd_mount(Apps.get_pndrun_path(), get_fullpath(), id) > 0); }
		public bool unmount() { return (pnd.pndfiles.pnd_unmount(Apps.get_pndrun_path(), get_fullpath(), id) > 0); }
	}
}
