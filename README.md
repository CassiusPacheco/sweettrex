# Sweettrex

Sweettrex is a small server written in [Vapor](https://vapor.codes) that sends e-mails on [Bittrex's](https://bittrex.com) price changes.

![email](https://raw.githubusercontent.com/CassiusPacheco/sweettrex/master/email.png)

## E-mail Provider

The project uses [Mailgun](https://www.mailgun.com) as the mail provider. After creating your Mailgun's account, add a `mailgun.json` file to `Config/Secrets/`:

```
{
    "domain": "some domain",
    "key": "some key"
}
```

## MySQL

Sweettrex uses a MySQL database to store the cryptocurrency `Markets` and the users' `NotificationRequests`. Configuring MySQL requires adding a `mysql.json` file to `Config/Secrets/` just as the example below:

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
