## 1.2.1
- Slight code cleanup for the main package
- Added analytics example (pretty much the same as the creator-code example.)
- Changed `link-tracker` -> `linktracker` for ease of access

## 1.2.0
- Updated the examples to always use the latest version of LinkTracker
- Fixed temporary links not being transferable between studio and in game
- Added dev directory (mostly for testing & is not included in any of the built versions of the package)
- Added `build.project.json` to fix problem with the `LinkTracker.rbxm` in releases not including packages
- Updated LinkTracker to be compatible with both the studio build and the wally build
- Fixed broken lint job
- Updated `release.yaml` to use the new `build.project.json` and renaming the extracted folder from `Examples.zip` from "releases" -> "examples"

## 1.1.0
- Updated the PromoCode, CreatorCode, and InviteTester examples.
- Updated LinkTracker docs to be more clear
  - Modified intro page / about
  - Added known problems page
  - Added installation guide(s)
- Added changelog to doc page
- Added git workflow to build & update examples
  - Added release.yaml
- Removed `serve.project.json`