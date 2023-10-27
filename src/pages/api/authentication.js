/**
 * __      _____ ___
 * \ \    / /_ _| _ \
 *  \ \/\/ / | ||  _/
 *   \_/\_/ |___|_|
 *
 * 02.08.21 - goal here is to use one unified Amiplify configured
 * instance for all login information
 */
import Amplify, { Auth } from 'aws-amplify'
import { config } from '~/lib/amplifyAuth'
Amplify.configure(config)

export default async function login(req, res) {
  if (req.method === 'POST') {
    try {
      const { email, password } = req.body
      const user = await Auth.signIn(email, password)
      // console.log('user', user)
      res.send({ success: true, data: user, message: 'Login successful' })
    } catch (err) {
      // this is the code give by Amplify
      if (
        err.code === 'NotAuthorizedException' ||
        err.code === 'UserNotFoundException'
      ) {
        res
          .status(401)
          .send({ success: false, message: 'Incorrect email or password' })
      } else {
        console.log(err)
        res.status(500).send(err)
      }
    }
  } else {
    res.status(400).send('must POST to login route')
  }
}
