# list all apps
#curl -H "Authorization: $BITRISE_TOKEN" -X GET "https://api.bitrise.io/v0.1/apps?sort_by=last_build_at" -H  "accept: application/json"

# trigger a build
APP_SLUG=f77e73c21d5d1a53
curl -X POST -H "Authorization: $BITRISE_TOKEN" "https://api.bitrise.io/v0.1/apps/$APP_SLUG/builds" -d \
  '{
	"hook_info": {
		"type": "bitrise"
	},
	"build_params": {
		"branch": "master"
	}
   }'


#curl -X POST -H "Authorization: $BITRISE_TOKEN" "https://api.bitrise.io/v0.1/apps/$APP_SLUG/bitrise.yml" -d '@/Users/rpappalax/git/demo-bitrise/bitrise.yml'
