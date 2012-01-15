# Yumtags!

Yumtags! aims to make build reproducibility easier on RPM/YUM systems (RHEL, CentOS, etc.).

## Usage

    gem install vagrant # If you haven't already  - do so now. Needs Virtualbox.
    vagrant up

Drop some RPMs into the /public directory.
Browse to [the vagrant VM's HTTPD port](http://localhost:8080/) .
Generate a tag.
Use the tag as the baseurl in your YUM repository definitions on your server builds, for example:

    [yumtag]
    name=Tagged repository for reproducible build
    baseurl=http://localhost/65299312-3f6d-11e1-8352-0800277424a0
    enabled=1

If you'd like to integrate this with your CI setup, you can POST for JSON.

Request

    curl -X POST -d "" -H "Accept: application/json" localhost

Response

    {"tag":"439793ae-3f70-11e1-82c1-0800277424a0"}


## Testing

    vagrant ssh
    sudo su -
    cd /vagrant
    bundle exec cucumber features

## Playing with Messaging / Easy Debugging

Open two terminals

Terminal 1:

    vagrant ssh
    sudo su -
    /etc/init.d/httpd stop
    cd /vagrant
    rackup -p 80

Terminal 2:

    vagrant ssh
    sudo su -
    /etc/init.d/repo_creator stop
    cd /vagrant
    ruby bin/repo_creator_control.rb run

Create some tags and observe the magic that is Yumtags!.

## Contributing

Please, please, please fork this, improve it, and issue a pull request. You know you want to.

## Changelog

[CHANGELOG](https://github.com/hatofmonkeys/yumtags/blob/master/CHANGELOG)

## License

[MIT](https://github.com/hatofmonkeys/yumtags/blob/master/LICENSE)
