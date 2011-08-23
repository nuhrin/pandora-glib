// TODO:
// 	* convenience class/methods for retrieving searchpath for various things (apps, scripts, etc)
//	* ala locatetest.c

// ****************************************************************************
// pnd.apps: pnd_apps.h, pnd_container.h, pnd_discovery.h
// ****************************************************************************
[CCode (cprefix="PND_", lower_case_cprefix = "pnd_", cheader_filename = "pnd_apps.h")]
namespace pnd.apps {
	// *******************************************************************
	// pnd_apps.h related
	// *******************************************************************

	// default application searchpath (and key to look it up in config)
	public const string APPS_SEARCHPATH;
	public const string APPS_KEY;

	public const string APPS_APPDATA_PREFIX;

	// default notify searchpath (and key to look it up in config)
	public const string APPS_NOTIFYPATH;
	public const string APPS_NOTIFY_KEY;

	public const string PNDRUN_SEARCHPATH_KEY;
	public const string PNDRUN_KEY;
	public const string PNDRUN_FILENAME;
	public const string PNDRUN_DEFAULT;

	public const string PXML_OVERRIDE_SEARCHPATH;
	public const string PXML_OVERRIDE_KEY;

	public const string MOUNT_PATH;

	// .desktop support
	public const string DESKTOP_DOTDESKTOP_PATH_KEY;
	public const string DESKTOP_ICONS_PATH_KEY;
	public const string DESKTOP_SEARCH_KEY;

	public const string MENU_DOTDESKTOP_PATH_KEY;
	public const string MENU_ICONS_PATH_KEY;
	public const string MENU_SEARCH_KEY;

	public const string DESKTOP_DOTDESKTOP_PATH_DEFAULT;
	public const string DESKTOP_ICONS_PATH_DEFAULT;
	public const string DESKTOP_SEARCH_PATH_DEFAULT;

	// apps
	public const string DEFAULT_WORKDIR;

	[Flags]
	[CCode(cprefix = "PND_EXEC_OPTION_")]
	public enum ExecOption {
		[CCode (cname="PND_EXEC_OPTION_NIL")]
		NONE = 0,
		/* wait till children complete; note, children might fork on their own.. */
		BLOCK = 1,
		/* wait till children complete; note, children might fork on their own.. */
		[CCode (cname="PND_EXEC_OPTION_NOUNION")]
		NO_UNION = 2,
		/* request pnd_run to kill x11 and restart it after */
		[CCode (cname="PND_EXEC_OPTION_NOXLL")]
		NO_X11 = 4,
		/* don't try to run; just form the pnd_run.sh line and cache it */
		[CCode (cname="PND_EXEC_OPTION_NORUN")]
		NO_RUN = 8,
		/* for apps_exec_disco() only; implies that 'reserved' points to pnd_apps_exec_info_t struct */
		INFO = 16,
		FUTURE2 = 32
	}

	/* exec() is used to blindly launch an app, be it a .pnd file bundle or a plain executable
	 * (shell, bin, whatever.) pndrun specifies the full path to the pnd_run sh script, which should be
	 * found using searchpaths and locates.. see locatetest.c for a sample
	 * pnd_run, fullpath, unique_id, rel_exec required
	 * rel_startdir, clockspeed, options are optional
	 * NOTE: Use pnd_locate function to locate the pnd_run, for example
	 * NOTE: if specified, clock speed will be set prior to invoking the script, and set back on exit
	 * NOTE: No values can be except clockspeed; a 0 clockspeed means 'leave alone'. Set startdoir to "." instead of NULL.
	 * fork() is implied; calling this function does not kill this process :)
	 * NOTE: Pass in the full path to the awesomeapp.pnd or to the directory containing PXML.xml (not the PXML.xml itself.)
	 * ExecOption is a set of flags, derived from the #define's below; OR them together.
	 *   option-block, when set, suggests the launch should wait until the invoked application exits (disregarding why app exits)
	 *   example: options = PND_EXEC_OPTION_BLOCK | PND_EXEC_OPTION_2;
	*/
	[CCode (cname="pnd_apps_exec")]
	public uint exec (string pndrun, string fullpath, string unique_id, string rel_exe,
	                         string? rel_startdir=null, string? args=null, uint clockspeed=0, uint options=0);
	// exec_runline(): returns the cached pnd_run.sh line from last PND_EXEC_OPTION_NORUN
	[CCode (cname="pnd_apps_exec_runline")]
	public unowned string exec_runline();

