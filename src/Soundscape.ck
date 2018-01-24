/*
    Plays the soundscape set.
*/
public class Soundscape extends FileSoundSet
{
    // setup reverb
    .1 => reverb.mix;
    
    // setup noise control
    Noise noise => Gain noiseGain;
    .05 => noiseGain.gain;
    0 => noise.gain;
    SmoothGain noiseController;
    
    // main gain cotrol
    SmoothGain masterController;
    
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
        
        // init master gain control
        masterController.init(master, .2, .4, .1);
        .8 => master.gain;
        
        // init noise processing
        noiseGain => master;
        noiseController.init(noise, 0, .4, .1);
    }
    
    /*
        Plays soundscapes.
    */
    public void run()
    {
        while(true)
        {
            // choose file
            shuffle.next() => int index;
            data[index] @=> SoundDescriptor sd;
            loadFromFile(baseDir + sd.fileName) @=> SndBuf snd;
            snd => master;
            
            // log what is playing
            l.stringify(snd.length()) => string soundDurationSeconds;
            l.log("Soundscape: " + sd.fileName + ", duration: " + soundDurationSeconds);
            
            // setup switching between sounds
            5 => int switchSeconds;
            snd.samples()::samp - switchSeconds::second => dur duration;
            
            // play
            0 => snd.pos;
            if (noise.gain() > 0){
                noiseController.decrease(switchSeconds);
                duration - switchSeconds::second => duration;
            }
            duration => now;
            
            // add noise
            noiseController.increase(switchSeconds);
            
            // stop sound
            snd.samples() => snd.pos;
            
            // dispose
            null @=> snd;
            
            // wait a bit
            Math.random2(1, 3)::second => now;
        }
    }
    
    /*
        Listens to play events.
    */
    public void listen(PlayEvent event)
    {
        while(true)
        {
            // get the data
            event => now;
            
            // process event
            if (event.noteOn > 0)
            {
                masterController.decrease((event.interval/(1::second)));
                
            }
            else 
            {
                masterController.increase((event.interval/(1::second)));
            }
        }
    }
}
