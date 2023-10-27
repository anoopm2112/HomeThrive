const rules = {
  name: 'regular',
  address: 'regular',
  city: 'regular',
  state: 'alpha|max:2',
  zip: 'digits:5',
  license: 'alpha_num',
  pocFirstName: 'regular',
  pocLastName: 'regular',
  pocEmail: 'email',
  pocTitle: 'regular',
  pocPhone: 'phone',
}

export default rules
