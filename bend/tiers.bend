import Base

# Grid Watch tier rules, mirrored from pipeline/pge_grip.py.
# Each flag is computed in Python from PG&E GRIP data:
#   s26..s30: effective headroom < 0 MW in that year
#   tight:    peak loading >= 90% of rating in 2026/2027
type Signals is Data:
  Sig{s26: Bool, s27: Bool, s28: Bool, s29: Bool, s30: Bool, tight: Bool}

type Tier is Data:
  Persistent{}
  ConstrainedNow{}
  Tight{}
  Emerging{}
  Open{}

def pick_short(+all5: Bool) -> Tier:
  match all5:
    case True{}:
      Persistent{}
    case False{}:
      ConstrainedNow{}

def pick_later(+later: Bool) -> Tier:
  match later:
    case True{}:
      Emerging{}
    case False{}:
      Open{}

def pick_tight(+tight: Bool, +later: Bool) -> Tier:
  match tight:
    case True{}:
      Tight{}
    case False{}:
      pick_later(later)

def pick(+near: Bool, +all5: Bool, +tight: Bool, +later: Bool) -> Tier:
  match near:
    case True{}:
      pick_short(all5)
    case False{}:
      pick_tight(tight, later)

def all_short(+s: Signals) -> Bool:
  match s:
    case Sig{+a, +b, +c, +d, +e, +t}:
      a && b && c && d && e

def classify(+s: Signals) -> Tier:
  match s:
    case Sig{+a, +b, +c, +d, +e, +t}:
      pick(a || b, a && b && c && d && e, t, c || d || e)

def is_open(+t: Tier) -> Bool:
  match t:
    case Open{}:
      True{}
    case _:
      False{}

def is_persistent(+t: Tier) -> Bool:
  match t:
    case Persistent{}:
      True{}
    case _:
      False{}

def is_tight(+t: Tier) -> Bool:
  match t:
    case Tight{}:
      True{}
    case _:
      False{}

# clean: no shortfall in any year and not loaded >= 90%
def clean(+s: Signals) -> Bool:
  match s:
    case Sig{+a, +b, +c, +d, +e, +t}:
      Bool.not(a || b || c || d || e || t)

def tier_code(+t: Tier) -> U32:
  match t:
    case Persistent{}:
      0
    case ConstrainedNow{}:
      1
    case Tight{}:
      2
    case Emerging{}:
      3
    case Open{}:
      4
