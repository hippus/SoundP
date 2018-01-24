
// Setup soundscapes
Soundscape scape;
scape.init(dac, 
    me.dir(-1) + "soundscape/", 
    [
        "ex-STE-000.wav",
        "ex-STE-001.wav",
        "ex-STE-002.wav",
        "ex-STE-003.wav",
        "ex-STE-004.wav",
        "ex-STE-005.wav",
        "ex-STE-006.wav",
        "ex-STE-007-a.wav",
        "ex-STE-007.wav",
        "ex-STE-008.wav",
        "ex-STE-009.wav",
        "ex-STE-010-a.wav",
        "ex-STE-010.wav",
        "ex-STE-011-1.wav",
        "ex-STE-011.wav",
        "ex-STE-012-a.wav",
        "ex-STE-012-b.wav",
        "ex-STE-012.wav",
        "ex-STE-013-a.wav",
        "ex-STE-013-b.wav",
        "ex-STE-013.wav",
        "ex-STE-014.wav",
        "ex-STE-015.wav",
        "ex-STE-016.wav",
        "ex-STE-020.wav",
        "ex-STE-021.wav",
        "ex-STE-023-a.wav",
        "ex-STE-023-b.wav",
        "ex-STE-023.wav",
        "ex-STE-024.wav",
        "ex-STE-025.wav",
        "ex-STE-026-a.wav",
        "ex-STE-026.wav"
    ]);

// Setup things
Thing thing;
thing.init(dac,
    me.dir(-1) + "thing/",
    [
        ["50kg.wav","back","echo","robot"],
        ["akty.wav","none","back","echo","robot","speedup","slowdown"],
        ["allo.wav","none","back","echo","robot","speedup"],
        ["apartamenty.wav","none","back","echo","speedup","slowdown"],
        ["beepbeep.wav","none","back","echo","speedup","slowdown"],
        ["buketik.wav","none","back","robot","speedup","slowdown"],
        ["dengi.wav","none","echo","speedup","slowdown"],
        ["dolma.wav","none","back","echo","speedup"],
        ["ebtvoyu.wav","echo","slowdown"],
        ["gruzchik.wav","none","back","echo","robot","speedup","slowdown"],
        ["hahaha.wav","none","echo","robot","speedup","slowdown"],
        ["hehehe.wav","none","back","echo","robot","speedup","slowdown"],
        ["hochesh.wav","echo","speedup","slowdown"],
        ["kartoshka.wav","none","back","echo","robot","speedup","slowdown"],
        ["laugh.wav","none","back","echo","speedup","slowdown"],
        ["mat.wav","none","echo","speedup","slowdown"],
        ["morkovochka.wav","none","back","echo","speedup","slowdown"],
        ["myaso.wav","none","back","echo","robot","speedup","slowdown"],
        ["nadereve.wav","none","back","echo","robot","speedup","slowdown"],
        ["naogorode.wav","none","back","echo","robot","speedup","slowdown"],
        ["negotovlu.wav","none","back","echo"],
        ["negovori.wav","none","back","echo","robot","speedup","slowdown"],
        ["nehochetsa.wav","none","back","echo","speedup","slowdown"],
        ["netakie.wav","none","back","echo","speedup","slowdown"],
        ["nezhaesh.wav","none","back","echo","speedup"],
        ["nichego.wav","none","back","echo","speedup","slowdown"],
        ["nuvottak.wav","none","back","echo","robot","speedup","slowdown"],
        ["ochko.wav","none","echo"],
        ["odnoitozhe.wav","none","back","echo","robot","speedup","slowdown"],
        ["ohuel.wav","none","echo"],
        ["oktyabr.wav","none","back","echo","speedup","slowdown"],
        ["papa.wav","echo","speedup","slowdown"],
        ["papam.wav","none","echo","speedup"],
        ["peretz.wav","none","back","echo","speedup","slowdown"],
        ["porosyatikuryat.wav","none","back","echo","robot","speedup","slowdown"],
        ["proizvodstvo.wav","none","echo"],
        ["razvekrupnaya.wav","none","echo","speedup","slowdown"],
        ["shekely.wav","none","back","echo","robot","speedup","slowdown"],
        ["sneeze.wav","none","back","echo","robot","speedup","slowdown"],
        ["sraboty.wav","none","echo","speedup","slowdown"],
        ["stakan.wav","none","echo","speedup","slowdown"],
        ["tantantan.wav","none","back","echo","robot","speedup"],
        ["ya-ya-ya.wav","none","echo","speedup"],
        ["zdorovya.wav","none","back","echo","speedup","slowdown"]
]);

// Setup drums
DrumMachine drums;
drums.init(dac,
    me.dir(-1) + "beat/",
    [
        ["hat01.wav","hat02.wav","hat03.wav","hat04.wav","hat05.wav","hat06.wav"],
        ["snare01.wav","snare02.wav","snare03.wav","snare04.wav","snare05.wav","snare06.wav"],
        ["kick01.wav","kick02.wav","kick03.wav","kick04.wav","kick05.wav","kick06.wav"]
    ]);

// Setup synth
GranularSynth synth;
synth.init(dac, 
    me.dir(-1) + "synth/", 
    [
        "akty.wav",
        "beepbeep.wav",
        "clack.wav",
        "dolma.wav",
        "door.wav",
        "hehehe.wav",
        "kartoshka.wav",
        "laugh.wav",
        "papa.wav",
        "papam.wav",
        "sneeze.wav",
        "tantantan.wav"
    ]);

/*
    Run soundscape sequence.
*/
fun void playScapes()
{
    scape.run();    
}
/*
    Run soundscape event listener shred.
*/
fun void listenPlayEvents(PlayEvent event)
{
    scape.listen(event);
}

/*
    Run thing sequence.
*/
fun void playThings()
{
    thing.run();    
}

/*
    Run drum machine.
*/
fun void playDrums()
{
    drums.run();
}

/*
    Run synth.
*/
fun void playSynth()
{
    synth.run();
}

spork ~ playScapes();
spork ~ listenPlayEvents(thing.playEvent);
spork ~ playThings();
spork ~ playDrums();
spork ~ playSynth();

while(true) 1::second => now;