# Cloud Foundry Node.js Oracle Buildpack by DDM

Forked from [nodejs-oracledb-buildpack](https://github.com/antonmc/nodejs-oracledb-buildpack)

A Cloud Foundry [buildpack](http://docs.cloudfoundry.org/buildpacks/) for Node based apps.

This is based on the [Heroku buildpack](https://github.com/heroku/heroku-buildpack-nodejs).

Additional documentation can be found at the [CloudFoundry.org](http://docs.cloudfoundry.org/buildpacks/node/index.html).

### How to use it

Run `bluemix api https://api.bluemixitg.staging.echonet`
Install [CloudFoundry CLI](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html)
Run `cf login -u YOUR_UID -p YOUR_PASSWORD`
Specify your node version in package.json of your application

```
{
  'engines':
    'node': 6.10.3,
    'npm': 3.10.3
}
```
:warning: Available node versions in this buildpacks 4.8.2, 4.8.3, 6.10.2, 6.10.3, 7.9.0, 7.10.0, 8.0.0
Run 'cf push your_app -b https://github.com/theodo/nodejs-oracledb-buildpack.git'
