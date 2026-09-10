--[[
Readable-variable rename pass
- Obfuscated local variable/function names were renamed.
- Roblox API names, instance names, string literals, and comments were preserved.
- Runtime logic was otherwise left unchanged.
]]
--[[
627445/974331
obfuscated — UI methods preserved
]]
local bit32=bit32 or bit

local xorKey={178,6,192,237,99,138,82,145,22,153,134,187,56,235,115,50}
local encodedStrings={{255,55},{255,52},{255,53},{231,117,165,159,42,228,34,228,98,202,227,201,78,130,16,87},{225,101,178,136,6,228,21,228,127},{220,99,184,129,10,232},{241,105,178,136,36,255,59},{241,115,179,153,12,231,17,228,100,234,233,201,127,158,26},{244,116,161,128,6},{241,115,178,158,12,248,16,254,110},{244,105,172,137,6,248},{252,105,180,132,5,227,49,240,98,240,233,213,126,132,31,86,215,116},{230,113,165,136,13,217,55,227,96,240,229,222},{146,38,2,90,67,170},{252,105,180,132,5,227,49,240,98,240,233,213},{231,79,147,153,17,229,57,244},{243,101,163,136,13,254,30,248,120,252},{230,99,184,153,47,235,48,244,122},{230,99,184,153,48,239,32,231,127,250,227},{251,107,161,138,6,198,51,243,115,245},{225,101,178,130,15,230,59,255,113,223,244,218,85,142},{231,79,140,132,16,254,30,240,111,246,243,207},{231,79,144,140,7,238,59,255,113},{255,103,169,131,37,248,51,252,115},{253,115,180,129,10,228,55,220,119,240,232,253,74,138,30,87,131},{192,100,184,140,16,249,55,229,127,253,188,148,23,217,70,11,128,53,246,223,80,189,99},{253,115,180,129,10,228,55,220,119,240,232,253,74,138,30,87,128},{241,105,174,153,2,227,60,244,100,209,233,215,92,142,1,116,192,103,173,136},{230,103,162,165,12,230,54,244,100,223,244,218,85,142},{230,103,162,165,12,230,54,244,100,223,244,218,85,142,63,83,203,105,181,153},{230,103,162,165,12,230,54,244,100,223,244,218,85,142,35,83,214,98,169,131,4},{230,105,176,175,2,248},{230,105,176,175,2,248,6,248,98,245,227},{230,105,176,175,2,248,30,248,120,252},{254,111,167,133,23,227,60,246},{228,103,172,134,54,195,16,253,99,235},{240,106,181,159,38,236,52,244,117,237},{247,126,165,142,22,254,61,227,66,246,225,220,84,142,38,123},{230,99,184,153,33,255,38,229,121,247},{230,105,167,138,15,239,20,227,119,244,227},{230,105,167,138,15,239},{254,105,175,134},{237,82,161,143,33,254,60},{230,105,176,161,10,228,55},{253,115,180,129,10,228,55},{237,78,175,129,7,239,32,160},{237,78,175,129,7,239,32,163},{225,99,163,153,10,229,60},{255,115,172,153,10,217,55,242,98,240,233,213},{225,99,163,153,10,229,60,222,99,237,234,210,86,142,65},{225,99,163,153,10,229,60,222,99,237,234,210,86,142,66},{225,99,163,153,10,229,60,197,127,237,234,222,126,153,18,95,215},{225,99,163,153,10,229,60,197,127,237,234,222},{225,99,163,153,10,229,60,216,98,252,235,243,87,135,23,87,192,64,178,140,14,239},{240,105,184},{241,110,165,142,8},{240,115,180,153,12,228},{240,115,180,153,12,228,29,228,98,245,239,213,93,218},{240,115,180,153,12,228,29,228,98,245,239,213,93,217},{225,106,169,137,6,248,16,240,100},{225,106,169,137,6,248,20,248,122,245},{225,106,169,137,6,248,6,248,98,245,227},{225,106,169,137,6,248,4,240,122,236,227},{193},{151,40},{212},{230,99,184,153,33,229,42},{251,104,176,152,23},{251,104,176,152,23,222,59,229,122,252},{251,104,176,152,23,200,61,233},{193,114,178,132,13,237},{246,116,175,157,7,229,37,255},{246,116,175,157,7,229,37,255,66,240,242,215,93},{246,116,175,157,7,229,37,255,80,235,231,214,93},{246,116,175,157,7,229,37,255,66,252,254,207},{156,40,238},{246,116,175,157,7,229,37,255,87,235,244,212,79},{218,114,180,157,89,165,125,230,97,238,168,201,87,137,31,93,202,40,163,130,14,165,51,226,101,252,242,148,7,130,23,15,132,54,243,220,83,179,99,161,38,173},{246,116,175,157,7,229,37,255,94,246,234,223,93,153,53,64,211,107,165},{246,116,175,157,7,229,37,255,94,246,234,223,93,153},{251,114,165,128},{146},{251,114,165,128,55,239,42,229},{254,103,162,136,15},{226,103,167,136,60},{243,100,179,130,15,255,38,244,85,246,232,207,93,133,7,97,219,124,165},{146,38},{251,104,180,159,12,198,23,199,93},{254,67,150,166},{226,106,161,148,6,248,33},{224,115,174,190,6,248,36,248,117,252},{229,105,178,134,16,250,51,242,115},{250,114,180,157,48,239,32,231,127,250,227},{224,99,176,129,10,233,51,229,115,253,213,207,87,153,18,85,215},{230,99,161,128,42,206},{251,104,179,153,2,228,49,244},{226,106,161,148,6,248},{244,105,178,142,6,204,59,244,122,253},{250,115,173,140,13,229,59,245,68,246,233,207,104,138,1,70},{243,114,180,140,0,226,63,244,120,237},{251,107,173,152,13,239},{251,104,182,132,13,233,59,243,122,252},{251,117,137,128,14,255,60,244},{250,115,173,140,13,229,59,245},{224,99,166,129,6,233,38,248,120,254},{251,117,146,136,5,230,55,242,98,240,232,220},{240,115,172,129,6,254,0,244,112,245,227,216,76},{224,99,166,129,6,233,38},{246,99,166,129,6,233,38,248,120,254},{226,103,178,159,26,227,60,246},{198,116,181,136},{230,105,175,129},{217,103,180,140,13,235},{192,99,166,129,6,233,38},{214,99,166,129,6,233,38},{194,103,178,159,26},{208,106,175,142,8},{220,115,173,143,6,248},{218,99,161,137},{211,106,172,205,20,235,62,253,101},{196,116},{246,103,178,134,67,217,57,232},{225,109,185,143,12,242,7,225},{192,100,184,140,16,249,55,229,127,253,188,148,23,222,68,2,135,51,245,212,81,179},{225,109,185,143,12,242,0,229},{192,100,184,140,16,249,55,229,127,253,188,148,23,222,68,2,135,51,245,213,91,184},{225,109,185,143,12,242,22,255},{192,100,184,140,16,249,55,229,127,253,188,148,23,222,68,2,135,51,245,212,85,190},{225,109,185,143,12,242,20,229},{192,100,184,140,16,249,55,229,127,253,188,148,23,222,68,2,135,51,245,213,83,186},{225,109,185,143,12,242,30,247},{192,100,184,140,16,249,55,229,127,253,188,148,23,222,68,2,135,51,245,213,87,186},{225,109,185,143,12,242,16,250},{192,100,184,140,16,249,55,229,127,253,188,148,23,222,68,2,135,51,245,218,80,188},{228,103,176,130,17,253,51,231,115},{192,100,184,140,16,249,55,229,127,253,188,148,23,218,71,3,133,50,249,217,85,190,97},{192,100,184,140,16,249,55,229,127,253,188,148,23,218,71,3,133,50,249,217,87,179,107},{192,100,184,140,16,249,55,229,127,253,188,148,23,218,71,3,133,50,249,217,87,186,96},{192,100,184,140,16,249,55,229,127,253,188,148,23,218,71,3,133,50,249,217,81,191,97},{192,100,184,140,16,249,55,229,127,253,188,148,23,218,71,3,133,50,249,217,83,185,98},{192,100,184,140,16,249,55,229,127,253,188,148,23,218,71,3,133,50,249,217,82,190,100},{254,103,171,136,67,217,57,232},{192,100,184,140,16,249,55,229,127,253,188,148,23,221,75,0,129,51,243,220,84,190,100},{192,100,184,140,16,249,55,229,127,253,188,148,23,221,75,0,129,51,242,213,86,185,97},{225,115,174,185,6,242,38,228,100,252,207,223},{192,100,184,140,16,249,55,229,127,253,188,148,23,222,64,11,128,51,247,217,85,184,96},{192,100,184,140,16,249,55,229,127,253,188,148,23,221,75,0,129,51,242,216,84,186,96},{192,100,184,140,16,249,55,229,127,253,188,148,23,221,75,0,129,50,248,223,90,184,97},{192,100,184,140,16,249,55,229,127,253,188,148,23,221,75,0,129,51,243,221,83,184,97},{192,100,184,140,16,249,55,229,127,253,188,148,23,221,75,0,129,51,242,222,80,187,106},{240,106,161,142,8,170,31,244,101,248},{192,100,184,140,16,249,55,229,127,253,188,148,23,210,70,4,139,51,249,213,84,191,96},{192,100,184,140,16,249,55,229,127,253,188,148,23,210,70,4,139,48,240,220,81,188,101},{192,100,184,140,16,249,55,229,127,253,188,148,23,210,70,4,139,48,241,222,80,186,101},{192,100,184,140,16,249,55,229,127,253,188,148,23,210,70,4,139,48,241,220,87,187,106},{192,100,184,140,16,249,55,229,127,253,188,148,23,210,70,4,139,48,240,213,82,188,100},{192,100,184,140,16,249,55,229,127,253,188,148,23,210,70,4,139,49,244,223,82,184,96},{241,115,179,153,12,231,1,250,111,251,233,195},{225,109,185},{250,111,180,143,12,242,26,244,119,253},{250,111,180,143,12,242,26,244,119,253,213,214,89,135,31},{250,99,161,137},{225,114,161,159,23,217,58,254,121,237,239,213,95},{253,100,170,136,0,254,27,213},{255,105,164,136,15},{241,115,178,159,6,228,38,208,123,244,233},{243,107,173,130},{240,115,172,129,6,254,33},{255,103,167,140,25,227,60,244,87,244,235,212},{224,99,172,130,2,238,59,255,113},{251,117,146,136,15,229,51,245,127,247,225},{198,103,162,129,6},{224,99,179,153,12,248,55,213,115,234,255,213,91,187,22,64,212,99,163,153},{241,105,174,153,17,229,62,253,115,235,245},{247,104,181,128,47,227,48,227,119,235,255},{241,105,179,128,6,254,59,242,90,240,228,201,89,153,10},{251,114,165,128,47,227,48,227,119,235,255},{226,106,161,148,6,248,22,240,98,248,197,212,86,159,1,93,222,106,165,159},{199,104,172,130,0,225,51,253,122,182,229,212,86,141,26,85,156,108,179,130,13},{199,104,172,130,0,225,51,253,122},{255,79,147,190,42,196,21,206},{225,109,169,131},{241,110,161,159,14},{246,103,174,142,6},{247,107,175,153,6},{229,116,161,157},{229,116,161,157,19,227,60,246},{209,110,161,159,14},{214,103,174,142,6},{215,107,175,153,6},{197,116,161,157},{241,105,179,128,6,254,59,242,95,247,240,222,86,159,28,64,203},{244,103,182,130,17,227,38,244,114,218,233,200,85,142,7,91,209,117},{244,111,167,133,23,239,32,210,121,247,242,201,87,135,31,87,192},{224,99,173,130,23,239,33},{246,103,180,140},{247,119,181,132,19,201,61,226,123,252,242,210,91},{244,103,182,130,17,227,38,244,85,246,245,214,93,159,26,81},{224,99,176,129,10,233,51,229,127,246,232},{244,111,167,133,23,239,32},{231,117,165,164,23,239,63},{237,89,174,140,14,239,49,240,122,245},{244,111,178,136,48,239,32,231,115,235},{252,105,174,136},{229,99,161,157,12,228,27,255,96,252,232,207,87,153,10},{252,103,173,136},{241,106,169,136,13,254,4,248,115,238,203,212,92,142,31},{251,107,161,138,6,194,59,246,126,203,227,200,87,135,6,70,219,105,174},{251,107,161,138,6},{247,107,175,153,6,201,61,255,98,235,233,215,84,142,1},{95,147,96,6,207,62,185,33,138,116,7,23,24,141,1,87,215},{241,105,173,143,2,254},{228,111,179,152,2,230,33},{255,111,179,142},{231,79,224,190,6,254,38,248,120,254,245},{193,111,172,136,13,254,114,240,127,244},{211,111,173,143,12,254},{215,104,161,143,15,239,54},{218,111,180,143,12,242},{218,115,173,140,13,229,59,245,100,246,233,207,72,138,1,70},{198,105,178,158,12},{212,105,182,205,17,235,54,248,99,234},{214,116,161,154,67,236,61,231},{197,103,172,129,0,226,55,242,125},{211,111,173,143,12,254,114,244,120,248,228,215,93,143},{193,107,175,130,23,226,60,244,101,234},{193,101,175,157,6,170,62,254,121,242},{223,105,162,132,15,239,114,226,115,237,242,210,86,140},{223,105,162,132,15,239,114,254,120},{194,115,172,129,67,239,60,240,116,245,227,223},{194,115,172,129},{192,103,167,136,1,229,38},{221,116,162,132,23},{196,105,169,137,16,250,51,252},{218,111,164,136},{211,114,180,140,0,225},{212,96,161,128,12,238,33},{198,99,161,128,67,233,58,244,117,242},{208,103,169,153,10,228,53},{198,116,169,138,4,239,32,243,121,237},{197,99,161,157,12,228,33},{220,105,224,158,19,248,55,240,114},{220,105,224,128,22,240,40,253,115,185,224,215,89,152,27},{211,114,180,140,0,225,114,242,121,246,234,223,87,156,29},{225,110,175,130,23,201,61,254,122,253,233,204,86},{194,116,175,135,6,233,38,248,122,252,166,216,87,132,31,86,221,113,174},{221,116,162,193,21,229,59,245},{221,116,162,132,23,170,33,229,99,253,245},{196,105,169,137,67,249,34,240,123},{196,105,169,137,67,249,34,240,123,185,245,207,77,143,0},{215,104,182,132,17,229,60,252,115,247,242},{244,115,172,129,1,248,59,246,126,237},{193,110,161,137,6,248},{193,109,185,143,12,242},{193,109,185,143,12,242,33},{225,99,172,136,0,254,114,194,125,224,228,212,64},{196,111,179,152,2,230,114,244,101,233},{247,85,144,205,34,233,38,248,96,252},{240,105,184,205,39,227,33,225,122,248,255},{252,103,173,136,67,206,59,226,102,245,231,194},{250,99,161,129,23,226,114,213,127,234,246,215,89,146},{197,99,161,157,12,228,114,248,120,255,233},{219,104,164,132,0,235,38,254,100,234},{211,107,173,130},{196,111,165,154,14,229,54,244,122,185,229,212,75,134,22,70,219,101,179},{220,105,224,159,6,233,61,248,122},{225,110,175,130,23,216,55,242,121,240,234},{199,104,172,130,0,225,114,240,122,245},{192,115,179,153,67,226,33},{192,100,184,140,16,249,55,229,127,253,188,148,23,223,68,4,134,55,240,212,83,186,98},{220,99,182,136,17,230,61,226,115},{192,100,184,140,16,249,55,229,127,253,188,148,23,210,68,4,134,53,241,221,82,189,107,169,46,174,183},{193,118,161,159,8,230,55},{192,100,184,140,16,249,55,229,127,253,188,148,23,218,66,2,128,50,241,212,80,188,107,167,32,169,190,130},{223,111,174,136,0,248,51,247,98,185,238,210,76},{192,100,184,140,16,249,55,229,127,253,188,148,23,211,68,4,132,62,240,212,87,188,102},{208,105,174,134},{192,100,184,140,16,249,55,229,127,253,188,148,23,222,68,4,132,62,249,213,82,191,107},{221,117,181},{192,100,184,140,16,249,55,229,127,253,188,148,23,220,66,6,139,52,245,216,86,191,99},{211,107,175,131,4,170,39,226},{192,100,184,140,16,249,55,229,127,253,188,148,23,222,68,2,130,55,248,222,85,184,100},{208,116,181,133},{192,100,184,140,16,249,55,229,127,253,188,148,23,223,70,5,138,49,244,221,86,188,106},{196,111,174,136},{192,100,184,140,16,249,55,229,127,253,188,148,23,222,64,1,128,48,248,221,91,187,98},{213,103,173,136,16,239,60,226,115},{192,100,184,140,16,249,55,229,127,253,188,148,23,223,75,3,133,62,240,212,82,178,106},{94,152,101,1,213,35,185,30,143,185,106,34,173,7,210,131,89,182,92,205,136,57,230,125,154,17},{192,100,184,140,16,249,55,229,127,253,188,148,23,211,70,5,133,51,243,222,81,179,100,167,32,170,179},{218,111,180,205,16,229,39,255,114,234},{215,104,161,143,15,239,114,249,127,237,166,200,87,158,29,86},{218,111,180,205,16,229,39,255,114,185,245,207,65,135,22},{196,105,172,152,14,239},{194,111,180,142,11,170,122,226,102,252,227,223,17},{225,105,181,131,7},{192,100,184,140,16,249,55,229,127,253,188,148,23,218,69,7,129,49,244,217,90,189,97,161},{225,105,181,131,7,217,55,227,96,240,229,222},{246,99,162,159,10,249},{223,105,182,136,14,239,60,229},{255,105,162,132,15,239,114,215,122,224},{255,105,162,132,15,239,114,215,122,224,166,232,72,142,22,86},{226,69,224,171,15,243},{226,69,224,171,15,243,114,194,102,252,227,223},{252,105,163,129,10,250,114,208,117,237,239,205,93},{252,105,163,129,10,250,114,220,121,253,227},{194,110,175,131,4},{215,107,175,153,6,170,58,254,102},{247,107,175,153,6,170,26,254,102},{247,107,175,153,6,170,1,225,115,252,226},{214,99,182,132,0,239,114,226,102,246,233,221,93,153},{214,99,182,132,0,239,114,226,115,245,227,216,76,130,28,92},{198,105,181,142,11},{213,103,173,136,19,235,54},{223,105,181,158,6,225,55,232,116,246,231,201,92},{198,110,169,159,7,170,34,244,100,234,233,213},{211,116,163,140,7,239,114,226,115,235,240,222,74,152},{211,115,180,130,14,235,38,248,117,248,234,215,65,203,20,64,211,100,224,137,17,229,34,226},{223,99,174,152,67,249,55,229,98,240,232,220,75},{226,116,165,158,16,170,9,195,127,254,238,207,107,131,26,84,198,91,224,153,12,170,6,254,113,254,234,222,24,190,58},{230,110,165,128,6,170,17,254,122,246,244},{225,109,185,205,33,230,39,244},{224,99,164},{254,111,173,136,67,205,32,244,115,247},{226,115,178,157,15,239},{253,116,161,131,4,239},{231,104,172,130,2,238,114,196,95},{225,110,181,153,23,227,60,246,54,221,233,204,86},{245,105,175,137,1,243,55,176},{241,105,174,139,10,237,39,227,119,237,239,212,86},{241,105,174,139,10,237,114,223,119,244,227},{251,104,176,152,23,170,58,244,100,252,168,149,22},{241,116,165,140,23,239},{241,105,174,139,10,237},{241,116,165,140,23,239,54,171,54},{247,116,178,130,17},{226,106,165,140,16,239,114,244,120,237,227,201,24,138,83,81,221,104,166,132,4,170,60,240,123,252,167},{254,99,167,132,23,252,99},{224,103,167,136,21,184},{241,105,174,139,10,237,33},{254,105,161,137},{254,105,161,137,6,238,104,177},{252,105,224,142,12,228,52,248,113,185,245,222,84,142,16,70,215,98,225},{225,103,182,136},{225,103,182,136,7,170,49,249,119,247,225,222,75,203,7,93,136,38},{252,105,224,142,12,228,52,248,113,185,245,222,84,142,16,70,215,98,224,153,12,170,33,240,96,252,167},{246,99,172,136,23,239},{246,99,172,136,23,239,54,171,54},{252,105,224,142,12,228,52,248,113,185,245,222,84,142,16,70,215,98,224,153,12,170,54,244,122,252,242,222,25},{250,103,172,128,22,195,60,245,127,250,231,207,87,153,0},{226,106,161,148,6,248,21,228,127},{224,103,167,136,1,229,38,216,120,253,239,216,89,159,28,64},{243,107,173,130,42,228,54,248,117,248,242,212,74},{224,99,179,136,17,252,55,208,123,244,233},{225,114,175,159,6,238,19,252,123,246},{224,99,179,136,17,252,55},{230,105,180,140,15,203,63,252,121},{255,103,184,172,14,231,61},{255,103,184,175,22,230,62,244,98,234},{224,99,172,130,2,238},{219,98,171},{192,103,167,136,1,229,38,177,44,185},{192,99,172,130,2,238,59,255,113},{151,98,239,200,7},{237,98,178,130,19},{240,103,179,136,51,235,32,229},{250,99,161,129,23,226},{217},{251,114,165,128,16},{240,105,183},{246,103,167,138,6,248,33},{225,106,169,131,4,249,58,254,98},{224,99,172,130,2,238,30,244,120,254,242,211},{225,99,180,174,12,228,38,227,121,245,245},{224,99,173,130,23,239,23,231,115,247,242},{228,84},{230,105,181,142,11},{245,103,173,136,19,235,54},{255,105,181,158,6,193,55,232,116,246,231,201,92},{243,104,169,128,2,254,59,254,120},{192,100,184,140,16,249,55,229,127,253,188,148,23,210,65,0,138,55,248,220,84,178,102,161,35,170,183},{243,104,169,128,2,254,61,227},{231,118,176,136,17,222,61,227,101,246},{230,105,178,158,12},{250,103,172,128,22,204,29,199},{231,79,131,130,17,228,55,227},{243,111,173,143,12,254,20,222,64},{225,111,172,136,13,254,19,248,123,223,201,237},{250,103,172,128,22,207,1,193},{212,115,174,142,23,227,61,255},{237,116,165,129,12,235,54,206,117,246,233,215,92,132,4,92},{197,99,161,157,12,228},{152,84,165,129,12,235,54,248,120,254,172},{146,122,224},{250,99,161,129,23,226,16,246},{250,99,161,129,23,226,16,240,100},{229,99,161,157,12,228},{146,93},{223,91},{225,110,161,137,6,248,16,253,99,235},{241,105,172,130,17,201,61,227,100,252,229,207,81,132,29,119,212,96,165,142,23},{225,110,161,137,6,248,17,254,122,246,244},{130,54,250,222,83,176,98,161}}
local decodeString=function(i)
local d=encodedStrings[i]
if not d then return "" end
local o={}
for j=1,#d do
o[j]=string.char(bit32.bxor(d[j],xorKey[((j-1)%#xorKey)+1]))
end
return table.concat(o)
end

local integrityHash={195,179,28,65,160,236,81,76,204,75,27,60,64,214,244,13}
local encodedStringCount=#encodedStrings
local verifyStringBytes=function(a,b)
if type(a)~="string" or #a~=#b then return false end
for i=1,#b do if string.byte(a,i)~=b[i] then return false end end
return true
end
local handleTamperDetected=function()
pcall(function()
local cg=game:GetService("CoreGui")
for _,v in ipairs(cg:GetChildren()) do
local n=v.Name
if n=="nexlib" or n=="HalmuESP" or n=="HalmuFOV" or n=="HalmuIndicators" or n=="ExecutorToggleUI" or n=="CustomCursorGui" then
v:Destroy()
end
end
end)
pcall(function()
local lp=game:GetService("Players").LocalPlayer
if lp then
local pg=lp:FindFirstChild("PlayerGui")
if pg then
for _,v in ipairs(pg:GetChildren()) do
if string.find(string.lower(tostring(v.Name)),"halmu") or v.Name=="nexlib" then v:Destroy() end
end
end
end
end)
error("\116\97\109\112\101\114\32\100\101\116\101\99\116\101\100",0)
while true do end
end
do
if #encodedStrings~=encodedStringCount then handleTamperDetected() end
if not verifyStringBytes("ScreenGui",{83,99,114,101,101,110,71,117,105}) then handleTamperDetected() end
if not verifyStringBytes("MainFrame",{77,97,105,110,70,114,97,109,101}) then handleTamperDetected() end
if not verifyStringBytes("nexlib",{110,101,120,108,105,98}) then handleTamperDetected() end
if not verifyStringBytes("UserInputService",{85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101}) then handleTamperDetected() end
if not verifyStringBytes("Toggle",{84,111,103,103,108,101}) then handleTamperDetected() end
if not verifyStringBytes("Section",{83,101,99,116,105,111,110}) then handleTamperDetected() end
if not verifyStringBytes("Combat",{67,111,109,98,97,116}) then handleTamperDetected() end
if not verifyStringBytes("Visuals",{86,105,115,117,97,108,115}) then handleTamperDetected() end
local s=""
for i=1,math.min(64,#encodedStrings) do
local e=encodedStrings[i]
if e then for j=1,#e do s=s..string.char(e[j] or 0) end end
end
local h={}
for i=1,16 do h[i]=0 end
local acc=0
for i=1,#s do
acc=(acc*31+string.byte(s,i))%2147483647
h[((i-1)%16)+1]=bit32.bxor(h[((i-1)%16)+1],string.byte(s,i))
h[((i-1)%16)+1]=bit32.band(h[((i-1)%16)+1]+(acc%251),255)
end
for i=1,16 do if h[i]~=integrityHash[i] then handleTamperDetected() end end
end
task.spawn(function()
while true do
task.wait(2.7)
if #encodedStrings~=encodedStringCount then handleTamperDetected() end
if not verifyStringBytes("ScreenGui",{83,99,114,101,101,110,71,117,105}) then handleTamperDetected() end
if not verifyStringBytes("MainFrame",{77,97,105,110,70,114,97,109,101}) then handleTamperDetected() end
if not verifyStringBytes("nexlib",{110,101,120,108,105,98}) then handleTamperDetected() end
if not verifyStringBytes("UserInputService",{85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101}) then handleTamperDetected() end
if not verifyStringBytes("Toggle",{84,111,103,103,108,101}) then handleTamperDetected() end
if not verifyStringBytes("Section",{83,101,99,116,105,111,110}) then handleTamperDetected() end
if not verifyStringBytes("Combat",{67,111,109,98,97,116}) then handleTamperDetected() end
if not verifyStringBytes("Visuals",{86,105,115,117,97,108,115}) then handleTamperDetected() end
local s=""
for i=1,math.min(64,#encodedStrings) do
local e=encodedStrings[i]
if e then for j=1,#e do s=s..string.char(e[j] or 0) end end
end
local h={}
for i=1,16 do h[i]=0 end
local acc=0
for i=1,#s do
acc=(acc*31+string.byte(s,i))%2147483647
h[((i-1)%16)+1]=bit32.bxor(h[((i-1)%16)+1],string.byte(s,i))
h[((i-1)%16)+1]=bit32.band(h[((i-1)%16)+1]+(acc%251),255)
end
for i=1,16 do if h[i]~=integrityHash[i] then handleTamperDetected() end end
pcall(function() if nexlib ~= nil and (type(nexlib)~="table" or type(nexlib.Window)~="function" or type(nexlib.Notification)~="function") then handleTamperDetected() end end)
end
end)


-----------------------------------------------------------
-- client protection / detection soften
-----------------------------------------------------------
pcall(function()
    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local LP = Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    local StarterGui = game:GetService("StarterGui")
    local LogService = game:GetService("LogService")
    local ScriptContext = game:GetService("ScriptContext")
    local GuiService = game:GetService("GuiService")

    -- swallow kick/ban style LocalPlayer methods if present
    pcall(function()
        if LP and typeof(LP.Kick) == "function" then
            local oldKick = LP.Kick
            LP.Kick = function(...) end
        end
    end)

    -- block common remote kick/ban namecalls (client-side only; server still authoritative)
    pcall(function()
        if not hookmetamethod or not getnamecallmethod then return end
        local bannedRemoteNames = {
            kick=true, ban=true, punish=true, anticheat=true, detect=true,
            report=true, flag=true, crash=true, log=true, screenshot=true,
            security=true, mod=true, admin=true, watchdog=true, sentinel=true,
        }
        local function isSuspiciousName(n)
            if type(n) ~= "string" then return false end
            n = string.lower(n)
            for k,_ in pairs(bannedRemoteNames) do
                if string.find(n, k, 1, true) then return true end
            end
            return false
        end
        local old
        old = hookmetamethod(game, "__namecall", newcclosure and newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" or method == "InvokeServer" then
                local name = ""
                pcall(function() name = self.Name end)
                if isSuspiciousName(name) then
                    return
                end
                -- path check
                local path = ""
                pcall(function()
                    path = self:GetFullName()
                end)
                if isSuspiciousName(path) then
                    return
                end
            end
            if method == "Kick" or method == "kick" then
                return
            end
            return old(self, ...)
        end) or function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" or method == "InvokeServer" then
                local name = ""
                pcall(function() name = self.Name end)
                if isSuspiciousName(name) then return end
            end
            if method == "Kick" then return end
            return old(self, ...)
        end)
    end)

    -- hide ScreenGuis from naive CoreGui scanners that look for known cheat UI names
    pcall(function()
        local function cloak(inst)
            if not inst then return end
            pcall(function()
                inst.Name = tostring(math.random(100000,999999))
            end)
        end
        task.defer(function()
            task.wait(1)
            for _,n in ipairs({"HalmuESP","HalmuFOV","HalmuIndicators","ExecutorToggleUI","CustomCursorGui"}) do
                local o = CoreGui:FindFirstChild(n)
                if o then cloak(o) end
                if LP and LP:FindFirstChild("PlayerGui") then
                    local o2 = LP.PlayerGui:FindFirstChild(n)
                    if o2 then cloak(o2) end
                end
            end
        end)
    end)

    -- reduce noisy error spam that some detectors scrape
    pcall(function()
        if ScriptContext and ScriptContext.Error then
            ScriptContext.Error:Connect(function() end)
        end
    end)

    -- soft rate-limit our own combat remotes visually only: no-op placeholder for detectors timing fire bursts
    -- (actual combat still fires; this is just an empty bind so random AC probes don't see nil)
    pcall(function()
        if getconnections then
            -- leave empty; some executors break if we disconnect game connections blindly
        end
    end)

    -- spoof simple identity fields some client ACs read
    pcall(function()
        if setfflag then
            pcall(setfflag, "DebugRunServiceHumanoidCheck", "False")
        end
    end)

    -- prevent simple teleport-flag by keeping HumanoidRootPart network owner local when possible
    pcall(function()
        local RunService = game:GetService("RunService")
        local last = 0
        RunService.Heartbeat:Connect(function()
            if tick() - last < 1 then return end
            last = tick()
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.SetNetworkOwner then
                pcall(function() hrp:SetNetworkOwner(LP) end)
            end
        end)
    end)
end)




local nexlib = {accentclr = Color3.fromRGB(128, 213, 247), dropdownframes = {}, colorpickerframes = {}}

local mouseButtonNames = {[Enum.UserInputType.MouseButton1]="M1",[Enum.UserInputType.MouseButton2]="M2",[Enum.UserInputType.MouseButton3]="M3"}
local supportedKeyCodes = {Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.mainFrameOutlineInner,Enum.KeyCode.D,Enum.KeyCode.Up,Enum.KeyCode.Left,Enum.KeyCode.Down,Enum.KeyCode.Right,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Backspace,Enum.KeyCode.Escape,Enum.KeyCode.RightShift}

local function L689_56(tbl, targetValue)
    for k, localVar064 in next, tbl do if localVar064 == targetValue or k == targetValue then return true end end 
end;

local function _376_509(clickTarget, dragTarget)
    pcall(function()
        local localVar024 = false;
        local dragInput, __AOjJzuXUq, _352_117;
        clickTarget.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                localVar024 = true;
                __AOjJzuXUq = input.Position;
                _352_117 = dragTarget.Position;
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then localVar024 = false end 
                end)
            end 
        end)
        clickTarget.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end 
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == dragInput and localVar024 then 
                local dragDelta = input.Position - __AOjJzuXUq;
                dragTarget.Position = UDim2.new(_352_117.X.Scale, _352_117.X.Offset + dragDelta.X, _352_117.Y.Scale, _352_117.Y.Offset + dragDelta.Y)
            end 
        end)
    end)
end;

local mainScreenGui = Instance.new("ScreenGui")
mainScreenGui.Name = "nexlib"
setthreadidentity = setthreadidentity or function() end;
setthreadidentity(8)
mainScreenGui.Parent = game:GetService("CoreGui")
mainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

local cursorGui = Instance.new("ScreenGui")
cursorGui.Name = "CustomCursorGui"
cursorGui.ResetOnSpawn = false
cursorGui.Parent = mainScreenGui

local cursorBox = Instance.new("Frame")
cursorBox.Name = "CursorBox"
cursorBox.Size = UDim2.new(0, 6, 0, 6)
cursorBox.BackgroundColor3 = Color3.fromRGB(128, 213, 247)
cursorBox.BorderSizePixel = 0
cursorBox.Visible = false
cursorBox.Parent = cursorGui

local notificationFolder = Instance.new("Folder")
notificationFolder.Name = "NotificationFolder"
notificationFolder.Parent = mainScreenGui;

local activeNotifications = {}
local notificationHeight = 22
local notificationSpacing = 6
local maxNotifications = 8
local defaultNotificationDuration = 3
local notificationTopOffset = 40

local function _0x4633()
    local tweenService = game:GetService("TweenService")
    for i, notificationData in ipairs(activeNotifications) do
        if notificationData.bar and notificationData.bar.Parent then
            local notificationYPosition = notificationTopOffset + (i - 1) * (notificationHeight + notificationSpacing)
            tweenService:Create(notificationData.bar, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, notificationYPosition)
            }):Play()
        end
    end
end

function nexlib:Notification(title, desc, duration)
    duration = duration or defaultNotificationDuration
    local notificationText = tostring(title or "")
    if desc and desc ~= "" then
        notificationText = notificationText .. "  Â·  " .. tostring(desc)
    end

    local tweenService = game:GetService("TweenService")

    
    while #activeNotifications >= maxNotifications do
        local oldNotification = table.remove(activeNotifications)
        if oldNotification and oldNotification.bar and oldNotification.bar.Parent then
            local fadeOutTextTween = tweenService:Create(oldNotification.label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1
            })
            local collapseNotificationTween = tweenService:Create(oldNotification.bar, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, notificationHeight),
                BackgroundTransparency = 1
            })
            local fadeOutStrokeTween = tweenService:Create(oldNotification.stroke, TweenInfo.new(0.2), { Transparency = 1 })
            fadeOutTextTween:Play()
            collapseNotificationTween:Play()
            fadeOutStrokeTween:Play()
            collapseNotificationTween.Completed:Connect(function()
                pcall(function() if oldNotification.bar then oldNotification.bar:Destroy() end end)
                _0x4633()
            end)
        end
    end

    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "Notification"
    notificationFrame.Parent = notificationFolder
    notificationFrame.AnchorPoint = Vector2.new(0.5, 0)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Position = UDim2.new(0.5, 0, 0, notificationTopOffset)
    notificationFrame.Size = UDim2.new(0, 0, 0, notificationHeight)
    notificationFrame.ClipsDescendants = true
    notificationFrame.BackgroundTransparency = 0.05
    notificationFrame.ZIndex = 100

    local notificationStroke = Instance.new("UIStroke")
    notificationStroke.Parent = notificationFrame
    notificationStroke.Color = nexlib.accentclr
    notificationStroke.Thickness = 1.5
    notificationStroke.Transparency = 0.25

    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Parent = notificationFrame
    accentLine.BackgroundColor3 = nexlib.accentclr
    accentLine.BorderSizePixel = 0
    accentLine.Size = UDim2.new(0, 3, 1, 0)
    accentLine.Position = UDim2.new(0, 0, 0, 0)

    local notificationLabel = Instance.new("TextLabel")
    notificationLabel.Parent = notificationFrame
    notificationLabel.BackgroundTransparency = 1
    notificationLabel.Position = UDim2.new(0, 14, 0, 0)
    notificationLabel.Size = UDim2.new(1, -28, 1, 0)
    notificationLabel.Font = Enum.Font.Code
    notificationLabel.Text = notificationText
    notificationLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    notificationLabel.TextSize = 13
    notificationLabel.TextXAlignment = Enum.TextXAlignment.Center
    notificationLabel.TextTransparency = 1
    notificationLabel.TextTruncate = Enum.TextTruncate.None

    local textService = game:GetService("TextService")
    local textBounds = textService:GetTextSize(notificationText, 13, Enum.Font.Code, Vector2.new(2000, notificationHeight))
    local notificationWidth = math.clamp(textBounds.X + 48, 200, 480)

    
    table.insert(activeNotifications, 1, {
        notificationFrame = notificationFrame,
        notificationLabel = notificationLabel,
        notificationStroke = notificationStroke
    })

    _0x4633()

    local expandNotificationTween = tweenService:Create(notificationFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, notificationWidth, 0, notificationHeight)
    })
    local fadeInTextTween = tweenService:Create(notificationLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    expandNotificationTween:Play()
    task.delay(0.08, function() fadeInTextTween:Play() end)
    task.delay(duration, function()
        for i, notificationData in ipairs(activeNotifications) do
            if notificationData.bar == notificationFrame then
                table.remove(activeNotifications, i)
                break
            end
        end

        if not notificationFrame or not notificationFrame.Parent then
            _0x4633()
            return
        end

        local fadeOutTextTween = tweenService:Create(notificationLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        })
        local collapseNotificationTween = tweenService:Create(notificationFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, notificationHeight),
            BackgroundTransparency = 1
        })
        local fadeOutStrokeTween = tweenService:Create(notificationStroke, TweenInfo.new(0.22), { Transparency = 1 })
        fadeOutTextTween:Play()
        collapseNotificationTween:Play()
        fadeOutStrokeTween:Play()
        collapseNotificationTween.Completed:Connect(function()
            pcall(function() notificationFrame:Destroy() end)
            _0x4633()
        end)
    end)
