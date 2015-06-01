# gitlab-irc

**Notice:** if you're looking for an **IRC Bot** (idling in your channel, taking commands etc.) take a look at my other project: **[gitlab-cinch-bot](https://github.com/aleks/gitlab-cinch-bot)**.

Tiny Sinatra App that takes POST Calls from Gitlab Web Hooks and pushes them in your IRC Channel of choice.

    22:59 < GitLabBot> New Commits for 'repo-name'
    22:59 < GitLabBot> by Aleks | Got shit done | http://yourgitlabhost.com/repo-name/commits/f9cbbe01c....
    22:59 < GitLabBot> by Aleks | Got even more shit done | http://yourgitlabhost.com/repo-name/commits/f9cbbe01c....

### Install Sinatra

<code>
gem install sinatra
</code>

### Configure
Copy config.yml.dist to config.yml and set right parameters.

The 'IRC\_CHANNEL' is the default channel to send the message to, if the hook is set to '/'.



### Launch
    ruby gitlab-irc.rb

You should see output like this:

    » ruby gitlab-irc.rb  
    == Sinatra/1.3.3 has taken the stage on 4567 for development with backup from Thin
    >> Thin web server (v1.4.1 codename Chromeo)
    >> Maximum connections set to 1024
    >> Listening on 0.0.0.0:4567, CTRL+C to stop

### Enable Web Hook Support in your GitLab Repository

Every Gitlab repository can have individual Web Hooks. Copy your gitlab-irc address <code>http://xxx.xxx.xxx.xxx:4567/nameofthechannel</code> and set it for every Repository that should send notifications to the channel #nameofthechannel.

### Run in Background

To keep gitlab-irc running, you should start it in some kind of background task. A good choice would be <code>tmux</code> or <code>screen</code>.

If you want to configure the webserver port, take a look at the [Sinatra Documentation](http://www.sinatrarb.com/configuration.html). You can also run it like any other Sinatra app.

