$(document).ready(() => {
  $(document.body).on('ajax:error', (e) => {
    const [,, xhr] = event.detail

    if (xhr.status < 500) {
      return
    }

    window.location = '/500'
  })
})
