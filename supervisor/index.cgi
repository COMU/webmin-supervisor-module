#!/usr/bin/perl
# Show all Supervisor webserver websites

require 'supervisor-lib.pl';

ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

# Build table contents
my @sites = list_supervisor_websites();
my @table = ( );
foreach my $s (@sites) {
	push(@table, [ "<a href='edit.cgi?domain=".urlize($s->{'domain'}).
		       "'>".html_escape($s->{'domain'})."</a>",
		       html_escape($s->{'directory'})
		     ]);
	}

# Show the table with add links
print ui_form_columns_table(
	undef,
	undef,
	0,
	[ [ 'edit.cgi?new=1', $text{'index_add'} ] ],
	undef,
	[ $text{'index_domain'}, $text{'index_directory'} ],
	100,
	\@table,
	undef,
	0,
	undef,
	$text{'index_none'},
	);

print ui_buttons_start();
print ui_buttons_row('start.cgi', 'Start server', 'Click this button to start the server process');
print ui_buttons_row('stop.cgi', 'Stop server', 'Click this button to stop the server process');
print ui_buttons_end(); 

ui_print_footer('/', $text{'index'});

