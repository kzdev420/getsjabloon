/* eslint no-console:0 */

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("stylesheets/application.scss")

import "controllers"

// Images (jpg, jpeg, png) are imported  here.
// This will copy all static images under `frontend/images` to the output
// folder and reference them with the image_pack_tag helper in views
// (e.g <%= image_pack_tag 'hero.png' %>) or the `imagePath` JavaScript helper
// below.

const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

