DOCKER_RUN := \
  docker run -i --rm -v ${CURDIR}:/data --entrypoint=dhall-to-json advancedtelematic/dhall-json --omitNull --pretty

DOCKER_RUN_DEBUG := \
  ${DOCKER_RUN} --explain

print-terraform-json:
	cat ./terraform.dhall | $(DOCKER_RUN)

generate-terraform-json: print-terraform-json
	cat ./terraform.dhall | $(DOCKER_RUN) | tr -d '\r' > output.tf.json
