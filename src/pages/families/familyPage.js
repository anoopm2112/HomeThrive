import React, { useState } from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import FamilyTable from '~/components/Tables/FamilyTable'

function FamilyPage() {
  return (
    <AuthedLayout>
      <FamilyTable />
    </AuthedLayout>
  )
}

export default FamilyPage
