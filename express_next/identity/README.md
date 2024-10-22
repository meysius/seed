## Prisma cheatsheet:

Create a migration from changes in Prisma schema, apply it to the database, generate prisma client artifacts
```
$ npx prisma migrate dev
```

Reset your database and apply all migrations
```
$ npx prisma migrate reset
```

Apply pending migrations to the database in production/staging
```
$ npx prisma migrate deploy
```

Generate artifacts (e.g. Prisma Client)
```
$ npx prisma generate
```

Browse your data
```
$ npx prisma studio
```

Pull the schema from an existing database, updating the Prisma schema
```
$ npx prisma db pull
```

Push the Prisma schema state to the database
```
$ npx prisma db push
```

Validate your Prisma schema
```
$ npx prisma validate
```

Format your Prisma schema
```
$ npx prisma format
```
