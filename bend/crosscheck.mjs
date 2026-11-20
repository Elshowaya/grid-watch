// Cross-check: Bend's proven classify() vs the Python tiers in the latest snapshot.
import fs from 'fs';
import T from './tiers.mjs';
const csvPath = process.argv[2];
const lines = fs.readFileSync(csvPath, 'utf8').trim().split('\n');
const hdr = lines[0].split(',');
const names = ['PERSISTENT','CONSTRAINED_NOW','TIGHT','EMERGING','OPEN'];
// naive CSV split that respects quotes
const split = s => s.match(/("([^"]|"")*"|[^,]*)(,|$)/g).map(x => x.replace(/,$/,'').replace(/^"|"$/g,''));
let agree = 0, mismatch = [];
for (const line of lines.slice(1)) {
  const r = Object.fromEntries(split(line).map((v,i)=>[hdr[i],v]));
  const neg = y => r['eff_headroom_'+y] !== '' && parseFloat(r['eff_headroom_'+y]) < 0;
  const pct = r.peak_pct_2027 === '' ? null : parseFloat(r.peak_pct_2027);
  const sig = {$:'Sig', s26:neg(2026), s27:neg(2027), s28:neg(2028), s29:neg(2029), s30:neg(2030), tight: pct !== null && pct >= 90};
  const bend = names[T.tier_code(T.classify(sig))];
  if (bend === r.tier) agree++; else mismatch.push([r.feeder, r.tier, bend, r.eff_headroom_2026, r.eff_headroom_2027, r.peak_pct_2027]);
}
console.log(JSON.stringify({feeders: lines.length-1, agree, mismatches: mismatch.length, sample: mismatch.slice(0,10)}, null, 1));
