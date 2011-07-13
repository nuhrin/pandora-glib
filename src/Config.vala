using pnd.apps;
using pnd.conf;

namespace Pandora
{
	namespace Config
	{
		public static string apps_searchpath() {
			var handle = conf_fetch_by_id(ConfFilenameId.APPS, conf_query_searchpath());
			if (handle != null)
				return handle.get_string(APPS_KEY);

			return APPS_SEARCHPATH;
		}
	}
}