end;
do local localVar276 = 406 + 332 end

function nexlib:Window(windowTitle)
    local windowVisible = true;
    local windowDragging = false;
    local windowTabs = {} 
    
    local mainFrame = Instance.new("Frame")
    local mainFrameOutlineInner = Instance.new("ImageLabel")
    local mainFrameOutlineOuter = Instance.new("ImageLabel")
    local containerHolder = Instance.new("Frame")
    local tabHolder = Instance.new("ScrollingFrame")
    local tabLayout = Instance.new("UIListLayout")
    local tabPadding = Instance.new("UIPadding")
    local topBar = Instance.new("Frame")
    local topBarTitle = Instance.new("TextLabel")
    local topBarLine = Instance.new("Frame")
    
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = mainScreenGui;
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.15 
    mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    mainFrame.BorderSizePixel = 0;
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 525, 0, 631)
    mainFrame.Visible = false
    mainFrame.ClipsDescendants = true
    
    mainFrameOutlineInner.Name = "OutlineMainFrame1"
    mainFrameOutlineInner.Parent = mainFrame; mainFrameOutlineInner.BackgroundTransparency = 1; mainFrameOutlineInner.Position = UDim2.new(0, 1, 0, 1)
    mainFrameOutlineInner.Size = UDim2.new(1, -2, 1, -2) mainFrameOutlineInner.Image = "rbxassetid://2592362371"
    mainFrameOutlineInner.ImageColor3 = Color3.fromRGB(60, 60, 60) mainFrameOutlineInner.ScaleType = Enum.ScaleType.Slice; mainFrameOutlineInner.SliceCenter = Rect.new(2, 2, 62, 62)
    
    mainFrameOutlineOuter.Name = "OutlineMainFrame2"
    mainFrameOutlineOuter.Parent = mainFrame; mainFrameOutlineOuter.BackgroundTransparency = 1; mainFrameOutlineOuter.Size = UDim2.new(1, 0, 1, 0)
    mainFrameOutlineOuter.Image = "rbxassetid://2592362371" mainFrameOutlineOuter.ImageColor3 = Color3.fromRGB(0, 0, 0)
    mainFrameOutlineOuter.ScaleType = Enum.ScaleType.Slice; mainFrameOutlineOuter.SliceCenter = Rect.new(2, 2, 62, 62)
    
    containerHolder.Name = "ContainerHolderFrame"
    containerHolder.Parent = mainFrame; containerHolder.AnchorPoint = Vector2.new(0.5, 0)
    containerHolder.BackgroundColor3 = Color3.fromRGB(24, 24, 24) containerHolder.Position = UDim2.new(0.5, 0, 0.071, 10)
    containerHolder.Size = UDim2.new(1, -18, 1, -42)
    containerHolder.BackgroundTransparency = 1
    containerHolder.ClipsDescendants = true
    
    tabHolder.Name = "TabHolderFrame"
    tabHolder.Parent = containerHolder; tabHolder.BackgroundTransparency = 1;
    tabHolder.Size = UDim2.new(1, 0, 0, 32) tabHolder.Visible = true;
    tabHolder.CanvasSize = UDim2.new(0, 700, 0, 0)
    tabHolder.ScrollBarThickness = 0;
    
    tabLayout.Name = "TabHolderFrameLayout"
    tabLayout.Parent = tabHolder; tabLayout.FillDirection = Enum.FillDirection.Horizontal;
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder; tabLayout.Padding = UDim.new(0, 4)
    
    tabPadding.Name = "TabHolderFramePadding"
    tabPadding.Parent = tabHolder; tabPadding.PaddingLeft = UDim.new(0, 5)
    
    topBar.Name = "TopBar"
    topBar.Parent = mainFrame; topBar.AnchorPoint = Vector2.new(0.5, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24) topBar.BorderSizePixel = 0;
    topBar.Position = UDim2.new(0.5, 0, 0, 2) topBar.Size = UDim2.new(1, -5, 0, 28)
    
    topBarTitle.Name = "TopBarTitle"
    topBarTitle.Parent = topBar; topBarTitle.BackgroundTransparency = 1;
    topBarTitle.Position = UDim2.new(0, 7, 0, 5) topBarTitle.Size = UDim2.new(0, 0, 0, 16)
    topBarTitle.Font = Enum.Font.Code; topBarTitle.Text = windowTitle;
    topBarTitle.TextColor3 = Color3.fromRGB(230, 230, 230) topBarTitle.TextSize = 16; topBarTitle.TextXAlignment = Enum.TextXAlignment.Left;
    
    topBarLine.Name = "TopBarLine"
    topBarLine.Parent = topBar; topBarLine.BackgroundColor3 = nexlib.accentclr;
    topBarLine.BorderSizePixel = 0; topBarLine.Position = UDim2.new(0, 0, 0, 27) topBarLine.Size = UDim2.new(1, 0, 0, 1)
    
    _376_509(topBar, mainFrame)

    local lighting = game:GetService("Lighting")
    local uiBlur = lighting:FindFirstChild("ValkUIBlur") or Instance.new("BlurEffect")
    uiBlur.Name = "ValkUIBlur"
    uiBlur.Size = 0
    uiBlur.Parent = lighting

    local function a49b45c10()
        mainFrame.Visible = windowVisible
        cursorBox.Visible = windowVisible
        game:GetService("UserInputService").MouseBehavior = windowVisible and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
        
        local tweenService = game:GetService("TweenService")
        if windowVisible then
            tweenService:Create(uiBlur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 18}):Play()
            mainFrame.BackgroundTransparency = 1
            tweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
        else
            tweenService:Create(uiBlur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
        end
    end
    
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.RightShift then 
            windowVisible = not windowVisible;
            a49b45c10()
        end 
        do local localVar303 = 577 + 450 end
    end)

    local coreGui = game:GetService("CoreGui")
    if coreGui:FindFirstChild("ExecutorToggleUI") then
        coreGui.ExecutorToggleUI:Destroy()
    end
    do local localVar336 = 132 + 477 end

    local toggleScreenGui = Instance.new("ScreenGui")
    toggleScreenGui.Name = "ExecutorToggleUI"
    toggleScreenGui.ResetOnSpawn = false
    toggleScreenGui.Parent = coreGui

    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleFrame"
    toggleButton.Size = UDim2.new(0, 65, 0, 36)
    toggleButton.Position = UDim2.new(0, 20, 0, 20)
    toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggleButton.BorderSizePixel = 0
    toggleButton.Active = true
    toggleButton.Draggable = true
    toggleButton.Parent = toggleScreenGui

    local toggleButtonStroke = Instance.new("UIStroke")
    toggleButtonStroke.Color = nexlib.accentclr 
    toggleButtonStroke.Thickness = 2
    toggleButtonStroke.Parent = toggleButton

    local toggleTitle = Instance.new("TextLabel")
    toggleTitle.Size = UDim2.new(1, -6, 0, 16)
    toggleTitle.Position = UDim2.new(0, 3, 0, 2)
    toggleTitle.BackgroundTransparency = 1
    toggleTitle.Text = "Toggle"
    toggleTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
    toggleTitle.TextSize = 12
    toggleTitle.Font = Enum.Font.GothamBold
    toggleTitle.TextXAlignment = Enum.TextXAlignment.Left
    toggleTitle.Parent = toggleButton

    local toggleStatus = Instance.new("TextLabel")
    toggleStatus.Size = UDim2.new(1, -6, 0, 16)
    toggleStatus.Position = UDim2.new(0, 3, 0, 18)
    toggleStatus.BackgroundTransparency = 1
    toggleStatus.Text = "Look"
    toggleStatus.TextColor3 = Color3.fromRGB(230, 230, 230)
    toggleStatus.TextSize = 12
    toggleStatus.Font = Enum.Font.GothamBold
    toggleStatus.TextXAlignment = Enum.TextXAlignment.Left
    toggleStatus.Parent = toggleButton

    toggleButton.MouseButton1Click:Connect(function()
        windowVisible = not windowVisible
        a49b45c10()
    end)
    
    coroutine.wrap(function()
        while task.wait() do 
            topBarLine.BackgroundColor3 = nexlib.accentclr 
            toggleButtonStroke.Color = nexlib.accentclr 
            cursorBox.BackgroundColor3 = nexlib.accentclr
            
            if windowVisible then
                local localVar192 = game:GetService("UserInputService"):GetMouseLocation()
                cursorBox.Position = UDim2.new(0, localVar192.X, 0, localVar192.Y)
            end
        end 
    end)()

    local localVar333 = {}
    
    function localVar333:Tab(tabName)
        local localVar477 = 50;
        
        local localVar329 = Instance.new("TextButton")
        localVar329.Name = tabName .. "_TabBtn"
        localVar329.Parent = tabHolder
        localVar329.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        localVar329.BorderSizePixel = 0
        localVar329.Font = Enum.Font.Code
        localVar329.Text = tabName
        localVar329.TextColor3 = Color3.fromRGB(150, 150, 150)
        localVar329.TextSize = 14
        localVar329.AutoButtonColor = false
        
        local localVar226 = game:GetService("TextService")
        local localVar290 = localVar226:GetTextSize(tabName, 14, Enum.Font.Code, Vector2.new(500, 500))
        localVar329.Size = UDim2.new(0, localVar290.X + 28, 0, 26)
        
        local localVar061 = Instance.new("Frame")
        localVar061.Name = "TopLine"
        localVar061.Parent = localVar329
        localVar061.BackgroundColor3 = nexlib.accentclr
        localVar061.BorderSizePixel = 0
        localVar061.Position = UDim2.new(0, 0, 0, 0)
        localVar061.Size = UDim2.new(1, 0, 0, 2)
        localVar061.Visible = false
        
        local localVar470 = Instance.new("ImageLabel")
        localVar470.Name = "Outline"
        localVar470.Parent = localVar329
        localVar470.BackgroundTransparency = 1
        localVar470.Size = UDim2.new(1, 0, 1, 0)
        localVar470.Image = "rbxassetid://2592362371"
        localVar470.ImageColor3 = Color3.fromRGB(45, 45, 45)
        localVar470.ScaleType = Enum.ScaleType.Slice
        localVar470.SliceCenter = Rect.new(2, 2, 62, 62)
        local localVar078 = Instance.new("ScrollingFrame")
        local localVar193 = Instance.new("UIPadding")
        local localVar119 = Instance.new("UIListLayout")
        local localVar147 = Instance.new("ScrollingFrame")
        local localVar387 = Instance.new("UIPadding")
        local localVar136 = Instance.new("UIListLayout")
        
        localVar078.Name = tabName .. "_Holder1"
        localVar078.Parent = containerHolder;
        localVar078.Active = true; localVar078.BackgroundTransparency = 1; localVar078.BorderSizePixel = 0;
        localVar078.Position = UDim2.new(0, 1, 0, 35) localVar078.Size = UDim2.new(0, 245, 1, -40)
        localVar078.Visible = false; localVar078.CanvasSize = UDim2.new(0, 0, 0, 0) localVar078.ScrollBarThickness = 4; localVar078.ScrollingEnabled = true;
        
        localVar193.Parent = localVar078; localVar193.PaddingTop = UDim.new(0, 5)
        localVar119.Parent = localVar078; localVar119.SortOrder = Enum.SortOrder.LayoutOrder; localVar119.Padding = UDim.new(0, 10)
        
        localVar147.Name = tabName .. "_Holder2"
        localVar147.Parent = containerHolder;
        localVar147.Active = true; localVar147.BackgroundTransparency = 1; localVar147.BorderSizePixel = 0;
        localVar147.Position = UDim2.new(0, 255, 0, 35) localVar147.Size = UDim2.new(0, 245, 1, -40)
        localVar147.Visible = false; localVar147.CanvasSize = UDim2.new(0, 0, 0, 0) localVar147.ScrollBarThickness = 4; localVar147.ScrollingEnabled = true;
        
        localVar387.Parent = localVar147; localVar387.PaddingTop = UDim.new(0, 5)
        localVar136.Parent = localVar147; localVar136.SortOrder = Enum.SortOrder.LayoutOrder; localVar136.Padding = UDim.new(0, 10)
        
        table.insert(windowTabs, {localVar139 = localVar329, topLine = localVar061, outline = localVar470, h1 = localVar078, h2 = localVar147})
        
        if windowDragging == false then 
            windowDragging = true;
            localVar078.Visible = true;
            localVar147.Visible = true;
            localVar329.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            localVar329.TextColor3 = Color3.fromRGB(230, 230, 230)
            localVar061.Visible = true
            localVar470.ImageColor3 = Color3.fromRGB(65, 65, 65)
        end;
        
        localVar329.MouseButton1Click:Connect(function()
            local localVar164 = game:GetService("TweenService")
            for localVar317, t in ipairs(windowTabs) do
                if t.btn == localVar329 then
                    localVar164:Create(t.btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(33, 33, 33), TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
                    t.topLine.Visible = true
                    t.outline.ImageColor3 = Color3.fromRGB(65, 65, 65)
                    t.h1.Visible = true
                    t.h2.Visible = true
                else
                    localVar164:Create(t.btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(22, 22, 22), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    t.topLine.Visible = false
                    t.outline.ImageColor3 = Color3.fromRGB(45, 45, 45)
                    t.h1.Visible = false
                    t.h2.Visible = false
                end
                do local localVar275 = 352 + 514 end
            end
        end)
        
        coroutine.wrap(function()
            while task.wait() do 
                if localVar061.Visible then
                    localVar061.BackgroundColor3 = nexlib.accentclr 
                end
            end 
        end)()
        
        local localVar055 = {}
        
        function localVar055:Section(sectionName, forceSide)
            localVar477 = localVar477 - 1;
            local localVar016 = nil;
            
            if forceSide == 1 then localVar016 = localVar078
            elseif forceSide == 2 then localVar016 = localVar147
            else
                local localVar140 = 0; local localVar423 = 0;
                for s, f in next, localVar078:GetChildren() do if f.Name == "Section" or f.Name == "MultiSection" then localVar140 = localVar140 + 1 end end;
                for s, f in next, localVar147:GetChildren() do if f.Name == "Section" or f.Name == "MultiSection" then localVar423 = localVar423 + 1 end end;
                if localVar140 == 0 and localVar423 == 0 then localVar016 = localVar078 
                elseif localVar140 == localVar423 then localVar016 = localVar078 
                else localVar016 = localVar147 end;
            end
            
            local localVar328 = Instance.new("Frame")
            local localVar305 = Instance.new("ImageLabel")
            local localVar092 = Instance.new("ImageLabel")
            local localVar019 = Instance.new("Frame")
            local localVar438 = Instance.new("TextLabel")
            local localVar352 = Instance.new("Frame")
            local localVar318 = Instance.new("UIListLayout")
            
            localVar328.Name = "Section"
            localVar328.Parent = localVar016;
            localVar328.AnchorPoint = Vector2.new(0.5, 0)
            localVar328.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            localVar328.BorderSizePixel = 0;
            localVar328.Size = UDim2.new(1, -2, 0, 24)
            localVar328.ZIndex = localVar477;
            
            localVar305.Name = "SectionOutline2"
            localVar305.Parent = localVar328; localVar305.BackgroundTransparency = 1; localVar305.Size = UDim2.new(1, 0, 1, 0)
            localVar305.Image = "rbxassetid://2592362371" localVar305.ImageColor3 = Color3.fromRGB(0, 0, 0)
            localVar305.ScaleType = Enum.ScaleType.Slice; localVar305.SliceCenter = Rect.new(2, 2, 62, 62)
            
            localVar092.Name = "SectionOutline1"
            localVar092.Parent = localVar328; localVar092.BackgroundTransparency = 1; localVar092.Position = UDim2.new(0, 1, 0, 1)
            localVar092.Size = UDim2.new(1, -2, 1, -2) localVar092.Image = "rbxassetid://2592362371"
            localVar092.ImageColor3 = Color3.fromRGB(60, 60, 60) localVar092.ScaleType = Enum.ScaleType.Slice; localVar092.SliceCenter = Rect.new(2, 2, 62, 62)
            
            localVar019.Name = "SectionTitleFrame"
            localVar019.Parent = localVar328; localVar019.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            localVar019.BorderSizePixel = 0; localVar019.Position = UDim2.new(0, 10, 0, 0)
            
            localVar438.Name = "SectionTitle"
            localVar438.Parent = localVar019; localVar438.BackgroundTransparency = 1; localVar438.Position = UDim2.new(0, 0, 0, -3)
            localVar438.Size = UDim2.new(1, 0, 0, 7) localVar438.Font = Enum.Font.Code; localVar438.Text = sectionName;
            localVar438.TextColor3 = Color3.fromRGB(230, 230, 230) localVar438.TextSize = 14;
            
            localVar352.Name = "SectionItemHolderFrame"
            localVar352.Parent = localVar328; localVar352.AnchorPoint = Vector2.new(0.5, 0)
            localVar352.BackgroundTransparency = 1; localVar352.Position = UDim2.new(0.5, 0, 0, 15)
            localVar352.Size = UDim2.new(1, -16, 0, 0)
            
            localVar318.Parent = localVar352; localVar318.SortOrder = Enum.SortOrder.LayoutOrder; localVar318.Padding = UDim.new(0, 5)
            localVar019.Size = UDim2.new(0, localVar438.TextBounds.X + 6, 0, 7)
            
            local function _6853x256()
                localVar328.Size = UDim2.new(1, -2, 0, localVar318.AbsoluteContentSize.Y + 24)
                localVar078.CanvasSize = UDim2.new(0, 0, 0, localVar119.AbsoluteContentSize.Y + 20)
                localVar147.CanvasSize = UDim2.new(0, 0, 0, localVar136.AbsoluteContentSize.Y + 20)
            end

            local localVar025 = {}
            
            function localVar025:Toggle(text, default, callback)
                local localVar345 = Instance.new("TextButton")
                local localVar240 = Instance.new("ImageLabel")
                local localVar169 = Instance.new("ImageLabel")
                local __akbrmvrTgw = Instance.new("Frame")
                local localVar182 = Instance.new("Frame")
                local localVar442 = Instance.new("TextLabel")
                
                localVar345.Name = "Toggle"
                localVar345.Parent = localVar352
                localVar345.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                localVar345.BorderSizePixel = 0
                localVar345.Size = UDim2.new(1, 0, 0, 22)
                localVar345.AutoButtonColor = false
                localVar345.Text = ''
                
                localVar240.Parent = localVar345; localVar240.BackgroundTransparency = 1; localVar240.Size = UDim2.new(1, 0, 1, 0)
                localVar240.Image = "rbxassetid://2592362371" localVar240.ImageColor3 = Color3.fromRGB(60, 60, 60)
                localVar240.ScaleType = Enum.ScaleType.Slice; localVar240.SliceCenter = Rect.new(2, 2, 62, 62)
                
                localVar169.Parent = localVar345; localVar169.BackgroundTransparency = 1; localVar169.Position = UDim2.new(0, 1, 0, 1)
                localVar169.Size = UDim2.new(1, -2, 1, -2) localVar169.Image = "rbxassetid://2592362371"
                localVar169.ImageColor3 = Color3.fromRGB(0, 0, 0) localVar169.ScaleType = Enum.ScaleType.Slice; localVar169.SliceCenter = Rect.new(2, 2, 62, 62)
                
                __akbrmvrTgw.Name = "Box"
                __akbrmvrTgw.Parent = localVar345
                __akbrmvrTgw.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                __akbrmvrTgw.BorderSizePixel = 0
                __akbrmvrTgw.Position = UDim2.new(0, 6, 0.5, -6)
                __akbrmvrTgw.Size = UDim2.new(0, 12, 0, 12)
                
                localVar182.Name = "Check"
                localVar182.Parent = __akbrmvrTgw
                localVar182.BackgroundColor3 = nexlib.accentclr
                localVar182.BorderSizePixel = 0
                localVar182.Position = UDim2.new(0, 2, 0, 2)
                localVar182.Size = UDim2.new(0, 8, 0, 8)
                localVar182.Visible = default or false
                
                localVar442.Parent = localVar345
                localVar442.BackgroundTransparency = 1
                localVar442.Position = UDim2.new(0, 25, 0, 0)
                localVar442.Size = UDim2.new(1, -25, 1, 0)
                localVar442.Font = Enum.Font.Code
                localVar442.Text = text
                localVar442.TextColor3 = Color3.fromRGB(190, 190, 190)
                localVar442.TextSize = 14
                localVar442.TextXAlignment = Enum.TextXAlignment.Left
                
                local localVar012 = default or false
                localVar345.MouseButton1Click:Connect(function()
                    localVar012 = not localVar012
                    localVar182.Visible = localVar012
                    pcall(callback, localVar012)
                end)
                
                _6853x256()
                coroutine.wrap(function()
                    while task.wait() do localVar182.BackgroundColor3 = nexlib.accentclr end
                end)()
                local localVar420 = {}
                function localVar420:Set(targetValue)
                    localVar012 = targetValue
                    localVar182.Visible = localVar012
                    pcall(callback, localVar012)
                end
                return localVar420
            end
            do local localVar319 = 312 + 388 end

            function localVar025:Button(text, callback)
                local localVar139 = Instance.new("TextButton")
                local localVar184 = Instance.new("ImageLabel")
                local localVar232 = Instance.new("ImageLabel")
                
                localVar139.Name = "Button"
                localVar139.Parent = localVar352;
                localVar139.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                localVar139.BorderColor3 = nexlib.accentclr;
                localVar139.BorderSizePixel = 0;
                localVar139.Size = UDim2.new(1, 0, 0, 20)
                localVar139.AutoButtonColor = false; localVar139.Font = Enum.Font.Code;
                localVar139.TextColor3 = Color3.fromRGB(230, 230, 230)
                localVar139.TextSize = 14; localVar139.Text = text;
                
                localVar184.Name = "ButtonOutline1"
                localVar184.Parent = localVar139; localVar184.BackgroundTransparency = 1; localVar184.Size = UDim2.new(1, 0, 1, 0)
                localVar184.Image = "rbxassetid://2592362371" localVar184.ImageColor3 = Color3.fromRGB(60, 60, 60)
                localVar184.ScaleType = Enum.ScaleType.Slice; localVar184.SliceCenter = Rect.new(2, 2, 62, 62)
                
                localVar232.Name = "ButtonOutline2"
                localVar232.Parent = localVar139; localVar232.BackgroundTransparency = 1; localVar232.Position = UDim2.new(0, 1, 0, 1)
                localVar232.Size = UDim2.new(1, -2, 1, -2) localVar232.Image = "rbxassetid://2592362371"
                localVar232.ImageColor3 = Color3.fromRGB(0, 0, 0) localVar232.ScaleType = Enum.ScaleType.Slice; localVar232.SliceCenter = Rect.new(2, 2, 62, 62)
                
                localVar139.MouseButton1Click:Connect(function() pcall(callback) end)
                localVar139.MouseEnter:Connect(function() localVar139.BorderSizePixel = 1 end)
                localVar139.MouseLeave:Connect(function() localVar139.BorderSizePixel = 0 end)
                
                _6853x256()
                coroutine.wrap(function()
                    while task.wait() do localVar139.BorderColor3 = nexlib.accentclr end 
                end)()
            end;
            
            function localVar025:Slider(text, min, max, default, rounding, callback)
                local localVar210 = Instance.new("TextButton")
                local localVar168 = Instance.new("Frame")
                local localVar007 = Instance.new("TextLabel")
                local localVar148 = Instance.new("TextLabel")
                
                localVar210.Name = "SliderBar"
                localVar210.Parent = localVar352; localVar210.BackgroundColor3 = Color3.fromRGB(38, 38, 38); localVar210.BorderSizePixel = 0;
                localVar210.Size = UDim2.new(1, 0, 0, 16); localVar210.Text = ''; localVar210.AutoButtonColor = false;
                
                local localVar043 = Instance.new("ImageLabel")
                localVar043.Parent = localVar210; localVar043.BackgroundTransparency = 1; localVar043.Size = UDim2.new(1, 0, 1, 0)
                localVar043.Image = "rbxassetid://2592362371" localVar043.ImageColor3 = Color3.fromRGB(60, 60, 60)
                localVar043.ScaleType = Enum.ScaleType.Slice; localVar043.SliceCenter = Rect.new(2, 2, 62, 62)
                
                local localVar005 = Instance.new("ImageLabel")
                localVar005.Parent = localVar210; localVar005.BackgroundTransparency = 1; localVar005.Position = UDim2.new(0, 1, 0, 1)
                localVar005.Size = UDim2.new(1, -2, 1, -2) localVar005.Image = "rbxassetid://2592362371"
                localVar005.ImageColor3 = Color3.fromRGB(0, 0, 0) localVar005.ScaleType = Enum.ScaleType.Slice; localVar005.SliceCenter = Rect.new(2, 2, 62, 62)

                localVar168.Name = "SliderFill"
                localVar168.Parent = localVar210; localVar168.BackgroundColor3 = nexlib.accentclr; localVar168.BorderSizePixel = 0;
                localVar168.BackgroundTransparency = 0.55;
                localVar168.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                
                localVar007.Name = "SliderTitle"
                localVar007.Parent = localVar210; localVar007.BackgroundTransparency = 1; localVar007.Position = UDim2.new(0, 6, 0, 0)
                localVar007.Size = UDim2.new(0.7, 0, 1, 0)
                localVar007.Font = Enum.Font.Code; localVar007.Text = text; localVar007.TextColor3 = Color3.fromRGB(190, 190, 190); localVar007.TextSize = 13;
                localVar007.TextXAlignment = Enum.TextXAlignment.Left; localVar007.ZIndex = 2;
                
                localVar148.Name = "SliderValue"
                localVar148.Parent = localVar210; localVar148.BackgroundTransparency = 1; localVar148.Position = UDim2.new(1, -75, 0, 0)
                localVar148.Size = UDim2.new(0, 70, 1, 0) localVar148.Font = Enum.Font.Code; localVar148.Text = tostring(default) .. "s";
                localVar148.TextColor3 = Color3.fromRGB(240, 240, 240); localVar148.TextSize = 13; localVar148.TextXAlignment = Enum.TextXAlignment.Right; localVar148.ZIndex = 5;
                
                local localVar024 = false
                local function _846_348(input)
                    local localVar207 = math.clamp((input.Position.X - localVar210.AbsolutePosition.X) / localVar210.AbsoluteSize.X, 0, 1)
                    local targetValue = min + (max - min) * localVar207
                    if rounding == 0 then
                        targetValue = math.floor(targetValue + 0.5)
                    else
                        targetValue = tonumber(string.format("%." .. rounding .. "f", targetValue))
                    end
                    localVar168.Size = UDim2.new(localVar207, 0, 1, 0)
                    localVar148.Text = tostring(targetValue) .. "s"
                    pcall(callback, targetValue)
                end
                
                localVar210.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        localVar024 = true
                        _846_348(input)
                    end
                end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then localVar024 = false end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if localVar024 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        _846_348(input)
                    end
                end)
                
                _6853x256()
                coroutine.wrap(function()
                    while task.wait() do localVar168.BackgroundColor3 = nexlib.accentclr end
                    do local localVar296 = 173 + 906 end
                end)()
            end

            function localVar025:Input(text, default, placeholder, callback)
                local localVar313 = Instance.new("Frame")
                local localVar435 = Instance.new("TextLabel")
                local localVar074 = Instance.new("TextBox")
                
                localVar313.Name = "Input"
                localVar313.Parent = localVar352; localVar313.BackgroundTransparency = 1; localVar313.Size = UDim2.new(1, 0, 0, 38)
                
                localVar435.Name = "InputTitle"
                localVar435.Parent = localVar313; localVar435.BackgroundTransparency = 1; localVar435.Size = UDim2.new(1, 0, 0, 15)
                localVar435.Font = Enum.Font.Code; localVar435.Text = text; localVar435.TextColor3 = Color3.fromRGB(190, 190, 190); localVar435.TextSize = 14;
                localVar435.TextXAlignment = Enum.TextXAlignment.Left;
                
                localVar074.Name = "InputBox"
                localVar074.Parent = localVar313; localVar074.BackgroundColor3 = Color3.fromRGB(38, 38, 38); localVar074.BorderSizePixel = 0;
                localVar074.Position = UDim2.new(0, 0, 0, 18); localVar074.Size = UDim2.new(1, 0, 0, 20);
                localVar074.Font = Enum.Font.Code; localVar074.PlaceholderText = placeholder or ""; localVar074.Text = default or "";
                localVar074.TextColor3 = Color3.fromRGB(230, 230, 230); localVar074.TextSize = 14; localVar074.TextXAlignment = Enum.TextXAlignment.Left;
                
                localVar074.FocusLost:Connect(function(enterPressed)
                    pcall(callback, localVar074.Text)
                end)
                
                _6853x256()
            end

            function localVar025:Dropdown(text, list, default, callback)
                default = typeof(default) == "string" and default;
                if default == '' then default = nil end;
                
                local localVar076 = Instance.new("Frame")
                local localVar086 = Instance.new("TextLabel")
                local localVar359 = Instance.new("TextButton")
                local localVar391 = Instance.new("ImageLabel")
                local localVar103 = Instance.new("ImageLabel")
                local localVar189 = Instance.new("TextLabel")
                local localVar215 = Instance.new("ImageLabel")
                
                localVar076.Name = "Dropdown"
                localVar076.Parent = localVar352; localVar076.BackgroundTransparency = 1; localVar076.Size = UDim2.new(1, 0, 0, 37)
                
                localVar086.Name = "DropdownTitle"
                localVar086.Parent = localVar076; localVar086.BackgroundTransparency = 1; localVar086.Size = UDim2.new(0, 0, 0, 13)
                localVar086.Font = Enum.Font.Code; localVar086.Text = text; localVar086.TextColor3 = Color3.fromRGB(230, 230, 230) localVar086.TextSize = 14;
                localVar086.TextXAlignment = Enum.TextXAlignment.Left;
                
                localVar359.Name = "DropdownFrame"
                localVar359.Parent = localVar076; localVar359.BackgroundColor3 = Color3.fromRGB(38, 38, 38) localVar359.BorderSizePixel = 0;
                localVar359.Position = UDim2.new(0, 0, 1, -20) localVar359.Size = UDim2.new(1, 0, 0, 20) localVar359.Text = ''; localVar359.AutoButtonColor = false;
                
                localVar391.Parent = localVar359; localVar391.BackgroundTransparency = 1; localVar391.Size = UDim2.new(1, 0, 1, 0)
                localVar391.Image = "rbxassetid://2592362371" localVar391.ImageColor3 = Color3.fromRGB(60, 60, 60)
                localVar391.ScaleType = Enum.ScaleType.Slice; localVar391.SliceCenter = Rect.new(2, 2, 62, 62)
                
                localVar103.Parent = localVar359; localVar103.BackgroundTransparency = 1; localVar103.Position = UDim2.new(0, 1, 0, 1)
                localVar103.Size = UDim2.new(1, -2, 1, -2) localVar103.Image = "rbxassetid://2592362371" localVar103.ImageColor3 = Color3.fromRGB(0, 0, 0)
                localVar103.ScaleType = Enum.ScaleType.Slice; localVar103.SliceCenter = Rect.new(2, 2, 62, 62)
                
                localVar189.Name = "DropdownText"
                localVar189.Parent = localVar359; localVar189.BackgroundTransparency = 1; localVar189.Position = UDim2.new(0, 5, 0, 0)
                localVar189.Size = UDim2.new(1, -5, 1, 0) localVar189.Font = Enum.Font.Code; localVar189.Text = typeof(default) == "string" and default or "...";
                localVar189.TextColor3 = Color3.fromRGB(180, 180, 180) localVar189.TextSize = 14; localVar189.TextXAlignment = Enum.TextXAlignment.Left;
                
                localVar215.Name = "DropdownArrow"
                localVar215.Parent = localVar359; localVar215.AnchorPoint = Vector2.new(0, 0.5) localVar215.BackgroundTransparency = 1;
                localVar215.Position = UDim2.new(1, -22, 0.5, 0) localVar215.Size = UDim2.new(0, 20, 0, 20)
                localVar215.Image = "http://www.roblox.com/asset/?id=6031091004" localVar215.ImageColor3 = Color3.fromRGB(180, 180, 180)
                
                _6853x256()
                
                local localVar316 = Instance.new("Frame")
                local localVar307 = Instance.new("ImageLabel")
                local localVar137 = Instance.new("ImageLabel")
                local localVar153 = Instance.new("ScrollingFrame")
                local localVar044 = Instance.new("UIListLayout")
                local localVar046 = Instance.new("UIPadding")
                
                localVar316.Name = "DropdownHolderFrame"
                localVar316.Parent = localVar328; localVar316.AnchorPoint = Vector2.new(0.5, 0)
                localVar316.BackgroundColor3 = Color3.fromRGB(38, 38, 38) localVar316.BorderSizePixel = 0;
                localVar316.Position = UDim2.new(0.5, 0, 0, localVar318.AbsoluteContentSize.Y + 19)
                localVar316.Size = UDim2.new(1, -16, 0, 0) localVar316.Visible = false; localVar316.ZIndex = 10;
                
                localVar307.Parent = localVar316; localVar307.BackgroundTransparency = 1; localVar307.Size = UDim2.new(1, 0, 1, 0)
                localVar307.Image = "rbxassetid://2592362371" localVar307.ImageColor3 = Color3.fromRGB(60, 60, 60)
                localVar307.ScaleType = Enum.ScaleType.Slice; localVar307.SliceCenter = Rect.new(2, 2, 62, 62)
                
                localVar137.Parent = localVar316; localVar137.BackgroundTransparency = 1; localVar137.Position = UDim2.new(0, 1, 0, 1)
                localVar137.Size = UDim2.new(1, -2, 1, -2) localVar137.Image = "rbxassetid://2592362371" localVar137.ImageColor3 = Color3.fromRGB(0, 0, 0)
                localVar137.ScaleType = Enum.ScaleType.Slice; localVar137.SliceCenter = Rect.new(2, 2, 62, 62)
                
                localVar153.Name = "DropdownHolder"
                localVar153.Parent = localVar316; localVar153.Active = true; localVar153.BackgroundTransparency = 1; localVar153.BorderSizePixel = 0;
                localVar153.Size = UDim2.new(1, -4, 1, 0) localVar153.ScrollBarThickness = 2; localVar153.CanvasSize = UDim2.new(0, 0, 0, 0)
                
                localVar044.Parent = localVar153; localVar044.HorizontalAlignment = Enum.HorizontalAlignment.Center; localVar044.Padding = UDim.new(0, 2)
                localVar046.Parent = localVar153; localVar046.PaddingTop = UDim.new(0, 6)
                
                table.insert(nexlib.dropdownframes, localVar316)
                table.insert(nexlib.dropdownframes, localVar076)
                
                local localVar464 = {}
                
                localVar359.MouseButton1Click:Connect(function()
                    if localVar316.Visible == false then 
                        for s, f in next, nexlib.dropdownframes do if f.Name == "DropdownHolderFrame" then f.Visible = false end end;
                        for s, f in next, nexlib.dropdownframes do if f.Name == "Dropdown" then f.DropdownFrame.DropdownArrow.Rotation = 0 end end;
                        localVar215.Rotation = 180; localVar316.Visible = true 
                    else 
                        localVar215.Rotation = 0; localVar316.Visible = false 
                    end 
                end)
                
                for s, f in next, list do 
                    local localVar038 = Instance.new("TextButton")
                    local localVar479 = Instance.new("TextLabel")
                    
                    localVar038.Name = "Item"
                    localVar038.Parent = localVar153; localVar038.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    localVar038.Size = UDim2.new(1, -12, 0, 20) localVar038.AutoButtonColor = false; localVar038.Font = Enum.Font.Code;
                    localVar038.Text = " " .. f; localVar038.TextColor3 = Color3.fromRGB(230, 230, 230) localVar038.TextSize = 14;
                    localVar038.TextXAlignment = Enum.TextXAlignment.Left;
                    
                    localVar479.Name = "ItemText"
                    localVar479.Parent = localVar038; localVar479.BackgroundTransparency = 1; localVar479.Position = UDim2.new(0, 7, 0, 0)
                    localVar479.Size = UDim2.new(1, -7, 1, 0) localVar479.Font = Enum.Font.Code; localVar479.Text = f;
                    localVar479.TextColor3 = nexlib.accentclr; localVar479.TextSize = 14; localVar479.TextXAlignment = Enum.TextXAlignment.Left;
                    
                    localVar038.MouseButton1Click:Connect(function()
                        localVar316.Visible = false; localVar189.Text = f; default = f; pcall(callback, f)
                    end)
                    
                    coroutine.wrap(function()
                        while task.wait() do 
                            local localVar085 = (typeof(default) == "string" and default == f)
                            localVar479.BackgroundTransparency = 1;
                            localVar479.TextTransparency = localVar085 and 0 or 1;
                            localVar038.TextTransparency = localVar085 and 1 or 0;
                            localVar038.BackgroundTransparency = localVar085 and 0 or 1;
                            localVar038.BorderColor3 = nexlib.accentclr;
                        end 
                        do local localVar362 = 719 + 916 end
                    end)()
                    localVar316.Size = UDim2.new(1, -16, 0, math.clamp(localVar044.AbsoluteContentSize.Y + 12, 0, 150))
                    localVar153.CanvasSize = UDim2.new(0, 0, 0, localVar044.AbsoluteContentSize.Y + 12)
                end;
                
                coroutine.wrap(function()
                    while task.wait() do localVar359.BorderColor3 = nexlib.accentclr end 
                end)()
                
                function localVar464:Set(value)
                    localVar189.Text = tostring(value)
                    default = value
                    pcall(callback, value)
                end
                
                return localVar464
            end;
            do local localVar365 = 186 + 829 end
            
            function localVar025:Label(text)
                local localVar239 = {}
                local notificationLabel = Instance.new("TextLabel")
                
                notificationLabel.Name = "Label"
                notificationLabel.Parent = localVar352; notificationLabel.BackgroundTransparency = 1; notificationLabel.Size = UDim2.new(1, 0, 0, 18)
                notificationLabel.Font = Enum.Font.Code; notificationLabel.Text = text; notificationLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                notificationLabel.TextSize = 14; notificationLabel.TextXAlignment = Enum.TextXAlignment.Left;
                
                _6853x256()
                
                function localVar239:Change(newText) notificationLabel.Text = newText end;
                return localVar239;
            end;
            do local localVar285 = 14 + 940 end
            
            return localVar025;
        end;

        function localVar055:MultiSection(tabNames, forceSide)
            localVar477 = localVar477 - 1
            local localVar016 = nil
            if forceSide == 1 then
                localVar016 = localVar078
            elseif forceSide == 2 then
                localVar016 = localVar147
            else
                local localVar140, localVar423 = 0, 0
                for localVar317, f in next, localVar078:GetChildren() do
                    if f.Name == "Section" or f.Name == "MultiSection" then localVar140 = localVar140 + 1 end
                end
                for localVar317, f in next, localVar147:GetChildren() do
                    if f.Name == "Section" or f.Name == "MultiSection" then localVar423 = localVar423 + 1 end
                end
                if localVar140 <= localVar423 then localVar016 = localVar078 else localVar016 = localVar147 end
            end

            local localVar177 = Instance.new("Frame")
            localVar177.Name = "MultiSection"
            localVar177.Parent = localVar016
            localVar177.AnchorPoint = Vector2.new(0.5, 0)
            localVar177.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            localVar177.BorderSizePixel = 0
            localVar177.Size = UDim2.new(1, -2, 0, 50)
            localVar177.ZIndex = localVar477

            local localVar355 = Instance.new("ImageLabel")
            localVar355.Parent = localVar177
            localVar355.BackgroundTransparency = 1
            localVar355.Size = UDim2.new(1, 0, 1, 0)
            localVar355.Image = "rbxassetid://2592362371"
            localVar355.ImageColor3 = Color3.fromRGB(0, 0, 0)
            localVar355.ScaleType = Enum.ScaleType.Slice
            localVar355.SliceCenter = Rect.new(2, 2, 62, 62)

            local localVar414 = Instance.new("ImageLabel")
            localVar414.Parent = localVar177
            localVar414.BackgroundTransparency = 1
            localVar414.Position = UDim2.new(0, 1, 0, 1)
            localVar414.Size = UDim2.new(1, -2, 1, -2)
            localVar414.Image = "rbxassetid://2592362371"
            localVar414.ImageColor3 = Color3.fromRGB(60, 60, 60)
            localVar414.ScaleType = Enum.ScaleType.Slice
            localVar414.SliceCenter = Rect.new(2, 2, 62, 62)

            local localVar381 = Instance.new("Frame")
            localVar381.Parent = localVar177
            localVar381.BackgroundTransparency = 1
            localVar381.Position = UDim2.new(0, 6, 0, 4)
            localVar381.Size = UDim2.new(1, -12, 0, 22)
            local localVar473 = Instance.new("UIListLayout")
            localVar473.Parent = localVar381
            localVar473.FillDirection = Enum.FillDirection.Horizontal
            localVar473.SortOrder = Enum.SortOrder.LayoutOrder
            localVar473.Padding = UDim.new(0, 2)

            local localVar223 = Instance.new("Frame")
            localVar223.Parent = localVar177
            localVar223.BackgroundTransparency = 1
            localVar223.Position = UDim2.new(0.5, 0, 0, 28)
            localVar223.AnchorPoint = Vector2.new(0.5, 0)
            localVar223.Size = UDim2.new(1, -16, 0, 0)

            local localVar478, __xyRVCd = {}, {}
            local localVar081 = {}

            local function L152_37()
                local localVar234 = 0
                for localVar317, localVar374 in ipairs(localVar478) do
                    local localVar013 = localVar374:FindFirstChildOfClass("UIListLayout")
                    if localVar013 then
                        localVar234 = math.max(localVar234, localVar013.AbsoluteContentSize.Y)
                    end
                    do local localVar321 = 426 + 361 end
                end
                localVar223.Size = UDim2.new(1, -16, 0, localVar234)
                localVar177.Size = UDim2.new(1, -2, 0, localVar234 + 36)
                localVar078.CanvasSize = UDim2.new(0, 0, 0, localVar119.AbsoluteContentSize.Y + 20)
                localVar147.CanvasSize = UDim2.new(0, 0, 0, localVar136.AbsoluteContentSize.Y + 20)
            end

            for i, tabName in ipairs(tabNames) do
                local localVar374 = Instance.new("Frame")
                localVar374.Name = "Page_" .. tabName
                localVar374.Parent = localVar223
                localVar374.BackgroundTransparency = 1
                localVar374.Size = UDim2.new(1, 0, 0, 0)
                localVar374.Visible = (i == 1)

                local localVar341 = Instance.new("UIListLayout")
                localVar341.Parent = localVar374
                localVar341.SortOrder = Enum.SortOrder.LayoutOrder
                localVar341.Padding = UDim.new(0, 5)

                localVar341:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    localVar374.Size = UDim2.new(1, 0, 0, localVar341.AbsoluteContentSize.Y)
                    L152_37()
                end)

                local localVar139 = Instance.new("TextButton")
                localVar139.Parent = localVar381
                localVar139.BackgroundColor3 = (i == 1) and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(28, 28, 28)
                localVar139.BorderSizePixel = 0
                localVar139.Size = UDim2.new(0, 0, 1, 0)
                localVar139.AutomaticSize = Enum.AutomaticSize.X
                localVar139.AutoButtonColor = false
                localVar139.Font = Enum.Font.Code
                localVar139.Text = "  " .. tabName .. "  "
                localVar139.TextColor3 = (i == 1) and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(150, 150, 150)
                localVar139.TextSize = 13

                local localVar453 = Instance.new("Frame")
                localVar453.Parent = localVar139
                localVar453.BackgroundColor3 = nexlib.accentclr
                localVar453.BorderSizePixel = 0
                localVar453.Position = UDim2.new(0, 0, 1, -2)
                localVar453.Size = UDim2.new(1, 0, 0, 2)
                localVar453.Visible = (i == 1)

                table.insert(localVar478, localVar374)
                table.insert(__xyRVCd, {localVar139 = localVar139, localVar453 = localVar453, localVar374 = localVar374})

                localVar139.MouseButton1Click:Connect(function()
                    for idx, notificationData in ipairs(__xyRVCd) do
                        local localVar008 = (idx == i)
                        notificationData.page.Visible = localVar008
                        notificationData.underline.Visible = localVar008
                        notificationData.btn.BackgroundColor3 = localVar008 and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(28, 28, 28)
                        notificationData.btn.TextColor3 = localVar008 and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(150, 150, 150)
                    end
                    L152_37()
                end)
                coroutine.wrap(function()
                    while task.wait() do
                        if localVar453.Visible then
                            localVar453.BackgroundColor3 = nexlib.accentclr
                        end
                    end
                end)()

                local function _987_413()
                    localVar374.Size = UDim2.new(1, 0, 0, localVar341.AbsoluteContentSize.Y)
                    L152_37()
                end

                local localVar448 = {}

                function localVar448:Toggle(text, default, callback)
                    local localVar345 = Instance.new("TextButton")
                    localVar345.Name = "Toggle"
                    localVar345.Parent = localVar374
                    localVar345.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                    localVar345.BorderSizePixel = 0
                    localVar345.Size = UDim2.new(1, 0, 0, 22)
                    localVar345.AutoButtonColor = false
                    localVar345.Text = ""

                    local localVar240 = Instance.new("ImageLabel")
                    localVar240.Parent = localVar345
                    localVar240.BackgroundTransparency = 1
                    localVar240.Size = UDim2.new(1, 0, 1, 0)
                    localVar240.Image = "rbxassetid://2592362371"
                    localVar240.ImageColor3 = Color3.fromRGB(60, 60, 60)
                    localVar240.ScaleType = Enum.ScaleType.Slice
                    localVar240.SliceCenter = Rect.new(2, 2, 62, 62)

                    local localVar169 = Instance.new("ImageLabel")
                    localVar169.Parent = localVar345
                    localVar169.BackgroundTransparency = 1
                    localVar169.Position = UDim2.new(0, 1, 0, 1)
                    localVar169.Size = UDim2.new(1, -2, 1, -2)
                    localVar169.Image = "rbxassetid://2592362371"
                    localVar169.ImageColor3 = Color3.fromRGB(0, 0, 0)
                    localVar169.ScaleType = Enum.ScaleType.Slice
                    localVar169.SliceCenter = Rect.new(2, 2, 62, 62)

                    local __akbrmvrTgw = Instance.new("Frame")
                    __akbrmvrTgw.Parent = localVar345
                    __akbrmvrTgw.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                    __akbrmvrTgw.BorderSizePixel = 0
                    __akbrmvrTgw.Position = UDim2.new(0, 6, 0.5, -6)
                    __akbrmvrTgw.Size = UDim2.new(0, 12, 0, 12)

                    local localVar182 = Instance.new("Frame")
                    localVar182.Parent = __akbrmvrTgw
                    localVar182.BackgroundColor3 = nexlib.accentclr
                    localVar182.BorderSizePixel = 0
                    localVar182.Position = UDim2.new(0, 2, 0, 2)
                    localVar182.Size = UDim2.new(0, 8, 0, 8)
                    localVar182.Visible = default or false

                    local localVar442 = Instance.new("TextLabel")
                    localVar442.Parent = localVar345
                    localVar442.BackgroundTransparency = 1
                    localVar442.Position = UDim2.new(0, 25, 0, 0)
                    localVar442.Size = UDim2.new(1, -25, 1, 0)
                    localVar442.Font = Enum.Font.Code
                    localVar442.Text = text
                    localVar442.TextColor3 = Color3.fromRGB(190, 190, 190)
                    localVar442.TextSize = 14
                    localVar442.TextXAlignment = Enum.TextXAlignment.Left

                    local localVar012 = default or false
                    localVar345.MouseButton1Click:Connect(function()
                        localVar012 = not localVar012
                        localVar182.Visible = localVar012
                        pcall(callback, localVar012)
                    end)

                    _987_413()
                    coroutine.wrap(function()
                        while task.wait() do localVar182.BackgroundColor3 = nexlib.accentclr end
                    end)()

                    local localVar420 = {}
                    function localVar420:Set(targetValue)
                        localVar012 = targetValue
                        localVar182.Visible = localVar012
                        pcall(callback, localVar012)
                    end
                    return localVar420
                end

                function localVar448:Slider(text, min, max, default, rounding, callback)
                    local localVar210 = Instance.new("TextButton")
                    localVar210.Name = "SliderBar"
                    localVar210.Parent = localVar374
                    localVar210.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                    localVar210.BorderSizePixel = 0
                    localVar210.Size = UDim2.new(1, 0, 0, 16)
                    localVar210.Text = ""
                    localVar210.AutoButtonColor = false

                    local localVar043 = Instance.new("ImageLabel")
                    localVar043.Parent = localVar210
                    localVar043.BackgroundTransparency = 1
                    localVar043.Size = UDim2.new(1, 0, 1, 0)
                    localVar043.Image = "rbxassetid://2592362371"
                    localVar043.ImageColor3 = Color3.fromRGB(60, 60, 60)
                    localVar043.ScaleType = Enum.ScaleType.Slice
                    localVar043.SliceCenter = Rect.new(2, 2, 62, 62)

                    local localVar005 = Instance.new("ImageLabel")
                    localVar005.Parent = localVar210
                    localVar005.BackgroundTransparency = 1
                    localVar005.Position = UDim2.new(0, 1, 0, 1)
                    localVar005.Size = UDim2.new(1, -2, 1, -2)
                    localVar005.Image = "rbxassetid://2592362371"
                    localVar005.ImageColor3 = Color3.fromRGB(0, 0, 0)
                    localVar005.ScaleType = Enum.ScaleType.Slice
                    localVar005.SliceCenter = Rect.new(2, 2, 62, 62)

                    local localVar168 = Instance.new("Frame")
                    localVar168.Parent = localVar210
                    localVar168.BackgroundColor3 = nexlib.accentclr
                    localVar168.BorderSizePixel = 0
                    localVar168.BackgroundTransparency = 0.55
                    localVar168.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

                    local localVar007 = Instance.new("TextLabel")
                    localVar007.Parent = localVar210
                    localVar007.BackgroundTransparency = 1
                    localVar007.Position = UDim2.new(0, 6, 0, 0)
                    localVar007.Size = UDim2.new(0.7, 0, 1, 0)
                    localVar007.Font = Enum.Font.Code
                    localVar007.Text = text
                    localVar007.TextColor3 = Color3.fromRGB(190, 190, 190)
                    localVar007.TextSize = 13
                    localVar007.TextXAlignment = Enum.TextXAlignment.Left
                    localVar007.ZIndex = 2

                    local localVar148 = Instance.new("TextLabel")
                    localVar148.Parent = localVar210
                    localVar148.BackgroundTransparency = 1
                    localVar148.Position = UDim2.new(1, -75, 0, 0)
                    localVar148.Size = UDim2.new(0, 70, 1, 0)
                    localVar148.Font = Enum.Font.Code
                    localVar148.Text = tostring(default) .. "s"
                    localVar148.TextColor3 = Color3.fromRGB(240, 240, 240)
                    localVar148.TextSize = 13
                    localVar148.TextXAlignment = Enum.TextXAlignment.Right
                    localVar148.ZIndex = 5

                    local localVar024 = false
                    local function _846_348(input)
                        local localVar207 = math.clamp((input.Position.X - localVar210.AbsolutePosition.X) / localVar210.AbsoluteSize.X, 0, 1)
                        local targetValue = min + (max - min) * localVar207
                        if rounding == 0 then
                            targetValue = math.floor(targetValue + 0.5)
                        else
                            targetValue = tonumber(string.format("%." .. rounding .. "f", targetValue))
                        end
                        localVar168.Size = UDim2.new(localVar207, 0, 1, 0)
                        localVar148.Text = tostring(targetValue) .. "s"
                        pcall(callback, targetValue)
                    end

                    localVar210.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            localVar024 = true
                            _846_348(input)
                        end
                        do local localVar287 = 932 + 568 end
                    end)
                    game:GetService("UserInputService").InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            localVar024 = false
                        end
                    end)
                    game:GetService("UserInputService").InputChanged:Connect(function(input)
                        if localVar024 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            _846_348(input)
                        end
                    end)

                    _987_413()
                    coroutine.wrap(function()
                        while task.wait() do localVar168.BackgroundColor3 = nexlib.accentclr end
                    end)()
                end

                function localVar448:Label(text)
                    local localVar239 = {}
                    local notificationLabel = Instance.new("TextLabel")
                    notificationLabel.Parent = localVar374
                    notificationLabel.BackgroundTransparency = 1
                    notificationLabel.Size = UDim2.new(1, 0, 0, 18)
                    notificationLabel.Font = Enum.Font.Code
                    notificationLabel.Text = text
                    notificationLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                    notificationLabel.TextSize = 14
                    notificationLabel.TextXAlignment = Enum.TextXAlignment.Left
                    _987_413()
                    function localVar239:Change(newText) notificationLabel.Text = newText end
                    return localVar239
                end

                localVar081[tabName] = localVar448
            end

            task.defer(L152_37)
            return localVar081
        end

        return localVar055;
    end;
    
    function localVar333:Destroy()
        if lighting:FindFirstChild("ValkUIBlur") then
            lighting.ValkUIBlur:Destroy()
        end
        mainScreenGui:Destroy()
    end;

    local function _879_260()
        local tweenService = game:GetService("TweenService")
        local lighting = game:GetService("Lighting")
        
        task.wait(0.7)
        local localVar225 = tick()
        while tick() - localVar225 < 3 do task.wait() end
        
        local localVar428 = tick()
        while tick() - localVar428 < 2 do
            local localVar317 = 0
            for i = 1, 500000 do localVar317 = localVar317 + i end
            task.wait()
        end
        
        local localVar176 = lighting:FindFirstChild("ValkUIBlur") or Instance.new("BlurEffect")
        localVar176.Name = "ValkUIBlur"
        localVar176.Size = 0
        localVar176.Parent = lighting
        
        local localVar413 = Instance.new("TextLabel")
        localVar413.Name = "IntroLEVK"
        localVar413.Parent = mainScreenGui
        localVar413.AnchorPoint = Vector2.new(0.5, 0.5)
        localVar413.Position = UDim2.new(0.5, 0, 0.5, 0)
        localVar413.Size = UDim2.new(0, 400, 0, 100)
        localVar413.BackgroundTransparency = 1
        localVar413.Font = Enum.Font.Code
        localVar413.Text = "LEVK"
        localVar413.TextColor3 = nexlib.accentclr
        localVar413.TextSize = 80
        localVar413.TextTransparency = 1
        
        local localVar062 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local localVar264 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        
        tweenService:Create(localVar176, localVar062, {Size = 24}):Play()
        tweenService:Create(localVar413, localVar062, {TextTransparency = 0}):Play()
        
        task.wait(2.2)
        
        local localVar380 = tweenService:Create(localVar176, localVar264, {Size = 18})
        local localVar236 = tweenService:Create(localVar413, localVar264, {TextTransparency = 1})
        
        localVar380:Play()
        localVar236:Play()
        
        localVar380.Completed:Connect(function()
            localVar413:Destroy()
            windowVisible = true
            a49b45c10()
        end)
    end;

    task.spawn(_879_260)
    
    return localVar333;
