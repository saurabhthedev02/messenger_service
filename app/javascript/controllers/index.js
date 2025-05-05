// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { Application } from "@hotwired/stimulus"
import ReadController from "./read_controller"
import EmojiController from "./emoji_controller"
import TypingController from "./typing_controller"

eagerLoadControllersFrom("controllers", application)

window.Stimulus = Application.start()
Stimulus.register("read", ReadController)
application.register("emoji", EmojiController)
application.register("typing", TypingController)
