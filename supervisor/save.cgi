#!/usr/bin/perl
# Create, update or delete a website

require 'supervisor-lib.pl';
ReadParse();
error_setup($text{'save_err'});
lock_file($config{'supervisor_conf'});

# Get the old site object
if (!$in{'new'}) {
	my @sites = list_supervisor_websites();
        ($site) = grep { $_->{'domain'} eq $in{'old'} } @sites;
	$site || error($text{'save_egone'});
	}

if ($in{'delete'}) {
	# Just delete it
	delete_supervisor_website($site);
	}
else {
	# Validate inputs
	$in{'domain'} =~ /^[a-z0-9\.\-\_]+$/i ||
		error($text{'save_edomain'});
	$in{'directory'} =~ /^\// ||
		error($text{'save_edirectory'});
	-d $in{'directory'} ||
		error($text{'save_edirectory2'});
	$site->{'domain'} = $in{'domain'};
	$site->{'directory'} = $in{'directory'};

	# Update or create
	if ($in{'new'}) {
		create_supervisor_website($site);
		}
	else {
		modify_supervisor_website($site);
		}
	}

# Log the change
unlock_file($config{'supervisor_conf'});
apply_configuration();
webmin_log($in{'new'} ? 'create' :
	   $in{'delete'} ? 'delete' : 'modify',
	   'site',
	   $site->{'domain'});
&redirect('');

