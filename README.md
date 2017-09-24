# Sweettrex

Sweettrex is a small server written in [Vapor](https://vapor.codes) that sends e-mails on [Bittrex's](https://bittrex.com) price changes.

![email](https://raw.githubusercontent.com/CassiusPacheco/sweettrex/master/email.png)

## E-mail Provider

The project uses [Mailgun](https://www.mailgun.com) as the mail provider. After creating your Mailgun account just add a `mailgun.json` file to the `Config/Secrets/` folder (you have to create the `Secrets` folder since it's in `.gitignore`):

```
{
    "domain": "some domain",
    "key": "some key"
}
```

## MySQL

Sweettrex uses a MySQL database to store the cryptocurrency `Markets` and the users' `NotificationRequests`. Configuring MySQL requires a `mysql.json` file in the `Config/Secrets/` directory. This file should contain the keys present in the example below:

```
{
    "hostname": "some host",
    "user": "some user",
    "password": "some password",
    "database": "db name",
    "port": 3306,
    "encoding": "utf8"
}
```

## WIP

This is still a work in progress project and managing alerts is limited via API. More info to come soon :)
