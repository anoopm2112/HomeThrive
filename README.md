# FosterShare

### Getting Started

NOTE: the `master` branch is empty. I am using the `main` branch

```
$ git clone https://jamierabbit@bitbucket.org/jackrabbit/web-fostershare.git
$ git checkout main
$ yarn install
// for Dev Environment
$ yarn dev

// for Prod
$ yarn build
$ yarn start
```

### Build Notes:

- Family and Children can currently have different agents. If you reassign one, it will NOT automatically re-assign the other.
- Events are sorted DESC by default. Meaning the most future event is listed first.
- There is no way currently to delete/manage Resource Categories. Once they are added. they will persist.
- There is no way to HARD delete users.
- On the API side "Messages" == "Notifications" (on web side), (API Side) "Notifications" == "Alerts" (on the web side), (api side) "Agents" == "Case Managers"
- Right now, the Event Participants Table will load up to 1000 participants for an event.
  This ensures that participants already marked as attending will appear so in the "Add Participants" dialog. If there are more than 1000 participants to an event.
  There is the possibility that you could invite a family twice.
- All copy currently exists in `/src/lib/assets/copy.js`. It is accessed through a "text" function found in `/src/lib/text.js`. This function can be adapted to serve the language needed.

### Dev Notes:

- The `AuthedLayout` passes the logged in `user` to its children component
- Most table components can be achieved using the "Generic Table" and its props in `/src/components/Tables/Generic/GenericTable.js`

### Known Issues

- [ ] The `Categories` Select on the `Create Resource` Dialog
  - [ ] Once `+ Add New` is selected, the input turns into a text field, and there is no way to cancel this mode unless you close the dialog.
  - [ ] There is currently no way to manage (delete or edit) the Resource Categories.
- [ ] Dev Environment inexplicably reloads occasionally.
- [ ] Updating a category on a Resource that was not created with any causes problems.
- [ ] It is possible to invite a participant to an event twice
