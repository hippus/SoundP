/*
    Plays the things set.
*/
public class Thing extends FileSoundSet
{
    PlayEvent playEvent;
    SoundDescriptor soundDescriptors[];
    
    /*
        Initialize with file set.
    */
    public void init(UGen ugen, string directory, string fileData[][])
    {
        // parse input data
        SoundDescriptor temp[fileData.cap()] @=> soundDescriptors;
        
        for(0 => int i; i < fileData.cap(); ++i)
        {
            // init sound descriptor
            SoundDescriptor sd;
            fileData[i][0] => sd.fileName;
            
            // init effects
            string e[fileData[i].cap() - 1];
            for (0 => int j; j < e.cap(); ++j)
            {
                fileData[i][j + 1] => e[j];
            }
            e @=> sd.effects;
            
            // save descriptor
            sd @=> soundDescriptors[i];
        }
        
        baseInit(ugen, directory, temp);
        
        // set base gain
        0.7 => master.gain;
    }
    
    /*
        Plays things.
    */
    public void run()
    {
        while(true)
        {
            // wait for some random interval
            Math.random2(20, 80)::second => dur wait;
            l.stringify(wait) => string soundDurationSeconds;
            l.log("Waiting " + soundDurationSeconds + " seconds for next thing...");
            wait => now;
            
            // choose file
            shuffle.next() => int index;
            data[index] @=> SoundDescriptor sd;
            loadFromFile(baseDir + sd.fileName) @=> SndBuf snd;
            
            // choose effect
            string effect;
            if (sd.effects.cap() > 1)
            {
                sd.effects[Math.random2(0, sd.effects.cap() - 1)] => effect;
            }
            else
            {
                sd.effects[0] => effect;
            }
    
            // the interval to wait event handlers
            5::second => dur handlerDuration;
            
            // log what is playing
            l.stringify(snd.length()) => soundDurationSeconds;
            l.log("Thing: " + sd.fileName + ", duration: " + soundDurationSeconds +", effect: " + effect);
            
            // raise before play event and wait until subscribers will process it
            handlerDuration => playEvent.interval;
            1 => playEvent.noteOn;
            playEvent.signal();
            handlerDuration => now;
            
            // wait a second on decreased gain
            1::second => now;
            
            // play
            Math.random2(-1, 1) => int side;
            Math.random2f(0.5, 1)*side => pan.pan;
            
            // apply effect
            if (effect == "back")
            {
                spork ~ back(snd);
            }
            else if (effect == "echo")
            {
                spork ~ echo(snd);
            }
            else if (effect == "robot")
            {
                spork ~ robot(snd);
            }
            else if (effect == "speedup")
            {
                spork ~ speedup(snd);
            }
            else if (effect == "slowdown")
            {
                spork ~ slowdown(snd);
            }
            else
            {
                spork ~ play(snd);
            }
            
                        
            // raise after play event and wait until subscribers will process it
            handlerDuration => playEvent.interval;
            0 => playEvent.noteOn;
            playEvent.signal();
            handlerDuration => now;
        }
    }
    
    /*
        Test sound effects.
    */
    public void test(SndBuf sound)
    {
        spork ~ play(sound);
        sound.samples()::samp => now;
        spork ~ back(sound);
        sound.samples()::samp => now;
        spork ~ echo(sound);
        (2 * sound.samples())::samp => now;
        spork ~ robot(sound);
        sound.samples()::samp => now;
        spork ~ speedup(sound);
        (4 * sound.samples())::samp => now;
        spork ~ slowdown(sound);
        (7 * sound.samples())::samp => now;
    }
            
    
    // Playback effects
    
    /*
        Play.
    */
    fun void play(SndBuf sound)
    {
        // setup sound chain
        getGain() @=> Gain mainGain;
        
        // setup sound chain
        sound => mainGain;
        
        // set position
        0 => sound.pos;
        // advance time
        sound.samples()::samp => now;
        
        // unset sound chain
        null @=> mainGain;
        null @=> sound;
    }
    
    /*
        Play backwards.
    */
    fun void back(SndBuf sound)
    {
        // setup sound chain
        getGain() @=> Gain mainGain;
		
        // setup sound chain
        sound => mainGain;
        
        // set rate
        -1 => sound.rate;
        // set position
        sound.samples() => sound.pos;
        // advance time
        sound.samples()::samp => now;
        // reset rate and position
        1 => sound.rate;
        sound.samples() => sound.pos;
        
        // unset sound chain
        null @=> mainGain;
        null @=>sound;
    }
    
    /*
        Emulate robotic voice.
    */
    fun void robot(SndBuf sound)
    {
        // setup sound chain
        getGain() @=> Gain mainGain;
        // leader
        sound => Gain g1 => DelayL d => mainGain;
        sound => Gain g2 => mainGain;
        // feedback
        d => Gain g3 => d;
        
        6 => mainGain.gain;

        // set parameters
        15::ms => d.delay;
        0.05 => g1.gain;
        0.05 => g2.gain;
        0.95 => g3.gain;

        // play
        0 => sound.pos;
        sound.samples()::samp => now;
        
        // unset sound chain
        null @=> g1;
        null @=> g2;
        null @=> mainGain;
        null @=> sound;
    }

    /*
        Add echo.
    */
    fun void echo(SndBuf sound)
    {
        // setup sound chain
        getGain() @=> Gain mainGain;
        
        // feedback
        sound => Gain gain => Gain feedback => DelayL delay => gain => mainGain;

        // set delay parameters
        .75::second => delay.max => delay.delay;
        // set feedback
        .4 => feedback.gain;
        // set effects mix
        .75 => delay.gain;

        // play
        0 => sound.pos;
        (2 * sound.samples())::samp => now;
        
        // unset sound chain
        null @=> mainGain;
        null @=> sound;
    }
    
    /*
        Repeat sound while slowing down.
    */
    fun void slowdown(SndBuf sound)
    {
        // setup sound chain
        getGain() @=> Gain mainGain;
        sound => JCRev reverb => mainGain;
        
        // set parameters
        .01 => reverb.mix;
        5 => int iterations;
        .1 => float step;
        
        // play
        for(0 => int i; i < iterations; ++i)
        {
            i * step => float fraction;
            (1 - fraction) => sound.rate;
            fraction => reverb.mix;
            0 => sound.pos;
            sound.samples()/iterations => int sampleIncrement;
            sound.samples()::samp + (sampleIncrement * i)::samp => now;
        }
        
        // advance more time
        2::second => now;
        
        // unset sound chain
        null @=> reverb;
        null @=> mainGain;
        null @=> sound;
    }

    /*
        Repeat sound while speeding up.
    */
    fun void speedup(SndBuf sound)
    {
        // setup sound chain
        getGain() @=> Gain mainGain;
        sound => JCRev reverb => mainGain;
        
        // set parameters
        .01 => reverb.mix;
        5 => int iterations;
        .1 => float step;
        
        // play
        for(0 => int i; i < iterations; ++i)
        {
            i * step => float fraction;
            (1 + fraction) => sound.rate;
            (1 + fraction) * reverb.mix() => reverb.mix;
            0 => sound.pos;
            sound.samples()/iterations => int sampleIncrement;
            sound.samples()::samp - (sampleIncrement * i)::samp => now;
        }
        
        // advance more time
        2::second => now;
        
        // unset sound chain
        null @=> reverb;
        null @=> mainGain;
        null @=> sound;
    }
    
    /*
        Initializes separate gain object.
    */
    fun Gain getGain()
    {
        Gain gain => dac;
        master.gain() => gain.gain;
        return gain;
    }
}
