# LNbits migrate SQLite to Postgres

The script migrates an existing [LNbits](https://lnbits.com) instance database in SQLite3 to Postgres.

To start, please backup up your `./data` folder, or if you haven't set one when installing LNbits, copy all the `*.sqlite3` files to a folder named `data`.

Move the database files (`*.sqlite3`) to the data folder in the script.

Make the script file executable:

```
$ chmod u+x migrate_sqlite_postgres.sh
```

## Install Postgres

Install postgres if you haven't yet, or follow the instalation guide on the [Postgres Tutorial](https://www.postgresqltutorial.com/install-postgresql-linux/) website.

Postgres doesn't have a default password, so we'll create one. Login and connect as the postgres user:

```
$ sudo -i -u postgres psql
```

Now send a command to change the `postgres` user's password:

```
postgres=# ALTER USER postgres PASSWORD 'myPassword';
```

Choose whatever password you like. `ALTER ROLE` should appear as the output of the command.

To exit, enter `\q`:

```
postgres=# \q
```

Then exit the user with `exit`.

## Create a database

Now create a database for LNbits. Login to postgres user:

```
$ sudo -i -u postgres psql
```

Create the database:

```
postgres=# createdb lnbits
```

Exit `psql` with `\q` then `exit` to exit `postgres` user.

## Generate LNbits tables

On LNbits folder edit your `.env` file and enter your database connection details `postgres://<user>:<password>@<host>/<database>`:

```
LNBITS_DATABASE_URL="postgres://postgres:postgres@localhost/lnbits"
```

Save and run LNbits to create all the tables on the postgres database.

`./venv/bin/hypercorn -k trio --bind 0.0.0.0:5000 'lnbits.app:create_app()'`

After the migration runs `Ctrl + c` to exit. Now you're ready to migrate the data from SQLite to Postgres.

On the terminal window, on the migration tool folder, with your copied data folder, run:

```
$ ./migrate_sqlite_postgres.sh
```

Script will promt you for the postgres username, if you haven't change the user just hit enter for the default `postgres` user. Next enter the database name you created above, `lnbits` in this example.
The migration tool will run, some warnings may appear about type issues with `integer`, `bigint`, etc... don't worry.

Hopefully, everything works and get migrated... Launch LNbits again and check if everything is working properly.
