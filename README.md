# edmodo

Completed user stories:

 * [x] Required: Lis of assignments and due dates
 * [x] Required: List of submissions for assignments
 * [x] Required: Submissions details from students
 * [x] Optional: Pull down to refresh
 * [x] Optional: Infinite scroll
 * [x] Optional: Add new assignments page

 
Architecture: 
UI is done throught StoryBoard, MVVM pattern, protocol for passing data back from new assignment page. No third pary frameworks. Image loading is done asyc and cached. Url string is checked before adding image to make sure it is correct image for cell. Autolayout has consistent look through all phones and cell sizes are created dynamically incase labels need to be wrapped and create two lines. Warning message is displayed if there is no connection.


