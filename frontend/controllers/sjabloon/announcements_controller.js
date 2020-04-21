import { Controller } from "stimulus"
import { truncate } from "./utilities.js"

export default class extends Controller {
  static targets = [ "button", "container" ]

  showDropdown() {
    if (this.open === 'true') return

    this.loadItems(event)
  }

  hideDropdown(event) {
    if ((this.open === 'true') && (this.element.contains(event.target) === false)) {
      this.containerTarget.remove()

      this.data.set('open', false)
    }
  }

  loadItems() {
    this.buttonTarget.insertAdjacentHTML('beforeend',
      `<div class="absolute top-0 right-0 mt-6 w-auto max-w-sm whitespace-no-wrap bg-white shadow-xl rounded slideUp z-20" data-target="sjabloon--announcements.container"><span class="block p-2 text-gray-600">Loading…</span></div>`);

    var html = ''
    fetch(this.data.get('data-url'))
      .then( data => {
        return data.json()
      }).then( announcements => {
        var html = ""

        announcements.forEach((json) => {
          html += this.itemTemplate(json)
        })

        this.containerTarget.innerHTML = html
        this.containerTarget.insertAdjacentHTML('beforeend', this.templateFooter())
        this.containerTarget.insertAdjacentHTML('afterbegin', this.templateHeader())

        this.data.set('open', true)
      })
  }

  itemTemplate(item) {
    return `
      <a href=${this.data.get('url')}#announcement_${item.id} class='block w-full py-2 border-t border-gray-200 cursor-pointer first:border-t-0 hover:bg-gray-100'>
        <header class='flex items-center px-2 leading-tight'>
          <span class='announcement__type announcement__type--${item.announcement_type} mb-0 static'>${item.announcement_type}</span>

          <h4 class='ml-2 text-sm font-semibold text-gray-700 truncate'>
            ${item.title}
          </h4>
        </header>

        <p class='py-1 px-3 text-left text-sm text-gray-600 whitespace-normal'>
          ${truncate(item.body, 70, '…')}
        </p>
      </a>
    `
  }

  templateHeader() {
    return `
      <p class='block w-full py-2 text-sm font-semibold text-gray-700 rounded-t'>Announcements</p>
    `
  }

  templateFooter() {
    return `
      <a href='${this.data.get('url')}' class='block w-full py-1 text-sm text-gray-500 bg-gray-100 border-t border-gray-200 rounded-b hover:text-gray-600'>View all announcements</a>
    `
  }

  get open() {
    return this.data.get('open')
  }
}

