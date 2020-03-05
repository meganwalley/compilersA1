import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 *
 * @author megan
 */
public class assignmentOne {
    static String filename = "input.txt";
    
    public static void main (String[] args) {
        System.out.println("Reading data from file: " + filename);
        //System.out.println("All values given are with base index at zero");
        char[] file = readFile(filename);
        if (file == null) {
        System.out.println("Closing program.");
            return;
        }
        taskOne(file);
        taskTwo(file);
        taskThree(file);
        System.out.println("Closing program.");
    }
    
    /**
     * Reads file at FileName and returns everything as a char array.
     * @param fileName
     * @return 
     */
    public static char[] readFile(String fileName) {
        try {
            File f = new File(fileName);
            f.createNewFile();
            String data = "";
            data = new String(Files.readString(Paths.get(fileName)));
            // adding this in to ensure the last character's state is read correctly so I don't need to run a null loop or anything like that. @_@
            data += ".";
            return data.toCharArray();
        } catch (IOException exception) {
            System.out.println("Error: " + fileName + " cannot be read from. Exception generated: " + exception);
            return null;
        }
    }
    
    
    public static void taskOne(char[] file) {
        System.out.print("Task One: End positions of the pattern 'abab' found: [");
        boolean foundatleastone = false;
        // if all states are false, we are in "stateZero"
        boolean stateOne = false; // 'a' received
        boolean stateTwo = false; // 'ab' received
        boolean stateThree = false; // 'aba' received
        boolean stateFour = false; // 'abab' received
        for (int i = 0; i < file.length; ++i) {
            if (stateOne) {
                // if we read a b, set stateTwo to be true and stateOne to be false
                if (file[i] == 'b') {
                    stateTwo = true;
                    stateOne = false;
                } 
                // otherwise, if we read something that isn't an a, 
                // change our state back to stateZero
                else if (file[i] != 'a') {
                    stateOne = false;
                }
                // the only way for stateOne to remain true is if we read an a.
            } else if (stateTwo) {
                // if we read an a, set stateThree to be true and stateTwo to be false
                if (file[i] == 'a') {
                    stateThree = true;
                    stateTwo = false;
                } 
                // otherwise, if we read something that isn't a b, change
                // our state back to stateZero
                else {
                    stateTwo = false;
                }
                // there is no way to remain on stateTwo.
            } else if (stateThree) {
                // if we read a b, set stateFour to true and stateThree to be false
                if (file[i] == 'b') {
                    stateFour = true;
                    stateThree = false;
                }
                // if we read an a, set stateOne to be true and stateThree to be false
                else if (file[i] == 'a') {
                    stateOne = true;
                    stateThree = false;
                }
                // otherwise, if we read something not an a or a b, change our
                // state back to state zero
                else {
                    stateThree = false;
                }
                // there is no way to remain on stateThree.
            } else if (stateFour) {
                // YAY this is a special state because we hit our goal of 'abab'. Output a response. :)
                // in this case, we need to subtract one from i, because we don't read this state until we
                // are searching for a number because I felt weird having it being handled
                // while stateThree was true. :I Technically it would be fine if 
                // this wasn't indexed with zero... hrm. Will ask after class on 
                // Thursday.
                if (foundatleastone)
                    System.out.print(", ");
                System.out.print(i);
                foundatleastone = true;
                
                // if we read an a, go back to stateThree and set stateFour to be false.
                if (file[i] == 'a') {
                    stateThree = true;
                    stateFour = false;
                }
                // otherwise, go back to state zero.
                else {
                    stateFour = false;
                }
            } else { // stateZero, when all the other four states are false. :)
                // if we read an a, set stateOne to be true.
                if (file[i] == 'a') {
                    stateOne = true;
                }
                // otherwise, continue to read everything! :)
            }
        }
        System.out.print("]\n");
    }
    
