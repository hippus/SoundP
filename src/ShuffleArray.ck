/*
    This class takes the array and sorts it in random order.
    It returns next array element and guarantees that all elements will be looped.
*/
public class ShuffleArray
{
    // the current element index
    0 => int index;
    
    // the internal data storage
    int data[];
   
    /*
        Sorts the array in random order.
    */
    private void shuffle()
    {
        (data.cap() - 1) => int currentIndex;
        int temp;
        int randomIndex;
        
        while(currentIndex != 0)
        {
            Math.random2(0, currentIndex) => randomIndex;
            currentIndex--;
            
            data[currentIndex] => temp;
            data[randomIndex] => data[currentIndex];
            temp => data[randomIndex];
        }
    }
    
    /*
        Initialize class with target array.
        Original array will leave unchanged.
    */
    public void init(int array[])
    {
        // re-initialize data
        int temp[array.cap()];
        
        // copy array to data
        for(0 => int i; i < array.cap(); ++i)
        {
            array[i] => temp[i];
        }
        
        temp @=> data;
        
        shuffle();
        
        // reset index
        0 => index;
    }
    
    /*
        Returns next element of random array.
    */
    public int next()
    {
        // get next element
        data[index] => int result;
        index++;
        
        // re-shuffle if necessary
        if (index == data.cap())
        {
            shuffle();
            0 => index;
        }
        
        return result;
    }
}