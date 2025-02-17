{pkgs, ...}:

{
    config = {
	environment.systemPackages = [
	    pkgs.yazi
	];
    };
}
