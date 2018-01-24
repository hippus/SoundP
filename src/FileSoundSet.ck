
/*
    The randomly ordered file based sound set.
*/
public class FileSoundSet
{
    // the directory where files resides
    string baseDir;
    
    // the sound descriptors to process
    SoundDescriptor data[];
    
    // the scape indices 
    int indices[];
    
    // the thing gain and reverb
    Gain master => JCRev reverb => Pan2 pan;
    .01 => reverb.mix;
    
    // the shuffle controller
    ShuffleArray shuffle;
    
    // the log manager
    Logger l;
    
    /*
        Loads sound from file.
    */
    protected SndBuf loadFromFile(string path)
    {
        SndBuf snd;
        path => snd.read;
        snd.samples() => snd.pos;
        return snd;
    }
   
    /*
        Initialize with file set.
    */
    public void baseInit(UGen ugen, string directory, SoundDescriptor inputFiles[])
    {
        // init fields
        directory => baseDir;
        inputFiles @=> data;
        int tempidx[inputFiles.cap()] @=> indices;
        master => ugen;
        
        // init indices
        for(0 => int i; i < inputFiles.cap(); ++i)
        {
            i => indices[i];
        }
        
        // init shuffle processing
        shuffle.init(indices);
    }
}
