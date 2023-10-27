import axios from 'axios'
import { getMetadata } from 'page-metadata-parser'
import domino from 'domino'

export default async (req, res) => {
  const { url } = req.query
  const response = await axios.get(url, {
    headers: {
      'Content-Type': 'text/html',
    },
  })
  const doc = domino.createWindow(response.data).document
  const metadata = getMetadata(doc, url)
  // const cleaned = removeScriptTags(response.data)
  res.send({ metadata, html: response.data })
}

function removeScriptTags(html) {
  return html.replace(/<script[^>]*>(?:(?!<\/script>)[^])*<\/script>/g, '')
}