	/* exec_disco:
	 * this is a superior version of pnd_apps_exec(), but avoiding breaking the pnd_apps_exec() API to
	 * extend it.
	 * - same option booleans
	 * - 'reserved' should be NULL unless you know what to put there (depends on options)
	 * - 'app' should be a return from discovery, or a populated disco-t struct
	 * - 'pndrun' is a reference to a pnd_run.sh script, to avoid seeking it out every time
	 */
	[CCode (cname="pnd_apps_exec_disco")]
	public uint exec_disco (string pndrun, PndAppInfo app, uint options=0, void *reserved=null);
	// for pnd_apps_exec_disco(), when option PND_EXEC_OPTION_INFO is used
	[CCode (cname="pnd_apps_exec_info_t", has_type_id=false, has_destroy_function=false, has_copy_function=false)]
	public struct ExecInfo {
		public string viewer; // required; viewer's executable
		public string args;   // optional; arg to viewer; ie: the file to view
	}

	// should you wish to know where an app will get mounted, call this function to obtain a guess. The
	// logic is wrapped up in pnd_run.sh, but in theory should be easily determined.
	/* get_appdata_path() is the one you probably want.. the appdata path (which includes both the
	 * files in the pnd, and any files updated/written-out from that app. Look up aufs or union-filesystems.)
	 * ie: appdata path is read/write, while ro_mountpoint is read-only
	 * Returns >0 on success, and if not-NULL will fill r_path (up to path_len length.)
	 */
	[CCode (cname="pnd_get_appdata_path")]
	public uint get_appdata_path (string fullpath, string unique_id, char* r_path, uint path_len=1024);
	/* get_ro_mountpoint() returns the _read only_ mountpoint, where the dir or .pnd is actually
	 * mounted to. This is probably NOT WHAT YOU WANT. You probably want the read/write mountpoint, which
	 * is the union-filesystem version of it.. see pnd_get_appdata_path()
	 *   r_mountpoint (if !NULL) will be populated; mountpoint_len should specify the maxlen of the buffer
	 */
	[CCode (cname="pnd_get_ro_mountpoint")]
	public void get_ro_mountpoint (string fullpath, string unique_id, char* r_mountpoint, uint mountpoint_len=1024);


	// *******************************************************************
	// pnd_discovery.h related (included by pnd_apps.h)
	// *******************************************************************

	// discover_search() [pnd_disco_search()]
	[CCode (cname="pnd_disco_search")]
	public DiscoverySearchHandle discovery_search(string searchpath, string? overrides_path);
	[Compact]
	[CCode (cname="void", free_function="pnd_box_delete")]
	public class DiscoverySearchHandle {
		DiscoverySearchHandle() {}
		[CCode (cname="pnd_box_get_head")]
		public PndAppInfo* get_head();
		[CCode (cname="pnd_box_get_next")]
		public static PndAppInfo* get_next(PndAppInfo* node);
	}

	// discovery_file() [pnd_disco_file()]
	[CCode (cname="pnd_disco_file")]
	public DiscoveryFileHandle discovery_file(string path, string filename);
	[CCode (cname="void", free_function="pnd_box_delete")]
	public class DiscoveryFileHandle {
		DiscoveryFileHandle() {}
		[CCode (cname="pnd_box_get_head")]
		public PndAppInfo* get_item();
	}

	// PndAppInfo and related enums [pnd_disco_t]
	[CCode (cname="pnd_object_type_t")]
	public enum ObjectType {
		[CCode (cname="pnd_object_type_unknown")]
		UNKNOWN,
		[CCode (cname="pnd_object_type_directory")]
		DIRECTORY,
		[CCode (cname="pnd_object_type_pnd")]
		PND,
		[CCode (cname="pnd_object_type_max")]
		MAX
	}
	[Flags]
	[CCode(cprefix = "PND_DISCO_")]
	public enum ObjectFlags {
		NONE = 0,
		FLAG_OVR = 1,
		GENERATED = 2,
		CUSTOM1 = (1<<30),
		CUSTOM2 = (1<<31)
	}
	[CCode (cname="pnd_disco_t", destroy_function="pnd_disco_destroy", has_type_id=false, has_copy_function=false)]
	public struct PndAppInfo {
		// base
		public ObjectType object_type;		// see enum above
		public string object_path;			// directory containing pnd or PXML.xml (does not include filename)
		public string object_filename;		// filename within object_path of the app: the PXML.xml or awesomeapp.pnd file itself
		public uint pnd_icon_pos;			// offset to the byte after end of PXML in a pnd file (should be icon if present)
		public uint subapp_number;			// # of app within PXML (ie: 0, 1, 2, 3, up to the number of apps within the PXML)
		public ObjectFlags object_flags;	// see PND_DISCO_ bitmasks above

