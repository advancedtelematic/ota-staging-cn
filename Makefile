DOCKER_RUN := \
  docker run -i --rm -v ${CURDIR}:/data --entrypoint=dhall-to-json advancedtelematic/dhall-json --omitNull --pretty

DOCKER_RUN_DEBUG := \
  ${DOCKER_RUN} --explain

test:
	cat ./output.dhall | $(DOCKER_RUN_DEBUG)

print-terraform-json:
	cat ./terraform.dhall | $(DOCKER_RUN)

generate-terraform-json: print-terraform-json
	cat ./terraform.dhall | $(DOCKER_RUN) | tr -d '\r' > output.tf.json

plan: generate-terraform-json
	./bin/terraform plan
