# ota-staging-cn

Set up infrastructure for OTA in that cn-northwest-1 region.

## Making changes

This project uses [Dhall](https://github.com/dhall-lang/dhall-lang) which is compiled into json for Terraform to consume. When you edit a `.dhall` file, you can recreate the Terraform json with:

```
make generate-terraform-json
```

For you're change/plan/change/plan Terraform workflow, there's:

```
make plan
```

which will update the Terraform json and run `terraform plan`

## Adding files

When adding a new file for terraform resources written in dhall, add the file name to the `resourceFiles` array in `./terraform.dhall`, and it should be picked up and compiled with the next `make plan`

## License

This code is licensed under the Mozilla Public License 2.0, a copy of which can be found in this repository. All code is copyright 2018 HERE Europe B.V.
