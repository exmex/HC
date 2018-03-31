using System;
using System.Collections.Generic;
using System.Linq;

namespace GameServer.Utils
{
    public static class ByteArrayExtension
    {
        public static string HexDump(this byte[] buffer, int offset = 0)
        {
			var hexDump = "";
            var j = 0;
            const int bytesPerLine = 16;

            hexDump = hexDump + "|--------|-------------------------------------------------|------------------|" + Environment.NewLine;
            hexDump = hexDump + "| S: "+buffer.Length.ToString().PadRight(4)+"| 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F  | Text             |" + Environment.NewLine;
            hexDump = hexDump + "|--------|-------------------------------------------------|------------------|" + Environment.NewLine;
            int count = 0, cur = 0;
            String left = "", right = "";
            foreach (byte b in buffer) {
                if (cur >= offset) {
                    if (count >= 16) {
                        hexDump = hexDump + $"| {j++ * bytesPerLine:d6} | {left}| {right} |" + Environment.NewLine;

                        left = "";
                        right = "";
                        count = 0;
                    }

                    left += $"{b:X2} ";
                    if (b >= 32 && b <= 255)
                        right += (char)b;
                    else
                        right += ".";

                    count++;
                } else
                    cur++;
            }

            if (count > 0)
                hexDump = hexDump + $"| {j++ * bytesPerLine:d6} | {left.PadRight(48)}| {right.PadRight(16)} |" + Environment.NewLine;
            hexDump = hexDump + "|--------|-------------------------------------------------|------------------|";
            return hexDump;
            /*const int bytesPerLine = 16;
            var hexDump = "";
            var j = 0;
            foreach (var g in buffer.Select((c, i) => new {Char = c, Chunk = i / bytesPerLine}).GroupBy(c => c.Chunk))
            {
                var s1 = g.Select(c => $"{c.Char:X2} ").Aggregate((s, i) => s + i);
                string s2 = null;
                var first = true;
                foreach (var c in g)
                {
                    var s = $"{(c.Char < 32 || c.Char > 122 ? '·' : (char) c.Char)} ";
                    if (first)
                    {
                        first = false;
                        s2 = s;
                        continue;
                    }
                    s2 = s2 + s;
                }
                var s3 = $"{j++ * bytesPerLine:d6}: {s1} {s2}";
                hexDump = hexDump + s3 + Environment.NewLine;
            }
            return hexDump;*/
        }
    }
}