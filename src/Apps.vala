/* Apps.vala
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
	public Pnd? get_pnd(string id) { return DataCache.get_pnd(id); }
	public App? get_app(string unique_id) { return DataCache.get_app(unique_id); }
	public Gee.List<Pnd> get_all_pnds() { return DataCache.get_all_pnds(); }
	public Gee.List<App> get_all_apps() { return DataCache.get_all_apps(); }

	public void scan_pnds() { DataCache.rescan(); }
	public void clear_pnd_cache() { DataCache.clear(); }

	public string? get_pndrun_path() {
		string path = (_runscript_path != null) ? _runscript_path : DataCache.get_runscript_path();

		if (FileUtils.test(path, FileTest.IS_EXECUTABLE) == false) {
			warning("runscript not found or not executable: %s", path);
			return null;
		}
		return path;
	}
	string _runscript_path;
	public void set_pndrun_path(string fullpath) { _runscript_path = fullpath; }
	public void unset_pndrun_path() { _runscript_path = null; }

	public bool mount_pnd(string fullpath, string id) {
		var pndrun = get_pndrun_path();
		if (pndrun == null)
			return false;
		return (pnd.pndfiles.pnd_mount(pndrun, fullpath, id) > 0);
	}
	public bool unmount_pnd(string fullpath, string id) {
		var pndrun = get_pndrun_path();
		if (pndrun == null)
			return false;
		return (pnd.pndfiles.pnd_unmount(pndrun, fullpath, id) > 0);
	}

	public unowned string? get_app_runline(string fullpath, string unique_id, string rel_exe, string? rel_startdir=null, string? args=null, uint clockspeed=0, ExecOption options=ExecOption.NONE)  {
		var pndrun = get_pndrun_path();
		if (pndrun == null)
			return null;
		uint real_options = ((uint)options) | pnd.apps.ExecOption.NO_RUN;
		exec(pndrun, fullpath, unique_id, rel_exe, rel_startdir, args, clockspeed, real_options);
		return exec_runline();
	}
	public unowned string? get_last_app_runline() {
		return exec_runline();
	}
	public uint execute_app(string fullpath, string unique_id, string rel_exe, string? rel_startdir=null, string? args=null, uint clockspeed=0, ExecOption options=ExecOption.NONE)  {
		var pndrun = get_pndrun_path();
		if (pndrun == null)
			return -1;
		return exec(pndrun, fullpath, unique_id, rel_exe, rel_startdir, args, clockspeed, (uint)options);
	}
	public string? get_appdata_path(string fullpath, string unique_id) {
		string command = "sh -c \"df \\\"%s\\\" | tail -1|awk '{print $6}'\"".printf(fullpath);
		string mountpoint;
		int result;
		try {
			if (Process.spawn_command_line_sync(command, out mountpoint, null, out result) == true && result == 0) {
				return "%s%s/%s/".printf(mountpoint.strip(), APPS_APPDATA_PREFIX, unique_id);
			}
		} catch(SpawnError e) {
			warning("Error looking up appdata path for %s: %s", fullpath, e.message);
		}
		return null;
	}
}
