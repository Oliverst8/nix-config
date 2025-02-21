{pkgs, ...}:

{
    config = {
	environment.systemPackages = [
	    pkgs.yazi
	    pkgs.spotify-player #https://github.com/aome510/spotify-player
	];
    };
}