		// strdup'd from PXML -- hey, who was the idiot who thought it was a reat idea not to just re-use the pxml-struct?
		public string package_id;
		public string title_en;
		public string desc_en;
		public string unique_id;
		public string appdata_dirname;		// preferred dir name for appdata; if missing, use unique-id
		public string icon;
		public string exec;
		public string execargs;
		public string clockspeed;
		public string startdir;
		public string option_no_x11;
		public string main_category;
		public string main_category1;
		public string main_category2;
		public string alt_category;
		public string alt_category1;
		public string alt_category2;
		public string preview_pic1;
		public string preview_pic2;
		public string mkdir_sp;
		public string info_name;			// should be a struct..
		public string info_filename;
		public string info_type;

		[CCode (cname="pnd_box_get_key")]
		public string get_key();
		[CCode (cname="pnd_box_get_next")]
		public PndAppInfo* get_next();

		[CCode (cname="pnd_disco_destroy")]
		public static void destroy(PndAppInfo* item);
	}

	// *******************************************************************
	// pnd_container.h related (included by pnd_apps.h)
	// *******************************************************************

	[Compact]
	[CCode (cname="void", lower_case_cprefix = "pnd_box_", free_function="pnd_box_delete")]
	public class BoxHandle {
		BoxHandle() {}

		[CCode (cname="pnd_box_new")]
		public static BoxHandle create(string name);

		public unowned string get_name();
		public unowned void* get_head();
		public uint get_size();
		public static unowned void* get_next(void* node);
		public static unowned string get_key(void* node);

		[CCode (cname="pnd_box_allocinsert")]
		public unowned void* alloc_insert(string key, uint size);
		public void delete_node(void* value);

		public void* find_by_key(string key);

		public uint append(BoxHandle append);
	}
}

// ****************************************************************************
// pnd.locate: pnd_locate.h
// ****************************************************************************
[CCode (cheader_filename = "pnd_locate.h")]
namespace pnd.locate {
	/* given a filename and a searchpath, return the first path it is found at (or NULL if not found)
	 * Returned path includes filename.
	 * WARNING: Returned path will be over-written, you must duplicate it!
	 */
	[CCode (cname="pnd_locate_filename")]
	public unowned string locate_filename(string searchpath, string filename);
}

// ****************************************************************************
// pnd.conf: pnd_conf.h
// ****************************************************************************
[CCode (cprefix="PND_", lower_case_cprefix = "pnd_", cheader_filename = "pnd_conf.h")]
namespace pnd.conf {

	public const string CONF_SEARCHPATH;
	public const string CONF_FILE;
	public const string CONF_KEY;

	[Compact]
	[CCode (cname="void", free_function="pnd_box_delete")]
	public class ConfHandle {
		ConfHandle() {}

		[CCode (cname="pnd_conf_get_as_char")]
		public unowned string get_string(string key);
		[CCode (cname="pnd_conf_get_as_int_d")]
		public int get_int_or_default(string key, int default);

		[CCode (cname="PND_CONF_BADNUM")]
		public const int BADNUM;
		[CCode (cname="pnd_conf_get_as_int")]
		public int get_int(string key);

		[CCode (cname="pnd_conf_set_char")]
		public unowned string set_string(string key, string value);
		[CCode (cname="pnd_conf_set_int")]
		public int set_int(string key, int value);

		[CCode (cname="pnd_conf_write")]
		public uint write(string fullpath);
	}

