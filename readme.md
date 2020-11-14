Application workflow:
1. The application checks for the network connection on opening the app.
2. If a network connection is available,
* and previously fetched data is not available in the database,
  - The app tries to fetch the data from the provided API, parse them, and store them in the database.
  - Then it gets the data from the database, sorts them first by ListId, and then by Name.
  - Then it creates a new TableModel List to display the data in Table View.
* and previously fetched data is available in the database,
  - The app tries to fetch the data from the provided API, parse them, and update the database.
  - Then it gets the data from the database, sorts them first by ListId, and then by Name.
  - Then it creates a new TableModel List to display the data in Table View.
3. If a network connection is not available,
* The app will check the database for the previously fetched data.
  - If previously fetched data is available, the app will sort the data by ListId and then by Name. It displays data in TableView. It also toasts a message: "No Internet".
  - If previously fetched data is not available, the app will simply toast a message "No Internet".

Improvements:

  * The app should display the data from the database on opening the app if previously fetched data is available in the database, and then try to fetch the new data from the API in the background. This can be achieved through different scenarios based on an application requirement. For example, an API service can provide only the updated data since the last fetched data or by comparing the previously fetched data with the new data. In any scenario, if an app is displaying critical data to the user without interfering with the current user's position, the app should display an action view to let the user know that new data is available and allow to update the view by clicking on the action view or by Pull-To-Refresh functionality.
