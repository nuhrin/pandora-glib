/* Config.vala
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
		public static AppsConfigFile get_config_apps() throws KeyFileError { return new AppsConfigFile(); }
		public static DesktopConfigFile get_config_desktop() throws KeyFileError { return new DesktopConfigFile(); }
		
		public static PndOvrFile get_pnd_ovr_file(string pnd_path) throws KeyFileError, FileError {	
			var ovr_path = PndOvrFile.get_pnd_ovr_path(pnd_path);
			if (FileUtils.test(ovr_path, FileTest.EXISTS) == true)
				return new PndOvrFile(ovr_path);
			
			// attempt to create the ovr file (which will be deleted if no changes are written)
			if (FileUtils.set_contents(ovr_path, "") == false)
				throw new FileError.FAILED("Unable to create '%s'.".printf(ovr_path));
				
			return new PndOvrFile.new_file(ovr_path);			
		}
		
		public static PndOvrAppFile get_pnd_ovr_app_file(string pnd_path, uint subapp_number) throws KeyFileError, FileError {	
			var ovr_path = PndOvrFile.get_pnd_ovr_path(pnd_path);
			if (FileUtils.test(ovr_path, FileTest.EXISTS) == true)
				return new PndOvrAppFile(ovr_path, subapp_number);
			
			// attempt to create the ovr file (which will be deleted if no changes are written)
			if (FileUtils.set_contents(ovr_path, "") == false)
				throw new FileError.FAILED("Unable to create '%s'.".printf(ovr_path));
				
			return new PndOvrAppFile.new_file(ovr_path,subapp_number);			
		}
	}
}
