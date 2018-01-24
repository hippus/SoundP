/*
    Smoothly increase or decrease gain of the given UGen.
*/
public class SmoothGain
{
    float _minGain;
    float _maxGain;
    float _step;
    UGen _ugen;
    
    /*
        Initialize required parameters.
    */
    public void init(UGen ugen, float minGain, float maxGain, float step)
    {
        ugen @=> _ugen;
        minGain => _minGain;
        maxGain => _maxGain;
        step => _step;
    }
    
    /*
        Increase from min gain to max gain by given time seconds.
    */
    public void increase(float seconds)
    {
        // use actual gain as min gain 
        _ugen.gain() => float minGain;
        
        seconds / _step => float totalSteps;
        (_maxGain - minGain) / totalSteps => float gainIncrement;

        for(0 => int i; i < totalSteps; ++i)
        {
            _ugen.gain() + gainIncrement => _ugen.gain;
            _step::second => now;
        }
    }
    
    /*
        Decrease from max gain to min gain by given time seconds.
    */
    public void decrease(float seconds)
    {
        // use actual gain as max gain
        _ugen.gain() => float maxGain;
        
        seconds / _step => float totalSteps;
        (maxGain - _minGain) / totalSteps => float gainIncrement;

        for(0 => int i; i < totalSteps; ++i)
        {
            _ugen.gain() - gainIncrement => _ugen.gain;
            _step::second => now;
        }
    }
}
