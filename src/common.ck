// common functions


/*
    The simple log manager.
*/
public class Logger 
{
    // The flag indicating whether the logging is enabled.
    1 => static int enabled;
    
    /*
        Log the message.
    */
    fun static void log(string message)
    {
        if (enabled > 0)
        {
            <<< message >>>;
        }
    }
    
    /*
        Get duration in seconds as string.
    */
    fun static string stringify(dur d) {
        return "" + ((d / (1::second))) + " seconds";
    }
}
    