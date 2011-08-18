using pnd.apps;
using pnd.conf;

namespace Pandora
{
	namespace Config
	{
		public static AppsConfigFile get_config_apps() throws KeyFileError { return new AppsConfigFile(); }
		public static DesktopConfigFile get_config_desktop() throws KeyFileError { return new DesktopConfigFile(); }

	}
}
