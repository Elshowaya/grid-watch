import Base
import ./tiers.bend as T

# LAW 1: a feeder short in 2027 is never marked OPEN.
law short_2027_never_open:
  for a: Bool
  for c: Bool
  for d: Bool
  for e: Bool
  for t: Bool
  {T.is_open(T.classify(T.Sig{a, True{}, c, d, e, t})) == False{} : Bool}

# LAW 2: a feeder short in 2027 is never hidden as merely TIGHT.
law short_2027_never_tight:
  for a: Bool
  for c: Bool
  for d: Bool
  for e: Bool
  for t: Bool
  {T.is_tight(T.classify(T.Sig{a, True{}, c, d, e, t})) == False{} : Bool}

# LAW 3: PERSISTENT means short in every year 2026-2030, and nothing else.
law persistent_iff_all_short:
  for s: T.Signals
  {T.is_persistent(T.classify(s)) == T.all_short(s) : Bool}

# LAW 4: OPEN means no shortfall in any year and not loaded >= 90%, and nothing else.
law open_iff_clean:
  for s: T.Signals
  {T.is_open(T.classify(s)) == T.clean(s) : Bool}