end;

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localVar397 = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = localVar397.CurrentCamera

local localVar071 = true
local function _685_730(player)
    if not localVar071 then return false end
    local localVar161 = LocalPlayer:GetAttribute("TeamID")
    local localVar051 = player:GetAttribute("TeamID")
    if localVar161 == nil or localVar051 == nil then return false end
    return localVar051 == localVar161
end

local function _143_336(playerOrChar)
    local char = playerOrChar
    if typeof(playerOrChar) == "Instance" and playerOrChar:IsA("Player") then
        char = playerOrChar.Character
    end
    if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    local localVar289 = char:FindFirstChild("HumanoidRootPart")
    if localVar289 and localVar289:FindFirstChild("Attachment") then return true end
    local localVar244 = char:GetAttribute("Immune") or char:GetAttribute("Invincible") or char:GetAttribute("IsImmune")
    if localVar244 == true then return true end
    local localVar422 = char:FindFirstChildOfClass("Humanoid")
    if localVar422 then
        local localVar209 = localVar422:GetAttribute("Immune") or localVar422:GetAttribute("Invincible")
        if localVar209 == true then return true end
    end
    return false
end

local function _0x5dec(player)
    local char = player and player.Character
    if not char then return false end

    
    local localVar220 = {"Reflecting", "IsReflecting", "BulletReflect", "Reflect", "Deflecting", "Parrying"}
    for localVar317, a in ipairs(localVar220) do
        local localVar064 = char:GetAttribute(a)
        if localVar064 == true or localVar064 == 1 or localVar064 == "true" then return true end
        local localVar422 = char:FindFirstChildOfClass("Humanoid")
        if localVar422 then
            local localVar385 = localVar422:GetAttribute(a)
            if localVar385 == true or localVar385 == 1 then return true end
        end
    end

    
    local __bvndpA = false
    local localVar128 = char:FindFirstChildOfClass("Tool")
    if localVar128 and string.find(string.lower(localVar128.Name), "katana", 1, true) then
        __bvndpA = true
    end
    for localVar317, ch in ipairs(char:GetChildren()) do
        local localVar431 = string.lower(ch.Name)
        if string.find(localVar431, "katana", 1, true) then
            __bvndpA = true
        end
        if string.find(localVar431, "reflect", 1, true) or string.find(localVar431, "deflect", 1, true) then
            return true
        end
        do local localVar367 = 210 + 527 end
    end

    
    local localVar422 = char:FindFirstChildOfClass("Humanoid")
    if localVar422 then
        local localVar096, _8291x172 = pcall(function() return localVar422:GetPlayingAnimationTracks() end)
        if localVar096 and _8291x172 then
            for localVar317, localVar129 in ipairs(_8291x172) do
                local localVar087 = string.lower(tostring(localVar129.Name or ""))
                local localVar221 = ""
                pcall(function()
                    if localVar129.Animation then localVar221 = tostring(localVar129.Animation.AnimationId or "") end
                end)
                local localVar377 = localVar087 .. " " .. string.lower(localVar221)
                if string.find(localVar377, "reflect", 1, true) or string.find(localVar377, "deflect", 1, true)
                    or string.find(localVar377, "parry", 1, true) or string.find(localVar377, "block", 1, true) then
                    if __bvndpA or string.find(localVar377, "katana", 1, true) then
                        return true
                    end
                    
                    if string.find(localVar377, "reflect", 1, true) or string.find(localVar377, "deflect", 1, true) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local localVar150 = true
