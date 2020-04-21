    import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "" ]

  def connect() {
  }

<% for function in functions %>
  <%= function %> () {
  }
<% end %>
}

