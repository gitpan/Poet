<%text>

<%class>
</%class>

<h2>Welcome to Poet!</h2>

<hr>

This is the default home page generated by <code>comps/index.mc</code>.

<h3>Site information</h3>

<table border=1>
  <tr><td>Environment root</td><td><code><% $env->root_dir %></code></td></tr>
  <tr><td>App name</td><td><code><% $env->app_name %></code></td></tr>
  <tr><td>Layer</td><td><code><% $conf->layer %></code></td></tr>
  <tr><td>Port</td><td><code><% $conf->get('server.port') %></code></td></tr>
</table>

<h3>Where things go</h3>

<table border=1>
  <tr><td>Scripts</td><td><code>bin/</code></td></tr>
  <tr><td>Configuration settings</td><td><code>conf/*.cfg</code></td></tr>
  <tr><td>Mason components</td><td><code>comps/</code></td></tr>
  <tr><td>Perl libraries (*.pm)</td><td><code>lib/<% $env->app_name %></code></td></tr>
  <tr><td>Static files (css, images, and javascript)</td><td><code>static/</code></td></tr>
</table>

<h3>Documentation</h3>

<ul>
  <li><a href="http://search.cpan.org/perldoc/Poet">Poet</a></li>
  <li><a href="http://search.cpan.org/perldoc/Mason::Manual">Mason</a></li>
  <li><a href="http://plackperl.org/">Plack/PSGI</a></li>
</ul>

<%init>
$.title('Welcome to Poet');
</%init>

</%text>
