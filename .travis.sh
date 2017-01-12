set -ev

case $SUITE in
chefspec)
  rspec
  ;;
lint)
  foodcritic --context --progress .
  rubocop --lint --display-style-guide --extra-details --display-cop-names
  ;;
*)
  rake kitchen:test[all,2,.kitchen.docker.yml]
  ;;
esac
