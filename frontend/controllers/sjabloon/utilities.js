export function setCookie(days, name, value) {
  const expires = new Date(Date.now() + days * 864e5).toUTCString()
  const path    = "/"

  document.cookie = `${name}=${encodeURIComponent(value)}; expires=${expires}; path=${path}`
}

export function getCookie(name) {
  let cookie = {};

  document.cookie.split(";").forEach(function(el) {
    let [k, v]        = el.split("=");
    cookie[k.trim()] = v;
  })

  return cookie[name];
}

export function truncate(element, limit, after) {
  var trailing = element.length > limit ? after : ''

  return element.substring(0, limit) + trailing
}

