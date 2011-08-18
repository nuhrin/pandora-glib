namespace Pandora.Apps
{
	[Flags]
	public enum ObjectFlags {
		NONE = 0,
		FLAG_OVR = 1,
		GENERATED = 2,
		CUSTOM1 = (1<<30),
		CUSTOM2 = (1<<31)
	}
	public enum ExecOptionX11 {
		IGNORE,
		REQUIRED,
		STOP
	}
	[Flags]
	public enum ExecOption {
		NONE = 0,
		BLOCK = 1,
		NO_UNION = 2,
		NO_X11 = 4
	}
}
