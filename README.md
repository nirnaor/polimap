# Polimap

Polimap is a Rails application that is showing a heatmap of Israel's politics.
### Parse votes file

In order to get everything running as quick as possible


```sh
$ bundle exec rake db:drop db:create db:migrate parse:votes
```
This command will parse the votes file, and will populate the DB with the right data.
