public class DrumMachine
{
    120 => int beatChar;
    
    // the gains and reverb
    Gain master => JCRev reverb;
    .01 => reverb.mix;
    .5 => master.gain;
    
    Gain kickGain => master;
    .5 => kickGain.gain;
    
    Gain snareGain => master;
    .7 => snareGain.gain;
    
    Gain hatGain => master;
    .5 => hatGain.gain;
    
    // the log manager
    Logger l;
    
    // files to play
    SndBuf hats[];
    SndBuf snares[];
    SndBuf kicks[];
    
    // beat presets
    [
        [
            "x-x-x-xxxxx-x-x-x-x-x-xxxxx-x-x-",
            "----x-------x-------x-------x---",
            "----------x-----x---------x-----"
        ],
        [
            "x-x-x-x-xxx-x-x-x-x-x-xxx-x---x-",
            "----x-------x-------x-------x---",
            "x---------x-----x---------x-----"
        ],
        [
            "--x---x---x---x---x---x---x---x-",
            "----x-------x-------x-------x---",
            "x-------x-------x-------x-------"
        ],
        [
            "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-",
            "---x--------x-------x-------x---",
            "x------x--x-----x-x---x---x-----"
        ],
        [
            "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x",
            "----x-------x-------x-------x--",
            "x------x--x-----x------x--x----"
        ],
        [
            "x-x-x-xxx-x-x-x-x-x-x-x-x-x-x-x-",
            "----x----x----x-------x--x--x---",
            "x---------x-------x-------x-----"
        ],
        [
            "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-",
            "----x---------x-----x-------x---",
            "x---------x-------x----x--x-----"
        ],
        [
            "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-",
            "--------x-----x-----x-------x---",
            "x---x-----x-----x-----x---x-----"
        ],
        [
            "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-",
            "--x-x---x--xx-xx----x-x---x-x---",
            "x-----x---x-------x-----x-------"
        ],
        [
            "x-x-x-xxxxx-x-x-x-x-x-xxxxx-x-x-",
            "----x-------x-------x-------x---",
            "x-----x---------x-----x---x--x--"
        ],
        [
            "x-x-x-x-x-x-x-x-x-x-x-x-x---x-x-",
            "----x-------x-------x-------x---",
            "x--x---x-xx----xx-x----xxxx-----"
        ],
        [
            "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-",
            "----x-------x-------x-------x---",
            "x--x---x-xx----xx-x----xxxx-----"
        ],
        [
            "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-xx",
            "----x-------x-------x-------x---",
            "x------x-x-x---xx----------x----"
        ]        
    ] @=> string presets[][];

    
    /*
        Loads sound from file.
    */
    protected SndBuf loadFromFile(string path, Gain gain)
    {
        SndBuf snd;
        path => snd.read;
        snd.samples() => snd.pos;
        snd => gain;
        return snd;
    }
    
    /*
        Load file set.
    */
    private SndBuf[] getSounds(string directory, string files[], Gain gain)
    {
        SndBuf result[files.cap()];
        // load sounds
        for(0 => int i; i < files.cap(); ++i)
        {
            loadFromFile(directory + files[i], gain) @=> result[i];
        }
        
        return result;
    }
    
    /*
        Initialize with file sets.
    */
    public void init(UGen ugen, string directory, string files[][])
    {
        // init fields
        master => ugen;
        
        getSounds(directory, files[0], hatGain) @=> hats;
        getSounds(directory, files[1], snareGain) @=> snares;
        getSounds(directory, files[2], kickGain) @=> kicks;
    }
    
    /*
        Run beat
    */
    public void run()
    {
        while (true)
        {
            // wait for some random interval
            Math.random2(30, 90)::second => dur wait;
            l.stringify(wait) => string soundDurationSeconds;
            l.log("Waiting " + soundDurationSeconds + " seconds for next beat...");
            wait => now;
            
            // just some prime numbers
            43 => int minBeats;
            199 => int maxBeats;
            Math.random2(minBeats, maxBeats) => int totalBeats;
            
            // get preset index
            Math.random2(0, presets.cap() - 1) => int presetIndex;
            
            // play beat
            play(presetIndex, totalBeats);
        }
    }
    
    /*
        Test all beats.
    */
    public void test()
    {
        for(0 => int i; i < presets.cap(); ++i)
        {
            play(i, 100);
            1::second => now;
        }
    }

    /*
        Play beat.
    */
    fun void play(int presetIndex, int totalBeats)
    {
        // select instruments
        hats[Math.random2(0, hats.cap() - 1)] @=> SndBuf hat;
        snares[Math.random2(0, snares.cap() - 1)] @=> SndBuf snare;
        kicks[Math.random2(0, kicks.cap() - 1)] @=> SndBuf kick;
            
        // get preset
        presets[presetIndex] @=> string preset[];
            
        // set speed
        Math.random2(50, 200) => int speedMs;
            
        // log what is playing
        l.stringify((speedMs*totalBeats)::ms) => string soundDurationSeconds;
        l.log("Beat: " + presetIndex + ", duration: " + soundDurationSeconds);
            
        0 => int beat;
        preset[0] => string hatPattern;
        preset[1] => string snarePattern;
        preset[2] => string kickPattern;
            
        for(0 => int i; i < totalBeats; ++i)
        {
            Math.random2f(0.9, 1.1) => hat.rate;
            Math.random2f(0.9, 1.1) => snare.rate;
            Math.random2f(0.5, 0.7) => kick.rate;
                
            // process beats
            if (hatPattern.charAt(beat) == beatChar) 
            {
                0 => hat.pos;
            }
                
            if (snarePattern.charAt(beat) == beatChar) 
            {
                0 => snare.pos;
            }
                
            if (kickPattern.charAt(beat) == beatChar)
            {
                0 => kick.pos;
            }
                
            // advance time
            speedMs::ms => now;
                
            beat++;
            if (beat >= hatPattern.length())
            {
                0 => beat;
            }
        }
    }
}