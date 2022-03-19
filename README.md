# CBL

**CBL is an open-source interactive productivity application for MacOSX** using Dear ImGui that provides a list of text copied to the clipboard and the ability to copy and delete text from the list. Additional additions will bring more features and functionality to the program.

## Usage

**CBL will grab all copied text and display** it in the main list along with a timestamp providing the date and time of the copy. Additional features include the ability to copy and delete entries in the list by right-clicking on the entry and selecting the appropriate option. Double-clicking on the entry will also copy the item to your current clipboard allowing for quick operations.

*Note that all text copied prior to running CBL will not appear in the list.*

Future iterations will include a history of copied text and automatically populate the list with text previously appending the the main list.

___

## Getting Started

In terminal, execute the following:

First, clone the repository

```
git clone --recursive https://github.com/brolgedu/cbl <destination path>/<folder name>
```

Next, you will need Homebrew to download and install GLFW and CMake  

Install Homebrew (*if Homebrew gets stuck, follow [this guide](https://github.com/Homebrew/discussions/discussions/622#discussioncomment-832848) and then reinstall Homebrew*):

  ```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
 ```

Then install GLFW and CMake using Homebrew:

```
brew install glfw
brew install cmake
```

Now build the project by running the following commands:

```
cd <path-to-CBL>
cmake ./ && cmake --build ./
```

Finally, run CBL:

```
cd bin/ && ./cbl
```
___

## Contact

Feel free to contact me with any questions or issues regarding the program, or any ideas you may have for features you would like to see added to CBL.
