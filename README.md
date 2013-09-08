# Hubot

<<<<<<< HEAD
WARNING: This is Jolly Science's version of Hubot. It is configured for the Jolly Science environments and systems. 

## 'min'

This branch is being used to establish the base-level of functionality for JoSi. Think of this as "JoSi-lite". She handles all of the basic conversational and memory tasks, but has no complex configuration, and no dangerous access points. She is totally polite, stable, and harmless.

## 'max'
=======
## Playing with Hubot
>>>>>>> 2696141eb44070548df9ccf6e6e33b1840f21589

This branch will be everything that works. This is a stable, but full-featured. Dangerous, but specific. It's highly-customized to the Jolly Science environment, members, and processes. It's the library of all things JoSi. When she uses this branch, she's Cruella Deville.

## 'master'

This is the default state for JoSi. Unless otherwise directed, she should always wake up on master. So should her children.

## 'develop'

This is the branch used for the engineers behind JoSi to work on her.

<<<<<<< HEAD
## 'hubot'

This is the branch that only Hubot pays attention to.
=======
```coffeescript
module.exports = (robot) ->
  robot.router.get "/hubot/version", (req, res) ->
    res.end robot.version
```

There are functions for GET, POST, PUT and DELETE, which all take a route and
callback function that accepts a request and a response.

### Redis

If you are going to use the `redis-brain.coffee` script from `hubot-scripts`
you will need to add the Redis to Go addon on Heroku which requires a verified
account or you can create an account at [Redis to Go][redistogo] and manually
set the `REDISTOGO_URL` variable.

    % heroku config:add REDISTOGO_URL="..."

If you don't require any persistence feel free to remove the
`redis-brain.coffee` from `hubot-scripts.json` and you don't need to worry
about redis at all.

[redistogo]: https://redistogo.com/

### Testing Hubot Locally

You can test your hubot by running the following.

    % bin/hubot

You'll see some start up output about where your scripts come from and a
prompt.

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/src/scripts
    Hubot>

Then you can interact with hubot by typing `hubot help`.

    Hubot> hubot help

    Hubot> animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that Hubot knows about.
    ...

Take a look at the scripts in the `./scripts` folder for examples.
Delete any scripts you think are silly.  Add whatever functionality you
want hubot to have.

## Adapters

Adapters are the interface to the service you want your hubot to run on. This
can be something like Campfire or IRC. There are a number of third party
adapters that the community have contributed. Check the
[hubot wiki][hubot-wiki] for the available ones.

If you would like to run a non-Campfire or shell adapter you will need to add
the adapter package as a dependency to the `package.json` file in the
`dependencies` section.

Once you've added the dependency and run `npm install` to install it you can
then run hubot with the adapter.

    % bin/hubot -a <adapter>

Where `<adapter>` is the name of your adapter without the `hubot-` prefix.

[hubot-wiki]: https://github.com/github/hubot/wiki

## hubot-scripts

There will inevitably be functionality that everyone will want. Instead
of adding it to hubot itself, you can submit pull requests to
[hubot-scripts][hubot-scripts].

To enable scripts from the hubot-scripts package, add the script name with
extension as a double quoted string to the `hubot-scripts.json` file in this
repo.

[hubot-scripts]: https://github.com/github/hubot-scripts

## external-scripts

Tired of waiting for your script to be merged into `hubot-scripts`? Want to
maintain the repository and package yourself? Then this added functionality
maybe for you!

Hubot is now able to load scripts from third-party `npm` packages! To enable
this functionality you can follow the following steps.

1. Add the packages as dependencies into your `package.json`
2. `npm install` to make sure those packages are installed

To enable third-party scripts that you've added you will need to add the package
name as a double quoted string to the `external-scripts.json` file in this repo.

## Deployment

    % heroku create --stack cedar
    % git push heroku master
    % heroku ps:scale app=1

If your Heroku account has been verified you can run the following to enable
and add the Redis to Go addon to your app.

    % heroku addons:add redistogo:nano

If you run into any problems, checkout Heroku's [docs][heroku-node-docs].

You'll need to edit the `Procfile` to set the name of your hubot.

More detailed documentation can be found on the
[deploying hubot onto Heroku][deploy-heroku] wiki page.

### Deploying to UNIX or Windows

If you would like to deploy to either a UNIX operating system or Windows.
Please check out the [deploying hubot onto UNIX][deploy-unix] and
[deploying hubot onto Windows][deploy-windows] wiki pages.

[heroku-node-docs]: http://devcenter.heroku.com/articles/node-js
[deploy-heroku]: https://github.com/github/hubot/wiki/Deploying-Hubot-onto-Heroku
[deploy-unix]: https://github.com/github/hubot/wiki/Deploying-Hubot-onto-UNIX
[deploy-windows]: https://github.com/github/hubot/wiki/Deploying-Hubot-onto-Windows

[hubot-wiki]: https://github.com/github/hubot/wiki

## Restart the bot

    sudo restart hubot
    sudo start hubot
    sudo stop hubot
>>>>>>> 2696141eb44070548df9ccf6e6e33b1840f21589
