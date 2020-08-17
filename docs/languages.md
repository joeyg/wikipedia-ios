### Updating languages

Inside the main project, there's a `languages` target that is a Mac command line tool. You can edit the swift files used by this target (inside `Command Line Tools/Update Languages/`) to update the localization script. Once you make changes, you can build and run the localization target through the `Update Localizations` scheme to re-run localizations and verify the output. Once you're done making changes, you need to archive the `localization` target which should copy the binary to `scripts/localizations` where it will be run with every build. Commit the changes to the script and the updated binary to the repo.