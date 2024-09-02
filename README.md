


https://github.com/user-attachments/assets/e6f2fa21-81a8-4d1a-8326-96adbebab392


```markdown
# Project Overview

 This project is designed to create a unique video navigation experience using a matrix of `PageView`s.
 The application features a horizontal `PageView` that contains vertical `PageView`s within it.
 The horizontal `PageView` represents the main posts, and each of its pages contains a vertical `PageView`
 representing either the main video post or a series of replies and sub-replies.

## Implementation Details

### Structure

The core of the application is built around a matrix concept:

- **Main `PageView` (Horizontal Scroll):** This `PageView` represents the main posts. Users can horizontally
 scroll through these posts. Each page of this `PageView` contains another `PageView` that scrolls vertically.

- **Vertical `PageView`s:** Inside each horizontal page, there is a vertical `PageView`.
 The first vertical page is the main video post, and subsequent vertical pages represent sub-replies to that main post.

### `VideosMatrix`

The `VideosMatrix` is the backbone of this implementation. It is a list of lists, where each list represents a column in the matrix:

- **parentId** and **parentTitle:** These fields help track the relationship between videos. They are set to `null`
for the first vertical `PageView` (the main post).
  
- **videos:** This is the list of videos corresponding to that particular level in the matrix.
  
- **grandParentId:** This is used for back traversal,to remove previous columns when swiped left.

### Navigation Logic

To enhance navigation, another list named `previousVerticalPages` is used. This list keeps
 track of the index of the video whose child (or reply) is being viewed. It allows users to return to the appropriate
 parent video in the previous column without losing their place.

### Error Handling and UI

As the focus was primarily on implementing the core logic, error handling and UI design have not been addressed in this phase.
 These aspects can be implemented later if needed, as the current implementation is purely logic-based.


