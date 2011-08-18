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
