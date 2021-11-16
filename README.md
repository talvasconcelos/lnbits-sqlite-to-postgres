# LNbits migrate SQLite to Postgres

The script migrates an existing [LNbits](https://lnbits.com) instance database in SQLite3 to Postgres.

To start, please backup up your `./data` folder, or if you haven't set one when installing LNbits, copy all the `*.sqlite3` files to a folder named `data`.

Move the database files (`*.sqlite3`) to the data folder in the script.

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
$ sudo -i -u postgres
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

`./venv/bin/uvicorn lnbits.__main__:app`

After the migration runs `Ctrl + c` to exit. Now you're ready to migrate the data from SQLite to Postgres. Edit the `conv.py` file in the script with the relevant data:

```
... 
pgdb = "lnbits" # Postgres DB name
pguser = "postgres" # Postgres user
pgpswd = "yourpassword" # Postgres password
...
```

On the terminal window, on the migration tool folder, with your copied data folder, run:

```
$ python conv.py
```

Hopefully, everything works and get migrated... Launch LNbits again and check if everything is working properly.

**Huge thanks to [fusion44](https://github.com/fusion44) for the hard work on this script!**
