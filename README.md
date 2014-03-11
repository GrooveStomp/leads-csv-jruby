# Dependencies
- jruby 1.7.5 (see .rbenv-version)
- Java 7 (or greater)
- JDBC Mysql Driver

## JDBC Driver

You need to make sure the driver is available for jruby to use.

I grabbed [Connector/J](https://dev.mysql.com/downloads/connector/j/)
and put this into `~/code/mysql-connector-java/`

I then symlinked that to `/usr/local/bin/jdbc.jar`

Then I modified my `.bashrc` with:
```
export CLASSPATH=/usr/local/bin/jdbc.jar
```
Now do `source ~/.bashrc` and the jdbc driver should be available for use.

# Running

```
bundle install
bundle exec ruby app.rb
```

Now hit your browser:

```
http://localhost:4567/page/:page_id
```
Where **:page_id** is a valid uuid for a page in your local lp_webapp database.

