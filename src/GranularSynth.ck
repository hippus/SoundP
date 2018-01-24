/*
    Simple granular synth.
*/
public class GranularSynth extends FileSoundSet
{
    // setup 
    .1 => reverb.mix;
    .5 => master.gain;
    
    /*
        Initialize with file set.
    */
    public void init(UGen ugen, string directory, string inputFiles[])
    {
        SoundDescriptor soundDescriptors[inputFiles.cap()];
        
        for(0 => int i; i < inputFiles.cap(); ++i)
        {
            // init sound descriptor
            SoundDescriptor sd;
            inputFiles[i] => sd.fileName;
            
            // save descriptor
            sd @=> soundDescriptors[i];
        }
        
        baseInit(ugen, directory, soundDescriptors);
    }

    /*
        Split sound and play random segment.
    */
    private void granularize(SndBuf snd, dur duration)
    {
        now + duration => time stop;
        snd => Pan2 pan => master;
        while (now < stop)
        {
            // set pan
            Math.random2f(-1, 1) => pan.pan;
            
            // set segment size
            Math.random2(70, 100) => int segments;
            
            // set grain size
            snd.samples()/segments => int grain;
            
            // set position
            Math.random2(0, snd.samples() - grain) + grain => snd.pos;
            
            // play
            grain::samp => now;
            
            // reset position
            0 => snd.pos;
        }
        
        // dispose
        null @=> pan;
        null @=> snd;
    }
    
    /*
        Plays soundscapes.
    */
    public void run()
    {
        while(true)
        {
            // wait for some random interval
            Math.random2(23, 71)::second => dur wait;
            l.stringify(wait) => string soundDurationSeconds;
            l.log("Waiting " + soundDurationSeconds + " seconds for next synth...");
            wait => now;
            
            // choose file
            shuffle.next() => int index;
            data[index] @=> SoundDescriptor sd;
            loadFromFile(baseDir + sd.fileName) @=> SndBuf snd;
            
            // set duration
            Math.random2(7, 29) => int seconds;
            
            // log what is playing
            l.log("Granular synth: " + sd.fileName + ", duration: " + seconds + " seconds");
            
            // play
            spork ~granularize(snd, seconds::second);
        }
    }
}