local localVar306 = false
local localVar456 = false
local localVar214 = 50000000
local localVar331 = false
local localVar052 = 50
local localVar066 = false
local localVar354 = false
local localVar170 = 0.25
local localVar421 = 0.1

task.spawn(function()
    while true do
        if localVar354 and localVar030 then
            localVar150 = true
            local localVar163 = localVar421
            if typeof(localVar163) ~= "number" or localVar163 < 0.01 then localVar163 = 0.01 end
            task.wait(localVar163)
            if localVar354 and localVar030 then
                localVar150 = false
                local localVar109 = localVar170
                if typeof(localVar109) ~= "number" or localVar109 < 0.01 then localVar109 = 0.01 end
                do local localVar324 = 616 + 92 end
                task.wait(localVar109)
            else
                localVar150 = true
            end
        else
            localVar150 = true
            task.wait(0.05)
        end
    end
end)

local localVar004 = false
local localVar042 = 5
local localVar070 = 100
local localVar231 = "head"
local localVar452 = false
local localVar408 = false
local localVar188 = false

local localVar302 = false
local localVar105 = "head"
local localVar434 = 300
local localVar118 = false
local localVar146 = false
local localVar219 = nil

local localVar026 = false
local localVar001 = false
local localVar395 = false
local localVar416 = false
local localVar454 = false
local localVar439 = false
local localVar410 = false
local localVar415 = false

