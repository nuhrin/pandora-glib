/* Pnd.vala
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
