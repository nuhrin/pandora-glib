/* AppsConfigFile.vala
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
		public class AppsConfigFile : ConfigFile
		{
			const string DEFAULT_PNDRUN_SEARCHPATH = "/usr/pandora/scripts";
			const string PND_NOTIFYD_LOGLEVEL_KEY = "pndnotifyd.loglevel";

			internal AppsConfigFile() throws KeyFileError
			{
				base.for_id(ConfFilenameId.APPS);
			}

			public string searchpath {
				get { return get_string(APPS_KEY, APPS_SEARCHPATH); }
				set { set_string(APPS_KEY, value); }
			}
			public string notify_path {
				get { return get_string(APPS_NOTIFY_KEY, APPS_NOTIFYPATH); }
				set { set_string(APPS_NOTIFY_KEY, value); }
			}
			public string overrides_searchpath {
				get { return get_string(PXML_OVERRIDE_KEY, PXML_OVERRIDE_SEARCHPATH); }
				set { set_string(PXML_OVERRIDE_KEY, value); }
			}
			public string runscript_searchpath {
				get { return get_string(PNDRUN_SEARCHPATH_KEY, DEFAULT_PNDRUN_SEARCHPATH); }
				set { set_string(PNDRUN_SEARCHPATH_KEY, value); _pndrun_full = null; }
			}
			public string runscript_filename {
				get { return get_string(PNDRUN_KEY, PNDRUN_FILENAME); }
				set { set_string(PNDRUN_KEY, value);  _pndrun_full = null; }
			}

			public string get_runscript_path() {
				if (_pndrun_full == null) {
					_pndrun_full = pnd.locate.locate_filename(runscript_searchpath, runscript_filename);
					if (_pndrun_full == null || _pndrun_full == "")
						_pndrun_full = PNDRUN_DEFAULT;
				}
				return _pndrun_full;
			}
			string _pndrun_full;



			public NotifyLogLevel notify_log_level {
				get {
					int level = get_int(PND_NOTIFYD_LOGLEVEL_KEY, -1);
					if (level < 0)
						return NotifyLogLevel.DEBUG;
					else if (level > 3)
						return NotifyLogLevel.ERRORS;
					return (NotifyLogLevel)level;
				}
				set { set_int(PND_NOTIFYD_LOGLEVEL_KEY, (int)value); }
			}
		}
		public enum NotifyLogLevel {
			DEBUG,
			REGULAR,
			WARNINGS,
			ERRORS
		}

	}
}