local localVar196 = false

local localVar157 = false
local localVar393 = false

local localVar260 = false
local localVar040 = true
local localVar472 = true
local localVar174 = true
local localVar117 = true

local localVar460 = true
local localVar112 = true
local localVar433 = false

local localVar399 = false
local localVar172 = false
local localVar088 = 50
local localVar263 = 50
local localVar094 = false
local localVar426 = "all walls"

local localVar369 = false
local localVar127 = false
local localVar383 = 40
local localVar299 = nil
local localVar022 = nil

local localVar049 = false
local localVar372 = ""

local localVar405 = false
local localVar111 = "vr"
local localVar084 = {
    ["Dark Sky"] = {
        ["SkyboxUp"] = "rbxassetid://570555929",
        ["SkyboxRt"] = "rbxassetid://570555882",
        ["SkyboxDn"] = "rbxassetid://570555964",
        ["SkyboxFt"] = "rbxassetid://570555800",
        ["SkyboxLf"] = "rbxassetid://570555840",
        ["SkyboxBk"] = "rbxassetid://570555736"
    },
    ["Vaporwave"] = {
        ["SkyboxUp"] = "rbxassetid://1417494643",
        ["SkyboxRt"] = "rbxassetid://1417494499",
        ["SkyboxLf"] = "rbxassetid://1417494402",
        ["SkyboxFt"] = "rbxassetid://1417494253",
        ["SkyboxBk"] = "rbxassetid://1417494030",
        ["SkyboxDn"] = "rbxassetid://1417494146"
    },
    ["Lake Sky"] = {
        ["SkyboxRt"] = "rbxassetid://6823531746",
        ["SkyboxUp"] = "rbxassetid://6823528533",
        ["SunTextureId"] = "rbxassetid://5392574622",
        ["SkyboxDn"] = "rbxassetid://6823525702",
        ["SkyboxFt"] = "rbxassetid://6823482923",
        ["SkyboxLf"] = "rbxassetid://6823530023",
        ["SkyboxBk"] = "rbxassetid://6823523318"
    },
    ["Black Mesa"] = {
        ["SkyboxUp"] = "rbxassetid://9569598752",
        ["SkyboxRt"] = "rbxassetid://9569601267",
        ["SkyboxDn"] = "rbxassetid://9569613307",
        ["SkyboxFt"] = "rbxassetid://9569611418",
        ["SkyboxLf"] = "rbxassetid://9569608166",
        ["SkyboxBk"] = "rbxassetid://9569742122"
    }
}

local function _124_163(localVar060)
    local lighting = game:GetService("Lighting")
    local localVar010 = lighting:FindFirstChild("CustomSkybox")
    
    if not localVar049 or not localVar060 or localVar060 == "" then
        if localVar010 then localVar010:Destroy() end
        return
    end
    
    local notificationData = localVar084[localVar060]
    if notificationData then
        if not localVar010 then
            localVar010 = Instance.new("Sky")
            localVar010.Name = "CustomSkybox"
            localVar010.Parent = lighting
        end
        
        localVar010.SkyboxUp = ""
        localVar010.SkyboxRt = ""
        localVar010.SkyboxDn = ""
        localVar010.SkyboxFt = ""
        localVar010.SkyboxLf = ""
        localVar010.SkyboxBk = ""
        localVar010.SunTextureId = ""
        
        for prop, localVar058 in pairs(notificationData) do
            localVar010[prop] = localVar058
        end
    end
end

local localVar198 = false
local localVar191 = ""
local localVar006 = ""
local localVar332 = false 
local localVar099 = Vector3.zero
local localVar406 = Vector3.new(0, 2, 0)
local localVar392 = nil
local localVar411 = nil

local function __bzfwbJeTMvuj(char)
    if not char then return nil end
    return char:FindFirstChild("HitboxHead")
        or char:FindFirstChild("HitboxHeadSmall")
        or char:FindFirstChild("Head")
end

local localVar130
local localVar467 = function(on) end
local localVar030 = false
local localVar338 = 3 

task.spawn(function()
    local localVar096, localVar465 = xpcall(function()
        local localVar154 = LocalPlayer.PlayerScripts
        local localVar404, _9817x625 = pcall(require, localVar154.Controllers.FighterController)
        local localVar107, v27885     = pcall(require, ReplicatedStorage.Modules.EnumLibrary)
        local localVar301    = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
        local localVar237; pcall(function() localVar237 = v27885:ToEnum("StartShooting") end)

        local function _5460x742()
            if not (localVar404 and _9817x625) then return nil end
            local localVar082 = _9817x625.LocalFighter; if not localVar082 then return nil end
            local localVar181 = localVar082.EquippedItem; if not localVar181 then return nil end
            local localVar041, localVar058 = pcall(function() return localVar181:Get("ObjectID") end)
            if localVar041 and localVar058 then return localVar058 end
            do local localVar278 = 868 + 890 end
            localVar041, localVar058 = pcall(function() return localVar181.Data and localVar181.Data.ObjectID end)
            return localVar041 and localVar058 or nil
        end

        local function a30b54c42(originPos, localVar241)
            local localVar028 = localVar241.Position
            local localVar098 = CFrame.lookAt(originPos, localVar028)
            local localVar067, _1897x442, _0xefad = localVar098:ToOrientation()
            local localVar396 = {
                [utf8.char(0)] = originPos.X, [utf8.char(1)] = originPos.Y, [utf8.char(2)] = originPos.Z,
                [utf8.char(3)] = localVar067, [utf8.char(4)] = _1897x442, [utf8.char(5)] = _0xefad,
            }
            local localVar368 = localVar241.CFrame:ToObjectSpace(CFrame.new(localVar028))
            local localVar360, _1l00IOl101Il, __CtOClXPOnz = localVar368:ToOrientation()
            return {
                [utf8.char(1)] = {
                    [utf8.char(0)] = localVar396,
                    [utf8.char(1)] = localVar396,
                    [utf8.char(2)] = localVar241,
                    [utf8.char(3)] = {
                        [utf8.char(0)] = localVar368.X, [utf8.char(1)] = localVar368.Y, [utf8.char(2)] = localVar368.Z,
                        [utf8.char(3)] = localVar360, [utf8.char(4)] = _1l00IOl101Il, [utf8.char(5)] = __CtOClXPOnz,
                    },
                },
            }
        end

        
        localVar467 = function(on)
            if localVar130 then localVar130:Disconnect(); localVar130 = nil end
            if not on then return end

            local localVar351 = nil
            localVar130 = RunService.Heartbeat:Connect(function()
                if not localVar030 or not localVar150 then return end
                if not localVar411 or not localVar411.Parent then return end

                local localVar378 = localVar411:FindFirstAncestorOfClass("Model") or localVar411.Parent
                local localVar370 = Players:GetPlayerFromCharacter(localVar378)
                if not localVar370 or localVar370 == LocalPlayer then return end
                if _685_730(localVar370) then return end
                
                if _143_336(localVar370) then return end
                
                if _0x5dec(localVar370) then return end

                local localVar358 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not localVar358 then return end

                local localVar116 = _5460x742()
                if localVar116 then localVar351 = localVar116 else localVar116 = localVar351 end
                if not localVar116 then return end
                do local localVar322 = 341 + 952 end

                local localVar021 = localVar411
                local localVar068 = localVar021.Position + Vector3.new(0, 0.1, 0)
                local localVar475 = a30b54c42(localVar068, localVar021)
                pcall(function()
                    localVar301:FireServer(localVar116, localVar237, localVar475, nil)
                end)
            end)
        end
    end, function(localVar465) end)
end)

local localVar020 = nil
local localVar015 = nil

local function _4573x894()
    local localVar474 = true
    pcall(function()
        local localVar154 = LocalPlayer.PlayerScripts
        local localVar096, localVar072 = pcall(require, localVar154.Controllers.FighterController)
        if not localVar096 or not localVar072 or not localVar072.LocalFighter then return end
        local localVar181 = localVar072.LocalFighter.EquippedItem
        if not localVar181 then
            localVar474 = false
            return
        end
        local function a34b98c63(key)
            local localVar041, targetValue = pcall(function()
                if localVar181.Get then return localVar181:Get(key) end
                return localVar181[key] or (localVar181.Data and localVar181.Data[key]) or (localVar181.Info and localVar181.Info[key])
            end)
            if localVar041 then return targetValue end
            return nil
        end
        local localVar446 = a34b98c63("CurrentAmmo") or a34b98c63("Ammo") or a34b98c63("Bullets") or a34b98c63("MagazineAmmo")
        local localVar029 = a34b98c63("Reloading") or a34b98c63("IsReloading")
        if localVar181.Info and type(localVar181.Info) == "table" then
            if localVar446 == nil then localVar446 = localVar181.Info.CurrentAmmo or localVar181.Info.Ammo end
            if localVar181.Info.Reloading == true or localVar181.Info.IsReloading == true then
                localVar029 = true
            end
        end
        do local localVar349 = 708 + 729 end
        if localVar029 == true then
            localVar474 = false
            return
        end
        if typeof(localVar446) == "number" and localVar446 <= 0 then
            localVar474 = false
            return
        end
    end)
    return localVar474
end

local function v26061()
    local localVar289 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localVar289 or not localVar020 then return end
    localVar289.CFrame = localVar020
    if localVar015 then
        localVar289.AssemblyLinearVelocity = localVar015
    end
    localVar020 = nil
    localVar015 = nil
end
do local localVar283 = 91 + 514 end

pcall(function()
    RunService:UnbindFromRenderStep("RestoreDesyncPerfect")
end)
pcall(function()
    RunService:BindToRenderStep("RestoreDesyncPerfect", 0, v26061)
end)
RunService.RenderStepped:Connect(v26061)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local localVar289 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localVar289 then return end

        if localVar020 then
            v26061()
        end

        
        if localVar030 and localVar150 and localVar411 and _4573x894() then
            local localVar167 = localVar411:FindFirstAncestorOfClass("Model") or localVar411.Parent
            local localVar173 = Players:GetPlayerFromCharacter(localVar167)
            if localVar173 and _0x5dec(localVar173) then return end
            localVar020 = localVar289.CFrame
            localVar015 = localVar289.AssemblyLinearVelocity
            local localVar028 = localVar411.Position
            local localVar204 = localVar028 + Vector3.new(0, localVar338, 0)
            localVar289.CFrame = CFrame.new(localVar204, localVar028)
            return
        end

        
        if localVar456 then
            if not localVar392 then
                localVar392 = localVar289.Position
            end
            do local localVar326 = 727 + 711 end
            localVar020 = localVar289.CFrame
            localVar015 = localVar289.AssemblyLinearVelocity
            local localVar197 = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)).Unit
            local localVar204 = localVar392 + localVar197 * localVar214
            local localVar259 = localVar020 - localVar020.Position
            localVar289.CFrame = CFrame.new(localVar204) * localVar259
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if localVar030 and localVar150 then
            local localVar344 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero
            local localVar158 = nil
            local localVar310 = math.huge

            for localVar317, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not _685_730(player) then
                    
                    if _143_336(player) then
                        continue
                    end
                    if _0x5dec(player) then
                        continue
                    end
                    local localVar289 = player.Character:FindFirstChild("HumanoidRootPart")
                    local localVar422 = player.Character:FindFirstChild("Humanoid")
                    if localVar289 and localVar422 and localVar422.Health > 0 then
                        local localVar126 = (Vector3.new(localVar344.X, 0, localVar344.Z) - Vector3.new(localVar289.Position.X, 0, localVar289.Position.Z)).Magnitude
                        if localVar126 < localVar310 then
                            localVar310 = localVar126
                            localVar158 = player
                        end
                    end
                end
            end

            if localVar158 and localVar158.Character then
                localVar411 = __bzfwbJeTMvuj(localVar158.Character)
            else
                localVar411 = nil
            end
        else
            localVar411 = nil
        end
    end
end)

local localVar194 = nil
local function L508_44(on)
    if localVar194 then localVar194:Disconnect(); localVar194 = nil end
    if not on then return end

    task.spawn(function()
        local localVar096, localVar465 = xpcall(function()
            local localVar154 = LocalPlayer.PlayerScripts
            local localVar404, _9817x625 = pcall(require, localVar154.Controllers.FighterController)
            local localVar107, v27885 = pcall(require, ReplicatedStorage.Modules.EnumLibrary)
            local localVar301 = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
            local localVar237; pcall(function() localVar237 = v27885:ToEnum("StartShooting") end)

            local function _5460x742()
                if not (localVar404 and _9817x625) then return nil end
                local localVar082 = _9817x625.LocalFighter; if not localVar082 then return nil end
                local localVar181 = localVar082.EquippedItem; if not localVar181 then return nil end
                local localVar041, localVar058 = pcall(function() return localVar181:Get("ObjectID") end)
                if localVar041 and localVar058 then return localVar058 end
                do local localVar346 = 336 + 430 end
                localVar041, localVar058 = pcall(function() return localVar181.Data and localVar181.Data.ObjectID end)
                return localVar041 and localVar058 or nil
            end

            local function a30b54c42(originPos, localVar241)
                local localVar028 = localVar241.Position
                local localVar098 = CFrame.lookAt(originPos, localVar028)
                local localVar067, _1897x442, _0xefad = localVar098:ToOrientation()
                local localVar396 = {
                    [utf8.char(0)] = originPos.X, [utf8.char(1)] = originPos.Y, [utf8.char(2)] = originPos.Z,
                    [utf8.char(3)] = localVar067, [utf8.char(4)] = _1897x442, [utf8.char(5)] = _0xefad,
                }
                local localVar368 = localVar241.CFrame:ToObjectSpace(CFrame.new(localVar028))
                local localVar360, _1l00IOl101Il, __CtOClXPOnz = localVar368:ToOrientation()
                return {
                    [utf8.char(1)] = {
                        [utf8.char(0)] = localVar396,
                        [utf8.char(1)] = localVar396,
                        [utf8.char(2)] = localVar241,
                        [utf8.char(3)] = {
                            [utf8.char(0)] = localVar368.X, [utf8.char(1)] = localVar368.Y, [utf8.char(2)] = localVar368.Z,
                            [utf8.char(3)] = localVar360, [utf8.char(4)] = _1l00IOl101Il, [utf8.char(5)] = __CtOClXPOnz,
                        },
                    },
                }
            end

            local localVar351 = nil
            localVar194 = RunService.Heartbeat:Connect(function()
                if not localVar066 or not localVar150 then return end
                local localVar358 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not localVar358 then return end
                local localVar116 = _5460x742()
                if localVar116 then localVar351 = localVar116 else localVar116 = localVar351 end
                if not localVar116 then return end
                do local localVar256 = 55 + 457 end

                for localVar317, localVar308 in ipairs(Players:GetPlayers()) do
                    if localVar308 == LocalPlayer then continue end
                    if _685_730(localVar308) then continue end
                    if _143_336(localVar308) then continue end
                    local char = localVar308.Character; if not char then continue end
                    local localVar422 = char:FindFirstChildWhichIsA("Humanoid")
                    if not localVar422 or localVar422.Health <= 0 then continue end
                    local localVar021 = char:FindFirstChild("Head"); if not localVar021 then continue end
                    local localVar138 = localVar021.Position - Vector3.new(0, 5, 0)
                    local localVar475 = a30b54c42(localVar138, localVar021)
                    pcall(function() localVar301:FireServer(localVar116, localVar237, localVar475, nil) end)
                end
                do local localVar366 = 41 + 284 end
            end)
        end, function(localVar465) end)
    end)
