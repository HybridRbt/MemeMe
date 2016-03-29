# MemeMe
Source code for Udacity iOS developer nanodegree project 2

#### App Spec for P2.1
[Full Description P2.1]
##### MemeMe 1.0 - The Meme Editor
MemeMe 1.0 is a meme-generating app that enables a user to attach a caption to a picture from their phone. After adding text to an image chosen from the Photo Album or Camera, the user can share it with friends.

##### User Flow
When the user first launches the app the Meme Editor View will appear.
In the Meme Editor View, when the user clicks on the “Album” button, an Image Picker is presented, making it possible to choose an image from the Photo Album. If there is a camera available on the device, pressing the camera button launches the camera, and a newly snapped photo can be chosen for the meme. If a camera is not available on the device, the camera button is disabled.

After an image is chosen, the image picker is dismissed, allowing text to be entered into the top and bottom text fields of the editor. When a user clicks inside one of the text fields, the default text disappears and the keyboard slides up. When the user finishes entering text and presses return, the keyboard is dismissed and the new meme is displayed.

When the user presses the “Cancel” button, the Meme Editor View returns to its launch state, displaying no image and default text.
When the user presses the share button, Apple’s stock Activity View appears, displaying several options for sharing the meme. After an option is chosen, the Activity View is dismissed and the Meme Editor View is visible again.

#### [Grading Rubric P2.1]

#### App Spec for P2.2
[Full Description P2.2]

##### MemeMe 2.0 - With Collection/Table View
MemeMe 2.0 is a meme-generating app that enables a user to attach a caption to a picture from their phone. After adding text to an image chosen from the Photo Album or Camera, the user can share it with friends. MemeMe also temporarily stores sent memes which users can browse in a table or a grid.

The app has three pages of content:
* Meme Editor View: Enables a user to add text to an image and share it. 
* Sent Memes View: Enables a user to browse sent memes in a table or a grid.
* Meme Detail View: Displays an image of a sent meme

The three pages are described in detail below.

###### Meme Editor View

The same as MemeMe 1.0.

###### Sent Memes View

The sent memes view displays recently sent memes. It has a bottom toolbar with tabs that allow the user to toggle between viewing sent memes in a table and viewing them in a grid. The top navigation bar has a title that reads “Sent Memes” and an add button in the right corner displaying Apple’s stock “Add” icon.
If the user taps the “table” tab on the left of the bottom toolbar, sent memes are displayed in a table. If the user taps on the “collection” tab on the right of the bottom toolbar, sent memes are displayed in a grid. Selecting a meme from the table or collection presents the Meme Detail View. Pressing the “add” button brings up the Meme Editor View.  

###### Meme Detail View

The Meme Detail View displays the selected meme in an image view in the center of the page with the meme’s original aspect ratio. The detail view has a back arrow in the top left corner. To the right of the arrow reads the title of the previous view, “Sent Memes.”

##### User Flow

When the user first launches the app the Sent Memes View will appear. It will be the root view of the navigation stack. When the user taps the + button in the top right corner the app should push the Meme Editor View on top of the Sent Memes View.

In the Meme Editor View, when the user clicks on the “Album” button, an Image Picker is presented, making it possible to choose an image from the Photo Album. If there is a camera available on the device, pressing the camera button launches the camera, and a newly snapped photo can be chosen for the meme. If a camera is not available on the device, the camera button is disabled.

After an image is chosen, the image picker is dismissed, allowing text to be entered into the top and bottom text fields of the editor. When a user clicks inside one of the text fields, the default text disappears and the keyboard slides up. When the user finishes entering text and presses return, the keyboard is dismissed and the new meme is displayed.

When the user presses the share button, Apple’s stock Activity View appears, displaying several options for sharing the meme. After an option is chosen, the Activity View is dismissed and the Sent Memes View appears. The Sent Memes View also appears upon pressing the “Cancel” button.

Selecting a meme from the table or collection presents the Meme Detail View. Clicking on the  back arrow of the Meme Detail View presents the previous Sent Memes View, either the table or collection.  

#### [Grading Rubric P2.2]

[Full Description P2.1]: <https://docs.google.com/document/d/1bt-SoB1GgqLebcT2mtE6hglkByzlxrobR5eHFMGPcTg/pub?embedded=true>
[Full Description P2.2]:
<https://docs.google.com/document/d/1G2onkzN_weWmiYErhQJw1lB9-zxM-2TQ0N5bNMAaI7I/pub?embedded=true>
[Grading Rubric P2.1]: <https://docs.google.com/document/d/1IcagLTEjCHMGMsLcroOWtNtXnIL0ySkAk8R2XfKk2t0/pub?embedded=true>
[Grading Rubric P2.2]: <https://docs.google.com/document/d/1ni0X5sjS0NreQqBHJpg8Z0foAYwegfGTPPdBKTPskPI/pub?embedded=true>
