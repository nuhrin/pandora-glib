/* Utility.vala
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

using pnd.utility;

namespace Pandora.Utility
{
	public string? determine_mountpoint(string test_path) {
		var mountpoint_array = new char[1024];
		if (pnd.utility.determine_mountpoint(test_path, mountpoint_array, 1024) == false)
			return null;
		
		return (string)mountpoint_array;
	}
}