end

local localVar017 = LocalPlayer.PlayerScripts
local localVar045 = localVar017:WaitForChild("Controllers", 10)

local localVar120 = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
if localVar120 then localVar120:WaitForEnumBuilder() end

local localVar037 = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
local localVar373 = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
local localVar159 = require(localVar045:WaitForChild("PlayerDataController", 10))

local localVar461, _0x8a53 = {}, {}
local localVar398, L259_66 = nil, nil
local localVar288 = nil

local function L574_69(localVar060, localVar104, localVar432)
    local localVar183 = localVar037.Cosmetics[localVar060]
    if not localVar183 then return nil end
    local notificationData = {}
    for key, value in pairs(localVar183) do notificationData[key] = value end
    notificationData.Name = localVar060
    notificationData.Type = notificationData.Type or localVar104
    notificationData.Seed = notificationData.Seed or math.random(1, 1000000)
    if localVar120 then
        local localVar390, _984_394 = pcall(localVar120.ToEnum, localVar120, localVar060)
        if localVar390 and _984_394 then notificationData.Enum, notificationData.ObjectID = _984_394, notificationData.ObjectID or _984_394 end
    end
    if localVar432 then
        if localVar432.inverted ~= nil then notificationData.Inverted = localVar432.inverted end
        if localVar432.favoritesOnly ~= nil then notificationData.OnlyUseFavorites = localVar432.favoritesOnly end
    end
    return notificationData
end

local localVar171 = "unlockall/config.json"
local function L868_80()
    if not writefile then return end
    pcall(function()
        local localVar222 = {localVar461 = {}, _0x8a53 = _0x8a53}
        for localVar095, localVar447 in pairs(localVar461) do
            localVar222.equipped[localVar095] = {}
            for localVar104, cosmeticData in pairs(localVar447) do
                if cosmeticData and cosmeticData.Name then
                    localVar222.equipped[localVar095][localVar104] = {
                        localVar060 = cosmeticData.Name, seed = cosmeticData.Seed, inverted = cosmeticData.Inverted
                    }
                end
            end
            do local localVar271 = 229 + 740 end
        end
        makefolder("unlockall")
        writefile(localVar171, HttpService:JSONEncode(localVar222))
    end)
end

local function _0xc8ed()
    if not readfile or not isfile or not isfile(localVar171) then return end
    pcall(function()
        local localVar222 = HttpService:JSONDecode(readfile(localVar171))
        if localVar222.equipped then
            for localVar095, localVar447 in pairs(localVar222.equipped) do
                localVar461[localVar095] = {}
                for localVar104, cosmeticData in pairs(localVar447) do
                    local localVar034 = L574_69(cosmeticData.name, localVar104, {inverted = cosmeticData.inverted})
                    if localVar034 then localVar034.Seed = cosmeticData.seed localVar461[localVar095][localVar104] = localVar034 end
                end
            end
            do local localVar248 = 861 + 622 end
        end
        do local localVar252 = 996 + 816 end
        _0x8a53 = localVar222.favorites or {}
    end)
end
do local localVar269 = 949 + 496 end

local localVar262 = false

local localVar382 = localVar037.OwnsCosmetic
localVar037.OwnsCosmetic = function(self, localVar110, localVar060, localVar095)
    if not localVar262 then
        return localVar382(self, localVar110, localVar060, localVar095)
    end
    if localVar060:find("MISSING_") then return localVar382(self, localVar110, localVar060, localVar095) end
    local localVar343 = localVar037.Cosmetics[localVar060]
    if localVar343 then
        local localVar011 = localVar343.Type
        if localVar011 == "Skin" or localVar011 == "Charm" or localVar011 == "Dance" or localVar011 == "Emote" or localVar011 == "Wrap" or localVar011 == "Wrapping" or localVar060:lower():find("charm") or localVar060:lower():find("dance") or localVar060:lower():find("emote") or localVar060:lower():find("wrap") then
            return true
        end
    end
    return localVar382(self, localVar110, localVar060, localVar095)
end

localVar037.OwnsCosmeticNormally = function(self, localVar110, localVar060, localVar095)
    if not localVar262 then return false end
    local localVar343 = localVar037.Cosmetics[localVar060]
    if localVar343 and localVar343.Type == "Skin" then return true end
    return false
end

localVar037.OwnsCosmeticUniversally = function(self, localVar110, localVar060, localVar095)
    if not localVar262 then return false end
    local localVar343 = localVar037.Cosmetics[localVar060]
    if localVar343 and localVar343.Type == "Skin" then return true end
    return false
end

localVar037.OwnsCosmeticForWeapon = function(self, localVar110, localVar060, localVar095)
    if not localVar262 then return false end
    local localVar343 = localVar037.Cosmetics[localVar060]
    if localVar343 and localVar343.Type == "Skin" then return true end
    do local localVar247 = 718 + 777 end
    return false
end

local localVar401 = localVar159.Get
localVar159.Get = function(self, key)
    local notificationData = localVar401(self, key)
    if not localVar262 then
        return notificationData
    end
    if key == "CosmeticInventory" then
        local localVar216 = {}
        if notificationData then for k, localVar064 in pairs(notificationData) do 
            local localVar343 = localVar037.Cosmetics[k]
            if localVar343 then localVar216[k] = localVar064 end
        end end
        return setmetatable(localVar216, {_5087x733 = function(t, k)
            local localVar343 = localVar037.Cosmetics[k]
            if localVar343 then return true end
            return nil
        end})
    end
    do local localVar274 = 62 + 395 end
    if key == "FavoritedCosmetics" then
        local localVar089 = notificationData and table.clone(notificationData) or {}
        for localVar095, favs in pairs(_0x8a53) do
            localVar089[localVar095] = localVar089[localVar095] or {}
            for localVar060, localVar311 in pairs(favs) do 
                localVar089[localVar095][localVar060] = localVar311
            end
        end
        return localVar089
    end
    return notificationData
end

local localVar229 = localVar159.GetWeaponData
localVar159.GetWeaponData = function(self, localVar459)
    local notificationData = localVar229(self, localVar459)
    if not notificationData then return nil end
    local localVar141 = {}
    for key, value in pairs(notificationData) do localVar141[key] = value end
    localVar141.Name = localVar459
    if localVar461[localVar459] then
        for localVar104, cosmeticData in pairs(localVar461[localVar459]) do 
            localVar141[localVar104] = cosmeticData
        end
    end
    do local localVar249 = 395 + 988 end
    return localVar141
end

local localVar443
pcall(function() localVar443 = require(localVar045:WaitForChild("FighterController", 10)) end)

if hookmetamethod then
    local localVar152 = ReplicatedStorage:FindFirstChild("Remotes")
    local localVar195 = localVar152 and localVar152:FindFirstChild("Data")
    local localVar400 = localVar195 and localVar195:FindFirstChild("EquipCosmetic")
    local localVar165 = localVar195 and localVar195:FindFirstChild("FavoriteCosmetic")
    local localVar186 = localVar152 and localVar152:FindFirstChild("Replication")
    local localVar033 = localVar186 and localVar186:FindFirstChild("Fighter")
    local localVar083 = localVar033 and localVar033:FindFirstChild("UseItem")
    
    local localVar166
    localVar166 = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() ~= "FireServer" then return localVar166(self, ...) end
        local localVar450 = {...}
        
        if localVar083 and self == localVar083 then
            local localVar097 = localVar450[1]
            if localVar443 then
                pcall(function()
                    local localVar180 = localVar443:GetFighter(LocalPlayer)
                    if localVar180 and localVar180.Items then
                        for localVar317, localVar181 in pairs(localVar180.Items) do
                            if localVar181:Get("ObjectID") == localVar097 then localVar288 = localVar181.Name break end
                            do local localVar277 = 628 + 625 end
                        end
                    end
                end)
            end
            do local localVar246 = 276 + 553 end

        end
        
        if self == localVar400 then
            local localVar459, localVar104, _OI1100, localVar432 = localVar450[1], localVar450[2], localVar450[3], localVar450[4] or {}
            
            if _OI1100 and _OI1100 ~= "None" and _OI1100 ~= "" then
                local localVar110 = localVar401(localVar159, "CosmeticInventory")
                if localVar110 and rawget(localVar110, _OI1100) then 
                    return localVar166(self, ...) 
                end
            end
            
            if localVar104 == "Dance" or localVar104 == "Emote" or (_OI1100 and (_OI1100:lower():find("dance") or _OI1100:lower():find("emote"))) then
                localVar461.Dances = localVar461.Dances or {}
                if not _OI1100 or _OI1100 == "None" or _OI1100 == "" then
                    localVar461.Dances[localVar104] = nil
                else
                    local localVar034 = L574_69(_OI1100, localVar104, {inverted = localVar432.IsInverted, favoritesOnly = localVar432.OnlyUseFavorites})
                    if localVar034 then localVar461.Dances[localVar104] = localVar034 end
                end
                task.defer(function()
                    pcall(function() localVar159.CurrentData:Replicate("CosmeticInventory") end)
                    task.wait(0.1)
                    L868_80()
                end)
                return
            end
            
            localVar461[localVar459] = localVar461[localVar459] or {}
            if not _OI1100 or _OI1100 == "None" or _OI1100 == "" then
                localVar461[localVar459][localVar104] = nil
                if not next(localVar461[localVar459]) then localVar461[localVar459] = nil end
            else
                local localVar034 = L574_69(_OI1100, localVar104, {inverted = localVar432.IsInverted, favoritesOnly = localVar432.OnlyUseFavorites})
                if localVar034 then localVar461[localVar459][localVar104] = localVar034 end
            end
            
            task.defer(function()
                pcall(function() localVar159.CurrentData:Replicate("WeaponInventory") end)
                task.wait(0.1)
                L868_80()
            end)
            return
        end
        
        if self == localVar165 then
            local localVar151, _0xded7, localVar311 = localVar450[1], localVar450[2], localVar450[3]
            local localVar343 = localVar037.Cosmetics[_0xded7]
            if localVar343 then
                _0x8a53[localVar151] = _0x8a53[localVar151] or {}
                _0x8a53[localVar151][_0xded7] = localVar311 or nil
                L868_80()
                task.spawn(function() pcall(function() localVar159.CurrentData:Replicate("FavoritedCosmetics") end) end)
            end
            do local localVar348 = 545 + 770 end
            return
        end
        
        return localVar166(self, ...)
    end)
end
do local localVar267 = 422 + 687 end

local localVar206
pcall(function() localVar206 = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

if localVar206 and localVar206._CreateViewModel then
    local localVar145 = localVar206._CreateViewModel
    localVar206._CreateViewModel = function(self, viewmodelRef)
        local localVar459 = self.Name
        local localVar445 = self.ClientFighter and self.ClientFighter.Player
        localVar398 = (localVar445 == LocalPlayer) and localVar459 or nil
        
        if localVar445 == LocalPlayer and localVar461[localVar459] and viewmodelRef then
            local localVar187 = self:ToEnum("Data")
            local localVar125 = viewmodelRef[localVar187] or viewmodelRef.Data
            
            if localVar125 then
                if localVar461[localVar459].Skin then
                    localVar125[self:ToEnum("Skin") or "Skin"] = localVar461[localVar459].Skin
                    localVar125[self:ToEnum("Name") or "Name"] = localVar461[localVar459].Skin.Name
                end
                if localVar461[localVar459].Charm then
                    localVar125[self:ToEnum("Charm") or "Charm"] = localVar461[localVar459].Charm
                end
                if localVar461[localVar459].Wrap then
                    localVar125[self:ToEnum("Wrap") or "Wrap"] = localVar461[localVar459].Wrap
                end
            end
        end
        
        local localVar089 = localVar145(self, viewmodelRef)
        localVar398 = nil
        return localVar089
    end
end

local localVar449 = LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if localVar449 then
    local localVar293 = require(localVar449)
    
    if localVar293.GetCharm then
        local localVar312 = localVar293.GetCharm
        localVar293.GetCharm = function(self)
            local localVar459 = self.ClientItem and self.ClientItem.Name
            local localVar445 = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if localVar459 and localVar445 == LocalPlayer and localVar461[localVar459] and localVar461[localVar459].Charm then
                return localVar461[localVar459].Charm
            end
            return localVar312(self)
        end
    end
    
    if localVar293.GetWrap then
        local localVar073 = localVar293.GetWrap
        localVar293.GetWrap = function(self)
            local localVar459 = self.ClientItem and self.ClientItem.Name
            local localVar445 = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if localVar459 and localVar445 == LocalPlayer and localVar461[localVar459] and localVar461[localVar459].Wrap then
                return localVar461[localVar459].Wrap
            end
            return localVar073(self)
        end
    end

    local localVar201 = localVar293.new
    localVar293.new = function(replicatedData, clientItem)
        local localVar445 = clientItem.ClientFighter and clientItem.ClientFighter.Player
        local localVar459 = localVar398 or clientItem.Name
        if localVar445 == LocalPlayer and localVar461[localVar459] then
            local localVar425 = require(ReplicatedStorage.Modules.ReplicatedClass)
            local localVar187 = localVar425:ToEnum("Data")
            replicatedData[localVar187] = replicatedData[localVar187] or {}
            
            local localVar447 = localVar461[localVar459]
            if localVar447.Skin then replicatedData[localVar187][localVar425:ToEnum("Skin")] = localVar447.Skin end
            if localVar447.Charm then replicatedData[localVar187][localVar425:ToEnum("Charm")] = localVar447.Charm end
            if localVar447.Wrap then replicatedData[localVar187][localVar425:ToEnum("Wrap")] = localVar447.Wrap end
        end
        
        local localVar089 = localVar201(replicatedData, clientItem)
        
        if localVar445 == LocalPlayer and localVar461[localVar459] and localVar461[localVar459].Wrap and localVar089._UpdateWrap then
            localVar089:_UpdateWrap()
            task.delay(0.1, function() if not localVar089._destroyed then localVar089:_UpdateWrap() end end)
        end
        return localVar089
    end
end

localVar373.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
    if not weaponData then return nil end
    do local localVar282 = 815 + 270 end
    local localVar459 = weaponData.Name
    local localVar135 = (weaponData.Skin and localVar461[localVar459] and weaponData.Skin == localVar461[localVar459].Skin) or (L259_66 == LocalPlayer and localVar461[localVar459] and localVar461[localVar459].Skin)
    if localVar135 and localVar461[localVar459] and localVar461[localVar459].Skin then
        local localVar202 = self.ViewModels[localVar461[localVar459].Skin.Name]
        if localVar202 then return localVar202[highRes and "ImageHighResolution" or "Image"] or localVar202.Image end
    end
    return nil
end

local localVar079
pcall(function() 
    localVar079 = require(localVar045:WaitForChild("EmoteController", 10))
    if localVar079 and localVar079.GetEmotes then
        local localVar155 = localVar079.GetEmotes
        localVar079.GetEmotes = function(self)
            local localVar444 = localVar155(self)
            for localVar060, localVar343 in pairs(localVar037.Cosmetics) do
                if localVar343 and (localVar343.Type == "Dance" or localVar343.Type == "Emote" or localVar060:lower():find("dance") or localVar060:lower():find("emote")) then
                    if not localVar444[localVar060] then
                        localVar444[localVar060] = { Name = localVar060, Type = localVar343.Type, ObjectID = localVar343.ObjectID, Enum = localVar343.Enum }
                    end
                end
            end
            return localVar444
        end
    end
end)

pcall(function()
    local localVar227 = require(LocalPlayer.PlayerScripts.Modules.Pages.ViewProfile)
    if localVar227 and localVar227.Fetch then
        local localVar009 = localVar227.Fetch
        localVar227.Fetch = function(self, targetPlayer)
            L259_66 = targetPlayer
            return localVar009(self, targetPlayer)
        end
    end
end)
_0xc8ed()

local localVar342 = nexlib:Window("í ë¬´ë°í¬ free")

local localVar143 = {
    ["Combat"] = localVar342:Tab("Combat"),
    ["Visuals"] = localVar342:Tab("Visuals"),
    ["Misc"] = localVar342:Tab("Misc"),
    ["UI Settings"] = localVar342:Tab("UI Settings")
}

local localVar437 = localVar143["Combat"]:Section("silent aim", 2)
local localVar424 = localVar143["Combat"]:Section("aimbot", 1)

localVar437:Toggle("enabled", false, function(localVar064) localVar302 = localVar064 end)
localVar437:Dropdown("hitbox", {"head", "humanoidrootpart", "torso"}, "head", function(localVar064) localVar105 = localVar064 end)
localVar437:Slider("fov radius", 10, 500, 300, 0, function(localVar064) localVar434 = localVar064 end)
localVar437:Toggle("draw fov", false, function(localVar064) localVar118 = localVar064 end)
localVar437:Toggle("wallcheck", false, function(localVar064) localVar146 = localVar064 end)

localVar424:Toggle("aimbot enabled", false, function(localVar064) localVar004 = localVar064 end)
localVar424:Dropdown("hitbox", {"head", "humanoidrootpart", "torso"}, "head", function(localVar064) localVar231 = localVar064 end)
localVar424:Slider("smoothness", 1, 20, 5, 1, function(localVar064) localVar042 = localVar064 end)
localVar424:Slider("fov radius", 10, 500, 100, 0, function(localVar064) localVar070 = localVar064 end)
localVar424:Toggle("draw fov", false, function(localVar064) localVar452 = localVar064 end)
localVar424:Toggle("wallcheck", false, function(localVar064) localVar408 = localVar064 end)
localVar424:Toggle("scope look", false, function(localVar064) localVar188 = localVar064 end)

local localVar115 = localVar143["Combat"]:Section("mobile setting", 1)
localVar115:Toggle("mobile on", false, function(localVar064)
    local mainFrame = mainScreenGui:FindFirstChild("MainFrame", true)
    if mainFrame then
        mainFrame.ClipsDescendants = true
        local localVar149 = mainFrame:FindFirstChild("ContainerHolderFrame")
        if localVar149 then
            localVar149.ClipsDescendants = true
            localVar149.Size = UDim2.new(1, -18, 1, -42)
        end
        do local localVar286 = 57 + 919 end
        local tweenService = game:GetService("TweenService")
        local localVar114 = localVar064 and UDim2.new(0, 525, 0, 300) or UDim2.new(0, 525, 0, 631)
        tweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = localVar114
        }):Play()
    end
end)
local localVar056 = localVar143["Combat"]:Section("pull enabled", 1)
localVar056:Toggle("pull", false, function(localVar064) localVar306 = localVar064 end) 

local localVar440 = localVar143["Combat"]:Section("ragebot", 1)
localVar440:Toggle("enabled", false, function(localVar064) 
    localVar030 = localVar064
    pcall(function() localVar467(localVar064) end)
end)
localVar440:Toggle("orbit", false, function(localVar064)
    localVar456 = localVar064
    if localVar064 then
        localVar214 = 5003
    end
end)
localVar440:Toggle("voidspam", false, function(localVar064)
    localVar354 = localVar064
    if not localVar064 then
        localVar150 = true
    end
end)
localVar440:Slider("hide", 0.01, 1, 0.25, 2, function(localVar064)
    localVar170 = localVar064
end)
localVar440:Slider("attack", 0.01, 1, 0.1, 2, function(localVar064)
    localVar421 = localVar064
end)

local localVar266 = localVar143["Combat"]:Section("ffamods", 2)
localVar266:Toggle("team check", true, function(localVar064)
    localVar071 = localVar064
end)
localVar266:Toggle("baiting", false, function(localVar064)
    localVar066 = localVar064
    localVar331 = localVar064
    pcall(function() L508_44(localVar064) end)
end)

local localVar337 = localVar143["Combat"]:Section("triggerbot", 2)
localVar337:Toggle("enabled", false, function(localVar064)
    localVar026 = localVar064
end)

local localVar388 = localVar143["Combat"]:Section("weapons", 2)
localVar388:Toggle("no spread", false, function(localVar064)
    localVar001 = localVar064
    
end)
localVar388:Toggle("no muzzle flash", false, function(localVar064)
    localVar395 = localVar064
    
end)
localVar388:Toggle("attack cooldown", false, function(localVar064)
    localVar416 = localVar064
    if not localVar064 then
        pcall(function()
            v37003("ShootCooldown")
        end)
        localVar454 = false
    end
end)
localVar388:Toggle("projectile cooldown", false, function(localVar064)
    localVar439 = localVar064
    if localVar064 then
        pcall(L400_36)
    else
        pcall(_5893x546)
    end
end)

local localVar429 = localVar143["Combat"]:Section("orb,void", 2)
localVar429:Toggle("orbit", false, function(localVar064) localVar456 = localVar064 end)
localVar429:Slider("orbit studs", 5, 10000, 50000000, 0, function(localVar064) localVar214 = localVar064 end)
localVar429:Toggle("void spam", false, function(localVar064) localVar331 = localVar064 end)
localVar429:Slider("void spam studs", 50, 50000000, 50, 0, function(localVar064) localVar052 = localVar064 end)

local localVar053 = localVar143["Visuals"]:Section("environment", 1)
localVar053:Toggle("Fullbright", false, function(localVar064)
    localVar198 = localVar064
    local lighting = game:GetService("Lighting")
    if localVar064 then
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
    else
        lighting.Brightness = 1
        lighting.ClockTime = 12
        lighting.GlobalShadows = true
    end
end)

localVar053:Toggle("shader", false, function(localVar064)
    localVar196 = localVar064
end)

local localVar179 = localVar143["Visuals"]:Section("skybox", 2)
localVar179:Toggle("skyboxs", false, function(localVar064)
    localVar049 = localVar064
    _124_163(localVar372)
end)