	/* we would like to open config files based on enums, so as to minimize specifying
	 * filenames; ie: It makes it easier to rename them later or display them in a native
	 * language, etc. It is optional as our API will allow direct open by filename as
	 * well.
	 */
	[CCode (cname="pnd_conf_filename_e")]
	public enum ConfFilenameId {
		[CCode (cname="pnd_conf_nil")]
		NIL,
		// provides settings for the config system
		[CCode (cname="pnd_conf_conf")]
		CONF,
		// provides application search-path, pxml override location, etc.
		[CCode (cname="pnd_conf_apps")]
		APPS,
		// provides list of startup applications, basic shell application, etc.
		[CCode (cname="pnd_conf_startup")]
		STARTUP,
		// provides settings for the launchers
		[CCode (cname="pnd_conf_desktop")]
		DESKTOP,
		// provides mapping from PXML category to dot-desktop category
		[CCode (cname="pnd_conf_categories")]
		CATEGORIES,
		// provides mapping from event to sh-script
		[CCode (cname="pnd_conf_evmap")]
		EVMAP
	}
	[CCode (cname="pnd_conf_filename_t", has_type_id=false, has_destroy_function=false, has_copy_function=false)]
	public struct ConfFilename {
		public ConfFilenameId id;
		public unowned string filename;
	}

	[CCode (array_null_terminated=false, array_length=false, array_length_cexpr="6")]
	public extern ConfFilename[] conf_filenames;

	//
	// config FILE reading public API

	/* since near every app may wish to use this piece of code,
	 * it is encapsulated here.
	 * Returns a search-path to be used hereafter; free it when done with it!
	 */
	public string conf_query_searchpath();

	/* fetch_by_id() will try to locate the config file as referred to by the enum'd 'id'. If it
	 * can be found and parsed a handle will be returned, otherwise a handle of 0 (NULL).
	 * Returns a 0 handle on fail, otherwise a useful handle.
	 */
	public ConfHandle conf_fetch_by_id(ConfFilenameId id, string searchpath);

	/* if you don't wish to use an 'id', you can fetch by filename. Essentially the fetch_by_id()
	 * function simply uses this to do the work, but you could use it to load up alternate config-format
	 * files.
	 * Returns a 0 handle on fail, otherwise a useful handle.
	 */
	public ConfHandle conf_fetch_by_name(string filename, string searchpath);

	/* fetch_by_path() will operate on a specific full filename; this essentially does the
	 * dirty work for the above functions, but can be used to pull in a specific path for
	 * whatever purpose.
	 * Returns a 0 handle on fail, otherwise a useful handle.
	 */
	public ConfHandle conf_fetch_by_path(string fullpath);
}

// ****************************************************************************
// pnd.notify: pnd_notify.h
// ****************************************************************************
[CCode (cprefix="PND_", lower_case_cprefix = "pnd_", cheader_filename = "pnd_notify.h")]
namespace pnd.notify {

	public unowned NotifyHandle notify_init();
	public void notify_shutdown(NotifyHandle handle);

	[Flags]
	[CCode(cprefix = "PND_NOTIFY_")]
	public enum WatchOptions {
		NONE = 0,
		RECURSE = 1
	}

	[Compact]
	[CCode (cname="void", lower_case_cprefix="pnd_notify_", free_function="pnd_box_delete")]
	public class NotifyHandle {
		NotifyHandle() {}
		/* register a path to watch
		 * Pass in a path to register it for watching; note that should you wish children
		 * directories to be watched as well you should set the recursive flag.
		 */
		public void watch_path(string fullpath, WatchOptions options);
		/* rescan_p (rescan predicate) -- wil return TRUE (>0) when the notify is reporting
		 * that we should do a re-discovery against the paths.
		 * NOTE:
		 * (Yes this is a little brute-forcey .. it should just collect notify events
		 * and suss-out the changes, and add/sub those from a working list of applications.)
		 */
		public uint rediscover_p();
		/* wait_until_ready() will loop (up to a max of secs_timeout) until inotify seems to
		 * be responding. Returns 0 if inotify is never ready during the interval, otherwise
		 * it suggests inotify is up and going.
		 * secs_timeout may be 0 which means 'forever'
		 * NOTE: This wastes some time, always
		 */
		public uint wait_until_ready(uint secs_timeout);
	}
}


// ****************************************************************************
// pnd.pndfiles: pnd_pndfiles.h
// ****************************************************************************
[CCode (cprefix="PND_", lower_case_cprefix = "pnd_", cheader_filename = "stdio.h,pnd_pndfiles.h")]
namespace pnd.pndfiles {
	public const string PACKAGE_FILEEXT;
	public char pnd_mount(string pndrun, string fullpath, string unique_id);
	public char pnd_unmount(string pndrun, string fullpath, string unique_id);
}