    public static void taskTwo(char[] file) {
        System.out.print("Task Two: End positions of the sequence 'abc*cba' found: [");
        boolean foundatleastone = false;
        // if all states are false, we are in "stateZero"
        boolean stateOne = false; // 'a' received
        boolean stateTwo = false; // 'ab' received
        boolean stateThree = false; // 'abc' received, 'abc*' received
        boolean stateFour = false; // 'abc*c' received
        boolean stateFive = false; // 'abc*cb' received
        boolean stateSix = false; // 'abc*cba' received
        for (int i = 0; i < file.length; ++i) {
            if (stateOne) {
                // if we receive 'b', go to stateTwo
                if (file[i] == 'b') {
                    stateTwo = true;
                    stateOne = false;
                }
                // if we don't, go back to stateZero
                else if (file[i] != 'a')
                    stateOne = false;
                // if we receive 'a', stay here.
            } else if (stateTwo) {
                // if we receive 'a', go back to stateOne.
                if (file[i] == 'a') {
                    stateOne = true;
                    stateTwo = false;
                }
                // if we receive 'c', go to stateThree.
                else if (file[i] == 'c') {
                    stateThree = true;
                    stateTwo = false;
                }
                // otherwise, go back to stateZero
                else {
                    stateTwo = false;
                }
            } else if (stateThree) {
                // if we receive 'c', go to stateFour.
                if (file[i] == 'c') {
                    stateFour = true;
                    stateThree = false;
                }
                // if we don't, stay here. (do nothing.)
            } else if (stateFour) {
                // if we get a 'b', go to stateFive.
                if (file[i] == 'b') {
                    stateFive = true;
                    stateFour = false;
                }
                // if we get anything but a 'c' or a 'b', go back to stateThree
                else if (file[i] != 'c') {
                    stateThree = true;
                    stateFour = false;
                }
                // if we get a 'c', stay here. (do nothing)
            } else if (stateFive) {
                // if we get a 'a', go to stateSix
                if (file[i] == 'a') {
                    stateSix = true;
                    stateFive = false;
                }
                // otherwise, go back to stateThree
                else {
                    stateFive = false;
                    stateThree = true;
                }
            } else if (stateSix) {
                // yay we made it to our goal.
                if (foundatleastone)
                    System.out.print(", ");
                System.out.print(i);
                foundatleastone = true;
                // if we have a 'c', go to step four, otherwise go to step three.
                if (file[i]=='c') {
                    stateFour = true;
                    stateSix = false;
                } else {
                    stateThree = true;
                    stateSix = false;
                }
            } else { // stateZero, when all the other six states are false. :)
                // read 'a', set stateOne to true.
                if (file[i] == 'a') {
                    stateOne = true;
                }
                
            }
        }
            System.out.print("]\n");
    }
    
    
    public static void taskThree(char[] file) {
        System.out.print("Task Three: End positions of the sequences aa or abb found: [");
        boolean foundatleastone = false;
        // if all states are false, we are in "stateZero"
        boolean stateOne = false; // 'a' received
        boolean stateTwo = false; // 'aa' received
        boolean stateThree = false; // 'ab' received
        boolean stateFour = false; // 'abb' received
        for (int i = 0; i < file.length; ++i) {
            if (stateOne) {
                // if we read 'a', set state to stateTwo
                if (file[i] == 'a') {
                    stateTwo = true;
                    stateOne = false;
                }
                // if we read 'b', set state to stateThree
                else if (file[i] == 'b') {
                    stateThree = true;
                    stateOne = false;
                }
                // otherwise, go back to state zero
                 else {
                     stateOne = false;
                 }
            } else if (stateTwo) {
                // yay we made it to our goal and found an instance of 'aa'
                if (foundatleastone)
                    System.out.print(", ");
                System.out.print(i);
                foundatleastone = true;
                // if we read 'b', go to stateThree
                if (file[i] == 'b') {
                    stateThree = true;
                    stateTwo = false;
                }
                // if we read anything but 'a', go to stateZero
                else if (file[i] != 'a') {
                    stateTwo = false;
                }
                // if we read 'a', stay here.
            } else if (stateThree) {
                // if we read a 'b', go to stateFour
                if (file[i] == 'b') {
                    stateFour = true;
                    stateThree = false;
                }
                // if we read 'a', go to stateOne
                else if (file[i] == 'a') {
                    stateOne = true;
                    stateThree = false;
                }
                // otherwise, return to stateZero
                else {
                    stateThree = false;
                }
            } else if (stateFour) {
                // yay we made it to our goal and found an instance of 'abb'
                if (foundatleastone)
                    System.out.print(", ");
                System.out.print(i);
                foundatleastone = true;
                // if we read 'a', go to stateOne
                if (file[i] == 'a') {
                    stateOne = true;
                    stateFour = false;
                }
                // return to stateZero
                else {
                    stateFour = false;
                }

            } else { // stateZero, when states 1-4 are false. :)
                // read 'a', set stateOne to true.
                if (file[i] == 'a') {
                    stateOne = true;
                }
            }

        }
        System.out.print("]\n");
    }
}