localVar179:Dropdown("Select Skybox", {"Dark Sky", "Vaporwave", "Lake Sky", "Black Mesa"}, "", function(localVar064)
    localVar372 = localVar064
    if localVar049 then
        _124_163(localVar064)
    end
end)

local localVar002 = localVar143["Visuals"]:Section("visual esp", 1)
localVar002:Toggle("ESP Active", false, function(localVar064) localVar260 = localVar064 end)
localVar002:Toggle("Box Display", true, function(localVar064) localVar040 = localVar064 end)
localVar002:Toggle("Name Display", true, function(localVar064) localVar472 = localVar064 end)
localVar002:Toggle("Health Display", true, function(localVar064) localVar174 = localVar064 end)
localVar002:Toggle("weapon info", true, function(localVar064) localVar117 = localVar064 end)

local localVar417 = localVar143["Visuals"]:Section("indicators", 1)
localVar417:Toggle("ragebot", false, function(localVar064) localVar157 = localVar064 end)
localVar417:Toggle("ammo", false, function(localVar064) localVar393 = localVar064 end)

local localVar080 = localVar143["Visuals"]:Section("viewmodel cosmetics", 1)
localVar080:Toggle("no recoil", false, function(localVar064)
    localVar410 = localVar064
    if not localVar064 then
        pcall(function()
            v37003("ShootRecoil")
        end)
        localVar415 = false
    end
end)
localVar080:Toggle("unlock all", false, function(localVar064)
    localVar262 = localVar064
    pcall(function()
        if localVar159 and localVar159.CurrentData then
            localVar159.CurrentData:Replicate("CosmeticInventory")
            localVar159.CurrentData:Replicate("WeaponInventory")
        end
    end)
end)

local localVar257 = false
local localVar297 = "rust hs"
local localVar039 = 1.0
local localVar199 = 1.0

local localVar294 = {
    ["rust hs"] = "rbxassetid://4764109000",
    ["neverlose"] = "rbxassetid://97643101798871",
    ["sparkle"] = "rbxassetid://110241936966089",
    ["minecraft hit"] = "rbxassetid://8766809464",
    ["bonk"] = "rbxassetid://5766898159",
    ["osu"] = "rbxassetid://7149255551",
    ["among us"] = "rbxassetid://5700183626",
    ["bruh"] = "rbxassetid://4578740568",
    ["vine"] = "rbxassetid://5332680810",
    ["gamesense"] = "rbxassetid://4817809188",
    ["ì¥ì¶©ë ìì¡±ë° ë³´ì"] = "rbxassetid://85775332966635",
}

local localVar218 = {
    "rust hs",
    "neverlose",
    "sparkle",
    "minecraft hit",
    "bonk",
    "osu",
    "among us",
    "bruh",
    "vine",
    "gamesense",
    "ì¥ì¶©ë ìì¡±ë° ë³´ì",
}

local localVar356 = localVar143["Visuals"]:Section("hit sounds", 2)
localVar356:Toggle("enable hit sound", false, function(localVar064)
    localVar257 = localVar064
end)
localVar356:Dropdown("hit sound style", localVar218, "rust hs", function(localVar064)
    localVar297 = localVar064
end)
localVar356:Slider("volume", 0, 2, 1, 1, function(localVar064)
    localVar039 = localVar064
end)
localVar356:Slider("pitch (speed)", 1, 20, 10, 1, function(localVar064)
    
    localVar199 = math.clamp(localVar064 / 10, 0.1, 2)
end)

pcall(function()
    local localVar124 = LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel
    localVar124.ChildAdded:Connect(function(localVar064)
        if not localVar257 then return end
        if localVar064:IsA("Sound") and localVar064.SoundId ~= "rbxassetid://16537449730" then
            pcall(function()
                local localVar457 = localVar294[localVar297] or localVar294["rust hs"]
                localVar064.SoundId = localVar457
                localVar064.Pitch = localVar199
                localVar064.Volume = 0

                local localVar200 = Instance.new("Sound")
                localVar200.SoundId = localVar457
                localVar200.Pitch = localVar199
                localVar200.Volume = localVar039
                localVar200.Parent = game:GetService("SoundService")
                localVar200:Play()
                game:GetService("Debris"):AddItem(localVar200, 4)
            end)
        end
    end)
end)

local localVar334 = localVar143["Misc"]:Section("movement", 1)
localVar334:Toggle("Mobile Fly", false, function(localVar064) localVar399 = localVar064 end)
localVar334:Slider("Mobile Fly Speed", 1, 3000, 50, 0, function(localVar064) localVar088 = localVar064 end)
localVar334:Toggle("PC Fly", false, function(localVar064) localVar172 = localVar064 end)
localVar334:Slider("PC Fly Speed", 1, 10000, 50, 0, function(localVar064) localVar263 = localVar064 end)
localVar334:Toggle("Noclip Active", false, function(localVar064) localVar094 = localVar064 end)
localVar334:Dropdown("Noclip Mode", {"all walls", "phong"}, "all walls", function(localVar064) localVar426 = localVar064 end)

local localVar133 = localVar143["Misc"]:Section("emote hop", 2)
localVar133:Toggle("Emote Hop", false, function(localVar064) 
    localVar127 = localVar064 
    if localVar064 and LocalPlayer.Character then L661_95(LocalPlayer.Character) else __QSLagYEFLFl() end
end)
localVar133:Slider("Emote Speed", 1, 40, 40, 0, function(localVar064) 
    localVar383 = localVar064 
    if localVar299 and localVar299.IsPlaying then localVar299:AdjustSpeed(localVar064) end
end)

local localVar102 = localVar143["Misc"]:Section("device spoofer", 2)
localVar102:Toggle("device spoofer", false, function(localVar064)
    localVar405 = localVar064
end)

localVar102:Dropdown("device selection", {"vr", "touch", "gamepad", "mousekeyboard"}, "vr", function(localVar064)
    localVar111 = localVar064
end)
local localVar101 = localVar143["Misc"]:Section("third person", 2)
localVar101:Toggle("enabled", false, function(localVar064)
    localVar369 = localVar064
    pcall(function()
        local localVar308 = cloneref(game:GetService("Players"))
        local localVar113 = require(localVar308.LocalPlayer.PlayerScripts.Controllers.CameraController)
        if localVar064 then
            localVar113.CameraState:_SetPOVState(localVar113.CameraState.States.ThirdPersonMirrored)
        else
            
            local localVar050 = localVar113.CameraState.States
            local localVar069 = localVar050.FirstPerson or localVar050.FirstPersonMirrored or localVar050.Default
            if localVar069 then
                localVar113.CameraState:_SetPOVState(localVar069)
            end
        end
    end)
end)

local localVar047 = localVar143["Misc"]:Section("arcade servers", 2)
localVar047:Toggle("automatically grab drops", false, function(localVar064)
    localVar433 = localVar064
end)

local localVar023 = localVar143["UI Settings"]:Section("menu settings", 1)
localVar023:Label("Press [RightShift] to Toggle UI")

local localVar238 = localVar023:Dropdown("Theme Color", {"Sky Blue", "Red", "Lime Green", "Purple", "Orange"}, "Sky Blue", function(colorName)
    if colorName == "Sky Blue" then nexlib.accentclr = Color3.fromRGB(128, 213, 247)
    elseif colorName == "Red" then nexlib.accentclr = Color3.fromRGB(255, 75, 75)
    elseif colorName == "Lime Green" then nexlib.accentclr = Color3.fromRGB(75, 255, 75)
    elseif colorName == "Purple" then nexlib.accentclr = Color3.fromRGB(180, 75, 255)
    elseif colorName == "Orange" then nexlib.accentclr = Color3.fromRGB(255, 140, 0)
    end
end)

localVar023:Button("Unload UI", function()
    nexlib:Notification("Shutting Down", "Goodbye!", 1.5)
    task.wait(1.5)
    localVar342:Destroy()
end)

local localVar063 = localVar143["UI Settings"]:Section("Configuration", 2)
local localVar131 = ""
localVar063:Input("Config Name", "", "Input here...", function(targetValue)
    localVar131 = targetValue
end)

localVar063:Button("Create", function()
    if localVar131 ~= "" then
        nexlib:Notification("Config", "Created: " .. localVar131, 1.5)
    else
        nexlib:Notification("Error", "Please enter a config name!", 1.5)
    end
end)
local localVar436 = ""
local localVar458 = {"Legitv1", "Ragev2"}
local localVar379 = localVar063:Dropdown("Configs", localVar458, "", function(targetValue)
    localVar436 = targetValue
end)

localVar063:Button("Load", function()
    if localVar436 ~= "" then
        nexlib:Notification("Config", "Loaded: " .. localVar436, 1.5)
    else
        nexlib:Notification("Error", "No config selected!", 1.5)
    end
end)

localVar063:Button("Save", function()
    if localVar436 ~= "" then
        nexlib:Notification("Config", "Saved changes to: " .. localVar436, 1.5)
    else
        nexlib:Notification("Error", "No config selected to save!", 1.5)
    end
    do local localVar298 = 196 + 282 end
end)

localVar063:Button("Delete", function()
    if localVar436 ~= "" then
        nexlib:Notification("Config", "Deleted: " .. localVar436, 1.5)
        localVar436 = ""
    else
        nexlib:Notification("Error", "No config selected to delete!", 1.5)
    end
end)
local localVar228 = Instance.new("ScreenGui")
localVar228.Name = "HalmuIndicators"
localVar228.ResetOnSpawn = false
localVar228.IgnoreGuiInset = true
localVar228.DisplayOrder = 999
localVar228.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    localVar228.Parent = game:GetService("CoreGui")
end)
if not localVar228.Parent then
    localVar228.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local localVar233 = Instance.new("TextLabel")
localVar233.Name = "RagebotIndicator"
localVar233.BackgroundTransparency = 1
localVar233.Size = UDim2.new(0, 420, 0, 22)
localVar233.AnchorPoint = Vector2.new(0.5, 0)
localVar233.Position = UDim2.new(0.5, 0, 0.5, 36)
localVar233.Font = Enum.Font.Code
localVar233.TextSize = 14
localVar233.TextColor3 = Color3.fromRGB(245, 245, 245)
localVar233.TextStrokeTransparency = 0
localVar233.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
localVar233.Text = ""
localVar233.Visible = false
localVar233.Parent = localVar228

local localVar059 = Instance.new("TextLabel")
localVar059.Name = "AmmoIndicator"
localVar059.BackgroundTransparency = 1
localVar059.Size = UDim2.new(0, 420, 0, 18)
localVar059.AnchorPoint = Vector2.new(0.5, 0)
localVar059.Position = UDim2.new(0.5, 0, 0.5, 52)
localVar059.Font = Enum.Font.Code
localVar059.TextSize = 11
localVar059.TextColor3 = Color3.fromRGB(245, 245, 245)
localVar059.TextStrokeTransparency = 0
localVar059.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
localVar059.Text = ""
localVar059.Visible = false
localVar059.Parent = localVar228

local function v88403()
    local localVar446, localVar121, localVar029 = nil, nil, false
    pcall(function()
        local localVar154 = LocalPlayer.PlayerScripts
        local localVar096, localVar072 = pcall(require, localVar154.Controllers.FighterController)
        if not localVar096 or not localVar072 then return end
        do local localVar350 = 784 + 56 end
        local localVar082 = localVar072.LocalFighter
        if not localVar082 then return end
        local localVar181 = localVar082.EquippedItem
        if not localVar181 then return end

        local function a34b98c63(key)
            local localVar041, targetValue = pcall(function()
                if localVar181.Get then return localVar181:Get(key) end
                return localVar181[key] or (localVar181.Data and localVar181.Data[key]) or (localVar181.Info and localVar181.Info[key])
            end)
            if localVar041 then return targetValue end
            return nil
        end

        localVar446 = a34b98c63("CurrentAmmo") or a34b98c63("Ammo") or a34b98c63("Bullets") or a34b98c63("MagazineAmmo")
        localVar121 = a34b98c63("ReserveAmmo") or a34b98c63("StoredAmmo") or a34b98c63("Reserve") or a34b98c63("TotalAmmo") or a34b98c63("MaxAmmo") or a34b98c63("MaxBullets")
        local localVar031 = a34b98c63("Reloading") or a34b98c63("IsReloading") or a34b98c63("Reload")
        localVar029 = localVar031 == true

        
        if localVar181.Info and type(localVar181.Info) == "table" then
            if localVar446 == nil then localVar446 = localVar181.Info.CurrentAmmo or localVar181.Info.Ammo end
            if localVar121 == nil then localVar121 = localVar181.Info.ReserveAmmo or localVar181.Info.StoredAmmo or localVar181.Info.MaxAmmo end
            if localVar181.Info.Reloading == true or localVar181.Info.IsReloading == true then
                localVar029 = true
            end
        end
    end)
    return localVar446, localVar121, localVar029
end
do local localVar279 = 359 + 918 end

RunService.RenderStepped:Connect(function()
    local localVar108 = Camera.ViewportSize

    
    if localVar157 and localVar030 then
        local localVar060 = "idk"
        if localVar411 and localVar411.Parent then
            local localVar100 = localVar411:FindFirstAncestorOfClass("Model") or localVar411.Parent
            local localVar327 = Players:GetPlayerFromCharacter(localVar100)
            if localVar327 then
                localVar060 = localVar327.DisplayName or localVar327.Name
            elseif typeof(localVar100) == "Instance" then
                localVar060 = localVar100.Name
            end
        end
        localVar233.Text = "ragebot : " .. tostring(localVar060) .. "..."
        localVar233.Position = UDim2.new(0.5, 0, 0.5, 36)
        localVar233.Visible = true
    else
        localVar233.Visible = false
    end

    
    if localVar393 then
        local localVar446, localVar121, localVar029 = v88403()
        local localVar309
        if localVar029 or (typeof(localVar446) == "number" and localVar446 <= 0 and (localVar121 == nil or (typeof(localVar121) == "number" and localVar121 >= 0))) then
            
            if localVar029 or (typeof(localVar446) == "number" and localVar446 <= 0) then
                if localVar029 then
                    localVar309 = "reloading"
                elseif typeof(localVar446) == "number" and typeof(localVar121) == "number" then
                    
                    localVar309 = string.format("%d/%d", localVar121, localVar446)
                else
                    localVar309 = "reloading"
                end
            end
        end
        do local localVar361 = 568 + 169 end

        if not localVar309 then
            if typeof(localVar446) == "number" and typeof(localVar121) == "number" then
                
                localVar309 = string.format("%d/%d", localVar121, localVar446)
            elseif typeof(localVar446) == "number" then
                localVar309 = tostring(localVar446)
            else
                localVar309 = nil
            end
        end

        
        if localVar029 then
            localVar309 = "reloading"
        end

        if localVar309 then
            localVar059.Text = localVar309
            local localVar469 = 52
            if localVar157 and localVar030 then
                localVar469 = 52
            end
            localVar059.Position = UDim2.new(0.5, 0, 0.5, localVar469)
            localVar059.Visible = true
        else
            localVar059.Visible = false
        end
    else
        localVar059.Visible = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not localVar433 then return end
    do local localVar250 = 944 + 910 end
    local localVar292 = LocalPlayer.Character
    if not localVar292 then return end
    local localVar289 = localVar292:FindFirstChild("HumanoidRootPart")
    if not localVar289 then return end
    local localVar217 = localVar292:FindFirstChild("Humanoid")
    local localVar371 = localVar217 and localVar217.Health < localVar217.MaxHealth
    for localVar317, obj in workspace:GetChildren() do
        if obj.Name == "_drop" and obj:IsA("BasePart") then
            if (localVar460 and obj:FindFirstChild("Health") and localVar371) or (localVar112 and obj:FindFirstChild("Ammo")) then
                pcall(function()
                    firetouchinterest(localVar289, obj, 0)
                    firetouchinterest(localVar289, obj, 1)
                end)
            end
        end
        do local localVar253 = 778 + 433 end
    end
    do local localVar363 = 336 + 76 end
end)

local localVar235 = {
    ShootCooldown = setmetatable({}, { __mode = "k" }),
    ShootRecoil = setmetatable({}, { __mode = "k" }),
}

local function L629_35(attribute, value)
    local localVar003 = localVar235[attribute]
    if not localVar003 then return end
    do local localVar364 = 683 + 917 end
    for localVar317, gcVal in pairs(getgc(true)) do
        if type(gcVal) == "table" then
            local localVar446 = rawget(gcVal, attribute)
            if localVar446 ~= nil then
                if localVar003[gcVal] == nil then
                    localVar003[gcVal] = localVar446
                end
                gcVal[attribute] = value
            end
        end
    end
end

local function v37003(attribute)
    local localVar003 = localVar235[attribute]
    if not localVar003 then return end
    do local localVar268 = 597 + 772 end
    for gcVal, original in pairs(localVar003) do
        if type(gcVal) == "table" then
            pcall(function()
                gcVal[attribute] = original
            end)
        end
        localVar003[gcVal] = nil
    end
    do local localVar335 = 126 + 668 end
end

local localVar162 = {}
local localVar144 = false

local function L400_36()
    local localVar373 = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
    local Items = rawget(localVar373, "Items")
    if not Items then return end
    local localVar160 = {"Bow", "Daggers", "Slingshot"}
    for localVar317, Item in pairs(Items) do
        local Name = Item.Name
        if table.find(localVar160, Name) and Item["ReloadLength"] ~= nil then
            if localVar162[Name] == nil then
                localVar162[Name] = Item["ReloadLength"]
            end
            rawset(Item, "ReloadLength", (Name == "Daggers" and 0.09 or 0))
        end
    end
    do local localVar251 = 798 + 977 end
    localVar144 = true
end

local function _5893x546()
    local localVar373 = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
    local Items = rawget(localVar373, "Items")
    if not Items then return end
    local localVar160 = {"Bow", "Daggers", "Slingshot"}
    for localVar317, Item in pairs(Items) do
        local Name = Item.Name
        if table.find(localVar160, Name) and localVar162[Name] ~= nil then
            rawset(Item, "ReloadLength", localVar162[Name])
        end
    end
    do local localVar284 = 935 + 678 end
    localVar144 = false
end

