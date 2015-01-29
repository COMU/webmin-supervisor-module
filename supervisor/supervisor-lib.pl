=head1 supervisor-lib.pl

Functions for the Supervisor Web Server. This is an example Webmin module for a
simple fictional webserver.

=cut

use WebminCore;
init_config();

=head2 list_supervisor_websites()

Returns a list of all websites served by the Supervisor webserver, as hash
references with C<domain> and C<directory> keys.

=cut
sub list_supervisor_websites
{
my @rv;
my $lnum = 0;
open(CONF, $config{'supervisor_conf'});
while(<CONF>) {
	s/\r|\n//g;
	s/#.*$//;
	my ($dom, $dir) = split(/\s+/, $_);
	if ($dom && $dir) {
		push(@rv, { 'domain' => $dom,
			    'directory' => $dir,
			    'line' => $lnum });
		}
	$lnum++;
	}
close(CONF);
return @rv;
}

=head2 create_supervisor_website(&site)

Adds a new website, specified by the C<site> hash reference parameter, which
must contain C<domain> and C<directory> keys.

=cut
sub create_supervisor_website
{
my ($site) = @_;
open_tempfile(CONF, ">>$config{'supervisor_conf'}");
print_tempfile(CONF, $site->{'domain'}." ".$site->{'directory'}."\n");
close_tempfile(CONF);
}

=head2 modify_supervisor_website(&site)

Updates a website specified by the C<site> hash reference parameter, which
must be a modified entry returned from the C<list_supervisor_websites> function.

=cut
sub modify_supervisor_website
{
my ($site) = @_;
my $lref = read_file_lines($config{'supervisor_conf'});
$lref->[$site->{'line'}] = $site->{'domain'}." ".$site->{'directory'};
flush_file_lines($config{'supervisor_conf'});
}

=head2 delete_supervisor_website(&site)

Deletes a website, specified by the C<site> hash reference parameter, which
must have been one of the elements returned by C<list_supervisor_websites>

=cut
sub delete_supervisor_website
{
my ($site) = @_;
my $lref = read_file_lines($config{'supervisor_conf'});
splice(@$lref, $site->{'line'}, 1);
flush_file_lines($config{'supervisor_conf'});
}

=head2 apply_configuration()

Signal the Supervisor webserver process to re-read it's configuration files.

=cut
sub apply_configuration
{
kill_byname_logged('HUP', 'supervisord');
}

1;

# stop_supervisor()
# Attempts to stop the running Supervisor process, and returns undef on success or
# an error message on failure
sub stop_supervisor
{
local $out;
if ($config{'stop_cmd'}) {
        # use the configured stop command
        $out = &backquote_logged("($config{'stop_cmd'}) 2>&1");
        if ($?) {
                return "<pre>".&html_escape($out)."</pre>";
                }
        }
return undef;
}

# start_supervisor()
# Attempts to start the running Supervisor process, and returns undef on success or
# an error message on failure
sub start_supervisor
{
local $out;
if ($config{'start_cmd'}) {
        # use the configured stop command
        $out = &backquote_logged("($config{'start_cmd'}) 2>&1");
        if ($?) {
                return "<pre>".&html_escape($out)."</pre>";
                }
        }
return undef;
}
