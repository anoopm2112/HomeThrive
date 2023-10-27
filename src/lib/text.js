import * as C from '~/lib/assets/copy'

/**
 * A function that will grab the desired text,
 * and translate it if needed.
 *
 * @param {*} selector
 * @returns
 */
function text(selector) {
  // return '******'
  if (C[selector]) return C[selector]
  else return '********' // this will make it easy to find.
}

export default text