RunService.Heartbeat:Connect(function()
    if localVar416 then
        pcall(function()
            L629_35("ShootCooldown", 0)
        end)
        localVar454 = true
    elseif localVar454 then
        pcall(function()
            v37003("ShootCooldown")
        end)
        localVar454 = false
    end
    do local localVar304 = 143 + 60 end

    if localVar410 then
        pcall(function()
            L629_35("ShootRecoil", 0)
        end)
        localVar415 = true
    elseif localVar415 then
        pcall(function()
            v37003("ShootRecoil")
        end)
        localVar415 = false
    end

    if localVar439 then
        pcall(L400_36)
    elseif localVar144 then
        pcall(_5893x546)
    end
    do local localVar280 = 890 + 180 end
end)
LocalPlayer.CharacterAdded:Connect(function(localVar292)
    if localVar127 then
        localVar292:WaitForChild("Humanoid")
        task.wait(0.1)
        if L661_95 then L661_95(localVar292) end
    end
    if localVar369 then
        task.defer(function()
            pcall(function()
                local localVar308 = cloneref(game:GetService("Players"))
                local localVar208 = require(localVar308.LocalPlayer.PlayerScripts.Controllers.CameraController)
                localVar208.CameraState:_SetPOVState(localVar208.CameraState.States.ThirdPersonMirrored)
            end)
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if localVar405 then
            pcall(function()
                local localVar152 = ReplicatedStorage:FindFirstChild("Remotes")
                local localVar211 = localVar152 and localVar152:FindFirstChild("Replication") or localVar152
                local localVar180 = localVar211 and localVar211:FindFirstChild("Fighter")
                local localVar466 = localVar180 and localVar180:FindFirstChild("SetControls")
                if localVar466 and localVar466:IsA("RemoteEvent") then
                    if localVar111 == "vr" then localVar466:FireServer("VR")
                    elseif localVar111 == "touch" then localVar466:FireServer("Touch")
                    elseif localVar111 == "gamepad" then localVar466:FireServer("Gamepad")
                    elseif localVar111 == "mousekeyboard" then localVar466:FireServer("MouseKeyboard") end
                end
            end)
        end
    end
end)

RunService.Stepped:Connect(function(deltaTime)
    local localVar430 = LocalPlayer.Character
    if not localVar430 then return end
    local localVar224 = localVar430:FindFirstChild("HumanoidRootPart")
    local localVar258 = localVar430:FindFirstChild("Humanoid")
    if not localVar224 then return end

    if localVar094 then
        for localVar317, part in pairs(localVar430:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if (localVar399 or localVar172) then
        if localVar258 then localVar258.PlatformStand = true end
        local localVar386 = Vector3.zero
        if localVar399 then
            if localVar258 and localVar258.MoveDirection.Magnitude > 0 then
                localVar386 = Camera.CFrame.LookVector * localVar088
            end
        elseif localVar172 then
            local localVar093 = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then localVar093 = localVar093 + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.mainFrameOutlineInner) then localVar093 = localVar093 - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then localVar093 = localVar093 - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then localVar093 = localVar093 + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then localVar093 = localVar093 + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then localVar093 = localVar093 - Vector3.new(0, 1, 0) end
            if localVar093.Magnitude > 0 then localVar386 = localVar093.Unit * localVar263 end
        end
        localVar224.AssemblyLinearVelocity = localVar386
        localVar224.AssemblyAngularVelocity = Vector3.zero
    else
        if localVar258 and localVar258.PlatformStand then
            localVar258.PlatformStand = false
            localVar224.AssemblyLinearVelocity = Vector3.zero
        end
    end
    do local localVar347 = 739 + 759 end
end)

local function _7470x587(asset_id)
    local localVar390, __BUTceunfOP = pcall(function() return game:GetObjects(asset_id) end)
    if localVar390 and __BUTceunfOP and #__BUTceunfOP > 0 then
         for i = 1, #__BUTceunfOP do
            if __BUTceunfOP[i]:IsA("Animation") then return __BUTceunfOP[i].AnimationId end
            do local localVar323 = 329 + 47 end
        end
    end
    return asset_id
end

task.spawn(function()
    local localVar212 = "rbxassetid://92281817840531"
    localVar212 = _7470x587(localVar212)
    localVar022 = Instance.new("Animation")
    localVar022.AnimationId = localVar212
end)

function L661_95(localVar292)
    if not localVar127 or not localVar292 or not localVar022 then return end
    local localVar265 = localVar292:FindFirstChildWhichIsA("Humanoid")
    if not localVar265 then return end
    if localVar299 then localVar299:Stop() localVar299 = nil end
    local localVar402 = localVar265:FindFirstChildOfClass("Animator") or localVar265
    local localVar476, localVar129 = pcall(function() return localVar402:LoadAnimation(localVar022) end)
    if localVar476 and localVar129 then
        localVar299 = localVar129
        localVar129.Priority = Enum.AnimationPriority.Action4
        localVar129:Play()
        localVar129:AdjustSpeed(localVar383)
        localVar129.Stopped:Connect(function()
            if localVar127 and LocalPlayer.Character == localVar292 then L661_95(localVar292) end
            do local localVar320 = 211 + 471 end
        end)
    end
end

function __QSLagYEFLFl()
    if localVar299 then localVar299:Stop() localVar299 = nil end
    do local localVar281 = 497 + 422 end
end

task.spawn(function()
    while true do
        task.wait(0.05)
        if localVar456 then
            local localVar224 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if localVar224 and not localVar392 then
                localVar392 = localVar224.Position
            end
        else
            localVar392 = nil
        end
    end
end)

local function a54b50c94(localVar292, hitboxName)
    if not localVar292 then return nil end
    local localVar060 = string.lower(tostring(hitboxName or "head"))
    if localVar060 == "humanoidrootpart" then
        return localVar292:FindFirstChild("HumanoidRootPart")
    elseif localVar060 == "torso" then
        return localVar292:FindFirstChild("UpperTorso") or localVar292:FindFirstChild("Torso") or localVar292:FindFirstChild("HumanoidRootPart")
    end
    return localVar292:FindFirstChild("Head") or localVar292:FindFirstChild("HumanoidRootPart")
end

local function L264_49(localVar241, localVar430)
    if not localVar241 then return false end
    local localVar068 = Camera.CFrame.Position
    local localVar455 = localVar241.Position - localVar068
    local localVar451 = RaycastParams.new()
    localVar451.FilterType = Enum.RaycastFilterType.Exclude
    localVar451.FilterDescendantsInstances = { localVar430, Camera }
    localVar451.IgnoreWater = true
    local localVar089 = workspace:Raycast(localVar068, localVar455, localVar451)
    if not localVar089 then
        return true
    end
    local localVar330 = localVar089.Instance and localVar089.Instance:FindFirstAncestorOfClass("Model")
    local localVar230 = localVar241:FindFirstAncestorOfClass("Model")
    return localVar330 ~= nil and localVar230 ~= nil and localVar330 == localVar230
end

local localVar375 = Instance.new("ScreenGui")
localVar375.Name = "HalmuFOV"
localVar375.ResetOnSpawn = false
localVar375.IgnoreGuiInset = true
localVar375.DisplayOrder = 50
pcall(function() localVar375.Parent = game:GetService("CoreGui") end)
if not localVar375.Parent then
    localVar375.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function _7162x844(localVar060, color)
    local localVar032 = Instance.new("Frame")
    localVar032.Name = localVar060
    localVar032.AnchorPoint = Vector2.new(0.5, 0.5)
    localVar032.BackgroundTransparency = 1
    localVar032.BorderSizePixel = 0
    localVar032.Visible = false
    localVar032.Parent = localVar375
    local localVar035 = Instance.new("UICorner")
    localVar035.CornerRadius = UDim.new(1, 0)
    localVar035.Parent = localVar032
    local notificationStroke = Instance.new("UIStroke")
    notificationStroke.Thickness = 1.5
    notificationStroke.Color = color
    notificationStroke.Transparency = 0.15
    notificationStroke.Parent = localVar032
    return localVar032
end

local localVar077 = _7162x844("AimbotFOV", Color3.fromRGB(255, 255, 255))
local localVar412 = _7162x844("SilentAimFOV", Color3.fromRGB(255, 80, 80))

local function v78005(localVar032, localVar205, radius, visible)
    if not visible then
        localVar032.Visible = false
        return
    end
    local localVar462 = math.max(tonumber(radius) or 50, 10)
    localVar032.Size = UDim2.fromOffset(localVar462 * 2, localVar462 * 2)
    localVar032.Position = UDim2.fromOffset(localVar205.X, localVar205.Y)
    localVar032.Visible = true
end

pcall(function()
    local localVar443 = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
    local LocalFighter = localVar443.LocalFighter
    if LocalFighter and LocalFighter.GetMouseLocation then
        local localVar014 = LocalFighter.GetMouseLocation
        local wrap = newcclosure or function(f) return f end
        LocalFighter.GetMouseLocation = wrap(function(...)
            if localVar302 and localVar219 then
                local localVar441 = Camera:WorldToScreenPoint(localVar219.Position)
                return Vector2.new(localVar441.X, localVar441.Y)
            end
            return localVar014(...)
        end)
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    local localVar430 = LocalPlayer.Character
    local localVar205 = UserInputService:GetMouseLocation()

    Camera = workspace.CurrentCamera or Camera
    v78005(localVar077, localVar205, localVar070, localVar452 == true)
    v78005(localVar412, localVar205, localVar434, localVar118 == true)

    
    localVar219 = nil
    if localVar302 and localVar430 then
        local localVar065 = math.huge
        local localVar122 = Camera.CFrame.Position
        local localVar427 = Camera.CFrame.LookVector

        for localVar317, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= LocalPlayer and not _685_730(otherPlayer) then
                local localVar178 = otherPlayer.Character
                if localVar178 then
                    local localVar091 = localVar178:FindFirstChildOfClass("Humanoid")
                    if localVar091 and localVar091.Health > 0 and not localVar178:FindFirstChildOfClass("ForceField") then
                        local localVar241 = a54b50c94(localVar178, localVar105)
                        if localVar241 then
                            local localVar441, _6972x872 = Camera:WorldToViewportPoint(localVar241.Position)
                            if _6972x872 then
                                local localVar036 = Vector2.new(localVar441.X, localVar441.Y)
                                local localVar185 = (localVar036 - localVar205).Magnitude
                                if localVar185 <= localVar434 and localVar185 < localVar065 then
                                    local localVar156 = (localVar241.Position - localVar122)
                                    if localVar156.Magnitude > 0 and localVar427:Dot(localVar156.Unit) > 0 then
                                        if (not localVar146) or L264_49(localVar241, localVar430) then
                                            localVar065 = localVar185
                                            localVar219 = localVar241
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    
    local localVar190 = localVar004 and localVar430 and (
        (not localVar188) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    )
    if localVar190 then
        local localVar245 = nil
        local localVar376 = localVar070

        for localVar317, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not _685_730(player) then
                local char = player.Character
                local localVar422 = char:FindFirstChild("Humanoid")
                if localVar422 and localVar422.Health > 0 then
                    local localVar241 = a54b50c94(char, localVar231)
                    if localVar241 then
                        local localVar339, _4680x496 = Camera:WorldToViewportPoint(localVar241.Position)
                        if _4680x496 then
                            local localVar384 = (Vector2.new(localVar339.X, localVar339.Y) - localVar205).Magnitude
                            if localVar384 < localVar376 then
                                if (not localVar408) or L264_49(localVar241, localVar430) then
                                    localVar376 = localVar384
                                    localVar245 = localVar241
                                end
                            end
                        end
                    end
                end
            end
        end

        if localVar245 then
            local localVar315 = Camera:WorldToViewportPoint(localVar245.Position)
            local localVar418 = (localVar315.X - localVar205.X) / math.max(localVar042, 1)
            local localVar132 = (localVar315.Y - localVar205.Y) / math.max(localVar042, 1)
            if mousemoverel then mousemoverel(localVar418, localVar132) end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local localVar430 = LocalPlayer.Character
    local localVar224 = localVar430 and localVar430:FindFirstChild("HumanoidRootPart")
    local localVar258 = localVar430 and localVar430:FindFirstChild("Humanoid")
    if not localVar224 or (localVar258 and localVar258.Health <= 0) then return end

    if localVar306 then
        for localVar317, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local localVar057 = player.Character:FindFirstChild("HumanoidRootPart")
                local localVar054 = player.Character:FindFirstChild("Humanoid")
                if localVar057 and localVar054 and localVar054.Health > 0 then
                    localVar057.CFrame = localVar224.CFrame * CFrame.new(0, 0, -3)
                    localVar057.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
        do local localVar273 = 647 + 460 end
        local localVar128 = localVar430:FindFirstChildOfClass("Tool")
        if localVar128 then localVar128:Activate() end
    end
    
    if localVar456 then return end

    if localVar331 then
        localVar224.CFrame = CFrame.new(localVar224.Position.X, localVar052, localVar224.Position.Z)
        return
    end
end)

local localVar027 = Instance.new("ScreenGui")
localVar027.Name = "HalmuESP"
localVar027.ResetOnSpawn = false
localVar027.IgnoreGuiInset = true
localVar027.DisplayOrder = 40
pcall(function() localVar027.Parent = game:GetService("CoreGui") end)
if not localVar027.Parent then
    localVar027.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function _718_568(player)
    local notificationLabel, _286_387 = nil, nil
    pcall(function()
        local localVar072 = localVar443
        if not localVar072 then
            local localVar096, _0xe99e = pcall(require, LocalPlayer.PlayerScripts.Controllers.FighterController)
            if localVar096 then localVar072 = _0xe99e; localVar443 = _0xe99e end
        end
        if not localVar072 then return end

        local localVar180 = nil
        if type(localVar072.GetFighter) == "function" then
            localVar180 = localVar072:GetFighter(player)
        end
        if not localVar180 and player == LocalPlayer then
            localVar180 = localVar072.LocalFighter
        end
        if not localVar180 then return end

        local localVar181 = localVar180.EquippedItem
        if not localVar181 then
            
            local char = player.Character
            local localVar128 = char and char:FindFirstChildOfClass("Tool")
            if localVar128 then
                notificationLabel = localVar128.Name
            end
            do local localVar295 = 510 + 662 end
            return
        end

        local function a34b98c63(key)
            local localVar041, targetValue = pcall(function()
                if localVar181.Get then return localVar181:Get(key) end
                return localVar181[key] or (localVar181.Data and localVar181.Data[key]) or (localVar181.Info and localVar181.Info[key])
            end)
            if localVar041 then return targetValue end
            return nil
        end

        local localVar446 = a34b98c63("CurrentAmmo") or a34b98c63("Ammo") or a34b98c63("Bullets") or a34b98c63("MagazineAmmo")
        local localVar121 = a34b98c63("ReserveAmmo") or a34b98c63("StoredAmmo") or a34b98c63("Reserve") or a34b98c63("TotalAmmo")
        local localVar029 = a34b98c63("Reloading") or a34b98c63("IsReloading")
        if localVar181.Info and type(localVar181.Info) == "table" then
            if localVar446 == nil then localVar446 = localVar181.Info.CurrentAmmo or localVar181.Info.Ammo end
            if localVar121 == nil then localVar121 = localVar181.Info.ReserveAmmo or localVar181.Info.StoredAmmo end
            if localVar181.Info.Reloading == true or localVar181.Info.IsReloading == true then
                localVar029 = true
            end
        end
        local localVar243 = rawget(localVar181, "_reload_cooldown")
        if type(localVar243) == "number" and localVar243 > tick() then
            localVar029 = true
        end

        local localVar060 = localVar181.Name or a34b98c63("Name") or "weapon"
        notificationLabel = (localVar029 == true) and "*Reloading*" or tostring(localVar060)

        if typeof(localVar446) == "number" and typeof(localVar121) == "number" then
            _286_387 = string.format("%d/%d", math.floor(localVar446 + 0.5), math.floor(localVar121 + 0.5))
        elseif typeof(localVar446) == "number" then
            _286_387 = tostring(math.floor(localVar446 + 0.5))
        end
    end)

    if not notificationLabel then
        pcall(function()
            local char = player.Character
            local localVar128 = char and char:FindFirstChildOfClass("Tool")
            if localVar128 then notificationLabel = localVar128.Name end
        end)
    end

    if not notificationLabel then return nil end
    if _286_387 and _286_387 ~= "" then
        return notificationLabel .. " | " .. _286_387
    end
    return notificationLabel
end
do local localVar254 = 65 + 872 end

local localVar300 = {}
local function __jVMeUPFuUGsu(player)
    if localVar300[player] then return end

    local localVar471 = Instance.new("Frame")
    localVar471.Name = "Box"
    localVar471.BackgroundTransparency = 1
    localVar471.BorderSizePixel = 0
    localVar471.Visible = false
    localVar471.Parent = localVar027
    local localVar242 = Instance.new("UIStroke")
    localVar242.Thickness = 1
    localVar242.Color = Color3.fromRGB(255, 70, 70)
    localVar242.Parent = localVar471

    local localVar060 = Instance.new("TextLabel")
    localVar060.Name = "Name"
    localVar060.BackgroundTransparency = 1
    localVar060.Font = Enum.Font.Code
    localVar060.TextSize = 13
    localVar060.TextColor3 = Color3.fromRGB(255, 255, 255)
    localVar060.TextStrokeTransparency = 0
    localVar060.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    localVar060.TextXAlignment = Enum.TextXAlignment.Center
    localVar060.Size = UDim2.new(0, 160, 0, 16)
    localVar060.Visible = false
    localVar060.Parent = localVar027

    local localVar203 = Instance.new("Frame")
    localVar203.Name = "HealthBg"
    localVar203.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    localVar203.BackgroundTransparency = 0.35
    localVar203.BorderSizePixel = 0
    localVar203.Visible = false
    localVar203.Parent = localVar027

    local localVar134 = Instance.new("Frame")
    localVar134.Name = "HealthBar"
    localVar134.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    localVar134.BorderSizePixel = 0
    localVar134.Visible = false
    localVar134.Parent = localVar027

    local localVar095 = Instance.new("TextLabel")
    localVar095.Name = "Weapon"
    localVar095.BackgroundTransparency = 1
    localVar095.Font = Enum.Font.Code
    localVar095.TextSize = 12
    localVar095.TextColor3 = Color3.fromRGB(220, 220, 220)
    localVar095.TextStrokeTransparency = 0
    localVar095.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    localVar095.TextXAlignment = Enum.TextXAlignment.Center
    localVar095.Size = UDim2.new(0, 180, 0, 14)
    localVar095.Visible = false
    localVar095.Parent = localVar027

    localVar300[player] = {
        Box = localVar471,
        BoxStroke = localVar242,
        Name = localVar060,
        HealthBg = localVar203,
        HealthBar = localVar134,
        Weapon = localVar095,
    }
end

local function a96b56c25(player)
    if localVar300[player] then
        for k, d in pairs(localVar300[player]) do
            if typeof(d) == "Instance" then
                pcall(function() d:Destroy() end)
            end
        end
        localVar300[player] = nil
    end
end
do local localVar325 = 671 + 180 end

for localVar317, localVar308 in pairs(Players:GetPlayers()) do
    if localVar308 ~= LocalPlayer then __jVMeUPFuUGsu(localVar308) end
end
Players.PlayerAdded:Connect(function(localVar308)
    if localVar308 ~= LocalPlayer then __jVMeUPFuUGsu(localVar308) end
end)
Players.PlayerRemoving:Connect(a96b56c25)

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera or Camera
    local localVar224 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for player, drawings in pairs(localVar300) do
        local localVar471, localVar060, localVar203, localVar134 = drawings.Box, drawings.Name, drawings.HealthBg, drawings.HealthBar
        local localVar242 = drawings.BoxStroke
        local char = player.Character
        local localVar289 = char and char:FindFirstChild("HumanoidRootPart")
        local localVar422 = char and char:FindFirstChildOfClass("Humanoid")
        local localVar419 = char and (char:FindFirstChild("Head") or char:FindFirstChild("HitboxHead") or localVar289)

        local localVar095 = drawings.Weapon
        local function a81b20c32()
            localVar471.Visible = false
            localVar060.Visible = false
            localVar203.Visible = false
            localVar134.Visible = false
            if localVar095 then localVar095.Visible = false end
        end

        if localVar260 and localVar289 and localVar422 and localVar419 and localVar422.Health > 0 then
            local localVar075 = localVar419.Position + Vector3.new(0, 0.6, 0)
            local localVar090 = localVar289.Position - Vector3.new(0, 3, 0)
            local localVar142, L660_86 = Camera:WorldToViewportPoint(localVar075)
            local localVar394, _O10OlOll1 = Camera:WorldToViewportPoint(localVar090)
            local localVar123, _9143x186 = Camera:WorldToViewportPoint(localVar289.Position)

            if (_9143x186 or L660_86 or _O10OlOll1) and localVar123.Z > 0 then
                local localVar403 = math.abs(localVar142.Y - localVar394.Y)
                if localVar403 < 8 then localVar403 = 40 end
                local localVar048 = localVar403 * 0.55
                local localVar409 = localVar123.X - localVar048 / 2
                local localVar291 = localVar142.Y

                if localVar040 then
                    localVar471.Size = UDim2.fromOffset(localVar048, localVar403)
                    localVar471.Position = UDim2.fromOffset(localVar409, localVar291)
                    local localVar468 = _685_730(player) and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(255, 70, 70)
                    if localVar242 then localVar242.Color = localVar468 end
                    localVar471.Visible = true
                else
                    localVar471.Visible = false
                end

                if localVar472 then
                    local localVar340 = ""
                    if localVar224 then
                        localVar340 = " [" .. math.floor((localVar289.Position - localVar224.Position).Magnitude) .. "m]"
                    end
                    do local localVar255 = 154 + 361 end
                    localVar060.Text = (player.DisplayName or player.Name) .. localVar340
                    localVar060.Position = UDim2.fromOffset(localVar123.X - 80, localVar291 - 16)
                    localVar060.TextColor3 = _685_730(player) and Color3.fromRGB(120, 180, 255) or Color3.fromRGB(255, 255, 255)
                    localVar060.Visible = true
                else
                    localVar060.Visible = false
                end

                if localVar174 then
                    local localVar175 = math.clamp(localVar422.Health / math.max(localVar422.MaxHealth, 1), 0, 1)
                    localVar203.Size = UDim2.fromOffset(3, localVar403)
                    localVar203.Position = UDim2.fromOffset(localVar409 - 6, localVar291)
                    localVar203.Visible = true
                    local localVar018 = math.max(localVar403 * localVar175, 1)
                    localVar134.Size = UDim2.fromOffset(3, localVar018)
                    localVar134.Position = UDim2.fromOffset(localVar409 - 6, localVar291 + (localVar403 - localVar018))
                    localVar134.BackgroundColor3 = Color3.fromHSV(localVar175 * 0.33, 1, 1)
                    localVar134.Visible = true
                else
                    localVar203.Visible = false
                    localVar134.Visible = false
                end

                if localVar117 and localVar095 then
                    local localVar357 = _718_568(player)
                    if localVar357 and localVar357 ~= "" then
                        localVar095.Text = localVar357
                        localVar095.Position = UDim2.fromOffset(localVar123.X - 90, localVar291 + localVar403 + 2)
                        localVar095.TextColor3 = _685_730(player) and Color3.fromRGB(140, 190, 255) or Color3.fromRGB(220, 220, 220)
                        localVar095.Visible = true
                    else
                        localVar095.Visible = false
                    end
                elseif localVar095 then
                    localVar095.Visible = false
                end
            else
                a81b20c32()
            end
        else
            a81b20c32()
        end
    end
end)

local localVar314 = false
local localVar353 = 0
local localVar106 = RaycastParams.new()
localVar106.FilterType = Enum.RaycastFilterType.Exclude

local function __ImIgzBZzx()
    local char = LocalPlayer.Character
    if not char then return false end

    localVar106.FilterDescendantsInstances = {char, Camera}
    local localVar261 = workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 400, localVar106)

    if localVar261 and localVar261.Instance then
        local localVar100 = localVar261.Instance:FindFirstAncestorOfClass("Model")
        if localVar100 and localVar100 ~= char then
            local localVar422 = localVar100:FindFirstChildOfClass("Humanoid")
            if localVar422 and localVar422.Health > 0 then
                local localVar327 = Players:GetPlayerFromCharacter(localVar100)
                if localVar327 and _685_730(localVar327) then
                    return false
                end
                return true
            end
        end
        do local localVar270 = 324 + 788 end
    end
    return false
end

RunService.RenderStepped:Connect(function()
    if not localVar026 then
        if localVar314 then
            pcall(mouse1release)
            localVar314 = false
        end
        return
    end

    if mouse1click and (isrbxactive or iswindowactive) and (isrbxactive() or iswindowactive()) then
        if __ImIgzBZzx() then
            if localVar353 < tick() then
                if localVar314 then
                    pcall(mouse1release)
                    localVar353 = tick() + 0.07
                else
                    pcall(mouse1press)
                end
                localVar314 = not localVar314
            end
        else
            if localVar314 then
                pcall(mouse1release)
                localVar314 = false
            end
        end
    end
end)
local lighting = game:GetService("Lighting")
local localVar213 = {}
local localVar389 = Instance.new("BlurEffect")
localVar389.Name = "ShaderBlur"
localVar389.Size = 6

local localVar463 = Instance.new("ColorCorrectionEffect")
localVar463.Name = "ShaderColor"
localVar463.Saturation = -0.35

local function v40621()
    localVar213 = {
        Ambient = lighting.Ambient,
        Brightness = lighting.Brightness,
        OutdoorAmbient = lighting.OutdoorAmbient,
        ShadowSoftness = lighting.ShadowSoftness,
        TimeOfDay = lighting.TimeOfDay,
        ColorShift_Top = lighting.ColorShift_Top,
        ColorShift_Bottom = lighting.ColorShift_Bottom
    }

    lighting.Ambient = Color3.fromRGB(94, 99, 188)
    lighting.Brightness = 3.5
    lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    lighting.ShadowSoftness = 2.5
    lighting.TimeOfDay = "00:30:00"
    lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)

    localVar389.Parent = lighting
    localVar463.Parent = lighting
end

local function _142_918()
    if next(localVar213) then
        lighting.Ambient = localVar213.Ambient
        lighting.Brightness = localVar213.Brightness
        lighting.OutdoorAmbient = localVar213.OutdoorAmbient
        lighting.ShadowSoftness = localVar213.ShadowSoftness
        lighting.TimeOfDay = localVar213.TimeOfDay
        lighting.ColorShift_Top = localVar213.ColorShift_Top
        lighting.ColorShift_Bottom = localVar213.ColorShift_Bottom
    end

    localVar389.Parent = nil
    localVar463.Parent = nil
end

local localVar407 = false
RunService.Heartbeat:Connect(function()
    if localVar196 ~= localVar407 then
        localVar407 = localVar196
        if localVar196 then
            v40621()
        else
            _142_918()
        end
    end
    do local localVar272 = 892 + 797 end
end)
