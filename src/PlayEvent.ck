/*
    The event to sync playing shreds.
*/
public class PlayEvent extends Event
{
    /*
        The flag indicating whether sound will play or stop.
    */
    0 => int noteOn;
    
    /*
        The interval remaining before sound will play or stop.
    */
    dur interval;
}