# GitHub Search Challenge

### Sample iPhone app that allows the user to search throughout GitHub and display users found along with their information.

#### Note: The project currently stubs sample JSON to avoid GitHub's rate limit of service calls, which causes the program to not be able to function appropriately. (To allow this app to use network calls, pass in "false" in the parameters of the service call inside of three functions in the GitHubViewModel: 
 1. getSearchResults
 2. getEntireUser
 3. getRepositories

**The workflow while stubbing:**

1. Type "Tom" in the search
2. Click on the second user, named "mojombo"

