import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()
window.App ||= {}
window.App.cable = consumer

export default consumer
