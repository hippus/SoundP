/*
    The sound file and effects data to play.
*/
public class SoundDescriptor
{
    /*
        The file name.
    */
    string fileName;
    
    /*
        The applicable effects list.
    */
    string effects[];
    
    /*
        Initialize fields.
    */
    public void init(string file, string effectsList[])
    {
        file => fileName;
        effectsList @=> effects;
    }
}