---
sidebar_position: 1
---

# Wally Setup
Wally is typically used in a Rojo based workflow and is used to manage install packages from the [Wally Site](https://wally.run/).

## Prerequisites
- [Aftman](https://github.com/LPGhatguy/aftman?tab=readme-ov-file)
- [Rojo](https://rojo.space/docs/v7/getting-started/installation/)
- [Wally](https://wally.run/install/)

## Installation
### Step 1
After downloading / installing Aftman, Rojo, and Wally head over to LinkTracker's [wally page](https://wally.run/package/vyon/linktracker).

You should see a gray-ish box as seen here
![Step 1](/wally/1.png)
Click that box to copy the package install to your clipboard

### Step 2
Paste the package install text into the dependencies part of your `wally.toml` file and rename the package with an appropriate casing style.

![Step 2](/wally/2.png)

### Step 3
Run the command
`wally install`

### Step 4
If you haven't already make sure to add the Packages folder into your `default.project.json` like this
![Step 3](/wally/3.png)

**Example code:**
```json
"Packages": {
	"$path": "Packages"
}
```