// =============================================
// MZI Insulation Chamber v6 (rev F) — fused base, banded-wall stack,
// BOTH-±X windows, no clamping frame
// =============================================
// 3D-printable modular chamber for dual-wavelength MZI droplet experiment.
//
// GLOBAL COORDINATES: origin = droplet fall line ∩ beam focus (Z=0).
//   Beam plane = window center = Z 0. Substrate top at −aperture/4.
//
// v6 rev D (USER-DIRECTED redesign):
//   • Bottom frame 60×60×10 and the 6mm hollow trumpet are FUSED into ONE
//     BaseModule (Z∈[−33,−17]; rev O — was [−36,−20], then [−33,−20] in
//     rev G, see the rev G and rev O blocks).
//     The frame is a HOLLOW WELL (bore 50.4 × 52.2 since rev J): bottom open,
//     the 50 × 51.8 copper block slides in from below (0.2/side) and protrudes
//     3.8 mm onto the TEC (rev K: was 3; the block is 10.8 thick, see plate_t).
//   • FIXED loft mismatch: the square bottom (4 pts) must loft to the
//     pentagon (5 pts) — lo_sq/lo_in now carry a collinear midpoint on the
//     bottom edge so every top cross-section is the full pentagon and the
//     Base top ring mates EXACTLY with the Pent bottom.
//   • UNIFORM wall thickness 5 mm over the entire Pent/TopCap (and Base top
//     ring) — the old 3 mm mid-section was kept only for brass inserts that
//     no longer exist. Groove + peg sockets now sit fully inside the wall.
//   • NO screws / bolts / brass inserts anywhere in the stack — the corner
//     insert bores (air-leak paths) and the ear lugs are REMOVED.
//   • The two joints keep ONLY a light anti-slip interlock: gasket groove
//     ring + 2×Ø3 pegs 榫 into sockets 卯, centred mid-wall (poke-out fix).
//     (rev G: Ø3 was too fat once the groove became a real 2 mm slot and it
//      was cutting the groove — pegs are Ø2.4 on the inner land now.)
//   • External WRAP FRAME (user option A) pressed the stack — REMOVED in
//     rev F at the user's direction; see the rev F block below.
//   • TopCap = closed pentagon lid with SOLID 3 mm roof and a single Ø5
//     round needle/syringe hole on the drop axis (fix: roof was being
//     carved away by the wall cut-out).
// v6 rev E (USER FEEDBACK #2 — thicker seal rings, thicker trumpet, thicker
//   gas layer, correct windows):
//   • JOINT rings are now 7 mm thick (pc_j profile) at every module interface
//     and at the Base trumpet top. The observation mid-section stays 5 mm
//     (pc_inn). PentModule carves a banded cavity: JOINT ring 0..6,
//     observation mid 6..22, JOINT ring 22..28 — so it presents a full 7 mm
//     seal face up AND down.
//   • Trumpet thickened: inner loft now starts at 40×40 (wall 10 at the
//     well) and converges to the 7 mm JOINT ring at the top (was 50.4→5).
//   • Thicker sealed gas layer: gasket groove deepened 1.2→1.6 mm and
//     widened (0.86..0.94 scale band), the top cap raised h_top 8→10 mm
//     (cap Z∈[+8,+18]) so the sealed gas column above the droplet is taller.
//     ⚠ CORRECTED IN rev G — the "deepened / widened" half of this claim is
//     VOID. The groove was a SCALED ring (see GrooveRing), so its width
//     tracked the local reach from the centroid: measured 0.92 mm on the
//     diagonal vs 1.32 mm on +Y, against a nominal 0.86..0.94 scale band.
//     A Ø2.0 gasket cord cannot enter 0.92 mm, so the joint faces were held
//     apart and NO gasket compression ever existed. Only the h_top 8→10 mm
//     part was real — and the sealed gas column is the CAVITY (h_top − cp_t),
//     not the groove depth.
//   • Windows fixed: the Φ10 aperture was centred at x=−20 and only spanned
//     the −X half (x∈[−40.02,0]) — it never bored the +X face. It now spans
//     BOTH faces (centre x=−3, length half+hx_f=34.02 → x∈[−20.01,14.01]).
//     Both seat cups now sit centred on the faces: +X at x=13 (12..14),
//     −X at x=−19 (−20..−18), each 2 mm deep, glass flush.
//   • Pedestal ribs shortened to the ±X/−Y faces reach 13 and thinned to
//     live inside the bottom JOINT ring band (z 0..6); the +X rib is dropped
//     — the pedestal (Ø16) already merges with the +X wall in the ring band
//     (inner +X reach 7 < pedestal radius 8).
//   • +X face at X=14 (flat window seat); diagonal (0,−20)–(14,−7) hugs the
//     obstacle hypotenuse Y = 1.25·X − 25.
//   • Windows: 0.5″ Ø12.7 glass recessed flush in the 2 mm seat (3 mm wall
//     backing), RTV-106 / O-ring rim seal, no protruding hardware.
//   • Rod chain (global Z): rod −26…−6 free through the open channel
//     (Ø10×20 stock, sitting DIRECTLY on the copper block top at −26; the
//     50×50×3 copper shim was deleted in rev G), guided by the pedestal Φ12
//     bore; substrate disc Z∈[−6,−2.5] on pedestal top.
//   • PentModule has NO bottom floor — pedestal Ø16 braced by 3 radial ribs
//     to the cavity walls so it prints as one piece.
//
// v6 rev F (2026-09-10 — render-error root cause + user-directed changes):
//   • ROOT CAUSE of "Object may not be a valid 2-manifold and may need
//     repair!" (Simple: no, Volumes: 6) on PentModule: each of the 3 pedestal
//     brace ribs ended EXACTLY on the Ø16 pedestal surface (±8 = ped_d/2). A
//     flat end face tangent to a cylinder is a zero-area LINE contact, which
//     CGAL cannot represent as a 2-manifold. Every rib now overlaps 2 mm into
//     the pedestal. Verified by A/B render: Simple: yes, warning gone.
//     (BaseModule / TopCapModule / FramePosts / FramePlate were already
//     clean — only PentModule ever failed.)
//   • WINDOWS: all three X-axis bores were missing `center = true`, so each
//     grew only ONE way from its translate() X. The Ø10 aperture actually cut
//     x ∈ [−3,+32] instead of [−20.5,+14.5] → the −X wall was NEVER bored and
//     the −X seat stopped 1 mm short of the face (the +X seat was likewise
//     only ~1 mm deep, not 2). With `center = true` BOTH ±X faces now get the
//     symmetric Ø10 through-bore plus a Ø12.7 × 2 mm seat that opens on the
//     outer face, so the 0.5″ glass drops in from OUTSIDE, flush, RTV/O-ring
//     rim seal.
//   • PegSockets cut DOWNWARD from zface, but both call sites pass a BOTTOM
//     face whose material is above it → the 卯 pockets never existed and the
//     榫 tenons would have crashed into the mating flat faces on assembly.
//     They now cut upward.
//   • TopCap gasket groove: GrooveRing cut DOWNWARD from z=0 on a part whose
//     material is above z=0, so the intended 1.6 mm groove was really 0.01 mm.
//     GrooveRing gained a `dir` parameter (default −1 = old behaviour, still
//     used by Base); the TopCap now passes dir = 1.
//   • FramePosts() + FramePlate() + every fr_* global + z_plate_bot REMOVED
//     (user-directed). The stack now carries NO clamping hardware at all —
//     rev G replaces it with a printed retainer cage; see the CLAMPING note
//     in the parameter block.
//
// v6 rev G (2026-09-10 — gasket groove, joint profile, no-shim chain):
//   • pc_j (the 7 mm JOINT-ring inner profile) had TWO WRONG VERTICES. It was
//     supposed to be a true 7 mm perpendicular offset of pent_outer, but its
//     diagonal ran at slope 0.500 instead of 0.929, so the seal ring pinched
//     from the intended 7.00 mm down to 3.54 mm at the (7,−8.674) corner —
//     a 49% thinning — and the trumpet's inner loft was twisted with it.
//     Recomputed from the edge equation 13x − 14y − (280 − 19.105·d) = 0 at
//     d=7; pc_inn (d=5) was checked against the same formula and is correct
//     to 0.004 mm, so only pc_j was wrong. Now uniform 7.00 mm.
//   • GrooveRing REWRITTEN. It used two SCALED copies of the face polygon
//     (`_sc(poly, 0.86)` inside `_sc(poly, 0.94)`), and — because
//     difference(){A;B;C} subtracts the UNION of B and C — the 0.86 copy was
//     dead code anyway. The result was a groove whose width varied with the
//     local reach from the centroid AND had no outer retaining land. It is
//     now an ABSOLUTE-width rectangular ring built with offset(delta=), a
//     true mitered perpendicular inset: jg_lw outer land, jg_gw wide, jg_d
//     deep, identical on all five faces. Render-verified: the vertices at the
//     −X face are exactly {−20, −19.2, −17.2} → 0.8 land + 2.000 groove.
//   • Anti-slip pegs moved OFF the groove. At x=−17.5 (2.5 mm in from the
//     face) the Ø3 peg spanned 1.0..4.0 mm and cut straight through the new
//     groove band (0.8..2.8). Now Ø2.4 centred 4.9 mm in (x=−15.1 / y=+15.1):
//     peg spans 3.7..6.1, socket Ø2.8 spans 3.5..6.3 → 0.7–0.9 mm clearance
//     to both the groove and the 7 mm ring's inner edge.
//   • 50×50×3 copper SHIM DELETED (user: "垫片不存在，涂导热油脂即可"). The
//     shim used to fill the 3 mm between the copper top (−29) and the frame
//     well ceiling (−26); removing it without compensation would have dropped
//     the whole chamber 3 mm and destroyed the optical alignment (window
//     centre is pinned at Z=0). Instead the BASE absorbs it: frame_h is now
//     DERIVED as plate_t − z_cop = 7, which makes z_cop_top ≡ z_frame_top by
//     construction, so the ceiling lands exactly on the copper's top face.
//     trans_h stays 6, the pentagon stays −20..+8, and the Ø10×20 rod is
//     unchanged — the copper block simply rises 3 mm (now −36..−26) and the
//     well becomes 7 mm deep instead of 10.
//     (rev O: trans_h 6 → 9, pentagon −20..+8 → −17..+8 — the 3 mm below
//     the aperture are absorbed because the as-built copper block runs short;
//     see the rev O block in the vertical chain.)
//   • Metal stack below the copper (preview ghosts): TEC 40×40×tec_t, water
//     block 40×40×9.5, two Ø9.5×15 barb fittings on the block's SIDE face.
//     The barb OD equals the block thickness, so the barb axis is at the
//     block's mid-height (−44.55) and it spans the full block height with no
//     Z conflict (user clarification). NOTE: the barbs sit at Z≈−44.6, well
//     BELOW the obstacle band (Z∈[−26,+26]), so the wedge does NOT constrain
//     their azimuth — only the retainer columns and tube routing do.
//   • OPEN: the printed retainer cage (the user's chosen replacement for RTV
//     glue) is NOT yet modelled here — see the CLAMPING note in the parameter
//     block. Z envelope and column positions are settled; geometry pending.
//
// v6 rev H (2026-09-10 — gasket grooves on BOTH faces, same-side barbs):
//   • GASKET GROOVES are now cut into BOTH faces of every joint (user-directed:
//     "凹槽容纳胶条时，应该是上下两个面都有槽"). Previously only the Base top
//     face and the TopCap underside carried a ring; the Pent's two joint faces
//     were flat, so the cord could only ever sink one way.
//   • The defect this exposed was the DEPTH, not the count. Silicone is
//     effectively incompressible (bulk modulus ~1 GPa), so the groove cavity
//     must be able to contain the cord's entire cross-section:
//         w · D  ≥  π·(jg_cord/2)²  = 3.1416 mm²
//     The rev-G groove was 2.0 × 1.5 = 3.00 mm² — 4.7 % SHORT — so the rubber
//     had nowhere to go and could only compress volumetrically (K·ΔV/V ≈
//     1 GPa × 0.047 ≈ 47 MPa). The rev-G comment sold that as "fully
//     constrained rubber, a proper static face seal"; it was a defect.
//     Now D = 1.6 total = 0.800 in EACH face → squeeze 20 %, fill 98.2 %,
//     just under the limit so the rubber still has void to deform into.
//   • Groove width is unchanged at 2.0 (= cord dia), so the 0.8..2.8 band and
//     the peg/socket clearance (0.7–0.9 mm) are untouched — no peg rework.
//   • Free-state stand-off is now 0.4 mm (was 0.5). The self-limiting load
//     path is unchanged: the screws close 0.4 mm, then the well ceiling
//     hard-stops on the copper at −26 and all further force becomes TEC preload.
//   • ⚠ 98.2 % fill puts the assembly force at the HIGH end of the
//     1.0–1.5 N/mm estimate, so the TEC preload may exceed the 150 kPa
//     ceiling. This is NOT settleable on paper (±50 %) — measure it on the
//     first assembly. If it is over, widen jg_gw to 2.6 (fill 75 %) and shrink
//     the pegs to Ø1.6 to keep them clear of the wider band.
//   • BARBS: both on the SAME side face — barb_az = 0 (+X), offsets ±10 mm →
//     20 mm centre-to-centre (user-specified). This replaced the placeholder
//     [0,180] opposite layout. Consequence: two barbs on ONE face sweep a much
//     wider sector than two on opposite faces, and at tip radius 35 mm they
//     come within 5.10 mm of the (−36,±15) retainer columns (8.75 mm needed)
//     → −X is a HARD COLLISION and ±Y leave only 1.3 mm, too little to route a
//     Ø8 tube. +X is the only clear side, which dovetails with the obstacle
//     wedge already denying +X to the columns. Z is unaffected: barb_d 9.5 ==
//     wb_t 9.5, so each barb spans exactly the block height (−49.30..−39.80)
//     — confirmed off the render as z = −44.55 + 4.75·sin θ.
//
// v6 rev I (2026-09-10 — EXTERNAL INSULATION FILM, thin solid walls):
//   • INSULATION STRATEGY CHANGED, and this supersedes every earlier scheme.
//     The internal hollow-wall idea (peg islands + a sealed gas void ring) is
//     DROPPED, and so is the outward-growth variant. The chamber wall is now
//     simply a THIN SOLID, insulated from OUTSIDE by a self-adhesive
//     aerogel felt: 富立仕 保温隔热气凝胶毡, 3 mm, single-sided aluminium foil
//     + adhesive backing (listing also says 铝箔防水防火隔音纳米保温棉).
//     WHY THIS WINS. For a solid ASA wall the two SURFACE FILMS dominate:
//     at h = 6 W/m²K they are 2/6 = 0.333 m²K/W, i.e. 77–92 % of the whole
//     path, so hollowing the core buys almost nothing — and it eats cavity
//     radius on every side. Insulation must go where the film resistance is
//     small, and that is OUTSIDE, where the polished foil also suppresses the
//     radiation component (ε ≈ 0.05 → h_out ≈ 4, not 8–10).
//         assembly U [W/m²K]:  5 mm solid wall     2.242
//                              3 mm solid wall     2.302   (worse — see below)
//                              3 mm wall + 3 mm aerogel (k=0.018)   1.664
//     So the film BEATS the abandoned 2+6+2 hollow (1.707) while costing ZERO
//     cavity volume. ⚠ Compressing the wall is NOT a thermal measure: on its
//     own it makes the wall 3 % WORSE (the wall is a small part of the path).
//     It is purely a VOLUME measure — see the next bullet.
//   • WALLS COMPRESSED, outer profile FROZEN (half 20 / hx_f 14 / fc_y −7 are
//     untouched, and the existing outer dimensions are a USER CONSTRAINT):
//       w_c  5 → 3   observation mid-section  (was the rev E "uniform 5")
//       w_j  7 → 5   JOINT ring (both interfaces + the trumpet top)
//     The binding floors, both verified before the change:
//       w_c ≥ 3 : the Ø13.1 × 2 mm window seat is cut from the OUTER face, so
//                 the seat floor = w_c − win_r. At 3.0 that floor is exactly
//                 1.000 mm (measured over the whole arc swept by the pocket,
//                 not just at Y=0). At 2.5 it would be 0.5 mm and the seat
//                 would break through. NOTE there is no pressure differential
//                 across the windows (the Ø5 needle hole is deliberately
//                 unsealed), so this floor carries no load — it is a spacer.
//       w_j ≥ 5 : the Ø2.8 peg socket needs a 1.0 mm land on each side.
//     ⚠ The rev G/H peg centres (4.9 mm in from the outer face) are IMPOSSIBLE
//     on a 5 mm ring: the Ø2.8 socket spans 3.5..6.3, i.e. 1.3 mm PAST the
//     inner edge, so the 卯 would have opened into the cavity. pent_pins moved
//     to 2.5 mm in → socket spans 1.1..3.9, 1.1 mm land each side.
//   • CAVITY AIR VOLUME 22.27 → 31.94 mL, +43.4 %. Same accounting both
//     times (trumpet loft + pentagon bands + cap hollow, MINUS the pedestal,
//     3 ribs, substrate disc and rod that occupy the cavity):
//                                      OLD          NEW
//         observation mid A [mm²]      664.2        883.1
//         trumpet inner                5.98         8.52 mL
//         pentagon bands              16.43        22.23 mL
//         top-cap hollow               3.33         4.65 mL
//         cavity air                  22.27        31.94 mL
//     ⚠ The FIRST run of this check reported 20.27 → 29.93 mL (+47.7 %).
//     Both those figures were WRONG: the pedestal was subtracted GROSS
//     (D16 × 14 = 2814.9 mm³) although a 12×12 rod bore is cut through it.
//     At w_j = 5 that over-subtracts (bore ∩ D16 area) × 14 = 1979 mm³, i.e.
//     ~2.0 mL, from BOTH columns. Corrected above. An independent accounting
//     straight off the rendered STLs — pentagon prism 35.532 mL minus the
//     measured pent material 13.757 mL, plus the mesh cap hollow — gives
//     32.76 mL, higher by exactly the sealed window pockets (0.54 mL) and the
//     Ø10 aperture through the seat floor (0.16 mL), which the model here
//     excludes because they sit behind the glass. So the two methods agree
//     to ~0.1 mL on the AIR the vapour can actually reach.
//     Vapour-saturation check (see 2026-08-24_large_cavity_first_droplet_method.md):
//     the real droplet is R_contact 0.75 mm at θ 85° (mzi_fringe_simulator.py
//     defaults) → V_drop 0.777 µL → V_sat 0.431 mL, so χ < 5 % needs only
//     8.6 mL. 31.94 mL gives χ ≈ 1.35 % — a 3.7× margin.
//   • TRUMPET inner enlarged to match (USER: "喇叭口适应修改"): lo_in ±20 → ±24.
//     The 40×40 well opening was sized for the old, much smaller pentagon
//     cavity; with the pentagon opened up it was needlessly necking the cavity
//     down. ±24 keeps a 1.2 mm seating ledge on the X sides of the well bore
//     and 2.1 mm on Y (rev J widened Y), keeps the trumpet wall at 6 mm at the
//     well (≥ w_j 5), and stays clear of the copper block (top face at −26) by
//     1.0 mm/side on X and 1.9 mm/side on Y.
//   • GASKET GROOVES DELETED ENTIRELY (USER: "删槽"). The whole jg_* parameter
//     set, the GrooveRing module and all four call sites are gone, and both
//     faces of both joints are FLAT. Consequence, stated plainly: the stack is
//     no longer gas-tight by itself, and the free-state stand-off that the rev
//     H self-limiting chain relied on (0.4 mm proud) no longer exists — the
//     faces now meet metal-to-metal. This is consistent with 方案 C (大腔首滴,
//     open chamber, unsealed Ø2 mm-class needle hole) where leakage is
//     negligible over a 100–300 s droplet lifetime, but it does mean the
//     chamber relies on the retainer cage alone for location instead of
//     cord + 榫. The 榫 tenons are retained and are now the ONLY registration.
//   • PLA → ASA throughout (USER). ASA: k ≈ 0.17 W/m·K, glass transition
//     ≈ 105 °C, far better UV/creep resistance than PLA — but it needs an
//     enclosed printer and a heated bed at ~90–100 °C.
//   • ObstacleGhost was WRONG and is fixed: it drew a quad built from mixed
//     +n/−n offsets (so a self-intersecting, concave shape on the FREE side of
//     the wedge) and its comment had the slope sign inverted. It now draws the
//     blocked half-plane X>0 ∧ Y < 1.25·X − 25 swept outward, extruded over
//     exactly the band Z ∈ [−26,+26] — which also makes the base overhang
//     noted below visible instead of hidden.
//   • NEW FilmGhost() (preview only, show==0): the 3 mm felt as a 3 mm
//     outward ring, tapered on the diagonal. See its header for the coverage
//     and the taper law.
//
// v6 rev J (2026-09-10 — NON-SQUARE WELL for the 50 × 51.8 copper block):
//   • The copper block is 50 × 51.8 with the LONG side on Y (Y = horizontal,
//     perpendicular to the beam axis X). frame_outer stays 60×60 — a USER
//     constraint — so the extra 1.8 mm is taken out of the Y walls alone:
//         X wall  4.8 → 4.8   (bore_x = 50.4, unchanged)
//         Y wall  4.8 → 3.9   (bore_y = 52.2 = 51.8 + the 0.2/side slide fit)
//     `plate`/`bore` are now `plate_x`/`plate_y` and `bore_x`/`bore_y`; there
//     is NO square `bore` left, so every use names its axis. Exactly two call
//     sites: the well cut in _base(), and the copper preview ghost — kept in
//     sync deliberately, because a ghost that disagrees with the part is the
//     same class of bug rev I had to hunt through the STLs to find.
//   • lo_in is UNCHANGED at ±24 (USER-confirmed). Every dependent clearance
//     therefore moves the SAFE way:
//         40×40 TEC nest clearance     Y 5.2 → 6.1 mm
//         seating ledge on the bore    Y 1.2 → 2.1 mm   (X 1.2 unchanged)
//         copper → lo_in clearance     Y 1.0 → 1.9 mm   (X 1.0 unchanged)
//   • That seating ledge IS the load-bearing ring: the copper top face at −26
//     bears on it and passes the TEC preload into the frame. Its area grows
//     236.2 → 326.9 mm² (+38 %), so at the 150 N design preload the bearing
//     stress drops 635 → 458 kPa. Thinning Y is a net GAIN here, not a cost.
//   • STRUCTURE: the base walls carry that 150 N in compression over
//     Z∈[−33,−20]. Section 60² − 50.4×52.2 = 969.1 mm² (was 1059.8) →
//     0.155 MPa (was 0.142). ASA compressive ≈ 50 MPa ⇒ SF > 300.
//   • UNCHANGED, and deliberately so: the trumpet wall (30 − 24 = 6 mm), the
//     whole vertical chain in Z, the cavity air (31.94 mL — the well sits
//     BELOW the −26 ceiling and is not part of the cavity), and the 60×60
//     outer footprint. ⚠ Because the footprint is unchanged, the OPEN item
//     below — the base overhanging the mirrored wedge in the band Z∈[−26,−20]
//     — is NOT touched by rev J. It still needs the physical check.
//   • VERIFIED off the rendered STLs (data/verify/20260910/revJ/), so the
//     claims above are measurements, not restatements of the intent:
//         X wall 4.800   bore_x 50.400
//         Y wall 3.900   bore_y 52.200
//         outer footprint 60.000 × 60.000 (unchanged) · Simple: yes · 1 component
//       ⚠ Slice at the well BOTTOM face (Z ∈ [−0.05, +0.05]). The well walls
//       are vertical planes, so their vertices exist ONLY at the slab's
//       bounding Z — a slab taken anywhere in the middle of the well returns
//       "0 verts" and looks like a bug that isn't one.
//       base material volume 13061.571 → 12426.529 mm³ = −635.042 mm³, vs the
//       predicted −(50.4×52.2 − 50.4²)×7 = −635.040 mm³. Residual 0.002 mm³
//       (3.5 ppm) ⇒ the ONLY geometry that moved in the whole module is the
//       well bore. Reproduce with revJ/base_volume_delta_check.py.
//       cavity air 32.763 mL in BOTH revisions, delta exactly 0.000000 — that
//       is the raw MESH void; the 31.94 mL figure above is the same mesh
//       minus the sealed window pockets + Ø10 aperture, so read the two
//       against each other per the reconciliation at the top of this block.
//       pent: 8 of 915 unique vertices differ by 1e-4 (tessellation noise);
//       topcap: bit-identical vertex set.
//       ⚠ NEVER verify these by STL md5. Two renders of the SAME unmodified
//       source produce different hashes — facet ORDER is not stable. Compare
//       canonical triangle SETS (round coords, sort) as every number in this
//       block does. An md5 mismatch means nothing on its own.
//
// v6 rev K (2026-09-10 — 热堆定位 + 支撑组件，且修掉一个浮点 ULP 引发的网格缺陷):
//   用户要求：在保温筒基础上加两件 3D 打印件 —— 定住 铜块/TEC/水冷头 位置与
//   相对位置的 StackCradle，以及把整堆托到（另购）高度调节台上的 SupportBase。
//   只有最小高度需要设计：台面 100–150 mm，支撑件底面到光束 ≤ 215 mm。
//
//   • 热堆重新参数化（新件必须挂在一个确定的 Z 链上）：
//         plate_t 10   → 10.8     铜块厚
//         z_cop    3   →  3.8     露出长度（用户给的 ≈3.8）
//         tec_t    3.8 →  4.0     用户给定
//     ⚠ 关键：`z_cop` 不参与金属堆的 Z 链 —— z_cop_bot = z_frame_top − plate_t，
//     与 z_cop 无关。z_cop 移动的是**保温筒底面**，也就是 frame_h。所以"铜块露出
//     3.8"是一条二选一：改 plate_t（保温筒不动）还是改 frame_h（保温筒要重验）。
//     这里取前者，frame_h = 10.8 − 3.8 = 7 —— 正是 rev J 已验收的值，**保温筒因此
//     分毫未动**（下面有逐三角形的证明）。
//   • 🔴 由此暴露并修掉一个真 bug：`frame_h = plate_t − z_cop` 的浮点结果。
//     10.0 − 3.0 恰为 7.0（rev J 侥幸），而 10.8 − 3.8 = 7.000000000000001。
//     这一个 ULP（1 飞米）让 z = frame_h 处「框架顶面 / 井切割顶面 / 喇叭口底面」
//     三面重合的判据失效，CGAL 没有合并，留下一对 UP 969.12 + DOWN 969.12 的
//     重合反向面 —— 一个零体积退化壳。包围体积**完全不变**（体积检查会放行），
//     `Simple: yes` 也**不会报**（一对重合反向面本身仍是闭合 2-流形，CGAL 视其为
//     退化球壳），唯一的马脚是 `Volumes: 2 → 3`。修法：保留推导，把结果 snap 回
//     1e-6 mm（比输入精度细 5 个数量级，不丢信息）。见 frame_h 定义处的长注释。
//   • 两件新模块（都在本文件内，show = 5 / 6）：
//        StackCradle  88×88×4 底板 + 58² 塔身（下部套座 + 上部抱箍）+ 4 个立柱锚台。
//                     rev K 只有 Ø40.8 下部套座（= 40 + 0.4/边），rev L 起在其上
//                     再加一段抱箍孔 50.8×52.6，抱住**铜块露出井外的 3.8 mm** ——
//                     因为 rev K 的铜块（靠保温筒井孔定位）与水冷头（靠套座孔定位）
//                     本是两条独立基准链，中间只靠"底板自由坐在支撑件平顶上"衔接，
//                     而铜块压在 TEC 上的单边余量只有 5.0 (X) / 5.9 (Y)：底板一滑
//                     就变边接触，脆性氧化铝被静默压裂。rev L 把两链并成一条。
//                     两段口沿分别停在 −38.0 / −34.2（都比各自上方的接触面低 1.2），
//                     因为铜块与保温筒都是**从上方落下**的：口沿一旦高过接触面，
//                     它们就会先坐死在套座上、压不到 TEC，预紧力全废。
//                     +X 一面墙故意不封 —— 两个 Ø9.5 宝塔水嘴正是从那一面出去，
//                     且沿 Z 恰好占满水冷头整个高度；用户另要求 TEC 也侧面接线，
//                     故统一到同一面。rev L 只在该面两端留 3.6×4.3 角撑保住 +X
//                     定位（中间 |Y| ≤ 22 的 44 mm 口子走引线）。
//                     Z ∈ [−54.3,−34.2]，在障碍楔限带 [−26,+26] 之下。
//        SupportBase  70×70×58.5 方管 + 5 顶板 + 十字筋 + 3 只 Ø8 脚垫（凸 1.5）。
//                     打印姿态：顶面朝下贴板 —— 承 底板 的那一面由热床保证平整，
//                     它直接决定水冷头的 Z 与倾角，进而决定 TEC 接触。
//                     3 脚垫构成三角形 (0,31)(−31,−20)(31,−20)，原点在其内部，
//                     整堆重心落在支撑三角形内 ⇒ 不摇晃、只需配平 3 个小面。
//   • 高度预算（支撑件底面 → 光束）：
//         50.3 (水冷头底面) + 4 (底板) + 60 (支撑件) = 114.3 mm
//     高度调节台最小 100 mm ⇒ 台面到光束 214.3 mm，卡在用户给的 215 mm 上限内，
//     余量仅 0.7 mm。⚠ 偏紧：想留裕量就减 sup_h，每减 1 mm 余量加 1 mm，台子行程
//     会补回来。台子升到 150 mm ⇒ 光束到 264.3 mm。
//   • 障碍楔不约束新件：两件整体在 Z∈[−114.3,−34.2]，远低于楔的限带 [−26,+26]。
//     4 个立柱锚点 (0,±36)/(−36,±15) 也都在自由侧（与 rev G 的判断一致）。
//     ⚠ 但"楔以下空间自由"这个假设源自 rev G 且未实测：BS2 (X=+20) 的立柱与
//       Y=−25 的支撑杆若一路伸到台面，就会穿过 70×70 的支撑件。装配前目视确认。
//   • VERIFIED（data/verify/20260910/revK/，全部为实测而非复述意图）：
//       BaseModule 与 rev J **逐三角形完全相同**（768 tris，only-A=0 / only-B=0，
//         worst invariant deviation 0.000e+00）⇒ frame_h = 7 守住，保温筒未动。
//         复现：revK_base_identity_check.py
//       ULP 缺陷的 A/B 对照（同一份源码，只用 -D 改三个参数）：
//         rev J 参数 → Simple: yes, Volumes: 2
//         rev K 参数 → Simple: yes, Volumes: 3   ← 膜
//         修复后回到 Volumes: 2 且与 rev J 网格逐三角形一致。
//         证据文件 ab_revJparams.stl / ab_revKparams.stl。
//       两件新件均 Simple: yes、单连通分量，围合体积对账：
//         StackCradle 39940.092 vs 39940.082 手算 (+0.009，float32 STL 量化)
//         SupportBase 100640.748 vs 100640.120 手算 (+0.628，脚垫搭接面)
//         复现：revK_volume_check.py
//       ⚠ 共面并集的核查结论写在 StackCradle 模块上方：本件接缝是**并集 + 面对面**，
//         与 rev F 记录的两类故障（端面切于圆柱 / 差集切带共面）机理不同，实测也未
//         触发，故**刻意不加 0.01 搭接**。换 OpenSCAD/CGAL 版本渲染若出问题，先查这里。
//   • 仍未做（不在 rev K 范围）：立柱截面/螺钉/碟簧/压板形状 —— rev K 只给出 4 个
//     锚台作为落点。见 CLAMPING 块的 TODO(user)。
//
// v6 rev L (2026-09-10 — 抱箍：用铜块露出的 3.8 mm 当基准，把 铜块/TEC/水冷头
//   并成一条定位链):
//   —— 为什么必须改 ——
//   rev K 的 X/Y 是两条**互不相干**的基准链（铜块靠保温筒井孔 0.2/边，水冷头靠
//   StackCradle 套座孔 0.4/边），两者只靠"底板自由坐在支撑件平顶上"衔接 —— 而
//   那块底板**没有任何横向定位**。铜块压在 TEC 上的单边余量只有 5.0 (X) / 5.9
//   (Y)：底板一滑，面接触就变边接触，0.6–1 mm 的脆性氧化铝被静默压裂，外观却
//   毫无异常。这正是"同步固定 TEC + 水冷头"这件事 rev K 只做了一半的地方。
//   —— 怎么改 ——
//   套座不再停在 TEC 顶面下方，而是一路长到 −34.2，抱住铜块露出井外 3.8 mm
//   （−36.8…−33）里的 2.6 mm。TEC 与水冷头因此自动与**铜块本体**对齐。
//   —— 三个代价（都已核算）——
//   (1) 抱箍孔 50.8×52.6 比 rev K 套座外廓 46.8² 还宽 ⇒ 塔身必须统一放宽到
//       58² 棱柱，否则抱箍四面墙整个悬在套座之外、零件断成不连通的两块。
//       （此案在动手前就被几何推导拦下：先选的"台阶式省料"方案即因此作废。）
//       体积 39940 → 53420 mm³，ASA 约 +14.4 g。
//   (2) +X 面必须留口（水嘴本来就从那一面出去；用户另指定 TEC 侧面接线，统一到
//       水嘴那一面）。抱箍的 +X 墙整面切开，只在 |Y| ∈ [22, 26.3] 留两道
//       3.6×4.3 角撑补回 +X 定位 —— 没有它，套座能在铜块底下沿 +X 滑 5.4 mm
//       才失去接触，正是上面要根除的静默压裂模式。角撑**没有**缩小引线通路：
//       套座那一段的开口本来就只有 |Y| ≤ cr_bore/2 = 20.4。设 cr_lip_y ≥
//       cr_bore_y 即可关掉角撑、整面敞开。
//   (3) 抱箍口沿停在 −34.2（比保温筒底面 −33 低 cr_vclr = 1.2），否则保温筒
//       改坐在抱箍上，TEC 预紧力被整个旁路。
//   —— 验证 ——
//   手法与 rev K 相同：Volumes 追平 + Simple: yes + 单连通分量 + 散度定理体积
//   对账，并逐三角形回归确认 BaseModule（= 保温筒）仍未动。
//   ⚠ cr_rim_lz / cr_top_lz 都 snap 到 1e-6：角撑的底面/顶面必须与塔身**逐位
//     相同**才能合并 —— 陷阱 4 的 ULP 教训在这里第二次生效。
//
// v6 rev O (2026-09-14 — pentagon below-aperture wall 20 → 17 mm; the as-built
//   copper block runs 3 mm short of design, so the below-aperture band absorbs
//   the deficit):
//   • trans_h 6 → 9 — trumpet extends to the new joint; z_pent_bot −20 → −17
//   • PentModule re-banded (hh 28 → 25): bottom JOINT 0..6, observation mid
//     6..19 (was 6..22), top JOINT 19..25 (was 22..28). Beam still at local 17.
//   • beam plane / window centre Z=0 UNMOVED — optics pin it; the metal stack
//     (copper −36.8..−26, rod −26..−6, substrate −6..−2.5) UNTOUCHED.
//   • pentagon-top modules (TopCap, Film, RetainerCage) UNTOUCHED — their Z
//     ranges are referenced off z_pent_top = +8, which has not moved.
//
// v6 rev P (2026-09-14 — DS18B20 cavity-air reference probe, USER-CONFIRMED):
//   • purpose: measure chamber-air reference temperature near the substrate
//     (independent PINN boundary/validation), NOT intrude optics or droplet.
//   • position: Pent +Y face, X=0 (sen_y), local Z=12 (sen_z = global −5, the
//     substrate plane −6..−2.5). Clears: beam/windows (±X, Z=0) ≥10 mm, the
//     obstacle wedge (X>0 AND Y<1.25X−25), and all four retainer columns.
//   • geometry: Ø16 boss (sen_bd) protrudes Y 20→26 (sen_bh=6, 3 mm past the
//     3 mm felt); Ø8.4 bore (sen_hd) sweeps Y 26→16.5 (tip 0.5 mm into cavity).
//   • sealing: RTV-106 thin ring between ring head and flat boss face (open
//     chamber — leak time constant ~46 days — so no pressure seal, only
//     convection isolation). Ring-head M3 holes deferred until user measures.
//   • felt: +Y strip cut Ø20 at global Z=−5 only; +X face stays unbroken.
//   • print note: +Y horizontal boss — ~6 mm underside overhang, need supports.
//
// ⚠ REV P SUPERSEDED BY rev Q (2026-09-15) — the +Y face boss and bore (sen_*)
//   are DELETED. The probe now hangs vertically through the top-cap roof, dual
//   caps + removable centre core replace the pedestal. See the rev Q block that
//   follows. Keep this history — it documents the +Y variant the user rejected.
//
// v6 rev Q (2026-09-15 — probe onto the roof, DUAL CAPS + removable centre
//   core, USER-DIRECTED):
//   • probe: DS18B20 hangs VERTICALLY through the top-cap roof at
//     (qc_x,qc_y) = (−10.5,+10.5) — the −X/+Y corner, away from the beam band
//     (Y=0±5), the drop axis (origin) and the Ø16 substrate. BOTH caps (short
//     TopCap and the new tall TopCapTall) carry the same Ø16×4 boss + Ø8.4
//     through-bore at that XY, so one drilled sensor serves either config.
//     29 mm body hangs FULLY inside the cavity: short-cap tip ≈ −14,
//     tall-cap tip ≈ −3. Roof boss sealed to the Ø15 ring head with RTV-106.
//   • felt: the rev P +Y Ø20 cut-out is DELETED — the roof is not felted.
//   • dual cap: droplet mode keeps the short cap (h_top=10 — the Rayleigh /
//     no-convection H=17.5 budget is UNTOUCHED); calibration swaps in the tall
//     cap TopCapTall (h_top_tall=21 → roof underside +26, 2 mm over the cuvette
//     top at +24).
//   • cuvette calibration: 比色皿 50×12.5×12.5 stands at WELL CENTRE on the
//     copper (−26); the beam Z=0 crosses its saturated vapour 26 mm above the
//     pool (10 mm optical path), reusing the ±X windows. Droplet experiments do
//     NOT use it.
//   • centre core (USER: "支座改可拔插插芯"): the one-piece 一体支座 is replaced
//     by a Pent annular floor (Ø20×6, fused into the +X joint wall 1 mm + 3
//     ribs) with an Ø18.5 centre bore — sized to pass the cuvette's Ø17.7
//     circumcircle — plus a removable insert (Ø12 rod bore, seat top −6).
//     Droplet: insert in. Calibration: insert out, cuvette drops to the copper.
//   • RetainerCage press plate gains a Ø18 clearance bore over the roof boss;
//     the cage is parked during calibration (the tall cap rises into its band).
//     ⚠ SUPERSEDED by rev V: the tall build now REUSES the cage, lifted to the
//     tall roof on the longer Ø10 × 93 columns (rc_pin_tall, cotter at +41.13).
//   • print note: the roof boss is vertical (no support needed); the rev P
//     horizontal boss and its ~6 mm underside overhang are gone.
//
// v6 rev R (2026-09-15 — 5-piece joint interlock, USER-CONFIRMED "多加榫卯"):
//   • Every stack joint (Base→Pent, Pent→TopCap, Pent→TopCapTall) shared only
//     TWO Ø2.4 anti-slip tenons 榫 (pent_pins: −X face + +Y face). Two points
//     define a PIVOT LINE, so a module can still rock about the axis through
//     the pair, and shear resistance is concentrated at two spots.
//   • pent_pins now carries FIVE pins, one on each ring face — −X (EA), +Y
//     (DE), +X (CD), −Y (AB) and the diagonal (BC) — all DERIVED from the
//     profile constants (half / hx_f / fc_y / w_j), not hand-written, so they
//     track any future geometry change (the rev G failure mode).
//   • Size UNCHANGED (Ø2.4 peg / Ø2.8 socket / 2.4 mm deep + 0.5 poke) — the
//     5 mm ring lands stay symmetric at every new site (≥1.1 mm each side).
//   • Verified non-interference at every new site: ±X Ø10 aperture bore lives
//     in Pent-local z 15..25 (beam band) — never co-planar with any socket
//     band (z≈0..3 / stack tops); the +X pin at y=6.5 also clears the
//     aperture's y=±5 carve by 1.5 mm where the top band (z22..25) overlaps.
//     Pedestal ribs end at r=15 (socket edge ≥16.1 → ≥1.1 clear); rev Q floor
//     annulus r≤10 (pins ≥13.2 from axis); probe-rod sweep X[−14.5,−6.5] /
//     Y[6.5,14.5] clears every new pin by ≥22 mm; RetainerCage columns are
//     external.
//
// v6 rev S (2026-09-15 — THREAD-FREE retainer cage: plate + arms + pins; readers
//   should note this REVISES the rev N column/M3 placeholder AND closes the
//   assembly gap left at the end of the rev R session — the "spring inside the
//   anchor socket, loaded by the key" idea was un-buildable: a Ø28/ID18.2 disc
//   stack can never seat on a 6.4 mm-wide key, and any trap lip small enough to
//   hold it also blocks insertion; rev T3 shrank the disc stacks Ø28→Ø23 because
//   at Ø28 the A2↔A4 discs (centre distance 24.19) overlapped by 3.8):
//   • ONE printed cage = inset pentagon plate (+18..+20, Ø8 needle bore, Ø18
//     probe-boss clearance) + 4 arms (+19.5..+21.5) routed around the frozen
//     DS18B20 boss at (−10.5,+10.5): A1 dog-legs the +X side (leg1 offset +X
//     4.5, continuing above the boss), A2 runs straight −Y, A3/A4 ride a west
//     spine at y=−13 buried into the plate with an A3 north stub to (−36,15).
//     Smallest measured arm clearance to the boss centre: 10.54 mm at z=20.5
//     (boss radius 8, ≥8.5 required) — verified by slice check. Every fastening
//     element is OFF-THE-SHELF and THREAD-FREE: 4×Ø10 pins + 4×disc stacks +
//     4×cotter pins + 4×printed key bars + 4×printed preload collars.
//   • PRELOAD — one closed loop, four legs, ~160 N total:
//          碟簧 → 压板 → 顶盖 → 接缝 → 底座 → 井顶台阶 → 铜块 → TEC → 水冷头
//             ↑                                                          ↓
//             └ 开口销 ← 印刷垫套 ← 碟簧 ← 轴销 ← 印刷长条销 ← 锚台套筒 ← ←┘
//     Each arm tip carries a Ø14 boss with a Ø10.5 pin bore; the Ø10 pin drops
//     through it into the cradle's anchor socket and is pinned at its BOTTOM by
//     the printed key bar (6×3×44, along X, through the socket wall slots AND a
//     matching slot in the pin). A disc (Ø23/ID18.2, free 2.0) sits ON the arm
//     top, around the pin; a printed COLLAR (Ø23/ID14×7.0, rev T4) sits ON the
//     disc and is loaded by a cotter pin (开口销) through a Ø2.2 hole at +31.33.
//     Disc+collar free = 9.0, arm-top→cotter-bottom span = 8.33 ⇒ δ=0.67 ⇒ ≈40
//     N/leg (k≈59 N/mm @ Ø23) ⇒ ≈160 N (±0.3 mm tolerance ≈ 88..232 N; TEC window
//     80..240 N). Preload is set by the COLLAR thickness, never by torque. ⚠ The
//     cotter hole is PIN-PRINTED at +31.33 and alone would float 7.33 above a bare
//     disc — the collar is what forces δ.
//   • ASSEMBLY: cage on the cap roof → drop the 4 pins through the arm tips into
//     the sockets → slide the 4 keys in from −X (through wall slot + pin slot,
//     z 7..10 in the socket) → drop the 4 discs on the arm tops → seat the 4
//     collars on the discs → 4 cotters at +30.5. CALIBRATION: pop the cotters,
//     lift the collars + stacks, pull the
//     pins — the keys may stay in the sockets (they sit at Z≈−46, far below the
//     +27.8 tall roof) and the cage lifts straight off.
//   • Anchor sockets (StackCradle): the old squat boss pads are replaced by
//     Ø20×15 columns (bottom 4 → top LOCAL 19, BELOW the tower top 20.1, so the
//     base frame at −33 never collides) each with a blind Ø12 pin bore (4..19)
//     and the key channel (Y±3.2, Z 7..10, open −X→+X). Sockets merge into the
//     tower where their footprints overlap (no free-floating columns). The
//     (−36,±15) +X channel ends are carved by cavity ① — the key there is held
//     by its −X wall slot + the pin slot and its +X end floats in the bore
//     (accepted; the key is a locator, not a load path in rev S).
//   • print notes: cradle with sockets prints plate-down (vertical socket walls,
//     zero support; cradle plate widened 88→96 so every Ø20 socket base sits
//     fully on it — ±48 covers the ±36+10 outer edge). Cage prints plate-down
//     (arms + Ø14 bosses + Ø18 plate cut-out, zero support). Keys and pins print
//     as the show==10 part (keys flat, pins standing, slot + cotter hole cut).
//
// v6 rev T (2026-09-15 — cage split into TWO printed layers, USER-CONFIRMED
//   "拆两层分开设计、打印"; A2 anchor relocated to clear the obstacle wedge):
//   • WHY THE SPLIT: rev S proved one fused cage, but inside one part the plate,
//     the arms and the DS18B20 boss had to route around each other (full Ø18
//     plate cut-out vs arms running past the same boss). Two layers decouple:
//       LAYER 1 PressPlate  (+18..+20, show == 7) — inset pentagon flush on the
//         cap roof, Ø8 needle bore, Ø18 probe cut-out, + an Ø3.2 anti-rotation
//         pin on top at (−8,−6). The flush face = the Z datum.
//       LAYER 2 ArmsLayer  (+20..+22, show == 11) — centre hub sleeve (ID 8.2 /
//         OD 11.8) + a Ø3.4 anti-rot hole register the two layers; an INTEGRATED
//         west spine + stepped centre flap + 4 legs carries the four Ø16 tip
//         bosses. Each boss carries a Ø10.5 pin bore AND a TOP 6×3×22
//         anti-rotation key channel (land 0.7 below, ≈0 above; the 1.4 mm
//         anti-lift slack lives in the PIN slot, so the top key is a
//         non-load-bearing guard). Both print plate-down, zero support.
//   • A2 ANCHOR (0,−36) → (−24,−36): the old column's socket reached into the
//     BS2 obstacle wedge (X>0 ∧ Y<1.25X−25) territory. The new socket spans
//     x −34..−14 (fully X−), the 44-long key spans x −46..−2, and the A2→A4
//     distance is 24.2 mm (≥ the Ø20 socket diameter). A2 rides as a west bar
//     x −29..−19, y −36..−8.
//   • PRELOAD (rev T4): one closed loop, ≈160 N total (4 × ≈40 N, δ=0.67,
//     k≈59 N/mm @ Ø23). Key hardware unchanged in function: bottom keys
//     6×3×44 + Ø10 pins (now carrying a 4.4-tall TOP slot at pin-local z 70.7 =
//     global rc_tslot_z) + Ø23/ID18.2 disc which press up against the collar
//     (Ø23/ID14×7.0, rev T4) on the arm tops (+22), loaded by cotter pins at
//     +31.33. The collar is REQUIRED — the cotter floats 7.33 above a bare disc
//     (the Ø2.2 hole bottom is +30.33, a free disc tops out at +24.0).
//   • ASSEMBLY unchanged in spirit: plate on the roof → arms layer on the plate
//     (registered by hub + anti-rot pin) → pins through the bosses into the
//     sockets → bottom keys in from −X at z 7..10 → top keys through the boss
//     channels at +21.4 → disc stacks → collars → cotters. CALIBRATION: pop the
//     cotters, lift the stacks, pull the pins (the bottom keys may stay in their sockets),
//     the cage lifts straight off.
//   • VERIFIED (data/verify/20260915/revT/): every printed part renders
//     Simple: yes / one component; slice checks at the arm band confirm ≥10 mm
//     boss clearances on all four members; the A2 socket + 44 key sit clear of
//     the wedge. Reproduce with the revT_* scripts in that directory.
//
// v6 rev T2 (2026-09-15 — tip bosses → thin RING collars + radial SIDE KEYS,
//   USER-CONFIRMED "按圆环尺寸减至1/2" + "在顶盘侧面加keybar固定顶盘与柱"):
//   • ROOT CAUSE: the Ø16 tip bosses registered only 36.8 / 37.3 % of their
//     footprint on the A1/A2 arms (both members ended EXACTLY at the boss
//     centre) — half of each cylinder floated over the cavity; the 22-mm flat
//     top key was only ~71 % inside the boss disk. User's fix: size the boss
//     as a RING around the Ø10 pin (halve the ring band), kill the overhang,
//     and lock ring ↔ pin with keys on the boss SIDE instead of a long flat
//     key lying in the arm band below the boss top.
//   • BOSSES → RING COLLARS: rc_boss_d 16 → 13 (bore 10.5 ⇒ wall 1.25 ≈ half of
//     the old 2.75 mm band; Ø8 was mathematically impossible — bore > OD). The
//     flat 22×6.4×3 top-key channel is GONE (it would slice a 1.25 wall in
//     two). Each ring instead gets a Ø3.4 radial passage (along X) at
//     rc_tslot_z for the new side key; the ring stays ONE body (only the bore +
//     two small wall punctures are subtracted).
//   • A1 leg2 and A2 west bar are WIDENED 10 → 14 and EXTENDED past the ring
//     far edge (A1 y 36 → 44, A2 y −36 → −44) so the ring sits fully on arm
//     material (A1/A2 cover 37 → realised 100 %; A3/A4 at 92.5 / 95.3 % were
//     already covered, untouched).
//   • SIDE KEYS: the four 6×3×22 flat top keys (KeyBar row y=40) are REMOVED.
//     Each pin now mates to its ring through a Ø3 × 16 radial dowel along X at
//     rc_tslot_z, threading the ring's Ø3.4 passage + the pin's EXISTING TOP
//     slot (narrowed 14 → Ø-pin+0.5 = 10.5 so it stays inside the bore and can
//     never break into the ring wall in the assembly). Same non-load-bearing
//     anti-rotation guard function as before; the bottom key + cotter still
//     carry the entire preload.
//   • PRELOAD / ASSEMBLY ORDER / CALIBRATION path unchanged (bottom keys → pins
//     → rings + side keys → disc stacks → preload collars → cotters).
//   • VERIFIED (data/verify/20260915/revT2/): every printed part renders
//     Simple: yes / one component; boss-clearance and A2-socket checks repeated.
//   • rev T2.1 (same session, USER-CONFIRMED):
//       – SIDE KEYS mirrored 180°: dowel axis stays X but threads in from −X
//         (centred through-hole ⇒ mesh identical; only the entry-side
//         convention / comment flips).
//       – A3/A4 BOTTOM keys shortened 44 → 24 (rc_key_l_col = [44,44,24,24],
//         span −48..−24): the old 44-length +X end reached over the cradle
//         cavity ① (x ≥ −20.4) and hung into the open interior; keys now stop
//         3.6 mm west of that edge. A1/A2 keys unchanged (44).
//
// v6 rev U (2026-09-17 — BASE trumpet +X/−Y BS2 wedge hugging):
//   • ROOT CAUSE: the Base module's trumpet +X/−Y quadrant (lo_sq corner
//     (30,−30)) was deep inside the BS2 wedge (−42.5 mm at the base plane,
//     still −1.0 mm at the pentagon join Z=−17).  The chamber sat ~4 mm
//     above design height, displacing the beam above the aperture.
//   • FIX: reshape only 4 numbers in lo_sq and lo_in — the trumpet outer
//     and inner 5-vertex base profiles:
//       lo_sq v1: (0,−30)  → (−4.5,−30)   last clear point on −Y wall
//       lo_sq v2: (30,−30) → (30,13.125)  wedge-parallel diagonal y=1.25x−24.375
//       lo_in v1: (0,−24)  → (−7.77,−24)  inner diagonal parallel to outer, 6.3 mm inset
//       lo_in v2: (24,−24) → (24,15.71)
//     Outer diagonal constant margin = 0.625 mm (wedge-parallel, slope 1.25).
//     Inner diagonal wall = 6.3 mm perpendicular to outer → ≥ 5 mm at every
//     loft height (minimum = w_j = 5 at the pentagon joint, by definition).
//   • VERIFIED (design_flare.py, 41-step loft + 41-step edge sampling):
//     surfclear(min g+25, X>0) = +0.50 (pentagon binding, margin preserved)
//     wall(min perp) = 5.00 ≥ w_j   centreline fittings OK   base gap 6.00
//   • Preserved: lo_sq v0/v3/v4 = (±30,±30) (frame 60×60 footprint),
//     lo_in v0/v3/v4 = (±24,±24) (1.2/2.1 mm ledge to bore), bore 50.4×52.2,
//     copper 50×51.8, pc_j/pc_inn, pent_outer/pent_pins — all untouched.
//   • Frame top face corner at Z=−26 (−30,−30)→(30,−30) is still coplanar
//     with the band's bottom plane in the wedge region (bore corner inside
//     wedge XY cannot be pulled without redesigning bore/copper).  Left as-is
//     per user confirmation ("忽略").
//
// v6 rev W (2026-09-18 — well-mouth corner seal shelf + copper lowered):
//   • USER-DIRECTED: fill the +X/−Y well-mouth step gap flush with the bearing
//     ring top ("把井口台阶缺口填平到与承载环顶面齐平；嵌入井口内；密封层厚
//     1mm即可；和base module做成一体打印的"), and drop the copper to clear it.
//   • The gap: the open notch T at the bore's +X/−Y corner (441.6 mm²),
//     between the bore edges (x=+25.2 / y=−26.1) and the loft's outer diagonal
//     y=1.25x−24.375. The fill is legal — T lies ENTIRELY BELOW the band floor
//     z=−26 (at its top face it only EXTENDS the floor, never enters the band),
//     and is 0.625+ outward of the wedge line in plan (setback 0.2 keeps 0.425).
//   • FIX: WellFloorSlab (rev W/W2/W3) — the whole well-mouth floor becomes a
//     1.0 mm ring `bore_rect − lo_in`, top FLUSH at z=frame_h (global −26),
//     flush against all four bore walls → "一体打印", one solid piece; rev W3
//     (2026-09-18, USER: "增厚其它边缘位置的厚度，找平…接触平面") hangs the
//     WHOLE ring underside to −27.0 so the copper top (−27.2) bears on ONE flat
//     plane (uniform 0.2 seat-in) instead of 0.2 at the notch vs 0.8 elsewhere.
//     The lo_in funnel hole stays open (cuvette drop / Ø10 rod / optics).
//   • Copper: lowered cop_drop = seal_t + cop_seal_gap = 1.2 as a whole
//     (USER: "铜块整体下移即可"); top −26 → −27.2, clearing the flat ring
//     underside (−27.0) by a uniform 0.2. The vertical chain follows: rod
//     20 → 21.2 (substrate −6 and
//     the beam/window/optics stay PINNED), TEC/cooling/cradle −1.2, cuvette and
//     tall cap drop 1.2 (标定池底→束流 26 → 27.2 — 需重验标定).
//
// Obstacle (USER, IMMUTABLE — mirrored to −Y):
//   • BS2 at X=+20 (on the beam); support rod at Y=−25.
//   • Blocked wedge: X>0 AND Y < −25·(1 − X/20) = 1.25·X − 25.
//   • Vertical extent: beam plane ±26 mm → band Z∈[−26,+26] blocked; below FREE.
//
// RESOLVED (rev U): the trumpet's +X/−Y quadrant was deep inside the wedge
// (worst clearance −42.5 mm at the base plane), causing the chamber to sit
// ~4 mm above design height.  Rev U reshapes lo_sq/lo_in so the outer wall
// follows the wedge at a constant 0.625 mm margin — enough to restore the
// pentagon's own 0.5 mm design margin.  The frame cube (Z ∈ [−34.6,−26];
// rev V raised the bottom 7 → 8.6 from the frame_h binary-grid snap)
// stays 60×60; its top-face corner at Z=−26 is coplanar with the band's
// bottom plane (rev J open item — sub-mm, left as-is per user confirmation).
//
// Legend (Z global):
//   [Base]    Z∈[−34.6,−17]  frame + trumpet fused (well 50.4×52.2 → JOINT ring w_j=5)
//   [Pent]    Z∈[−17,+8]    pentagon frame (banded: w_j=5 rings / w_c=3 mid), windows @ Z=0
//   [TopCap]  Z∈[+8,+18]    pentagon lid, 3 mm roof, single Ø5 needle hole
//   [TopCapTall] Z∈[+8,+26] rev Q calibration lid over the 50 mm cuvette
//                           (swaps in; droplet experiments keep the short cap)
//   [Cuvette]  Z∈[−27.2,+22.8]   calibration only — 12.5² cell at well centre on
//                            the copper; beam crosses its vapour at Z=0
//                            (rev W: pool follows the copper drop)
//   [CentreCore] Pent 环形地板 Ø18.5 bore (−17..−11) + removable insert (−17..−6)
//   [Film]    Z∈[−17,+18]   3 mm external aerogel felt, TAPERED to zero on BC
//                           (preview only — see FilmGhost; the trumpet takes a
//                            separate sloped piece, not drawn)
//   [Metal]   copper −38.0..−27.2, rod −27.2..−6, substrate −6..−2.5 (preview)
//             (rev W: copper dropped 1.2 under the flat well-floor ring)
//   [Cooling] TEC −42.0..−38.0, water block −51.5..−42.0, barbs @ Z=−46.75
//             (preview; follows the copper drop by construction)
//   [Cradle]  StackCradle  −55.5..−34.2 (rev L printed part, show = 5;
//             rev K 的套座停在 −38.0 —— rev L 的抱箍多长 3.8，抱住铜块突出部)
//   [Support] SupportBase  −113.5..−55.5 (rev K printed part, show = 6;
//             rev W: sup_h 60→58, USER-CONFIRMED, 215 上限余量回到 1.5)
//   (no [Frame] — the external clamping frame was REMOVED in rev F; rev G
//    replaces it with a PRINTED RETAINER CAGE, still to be modelled — see the
//    CLAMPING note in the parameter block. rev K gives it 4 anchor pads on
//    StackCradle but does not model the cage itself.)
//
// Workflow: toggle ONE print module, F6 render, export STL, slice in Bambu.
// =============================================

/* [Global] */
$fn = 60;
// View selector — replaces the old "uncomment one module" workflow:
//   0 = ASSEMBLY PREVIEW (default; global-Z layout + metal/thermal ghosts)
//   1 = BaseModule   2 = PentModule   3 = TopCapModule   (single-part export)
//   4 = FILM GHOST alone (not a printed part — this is the shape the aerogel
//       felt is cut to; view it from +Z to read the BC taper)
//   5 = StackCradle  (rev L — thermal-stack locator + collar, print as-is)
//   6 = SupportBase  (rev K — pedestal onto the height stage, print as-is)
//   7 = PressPlate   (rev T LAYER 1 — inset pentagon on the cap roof + the
//                     anti-rotation pin; print as-is, plate-down)
//   8 = TopCapTall    (rev Q — 21 mm calibration lid over the 50 mm cuvette)
//   9 = PedestalInsert(rev Q — removable centre core; droppable for calibration)
//  10 = KeyBar        (rev T2 — 4× bottom keys + 4× Ø3 radial side keys + 4×
//                     pins w/ both slots + cotter holes; small cage hardware)
//  11 = ArmsLayer     (rev T2 LAYER 2 — hub + west spine + flap + 4 legs +
//                       four Ø13 ring bosses w/ radial-key passages; print as-is)
//  14 = NeedleHolePlug (针孔塞，封 Ø5 针孔)
//  15 = WindowCap       (光学窗防尘盖，±X 各一个)
// The single-part views sit at the LOCAL origin, already in print orientation.
// calib: 0 = droplet config (short cap + insert + rod + substrate + cage),
//        1 = calibration config (tall cap + cuvette ghost, centre core removed)
show = 01;
calib = 0;

// ---- Material: ASA ----
material = "ASA";
//   k ≈ 0.17 W/m·K, Tg ≈ 105 °C, shrinkage ≈ 0.5–0.7 %
//   Print: enclosed printer, bed 90–100 °C, nozzle 240–260 °C
//   ⚠ ASA 收缩率比 PLA 高，以下关键配合尺寸可能需要在切片时 +0.1–0.2 mm 补偿：
//     • 井孔 50.4×52.2（铜块 50×51.8，单边 0.2 间隙）
//     • 榫/卯 Ø2.4/Ø2.8（0.2 mm 间隙）
//     • 窗座 Ø13.1（玻璃 Ø12.7，0.2 mm 间隙）
//     • TEC 套座 40.8²（TEC 40²，单边 0.4 间隙）

// ---- Obstacle (USER: −Y side, +X side of beam) ----
bs2_x = 20;         // [mm] focus → BS2 along beam (+X)
rod_y = -25;        // [mm] focus → support rod on −Y side (below beam)
// Hypotenuse:  Y = rod_y·(1 − X/bs2_x) = 1.25·X − 25
// Blocked: X>0 AND Y < 1.25·X − 25. Vertical band: beam plane ±26 mm.

// ---- Pentagon observation profile (upper frame) ----
half = 20;          // [mm] Y reach and −X reach of the 40×40 source square
hx_f = 14.0;        // [mm] +X face pulled back to X=14 (6mm chamber shortening)
fc_y = -7.0;        // [mm] +X face lower-corner Y (wedge relief; ring stays flat)
                    //      vertex set: (−20,−20)(0,−20)(14,−7)(14,20)(−20,20)
// rev I — COMPRESSED to the structural floor. The outer profile is FROZEN
// (USER CONSTRAINT: "在现有外壁尺寸的情况下"), so every millimetre taken off
// the wall becomes cavity. Insulation is the external aerogel film, NOT the
// wall — see the rev I header block.
w_c  = 3;           // [mm] observation-section wall thickness (cavity mid).
                    //      FLOOR = the Ø13.1 × 2 mm window seat cut from the
                    //      outer face: seat floor ≡ w_c − win_r. At 3 this is
                    //      1.000 mm; 2.5 would break through.
w_j  = 5;           // [mm] JOINT ring wall — carries the Ø2.8 peg sockets at
                    //      every module interface + the Base trumpet top.
                    //      FLOOR = 1.0 mm land each side of the socket.
c_in   = half - w_c;        // inner reach −X/±Y (17), observation mid-section
c_in_px = hx_f - w_c;       // inner +X reach (11), observation mid-section
c_j    = half - w_j;        // inner reach −X/±Y (15) in the JOINT rings
c_j_px = hx_f - w_j;        // inner +X reach (9) in the JOINT rings
aperture = 10;      // [mm] clear beam aperture (FOV 10.24, seats keep clear)
win_d = 12.7;       // [mm] 0.5" window glass OD (seat bore)
win_r = 2;          // [mm] seat recess depth per face (glass + RTV/O-ring)
win_clr = 0.4;      // [mm] seat-bore clearance so the glass always seats
win_g = 3.0;        // [mm] window glass thickness — USER-CONFIRMED 3.0 (the
                    //      old 1.0 here was stale and wrong). A 3 mm plate in
                    //      the 2 mm seat therefore stands 1.0 mm PROUD of each
                    //      face. Accepted, deliberately: (a) there is no ΔP
                    //      across the window so nothing loads the seat floor,
                    //      (b) the 2 mm bore still engages 2 mm of the rim for
                    //      the RTV/O-ring seal, (c) the film is cut away there
                    //      anyway, (d) the +X margin to BS2 drops 6.0 → 5.0 mm
                    //      — still clear. ⚠ NB the 3 mm felt then glues ON TOP
                    //      of that: outer felt face at X=17, so the true
                    //      clearance to BS2 at X=20 is 3.0 mm, not 5.0. Still
                    //      clear, but that is the number to check against the
                    //      real BS2 mount. ⚠ To make the glass flush instead,
                    //      win_r must become 3 and w_c must rise to ≥ 4.5 for a
                    //      1.5 mm seat floor; that costs ~1.8 mL (31.94 →
                    //      30.12 mL at w_c 4), which is why it was NOT taken.
ptfe = 5;           // [mm] syringe/needle hole Ø in the top cap (drop axis)

// ---- DS18B20 cavity-air reference probe (rev Q, USER-DIRECTED REDESIGN) ----
//   USER 采购件：环头 Ø15（可螺栓固定）/ 杆体 Ø8 / 全长 29 mm / 线 Ø5。
//   用途：测腔气参考温度（作 PINN 边界/验证的独立参考）。
//   rev Q 位置策略（USER: "探针改由 TopCap 打孔探入，且矮盖/高盖都要留孔、
//   29 mm 杆体必须全部悬入腔内"）：
//     • 探针轴 = 竖直，穿过顶盖屋面（BOTH 矮盖 TopCap 与高盖 TopCapTall）。
//     • 屋面落孔中心 (qc_x, qc_y) = (−10.5, +10.5)：取 −X/+Y 之间、远离光束
//       带(Y=0±5)、远离下落轴(原点)、远离基片 Ø16 的角区。
//       逐项核对（走 pc_j 最窄环形带，内壁 X∈[−15,+9]、Y∈[−15,+15]）：
//         – 杆体 Ø8 横扫 X∈[−14.5,−6.5] / Y∈[6.5,14.5]，四壁全留 ≥0.5mm；
//         – 基片 Ø16@原点：最近点(−6.5,6.5) 距心 9.2mm > 8+0 且留 1.2mm；
//         – ±X 窗座 Ø13.1@(±19,0)：最近 7.9mm > 6.55；光束通孔 Y=0±5 留 1.5mm；
//         – 比色皿(标定，12.5² 站姿)：近角(−6.25,6.25) 距探针轴 6.0mm，杆面
//           留 2.0mm —— 标定时探针也在位，仍不碰。
//     • 伸出结构：屋面外凸 Ø16 boss (qc_bh=4)+ Ø8.4 垂直通孔贯穿 boss+屋面。
//       环头坐在 boss 顶面，RTV-106 薄圈密封（开放腔不承压差，同窗）。
//       探杆自屋面内缘直悬 29mm：矮盖 tip≈−14、高盖(tip≈−3)，全程在腔内。
//     • 压板（RetainerCage）在该 XY 开 Ø18 让位孔，避开 boss（见其模块）。
//     • 毡：boss 在屋面上方，毡只贴外壁，不需剪口（删除 rev P 的 +Y Ø20）。
qc_ring = 15;       // [mm] 环头 Ø（用户采购件）
qc_bd   = 16;       // [mm] 屋面 boss 外径（Ø15 环头 + 0.5 边）
qc_bh   = 4;        // [mm] 屋面 boss 高（屋面上方，矮盖顶 +18..+22）
qc_hd   = 8.4;      // [mm] 垂直通孔 Ø（Ø8 杆体 + 0.4 间隙）
qc_x    = -10.5;    // [mm] 落孔中心 X（−X/+Y 角区，见上核对）
qc_y    = 10.5;     // [mm] 落孔中心 Y
qc_pclr = 16.8;     // [mm] 压板让位孔 Ø（boss Ø16 + 0.8 → 径向 0.4）。rev T2.2:
                     //      曾为 Ø18(1.0/side) —— 孔顶 y=19.5 只离 bump 顶 19.7
                     //      0.2mm，NW 角薄到一碰就断；缩到 boss+0.8 后孔顶 y=18.9，
                     //      bump 提到 19.9 ⇒ 最小壁 1.0mm。boss 不转动、不穿件，
                     //      0.4/side 足够。

//   (rev Q cuvette + centre-floor/insert parameters live BELOW the vertical
//    chain — they depend on z_cop_top / z_pent_top / z_sub_bot, defined there.)

// ---- Pentagon vertex sets (shared by Base/Pent/TopCap) ----
pent_outer = [
    [-half, -half],
    [ 0,    -half],
    [hx_f,   fc_y],
    [hx_f,   half],
    [-half,  half]
];
// Precomputed perpendicular inset of pent_outer by rc_p_ins = 1.5 mm.
// OpenSCAD's offset(delta=-1.5) self-intersects at the sharp 43° corner
// (0,−20) → CGAL reports Volumes: 3 (two separate solids).  The mathematically
// correct inset avoids this entirely:
//   w = 1.5;  |n| = √365 = 19.105;  C' = 280 − 19.105·w = 251.343
//   AB(y=−18.5) ∩ BC(13x−14y=251.343) → x = −0.589
//   BC ∩ CD(x=12.5)                    → y = −6.346
// rev T: a top-edge BUMP at the DS18B20 boss completes the outline. Without it,
// the Ø18 probe cut-out (centre (−10.5,10.5), r=9) crosses BOTH the top edge
// (y=18.5, r breach to 19.5) and the left edge (x=−18.5, breach to −19.5),
// isolating the top-left corner into a separate 32-triangle chip (print defect).
// The bump (y 18.5→19.7 over x −15.5..−5.5) contains the hole's top breach, so
// the cut-out opens ONLY through the left edge → the plate stays one solid.
// 19.7 < cap roof outer y=20 ⇒ no overhang.
pent_plate = [
    [-18.500, -18.500],   // bottom-left corner (inset pentagon)
    [ -0.589, -18.500],   // diagonal inset start
    [ 12.500,  -6.346],   // diagonal inset end
    [ 12.500,  18.500],   // bottom of the right edge / top corner
    [ -5.500,  18.500],   // top edge → bump right corner
    [ -5.500,  19.900],   // bump right wall up (rev T2.2: 19.7→19.9 — the DS18B20
    [-18.500,  19.900],   //   hole apex was only 0.2 mm under the old bump; the
                         //   bump now spans to the LEFT edge, giving ≥1 mm wall
                         //   ALL across the −X/+Y corner).
    [-18.500,  18.500],   // bump left wall down (extended to the plate left edge)
    [-18.500, -18.500]    // back down the left edge (closes the loop)
];
// Inner profiles = TRUE perpendicular offsets of pent_outer. Diagonal edge BC
// of pent_outer is 13x − 14y − 280 = 0 with |normal| = √365 = 19.105, so the
// inward-w line is  13x − 14y − (280 − 19.105·w) = 0.
//   AB (y = −c) ∩ BC        → x = (C − 14c)/13
//   BC ∩ CD (x = c_px)      → y = (13·c_px − C)/14
// rev I: the two DIAGONAL vertices are now COMPUTED from that line instead of
// being hand-written constants. This is not cosmetic — rev G's defect was
// exactly this failure mode: pc_j carried hand-computed vertices (−1.653 /
// −8.674) whose diagonal ran at slope 0.500 instead of 0.929, pinching the
// seal ring from 7.00 mm to 3.54 mm at the +X corner while pc_inn, computed
// correctly, was fine. Deriving both makes that error class impossible when
// w_c / w_j change — and they just changed.
_c_inn = 280 - sqrt(365)*w_c;   // offset-line constant, observation mid-section
_c_j   = 280 - sqrt(365)*w_j;   // offset-line constant, JOINT rings
// observation mid-section (wall w_c). For the old w_c=5 the diagonal vertices
// were (−1.960, −15) and (9, −4.820); at w_c=3 they are (−1.178, −17) and
// (11, −5.692).
pc_inn = [
    [-c_in, -c_in],                        // EA ∩ AB
    [(_c_inn - 14*c_in)/13, -c_in],        // AB ∩ BC
    [ c_in_px, (13*c_in_px - _c_inn)/14],  // BC ∩ CD
    [ c_in_px,  c_in],                     // CD ∩ DE
    [-c_in,   c_in]                        // DE ∩ EA
];
// JOINT-ring inner profile (wall w_j). At w_j=5: (−1.963, −15) and (9,−4.820)
// — i.e. pc_j(5) is identical to the old pc_inn(5), as it must be.
pc_j = [
    [-c_j, -c_j],                          // EA ∩ AB
    [(_c_j - 14*c_j)/13, -c_j],            // AB ∩ BC
    [ c_j_px, (13*c_j_px - _c_j)/14],      // BC ∩ CD
    [ c_j_px,  c_j],                       // CD ∩ DE
    [-c_j,   c_j]                          // DE ∩ EA
];

// ---- Copper plate / rod / substrate ----
//   rev J (USER-SPECIFIED): the copper block is 50 × 51.8 with the LONG side on
//   Y (Y = horizontal, perpendicular to the beam axis X). frame_outer 60×60 is
//   a user constraint and does NOT move, so the extra 1.8 mm comes out of the Y
//   walls alone — they thin 4.8 → 3.9 while X stays 4.8. Both splits are
//   NON-SQUARE now, so every downstream use must carry the axis it belongs to.
//   See the rev J block in the header for the full dependent-clearance table.
plate_x = 50;       // [mm] copper block side along X (the beam axis)
plate_y = 51.8;     // [mm] copper block side along Y (USER: 51.8 runs on Y)
plate_t = 10.8;     // [mm] copper block thickness — rev K (was 10). USER: the
                    //      block protrudes ≈3.8 below the frame, and the well
                    //      depth frame_h is PINNED at its verified rev J value
                    //      of 7 (frame_h = plate_t − z_cop), so plate_t must be
                    //      7 + 3.8. The other root — plate_t stays 10 and
                    //      frame_h drops to 6.2 — would have changed the
                    //      already-verified rev J chamber and was NOT taken.
frame_outer = 60;   // [mm] bottom frame outer side (UNCHANGED — user constraint)
fit = 0.4;          // [mm] total slide fit (0.2/side) so the block drops in from
                    //      BELOW and protrudes z_cop = 3.8 mm onto the TEC
bore_x = plate_x + fit;         // [mm] frame bore, X = 50.4 → X wall 4.8
bore_y = plate_y + fit;         // [mm] frame bore, Y = 52.2 → Y wall 3.9

// ---- WellFloorSlab + copper drop (rev W 系列, USER-DIRECTED) ----
//   Well floor the copper bears on, FLAT.
//   rev W1/W2 filled only the +X/−Y notch (WellMouthSeal); that left the rest
//   of the well-floor underside at −26 while the notch hung to −27.0 ⇒ the
//   copper top face (−27.2) met an UNEVEN contact plane (0.2 in the notch,
//   0.8 elsewhere).
//   rev W3 (USER-CONFIRMED 2026-09-18: "增厚其它边缘位置的厚度，找平喇叭口与底部
//   铜块接触的平面"): the whole well-mouth floor becomes ONE 1.0 mm ring,
//   `bore_rect − lo_in`, z ∈ [frame_h−seal_t, frame_h]:
//     • top FLUSH at frame_h (−26) — sits under/with the loft cap ring,
//     • underside FLUSH at −27.0 — a single level contact plane for the copper
//       top (−27.2, uniform 0.2 seat-in all round),
//     • flush against all four bore walls ⇒ one printed body with the base,
//     • the lo_in funnel hole stays OPEN (cuvette drop / Ø10 rod / optics).
//   All values self-derived from rev U / rev J constants.
seal_t       = 1.0;   // [mm] floor-ring thickness — top FLUSH at frame_h (−26),
                      //      underside −27.0 = the flat copper-contact plane
cop_seal_gap = 0.2;   // [mm] copper-top (−27.2) → ring underside (−27.0) clearance
cop_drop     = seal_t + cop_seal_gap;          // 1.2  whole-copper drop (USER: 整体下移)

rod_d = 10;         // [mm] copper rod diameter
rod_hole = 12;      // [mm] printed bore for rod (clearance)
sub_t = 3.5;        // [mm] substrate thickness (on pedestal top)
sub_d = 16;         // [mm] substrate disc diameter
ped_d = sub_d;      // [mm] printed pedestal (substrate seat) diameter

// ---- TEC / water block / barbs (USER-SPECIFIED, preview only) ----
//   No shim between the copper block and the TEC — thermal grease only.
//   The 40×40 TEC nests INSIDE the frame's 50.4 × 52.2 bore (rev J: 5.2 mm
//   clearance/side on X, 6.1 on Y), so it reaches the copper's bottom face at
//   −36 without needing a boss.
tec_s   = 40;       // [mm] TEC1-12706 side
tec_t   = 4.0;      // [mm] TEC thickness — rev K (was a 3.8 placeholder).
                    //      USER-SPECIFIED 4 mm. The old caliper warning still
                    //      stands in spirit: vendors ship 3.6–4.0 and every Z
                    //      below (and the cradle) shifts with it, so measure the
                    //      real part before printing StackCradle().
wb_s    = 40;       // [mm] copper water block side
wb_t    = 9.5;      // [mm] water block thickness
barb_d  = 9.5;      // [mm] barb (宝塔) fitting OD — equals wb_t, so the barb
                    //      spans exactly the block's height: no Z conflict
barb_l  = 15;       // [mm] barb projection beyond the block face
barb_az  = 0;       // [deg] azimuth of the ONE side face that carries BOTH
                    //      barbs (0 = +X). USER-SPECIFIED: the two barbs are on
                    //      the SAME face, not on opposite faces.
barb_off = [-10, 10];  // [mm] lateral offset of each barb along that face
                    //      (perpendicular to barb_az): −10..+10 = 20 mm
                    //      centre-to-centre (USER-SPECIFIED: 20).
                    //      NOTE the obstacle wedge does NOT constrain barb_az —
                    //      the barbs sit at Z ≈ −44.6, below the band
                    //      Z∈[−26,+26]. What DOES constrain it is the 4 retainer
                    //      columns. Two barbs on ONE face sweep a far wider
                    //      sector than two on opposite faces, and at tip radius
                    //      35 mm they come within 5.10 mm of the (−36,±15)
                    //      columns (8.75 mm needed) → −X is a HARD COLLISION;
                    //      ±Y leave only 1.3 mm, not enough to route a Ø8 tube.
                    //      +X is the only clear side — and it is exactly the
                    //      side the wedge already denies to the columns, so the
                    //      two constraints dovetail. RE-CHECK if columns move.
                    // (Z placements live in the vertical-chain block below —
                    //  OpenSCAD evaluates top-level assignments in file order,
                    //  so they must follow z_cop_bot.)

// ---- Vertical chain (global Z) ----
//   HARD CONSTRAINTS (both PINNED by optics + the obstacle band, cannot move):
//     • beam plane / window centre  Z = 0
//     • pentagon bottom             Z = −17  (= z_frame_top + trans_h)
//   So the BASE absorbs any change to the metal stack. With the copper shim
//   DELETED (rev G) the frame well ceiling must land exactly on the copper
//   block's TOP face, and that single requirement FIXES frame_h:
//     z_frame_top = z_cop_top  ⟺  z_frame_bot + frame_h = z_cop_bot + plate_t
//                              ⟺  frame_h = plate_t − z_cop = 7
//   It is written derivatively so the identity cannot be broken by a hand edit.
obs_band = 26;      // obstacle half-band around beam plane
z_win = 0;          // beam plane = window center (origin)
z_frame_top = -obs_band;             // −26  frame top = low edge of band
trans_h = 9;                         // trumpet height (was 6, +3 in rev O —
                                         //      shortens the below-aperture wall
                                         //      from 20 mm to 17 mm, z_pent_bot −20→−17;
                                         //      the 3 mm matches the as-built copper
                                         //      block running short; 4 mm was a miscount)
z_pent_bot = z_frame_top + trans_h;  // −17  pentagon bottom  (PINNED)
z_pent_top = 8;                      // +8   pentagon / top-cap top (PINNED)
z_cop = 2.2;                         // copper protrudes below frame bottom
                                     //      (rev K: 3, USER-SPECIFIED ≈3.8;
                                     //       rev V: 3.8 → 2.2 — USER: 底框向下增高
                                     //       1.6 mm, frame_h 7 → 8.6, cradle 不改)
                                     // ⚠ z_cop is NOT allowed to drive the metal
                                     //   stack: z_cop_bot = z_frame_top − plate_t
                                     //   independently of z_cop. What z_cop moves
                                     //   is the CHAMBER's bottom face
                                     //   (z_frame_bot = z_frame_top − plate_t +
                                     //   z_cop) — i.e. `frame_h` — and that is
                                     //   why `frame_h` must stay derived.
//   ⚠ 必须 snap 回**二进制网格**（×1024，即 1/1024 mm 分辨率的 power-of-2 分母）。
//     plate_t / z_cop 是 0.1 mm 精度的十进制字面量，二者之差在二进制里不保证
//     落在同一个 double 上：10.0 − 3.0 恰为 7.0（rev J 侥幸没事），而
//     10.8 − 3.8 = 7.000000000000001。这一个 ULP（1 飞米）是**真会造成网格缺陷**
//     的 —— A/B 对照（同一份源码，只用 -D 改 plate_t/z_cop/tec_t）实测：
//       rev J 参数 → Simple: yes,  Volumes: 2
//       rev K 参数 → Simple: yes,  Volumes: 3     ← 多出零体积退化壳
//     缺在 z = frame_h 平面：框架顶面 / 井切割顶面 / 喇叭口底面三者精确重合，
//     CGAL 只有在该平面高度**恰好可精确表示**时才合并这些重合面（rev V 探针：
//     dyadic frame_h 一律 Volumes: 2，非 dyadic 一律 Volumes: 3）。
//     包围体积仍精确不变（体积检查会放行），但网格不再干净。Simple: yes 也不会报 ——
//     一对重合反向面本身仍是闭合 2-流形，CGAL 视其为退化球壳，故只在 Volumes 计数
//     上露出马脚。
//     🔴 rev V 发现：原来的 ×1e6 **十进制** snap 只在目标值恰好 dyadic 时有效
//     （rev K 的 7.0 侥幸）；z_cop=2.2 → frame_h 目标是 8.6，非 dyadic，
//     ×1e6 snap 后仍是 8.5999999999999996… → Volumes: 3 复发。修法：把结果 snap
//     到**二进制网格** round(x*1024)/1024 = 1/1024 mm。8.6 → 8.599609375
//     （偏差 0.39 µm，远小于 float32 STL 量化噪声 ~1 µm 与打印公差），但该值
//     恰好是有限二进制小数 → CGAL 正确合并 → Volumes: 2。保留推导不变。
frame_h = round((plate_t - z_cop)*1024)/1024;  // 8.599609375  well depth = copper inside the well
z_frame_bot = z_frame_top - frame_h; // −34.6 = −26 − 8.599609375
z_cop_bot = z_frame_bot - z_cop - cop_drop;   // −38.0  copper bottom = TEC contact face
                                              // (rev W: −1.2 for the flat well-floor ring)
z_cop_top = z_cop_bot + plate_t;     // −27.2  copper top — uniform 0.2 (cop_seal_gap)
                                     //        below the FLAT rev-W3 ring underside (−27.0);
                                     //        still above the
                                     //        frame bottom −34.6, still inside the well
sub_top = -aperture/4;               // −2.5 substrate top (¼ aperture rule)
z_sub_bot = sub_top - sub_t;         // −6   substrate bottom = pedestal top
z_rod_bot = z_cop_top;               // −27.2  rod sits directly on the copper top
rod_len = z_sub_bot - z_rod_bot;     // 21.2   Ø10 through-stock (was 20 + the 1.2 drop)

// ---- Cuvette calibration (rev Q, USER-DIRECTED) ----
//   标定实验：比色皿（50×12.5×12.5，站姿）盛液坐井腔正中，池底贴铜顶(−26)，
//   束流 Z=0 穿其 26mm 高处的饱和蒸气区（光程 10mm），高盖罩住皿顶(+24)。
//   液滴实验不需要比色皿 —— 双顶盖互换：日常矮盖(rev O 现形)，标定拆堆后换高盖。
cuv_w   = 12.5;     // [mm] 比色皿外脚宽（X/Y，站姿，外接圆 Ø17.7）
cuv_step= 27.2;     // [mm] 池底→束流高 — rev W: 池底跟随铜块 −27.2 → 束流 0
                    //      （束流穿皿位置；标准皿光程 10mm；⚠ 标定几何需重验）
cuv_top = z_cop_top + 50;          // 皿顶 Z = −27.2+50 = +22.8
h_top_tall = cuv_top - z_pent_top + 3 + 2;   // 19.8  高盖 h_top：屋面内缘 ≥ 皿顶+2 (was 21)

// ---- Centre floor + removable insert (rev Q, USER-CONFIRMED "支座改可拔插插芯") ----
//   一体支座(rev F–P)改为：Pent 底部固定环形地板（外 Ø20 × 高 6，中心 Ø18.5
//   通孔，熔接 +X 墙 1mm + 3 肋），插芯单独打印（定位段 Ø17.4 / 座台 Ø19.4 /
//   上身 Ø16 / Ø12 销孔，全长 11，顶=基片底 −6）。
//   液滴模式：插芯+铜棒落放（基片顶在 −6）；标定模式：整组拔出，比色皿经
//   Ø18.5 孔直落铜顶 −26 —— 12.5² 外接圆 Ø17.7 留 0.4/边。
flr_od   = 20;      // [mm] 环形地板外径（r10，+X JOINT 内缝 9 搭接 1mm 融合）
flr_bo   = 18.5;    // [mm] 地板中心孔 Ø（USER-APPROVED：比色皿 Ø17.7 + 0.4/边）
ins_loc  = 17.4;    // [mm] 插芯定位段 Ø（z 0..6 滑入地板孔 18.5，0.55/边；再给
                    //      +X JOINT 墙(内缝 9 处,|y|>2.1) 留 ≥0.3mm —— 17.9 只有 0.05）
ins_flg  = 19.4;    // [mm] 插芯座台 Ø（z 6..7，坐在地板顶环面 9.25..10 上，0.45）
ins_od   = 16;      // [mm] 插芯上身 Ø（基片座，z 7..11，腔中净空 17 → 1mm/边）
ins_h    = z_sub_bot - z_pent_bot;   // 11  插芯全长（顶 = 基片底 −6）

// ---- Vertical chain, thermal stack (below the copper) ----
z_tec_top = z_cop_bot;               // −38.0  copper bottom = TEC cold face
z_tec_bot = z_tec_top - tec_t;       // −42.0  TEC hot face
z_wb_top  = z_tec_bot;               // −42.0  water block top
z_wb_bot  = z_wb_top - wb_t;         // −51.5  water block bottom
z_barb    = (z_wb_top + z_wb_bot)/2; // −46.75 barb axis = block mid-height

// =============================================
// rev K — 热堆定位模块 (StackCradle) + 支撑组件 (SupportBase)
//   USER-REQUESTED. 两件新的 3D 打印件，全部挂在上面已定稿的 Z 链上：
//     StackCradle()  定住 铜块 / TEC / 水冷头 的位置与相对位置，并把 rev G
//                    就已定稿的 4 个立柱锚点做成实体台。
//     SupportBase()  把 底板 + 整堆 + 保温筒 托到（另购的）高度调节台上。
//
//   障碍楔不约束这两件：它们整体在 Z ∈ [−114.3, −34.8]，远低于楔的限带
//   [−26,+26]。立柱锚点也照样安全 —— (0,±36) 不满足 "X>0"，(−36,±15) 的
//   X<0，四个点都在自由侧（与 rev G 的判断一致）。
//
//   ⚠ 口沿高度是本块唯一的"危险尺寸"，推导写在 StackCradle() 上面。
// =============================================
cr_wall   = 3;      // [mm] rev K 的套座壁厚。rev L 起外廓由 cr_col_w 定，
                    //      壁厚不再是常数（X 壁 3.6 / Y 壁 2.7），此值只作存档。
cr_clear  = 0.4;    // [mm] 单边间隙 — 沿用文件既有规则：对 TEC / 水冷头
                    //      只能是间隙配合，过盈会压碎 TEC 的 0.6–1 mm 氧化铝面
cr_bore   = tec_s + 2*cr_clear;     // 40.8  水冷头 (40) 与 TEC (40) 共用腔
cr_vclr   = 1.2;    // [mm] 口沿必须比它上方那个件的**接触面**低这么多。装配时
                    //      铜块是随保温筒从上方落下来的，口沿一旦高过接触面，
                    //      铜块就会压在套座上而不是压在 TEC 上，预紧力整个失效
cr_rim_z  = z_tec_top - cr_vclr;    // −38.0  套座口沿 = 铜块底面下方 1.2
cr_plt_t  = 4;      // [mm] 底板厚
cr_plt_w  = 96;     // [mm] 底板边长 (rev S: 88→96) — 每个 Ø20 锚台套筒必须整座
                    //      落在板上：套筒在 (0,±36) 张开 y∈[26,46]、在 (−36,±15)
                    //      张开 x∈[−46,−26] ⇒ 半宽 ≥46 ⇒ 96 留 2 mm 边
cr_plt_z  = z_wb_bot - cr_plt_t;    // −55.5  底板底面 = 支撑件顶面 (rev W: −54.3 − 1.2)
cr_rim_lz = round((cr_rim_z - cr_plt_z)*1e6)/1e6;    // 16.3  套座口沿（局部 Z）
                    //      ⚠ snap 到 1e-6：rev L 的角撑底面要用它、抱箍顶面要用
                    //        cr_top_lz，两处必须与塔身**逐位相同**才能合并 ——
                    //        "数学上相等"不等于"浮点上相等"（陷阱 4 的 ULP 膜）。

//   —— rev L 抱箍：用铜块露出的 3.8 mm 当基准，把 铜块/TEC/水冷头 并成一条链 ——
//   rev K 的 X/Y 有**两条独立基准**：铜块靠保温筒井孔（0.2/边），水冷头靠套座孔
//   （0.4/边），两者之间只靠"底板自由坐在支撑件平顶上"衔接 —— 而那块底板**没有
//   任何横向定位**。铜块压在 TEC 上的单边余量只有 5.0 (X) / 5.9 (Y)，底板一滑，
//   面接触就变边接触，0.6–1 mm 的脆性氧化铝被静默压裂而外观毫无异常。rev L 让
//   套座一直长到抱住铜块露出井外的那段，于是 TEC / 水冷头自动与铜块本体对齐。
cr_col_w  = 58;     // [mm] 套座 + 抱箍的**统一外廓**（rev K 的下部是 46.8）。
                    //      必须 ≥ 抱箍孔 52.6 + 两侧壁，否则抱箍的墙整个悬在
                    //      套座之外 —— 零件会断成不连通的两块。
cr_bore_x = plate_x + 2*cr_clear;   // 50.8  抱箍孔 X（铜块 50）
cr_bore_y = plate_y + 2*cr_clear;   // 52.6  抱箍孔 Y（铜块 51.8）
cr_lip_y  = 44;     // [mm] +X 开口宽度（|Y| ≤ 22）—— TEC 侧面接线，必须有一面
                    //      敞开，统一到水冷头水嘴那一面。两侧各留 3.5 mm 宽的
                    //      "角撑"补回 +X 定位：没有它，套座能在铜块底下沿 +X
                    //      滑 5.4 mm 才失去接触 —— 正是 rev L 要根除的静默压裂
                    //      模式。设 ≥ cr_bore_y 即关掉角撑、整面敞开。
                    //      ⚠ 角撑**没有**缩小引线通路：套座那一段的开口本来
                    //        就只有 |Y| ≤ cr_bore/2 = 20.4。
cr_top_z  = z_frame_bot - cr_vclr;  // −34.2  抱箍口沿 = 保温筒底面下方 1.2。
                                    //      必须比 −33 低：保温筒落到位时不能坐在
                                    //      抱箍上，否则 TEC 预紧力被整个旁路。
cr_top_lz = round((cr_top_z - cr_plt_z)*1e6)/1e6;    // 20.1  抱箍口沿（局部）
                                    //      对铜块突出部 (−36.8…−33) 的抱合量
                                    //      = −34.2 − (−36.8) = 2.6 mm。snap 同
                                    //      cr_rim_lz：16.3 与 20.1 同属一个二进制
                                    //      阶（[16,32)），差值精确 ⇒ 角撑高度
                                    //      cr_top_lz−cr_rim_lz 加回去**恰好**是
                                    //      cr_top_lz，顶面才能与塔身顶面合并。
cr_cham   = 1;      // [mm] 抱箍口 1 × 45° 导入倒角
cr_lap    = 0.01;   // [mm] 差集切面之间的搭接 —— 防共面切带（rev F 陷阱 b）

//   立柱锚点：rev G 就已定稿的 4 个位置（全在 60×60 底座外、五边形 28.3 外、
//   离光轴 ≥36）。rev S 起这里不再是"低台"：4 个 Ø20×15 锚台套筒（含 Ø12 盲孔
//   与 key 槽）把 cage 的 4 根轴销收住 —— 承载 + 定位都在这四个点上（见 rev S
//   头注与 CLAMPING 块）。
// rev T — A2 从 (0,−36) 迁到 (−24,−36)：rev S 的 (0,−36) 柱已经踩进 BS2 障碍楔
//   （X>0 ∧ Y<1.25X−25）的领地，新套筒整段 x∈[−34,−14] 都在 X−，44 长 key 跨
//   x∈[−46,−2]，A2(−24,−36)→A4(−36,−15) 相距 24.2 mm（≥ Ø20 套筒直径）。
col_pos    = [[0, 36], [-24, -36], [-36, 15], [-36, -15]];
col_sock_od = 20;   // [mm] 锚台套筒外径（壁厚对 key 通道 ≥ (20−12)/2 = 4）
col_sock_h  = 19;   // [mm] 套筒顶面（LOCAL z） —— 比塔顶 20.1 低 1.1，底座
                    //      底面 (−33) 永远碰不到套筒口（rev S 关闭了 rev R
                    //      会话遗留的口沿干涉问题）
col_pin_br  = 12;   // [mm] Ø12 盲孔（LOCAL 4..19），收 4×Ø10 轴销（1/边）
col_key_z   = 7;    // [mm] key 通道 LOCAL z 下沿（channel z 7..10）

sup_h      = 58;    // [mm] 支撑件总高（底面 → 顶面）
                    //      rev W 铜块下移 1.2 → 热堆整体下移；高度预算：
                    //      支撑底面 → 光束 = 51.5 + cr_plt_t + sup_h = 113.5 mm。
                    //      USER-CONFIRMED (2026-09-18)：减 sup_h 60→58，台面到光束
                    //      = 113.5 + stage min 100 = 213.5 mm，215 上限余量 1.5 mm
                    //      （sup_h=60 时 215.5 超上限 0.5）。台子升到 150 mm ⇒ 265.5。
                    //      ⚠ 余量偏紧：想再留裕量就继续减 sup_h（每减 1 mm，台面到
                    //        光束就减 1 mm），台子的行程会补回来。
sup_w      = 70;    // [mm] 支撑件外廓（方管）
sup_wall   = 4;     // [mm] 管壁厚
sup_top_t  = 5;     // [mm] 顶板厚 — 这一面的底面承 底板，打印时朝下贴板，
                    //      由热床保证平整（承 底板 的那一面 = 装配里的上面）
sup_rib_t  = 3;     // [mm] 内部十字筋厚
                      // (rev M: 底面 3 只 Ø8 脚垫已按用户要求删除 —— 底面整体
                      //  贴高度调节台台面，四壁/筋直通到底，总高不变)
sup_body_h = sup_h; // 58   四壁/筋的下端 = 底面（无脚垫）
z_sup_bot  = cr_plt_z - sup_h;      // −113.5 支撑件底面 = 高度调节台顶面

// ---- Build-level ----
//   (rev G: the dead g_d / g_w placeholders were removed — the live gasket
//    parameters are the jg_* set below.)
h_top = 10;         // [mm] top cap height (Z ∈ [+8,+18]). The sealed gas
                    //      column above the droplet is the CAVITY, h_top −
                    //      cp_t = 7 mm — NOT the gasket groove depth.

// ---- Retainer cage (rev T — TWO printed layers: plate + arms, register+pin) ----
//   The stack clamping hardware per the CLAMPING note. The old rev N columns +
//   M3 placeholder is GONE. Rev S proved one fused cage; rev T (2026-09-15,
//   USER-CONFIRMED "拆两层分开设计、打印") splits it into TWO prints so the part
//   budget, the boss routing and printability stop fighting each other:
//     • LAYER 1 = PressPlate  (+18..+20, show == 7): inset pentagon flush on the
//       top-cap roof, Ø8 needle bore, Ø18 DS18B20 cut-out, + ONE Ø3.2
//       anti-rotation pin on top at rc_arot_pos. Flush face = the Z datum.
//     • LAYER 2 = ArmsLayer  (+20..+22, show == 11): centre HUB (ID 8.2 / OD
//       11.8) sleeves the plate bore → X/Y register (0.2 mm slip), a Ø3.4 hole
//       catches the plate's anti-rot pin, and an INTEGRATED west spine + A1 legs
//       + A2 south leg + A3 north stub carries the 4 tip bosses. The flap of the
//       spine near the centre connects A1 down through the hub sleeve.
//     • Each arm tip = Ø13 RING COLLAR on the Ø10.5 pin bore (rc_boss_z0..z1):
//       rev T2 shrank the old Ø16 solid boss to a thin ring (wall 1.25, halving
//       the old 2.75 band per user "圆环减半"). The A1 leg2 / A2 west-bar seats
//       were widened to 14 AND extended past the ring far edge so the collar
//       sits fully on arm material (was 37 %). Each ring carries a Ø3.4 radial
//       passage (along −X, rev T2.1 mirror) at rc_tslot_z for the Ø3 SIDE KEY
//       that anti-rotation-locks ring ↔ the pin's TOP slot. Guard only (no vertical load); the
//       preload is carried ONLY by the bottom key + cotter.
//   Verified constraints (all re-measured after the A2 move):
//     • 4 arms reach the 4 frozen anchor sockets col_pos = (0,+36), (−24,−36),
//       (−36,±15). A2 was RELOCATED rev S (0,−36)→(−24,−36) because the old
//       socket column at (0,−36) entered the BS2 obstacle wedge (X>0 ∧ Y<1.25X−25)
//       territory. The new socket spans x −34..−14 (fully X−), its 44-long key
//       spans x −46..−2, and A2(−24,−36) → A4(−36,−15) is 24 mm apart (≥ the
//       Ø20 sockets). A2 rides as a west bar x −29..−19, y −36..−8.
//     • every arm stays ≥ 9.5 mm from the Ø16 DS18B20 boss centre at
//       (−10.5,+10.5): A1 leg1 10.0, A1 leg2 18.5, A2 west bar ≥ 20.4, west
//       spine 20.8, A3 stub 18.5 (boss radius 8, ≥8.5 required). Verified at the
//       arm band by slice check.
//     • disc + collar stacks (Ø23/ID18.2 + Ø23/ID14×7.0, rev T4) sit ON the arm
//       top (+22) around each pin: disc free 2.0 + collar 7.0 = 9.0, pressed by
//       the cotter (开口销) at +31.33 (hole bottom face +30.33, span arm→cotter
//       8.33) ⇒ δ=0.67 ⇒ ≈40 N/leg (k≈59 N/mm @ Ø23 single disc) ⇒ ≈160 N total.
//       Tolerance ±0.3 mm ⇒ ≈88..232 N (TEC window 80..240 N). Preload is set by
//       the COLLAR thickness (and the pin-printed cotter hole), never by torque.
//       δ is NOT set by the cotter hole position: the hole is pin-printed and the
//       disc alone would float 7.33 under it (rev T4 audit — zero-preload trap).
//   ⚠ OPEN: the cradle plate (96×96, rev S) overhangs the 70×70 SupportBase top
//     by ≈13 mm/side. The sockets sit fully on the plate, the load passes down
//     their columns, and the plate is 4 mm ASA — accept + re-verify before print.
rc_p_t      = 2.0;   // [mm] plate AND arm thickness (+18..+20 / +20..+22)
rc_p_bot    = z_pent_top + h_top;   // +18  plate underside = cap roof top
rc_p_ins    = 1.5;   // [mm] plate-outline inset from pent_outer (clear felt)
rc_p_hole   = 8.0;   // [mm] central bore (clears the Ø5 needle hole) — doubles
                     //      as the arms-hub sleeve register (0.2 mm slip)
rc_arm_bot  = rc_p_bot + rc_p_t;    // +20  arms underside = plate top
rc_arm_top  = rc_arm_bot + rc_p_t;  // +22  arms top (= disc-spring seat)
rc_arm_w    = 10;    // [mm] arm width. The Ø16 DS18B20 boss at (−10.5,+10.5)
                     //      (z +18..+22) sits inside the arm band, so A1/A3/A4
                     //      are routed around it (see the module comment) —
                     //      smallest resulting clearance 10.0 mm from the boss
                     //      centre (A1 leg1), far above the 8.0 boss radius.
rc_key_w    = 6;     // [mm] key bar width (Y). Defined BEFORE the derived group:
rc_key_t    = 3;     // [mm] key bar height (Z).  rc_tslot_z / rc_pin_bot depend
rc_key_l    = 44;    // [mm] BOTTOM key bar length (X) for A1/A2. A3/A4 use 24 —
                     //      see rc_key_l_col (a 44 for (−36,±15) would have its
                     //      +X end reach into the cradle cavity ① past x −20.4).
rc_key_l_col= [rc_key_l, rc_key_l, 20, 20];     // per-socket bottom-key length (X):
                     //      A3/A4 (−36,±15) 44→20 (span p_x−10..p_x+10 = −46..−26 =
                     //      EXACTLY the Ø20 anchor-socket dia): the +X end is now
                     //      FLUSH with the socket face — nothing enters the tower/
                     //      cradle interior at all (rev T2.2; 24 still poked ~2 mm
                     //      into the tower body). All keys still enter from −X.
rc_radkey_s = 3;     // [mm] RADIAL side-key SQUARE side (3×3 bar) — matches the pin's
                     //      square TOP slot; threads each ring's square passage
                     //      (+0.4 clr, 3.4×3.4) at rc_tslot_z, fixing ring ↔ pin.
                     //      rev T2: replaced the 6×3×22 flat top keys; rev T2.2:
                     //      ROUND Ø3 dowel → SQUARE — the round key fitted the ring's
                     //      round passage but slopped in the pin's square slot (user:
                     //      "立柱两端孔都是方的"). Square prints flat, zero slip.
rc_radkey_l = 16;    // [mm] side-key length — ring Ø13 + lead-in both sides
rc_key_clr  = 0.2;   // [mm] per-side slot clearance (slot Y = key_w + 2·clr)
rc_arm_wide = 14;    // [mm] WIDENED boss seat under A1 (leg2) and A2 (west bar):
                     //      the Ø13 ring (r 6.5) must sit fully on material — the
                     //      old 10-wide members ended at the boss centre (37 %).
                     //      A3/A4 ride the 10-wide spine/stub (92.5/95.3 %), untouched.
rc_hub_od   = 11.8;  // [mm] arms centre-hub OD — sleeves the plate bore for X/Y
                     //      register. Kept ≤ 12.9 so it clears the Ø16 DS18B20 boss
                     //      near-face at 6.85 from axis (OD 11.8 ⇒ 0.95 gap).
rc_hub_id   = rc_p_hole + 0.2;      // 8.2  sleeve over the plate Ø8 bore
rc_arot_d   = 3.2;   // [mm] anti-rotation pin (plate boss) → Ø3.4 hole in spine
rc_arot_pos = [-8.0, -6.0];   // [mm] pin XY — under the west-spine root, clear of
                     //      the centre bore (10.0 from axis) and of the boss cut-out
rc_boss_d   = 13;    // [mm] arm-tip boss = RING COLLAR Ø (bore 10.5 ⇒ wall 1.25 =
                     //      half the old Ø16 / 2.75 band — rev T2 user "圆环减半").
                     //      The A1/A2 seats are widened 14 + extended past the ring
                     //      far edge; A3/A4 fully covered (92.5/95.3 %). Non-load-
                     //      bearing; sits under the Ø23 disc stack, well below ID 18.2.
rc_boss_z0  = rc_arm_bot - 0.8;     // 19.2 ring underside — bites 0.8 below the
                     //      arm so it stands as a small pedestal (print plate-down,
                     //      no support): the Ø3 radial side-key axis lives mid-ring.
rc_boss_z1  = rc_arm_bot + 2.9;     // 22.9 ring top — the side-key passage (Ø3.4 at
                     //      rc_tslot_z) is fully inside the ring at all times.
rc_tslot_z  = rc_boss_z0 + 0.7 + rc_key_t/2;   // 21.4 radial side-key axis (Z) —
                     //      inside the pin TOP-slot band (19.2..23.6) so the Ø3
                     //      dowel crosses ring wall + pin at their mid-height.
rc_pin_d    = 10;    // [mm] pin Ø (printed ASA, or Ø10 steel rod alternative)
rc_pin_h    = 82;    // [mm] pin length (SHORT/droplet): base −50.5 → top +31.5
                     //      (rev W dropped the socket 1.2 with cr_plt_z −55.5, so the
                     //      "−49.3/+32.7" of the old comment is stale. The cotter hole
                     //      top at +32.33 now pokes 0.83 INTO the top face — pins
                     //      printed from the CURRENT file carry a slightly open cotter
                     //      slot at the tip; still functional, cosmetically imperfect.
                     //      Fresh short-pin prints should use rc_pin_h = 84.)
rc_pin_slot_c = 3.5; // [mm] BOTTOM key-slot centre from the pin base (slot 2..5
                     //      lands EXACTLY on the socket key channel 7..10 = −48.5..−45.5)
rc_pin_bot  = cr_plt_z + col_key_z - (rc_pin_slot_c - rc_key_t/2);  // −50.5 pin base
                     //      (1.0 above the bore floor −51.5 — the pin rests on the key)
rc_topslot_t = 4.4;  // [mm] pin TOP slot height = 3.0 key + 1.4 vertical slack:
                     //      non-load-bearing anti-rotation guard (never carries δ)
rc_spr_w    = 23;    // [mm] disc OD (Ø23, wall band 2.4 — rev T3 user: 缩四颗立柱顶端
                     //      圆盘; Ø28 时 A2↔A4 中心距 24.19 ⇒ 相叠 3.8, Ø23 ⇒ 间隙
                     //      1.19 mm。boss 圆环（rc_boss_d 13）不动)
rc_spr_id   = 18.2;  // [mm] disc-spring ID (bore over the Ø13 boss ring)
rc_spr_t    = 1.2;   // [mm] disc material thickness (cone face, axial)
rc_spr_cone = 0.8;   // [mm] cone lift: OD rim rides rc_spr_cone above the ID rim
                     //      ⇒ ONE-disc free height 2.0 = t + cone
rc_spr_del  = 0.67;  // [mm] ONE disc NOMINAL deflection — the ONLY preload setter.
                     //      δ=0.67 ⇒ F = k·δ = 59 × 0.67 ≈ 40 N/leg ⇒ ≈160 N total
                     //      (k≈59 N/mm @ Ø23 single disc, Ø28 k=40 scaled ∝1/D²).
rc_spr_inst = rc_spr_t + rc_spr_cone - rc_spr_del;   // 1.33 installed disc height
                     //      (2.0 free − 0.67 δ). The disc is compressed BETWEEN the
                     //      arm top (+22) and the COLLAR bottom (+23.33) — NEVER
                     //      between arm and cotter: the cotter is 9.33 above the arm
                     //      top and would float 7.33 above a free 2.0 disc (rev T4).
rc_spr_i    = 9.33;  // [mm] cotter-hole offset above the arm top — PIN GEOMETRY IS
                     //      FIXED: the Ø10 pin prints the hole at this height
                     //      (axis +31.33 = rc_arm_top + rc_spr_i). It is the pin's
                     //      printed datum, NOT a "tune δ" knob — you do not move it.
rc_spr_cot  = 1.0;   // [mm] cotter-hole radius: the Ø2.2 hole's BOTTOM edge sits
                     //      rc_spr_cot below the axis ⇒ +30.33 — the face the cotter
                     //      actually bears on.
rc_spr_seat = rc_arm_top + rc_spr_i;   // +31.33 cotter hole AXIS (pin-printed)
rc_col_h    = rc_spr_seat - rc_spr_cot - rc_arm_top - rc_spr_inst;   // 7.0 mm
                     //      [mm] COLLAR height (rev T4) = cotter BOTTOM (+30.33) −
                     //      disc INSTALLED top (+23.33). The collar sits ON the disc
                     //      OD rim, pressed by the cotter, and that cobination —
                     //      disc free 2.0 + collar 7.0 = 9.0 — must compress into the
                     //      span arm-top→cotter-bottom = 30.33 − 22 = 8.33
                     //      ⇒ δ = 9.0 − 8.33 = 0.67 ✓  (checked, not assumed)
rc_col_od   = 23;    // [mm] collar OD = disc OD (same A2↔A4 clearance 1.19 mm)
rc_col_id   = 14;    // [mm] collar ID — clears the Ø13 boss ring (+0.5/side), presses
                     //      down on the disc OD annulus 18.2..23 (full contact band)

// ---- TALL-column variant (rev V) — HIGH-CAP / calibration build -------------
//   Root cause (user field report): the tall roof fused with the Ø16 boss rises
//   to +31.8 — within a whisker of the SHORT-column pin tops (≤+32.7) — and the
//   real felt climbed the tall cap, so the pin tops ended FLUSH with the felt top
//   and could take neither ArmsLayer nor PressPlate nor keybar preload. Fix: the
//   SAME cage parts are reused, LIFTED onto the tall roof (+9.8); ONLY the pin
//   lengthens (Ø10 × 93) so its TOP slot + cotter re-thread the elevated ring and
//   clamp chain. rc_pin_tall = 1 prints them from the SAME KeyBar sheet (show 10).
rc_pin_tall   = 0;    // 1 = tall/calibration columns (Ø10 × 93, cotter @ +41.13);
                      // 0 = short/droplet columns (unchanged Ø10 × 82)
rc_p_bot_tall = z_pent_top + h_top_tall;      // +27.8 plate underside = tall roof top
rc_arm_bot_tall = rc_p_bot_tall + rc_p_t;     // +29.8 arms underside (tall)
rc_arm_top_tall = rc_arm_bot_tall + rc_p_t;   // +31.8 arms top = disc seat (tall)
rc_boss_z0_tall = rc_arm_bot_tall - 0.8;      // +29.0 ring underside (tall)
rc_boss_z1_tall = rc_arm_bot_tall + 2.9;      // +32.7 ring top (tall)
rc_tslot_z_tall = rc_boss_z0_tall + 0.7 + rc_key_t/2;  // +31.2 side-key axis (tall)
rc_spr_seat_tall = rc_arm_top_tall + rc_spr_i; // +41.13 cotter-hole AXIS (tall)
rc_pin_h_tall = round(rc_spr_seat_tall - rc_pin_bot + rc_spr_cot + 0.37);  // 93
                      // [mm] pin length = cotter hole top (+42.13) + 0.37 tip margin
                      //      ⇒ pin top global +42.5, 10.7 proud of the tall boss top
                      //      (+31.8) and 24.5 above the tall roof (+27.8)

// ---- Joint gasket: DELETED (rev I, USER-DIRECTED "删槽") ----------------
//   The whole jg_* set, the GrooveRing module and all four call sites are
//   gone. Both faces of both joints are FLAT. What this gives up, stated
//   plainly rather than glossed:
//     • the stack is no longer gas-tight on its own — registration is the five
//       榫 tenons only (plus the not-yet-modelled retainer cage);
//     • the rev H self-limiting chain loses its trigger. That chain closed the
//       screws through a 0.4 mm cord stand-off and then hard-stopped the well
//       ceiling on the copper top at Z=−26; with flat faces the two joint
//       faces meet directly, so the stand-off is 0 and the ceiling stop is
//       reached immediately.
//   Both are acceptable FOR THIS EXPERIMENT and were the user's call: 方案 C
//   (2026-08-24_large_cavity_first_droplet_method.md) is a deliberately OPEN
//   chamber whose Ø2 mm-class needle hole is left unsealed because the leak
//   time constant is ~46 days against a 100–300 s droplet lifetime. Nothing
//   in the optical path depends on the chamber holding pressure.
//   Do NOT read this as a thermal change: the grooves were 0.8 mm deep in a
//   wall that is now 3–5 mm, and both are dwarfed by the surface films. If a
//   seal is wanted later it should be a flat gasket sheet or a bead of RTV on
//   the flat faces, not a machined groove.

// ---- Joints: anti-slip interlock ONLY (no screws, no inserts, no grooves) ----
//   Between modules the 榫 keep the stack registered — with the gasket grooves
//   deleted in rev I they are the ONLY registration, which is why the socket
//   lands below are a hard floor on w_j.
//   The compressive force is NOT built in — see the CLAMPING note below.
j_pin_d = 2.4;      // [mm] anti-slip peg dia (was 3.0 — it cut the old groove)
j_pin_h = 2.4;      // [mm] peg height / socket depth
// Peg centres sit 2.5 mm in from the OUTER face, centred on the w_j joint ring:
//   socket Ø2.8 spans 1.1..3.9 → 1.1 mm land outer, 1.1 mm land inner;
//   peg    Ø2.4 spans 1.3..3.7 → 1.3 / 1.3 mm.
//   rev I: these were 4.9 mm in (x=−15.1 / y=+15.1). That was correct for the
//   7 mm ring of rev E–H but is INVALID on a 5 mm ring — the Ø2.8 socket would
//   span 3.5..6.3, i.e. 1.3 mm PAST the inner edge, opening the 卯 into the
//   cavity. The centre must track the ring, so write it as w_j-derived, not as
//   a constant:   centre_from_face = w_j − 2.5
//   Also clear of the pedestal ribs, which end at reach c_j = 15 (nearest
//   socket edge 17.5 − 1.4 = 16.1 → 1.1 mm clear).
// rev R (2026-09-15): FIVE pins, one per ring face. Positions are DERIVED from
// the profile constants so they stay inside the ring if the geometry changes:
//   EA(−X), DE(+Y) kept; CD(+X) at the face's vertical mid (y=6.5 — clear of
//   the Ø10 aperture band y=±5 by 1.5 mm in the z22..25 band overlap);
//   AB(−Y) at x=−9 (7.5 mm from the B-corner wedge, inner land intact);
//   diag BC at its midpoint, 2.5 mm in along the inward normal
//   (−(half+fc_y), hx_f)/|BC| — mud at (7,−13.5) → pin (5.30,−11.67).
pent_pins = [
    [-(half - (w_j - 2.5)), 0.0],                      // EA −X face
    [0.0, half - (w_j - 2.5)],                         // DE +Y face
    [hx_f - (w_j - 2.5), 6.5],                         // CD +X face
    [-9.0, -(half - (w_j - 2.5))],                     // AB −Y face
    [ hx_f/2, (fc_y - half)/2 ]                        // BC diagonal face
      + (w_j - 2.5) * [-(half + fc_y), hx_f]
        / sqrt(pow(hx_f, 2) + pow(half + fc_y, 2))     // 2.5 mm in from mid-face
];

// ---- Windows: 0.5″ × 3 mm glass in a 2 mm seat, RTV-106 / O-ring rim seal ----
//   Geometry: the Ø10 aperture bores the full wall at the beam line; a Ø12.7
//   × win_g glass disc drops into the 2 mm cup on each face, opening from
//   OUTSIDE. With win_g = 3 the disc stands 1.0 mm proud of the face — see the
//   win_g parameter note for why that is accepted rather than deepening the
//   seat. The 2 mm of engaged bore still carries the rim seal; sealing +
//   fixation = RTV-106 bead (or a silicone O-ring) in the 0.4 mm rim gap
//   (win_clr). Captive cup = radial location + axial capture.
// ⚠ FILM CUT-OUTS (rev I): the felt must be cut away over both windows. A
//   3 mm felt disc left covering the glass would put a scattering, opaque,
//   thermally-shorting layer in the beam. Needed per ±X face: one Ø14 hole
//   centred on the window (it clears the Ø13.1 seat AND the Ø10 aperture
//   behind it). The user is cutting the film; this is the spec for it.

// ---- Stack clamping: PRINTED RETAINER CAGE (rev G — USER'S CHOICE) -----
//   The external 3-corner wrap frame (corner posts + triangular press plate
//   + M3 studs into brass inserts) was REMOVED in rev F along with every fr_*
//   parameter and z_plate_bot. The user then chose the REPLACEMENT mechanism:
//   a printed side retainer cage (保持架) — NOT RTV glue. RTV's only job was
//   anti-tipping; a cage does that AND does it better (see the thermal note).
//
//   ONE closed load loop solves BOTH force paths at once:
//
//     螺钉+碟簧 → 顶盖 → 五边形接缝 → 底座 → 井顶台阶 → 铜块 → TEC → 水冷头
//        ↑                                                                 ↓
//        └──── 底板（定位套座在支板上）← 立柱 ← ← ← ← ← ← ← ← ← ← ← ← ← ← ←┘
//
//   • FORCE PATH ①  TEC preload = the ONLY force that has to be engineered.
//     With the gasket grooves deleted (rev I) there are no cord squeezes left
//     to close, so the requirement collapses to the TEC vendor window alone:
//     50–150 kPa over 40×40 = 1600 mm² → 80–240 N total, target ≈ 150 N
//     (≈ 94 kPa). The chain is SERIES, so that one force passes through the
//     cap → both flat joints → the base → the well-ceiling step → the copper
//     → the TEC → the water block. Nothing in between absorbs it.
//     ⚠ rev E–H instead sized the screw force from the rubber (1.0–1.5 N/mm
//     over the 140 mm pentagon perimeter → 140–210 N per joint). That driver
//     is GONE, and with it the risk that the cord's near-98 % groove fill
//     pushed the preload above 150 kPa. The number to hit is now just 150 N.
//   • SELF-LIMITING, still, but by a simpler path: the well-ceiling + rev W
//     seal-shelf floor (all at Z = −26) presses on the copper top at −27.2
//     (0.2 seat-in gap, cop_seal_gap), so once the flat joint faces touch, all
//     further screw force goes into TEC preload and none of it into the printed
//     walls. ⚠ rev W: ~0.2 mm of disc-spring travel is consumed seating the
//     copper before preload builds — at the fixed collar setting δ_net ≈ 0.47
//     ⇒ ≈ 111 N total (window 80..240 in either case). The rev H 0.4 mm
//     cord stand-off is gone; there is no longer a 0.4 mm travel before the
//     stop, so back the screws off to the measured spring height, do not
//     torque to a value.
//   • DISC SPRINGS ARE MANDATORY: the chain is rigid, so the force is set by
//     spring COMPRESSION (F = kx), not by displacement. Without them a
//     thermal cycle changes the force unpredictably.
//   • The cage must be a pure CLEARANCE fit on the TEC / water block (0.4 mm
//     per side) — never an interference fit, or it would edge-load the 0.6–1
//     mm alumina faces of the TEC and chip them. The cage carries NO sustained
//     load (only handling shear), so creep is not a concern. rev I: material
//     is now ASA, not PLA (ASA creeps less, additionally reassuring here).
//   • THERMAL BYPASS is negligible: the cage bridges the cold cap (≈15 °C) to
//     the water block (≈30 °C); with 2 mm ASA walls (k ≈ 0.17 W/m·K),
//     R = L/(k·A) ≈ 145 K/W → ΔT ≈ 15 K → Q ≈ 0.10 W against a 3–5 W TEC
//     load, i.e. ≈ 2–3 %.
//
//   Z ENVELOPE (settled): cage spans Z ∈ [−49.3 (base plate top face =
//   z_wb_bot) … +18 (TopCap top = z_pent_top + h_top)], plus the base-plate
//   and press-plate thicknesses.
//   ✅ rev S (2026-09-15): the geometry TODO is RESOLVED by a thread-free
//   mechanism (see the rev S header block and the rc_* parameter set):
//   4 arms to the frozen col_pos + Ø10 pins + printed key bars + printed preload
//   collars (rev T4) + disc stacks on the arm tops loaded by cotter pins ⇒ ≈160 N
//   on the cap roof, δ-set by the COLLAR thickness, never by torque. No screws, no
//   nut pockets, no column bases.
//   The stack remains located by the 5×Ø2.4 tenons 榫 (the cage adds preload and
//   anti-tipping; it is NOT a gas seal — see rev I notes on the open chamber).
//   Prior geometry: rev N columns/M3 placeholder, dated snapshots
//   insulation_chamber_v6revE/F or git.

// =============================================
// OBSTACLE GHOST — preview only
//   The beam arm from the focus to BS2 at X=+20 and the support rod at Y=−25
//   define the hypotenuse  Y = 1.25·X − 25. Everything on the BS2/rod side of
//   it is BLOCKED, but only inside the beam band Z ∈ [−26,+26]; above and
//   below that band the space is free — which is what lets the copper/TEC/
//   water-block stack (all below Z=−26) sit under the wedge.
//       blocked:  X > 0  AND  Y < 1.25·X − 25,   Z ∈ [−26,+26]
//
//   rev I FIX. The previous ghost was wrong twice over:
//     (1) its comment stated the complement — "Y > 25 − 1.25·X", slope sign
//         inverted — so it named the free side as blocked;
//     (2) its polygon took MIXED +n / −n offsets of the BS2→rod segment, which
//         makes a concave, self-intersecting quad lying on the FREE side.
//   Net effect: it displayed the exact complement of the real obstacle, so any
//   interference check done against it was meaningless. It now sweeps the true
//   blocked half-plane, extruded over exactly the band — which also makes the
//   base overhang in the header's open item VISIBLE instead of hidden.
// =============================================
module ObstacleGhost() {
    ext = 55;                    // how far the wedge is drawn past the chamber
    m  = -rod_y / bs2_x;         // 1.25   line: y = m·x + rod_y
    s  = sqrt(m*m + 1);          // 1.6008 |normal| = √(1.25²+1)
    nx =  m / s;                 // +0.7809  outward normal, INTO the blocked side
    ny = -1 / s;                 // −0.6247  (gradient of  1.25x − y − 25)
    L  = sqrt(bs2_x*bs2_x + rod_y*rod_y);   // 32.016
    tx =  bs2_x / L;             // +0.6247  unit vector along rod → BS2
    ty = -rod_y / L;             // +0.7809
    color("Tomato", 0.22)
        translate([0, 0, -obs_band])
            linear_extrude(height = 2*obs_band)
                polygon([                       // CCW: far corner first
                    [0 - tx*ext + nx*ext, rod_y - ty*ext + ny*ext],
                    [bs2_x + tx*ext + nx*ext,   0 + ty*ext + ny*ext],
                    [bs2_x + tx*ext,            0 + ty*ext],
                    [0 - tx*ext,                rod_y - ty*ext]
                ]);
}

// =============================================
// FILM GHOST — preview only (rev I)
//   The external insulation: 富立仕 3 mm self-adhesive aerogel felt, aluminium
//   foil out, k ≈ 0.018 W/m·K → R = t/k = 0.1667 m²K/W. It is glued to the
//   OUTSIDE of the printed stack, so it costs ZERO cavity volume. That is the
//   entire point of the rev I redesign: for a solid ASA wall the two surface
//   films are ~77 % of the thermal path, so the resistance has to be added
//   OUTSIDE — where the polished foil also suppresses the radiative part
//   (ε ≈ 0.05 → h_out ≈ 4, not 8–10). Assembly U: 2.302 for a bare 3 mm wall
//   vs 1.664 with the felt.
//
//   COVERAGE (pentagon perimeter 140.1 mm)
//     −X face (X=−20)   yes, full 3 mm
//     −Y face (Y=−20)   yes, full 3 mm
//     +Y face (Y=+20)   yes, full 3 mm
//     +X face (X=+14)   yes, full 3 mm   (leaves 3.0 mm to BS2 at X=20 — the
//                                         glass stands 1.0 mm proud to X=15,
//                                         then this felt to X=17; the Ø14
//                                         bore keeps the two from touching)
//     diagonal BC       TAPERED to zero  — 19.1 mm = 13.6 % of the perimeter
//   The 60×60 base frame is deliberately NOT insulated: it is the copper/TEC
//   region and wrapping it would fight the TEC.
//
//   WHY THE DIAGONAL IS TAPERED (the user's option C). BC runs (0,−20) →
//   (14,−7) and is nearly parallel to the obstacle hypotenuse Y = 1.25·X − 25,
//   closing on it toward the vertex. Perpendicular clearance from the point at
//   fraction s along BC:   d(s) = (5 − 4.5·s)/1.6008   →  3.12 mm at s=0,
//   0.31 mm at s=1. A felt of uniform thickness CANNOT be stuck on: at the
//   midpoint it would already need to be 1.72 mm and at the vertex 0.31 mm.
//   So the felt is cut as a WEDGE whose outer edge runs 0.3 mm clear of the
//   wedge line, giving thickness  min(3, d − 0.3):
//        s 0.00   d 3.123   t 2.82 mm     s 0.50   d 1.718   t 1.42 mm
//        s 0.25   d 2.421   t 2.12        s 0.75   d 1.015   t 0.72
//        s 1.00   d 0.312   t 0.01  (nothing left to stick)   s 0.90 t 0.29
//   Cut it straight along a jig line; do not try to hold 3 mm. This costs
//   little: where the felt is thinnest, the flanking ±Y and +X faces are
//   already at full 3 mm, and BC is the face pointing at the obstacle anyway.
//
//   CUT-OUTS — the user cuts these; sizes are the spec, not a suggestion:
//     • ONE Ø14 bore coaxial with the beam (±X faces), which clears the Ø13.1
//       window seat AND the Ø10 aperture behind it. A felt disc left covering
//       the glass would put a scattering, opaque, thermally-shorting layer in
//       the beam.
//     • rev P cut a Ø20 +Y hole for the DS18B20 boss here; DELETED in rev Q —
//       the probe moved to the top-cap roof, which is never felted.
//     • a relief slit at BOTH joint planes (Z=−17 and Z=+8). The felt goes on
//       three separate printed modules and must not bridge them, or it will
//       fight the joint faces apart.
//     • no cut-out is needed at the Ø5 needle hole — that is in the roof, and
//       this felt covers side walls only.
//
//   The trumpet (Z∈[−34.6,−17]) takes a SEPARATE piece following its sloped
//   lofted outer surface. It is NOT drawn here — this ghost only covers the
//   pentagon + cap prism, which is the part that needs checking against the
//   obstacle. Preview only; not a printable part and not exported.
// =============================================
FILM_T  = 3;                        // [mm] felt thickness as purchased
FILM_Z0 = z_pent_bot;               // −17  pentagon bottom  (trumpet piece separate)
FILM_Z1 = z_pent_top + h_top;       // +18  top cap top
module FilmGhost() {
    m   = -rod_y / bs2_x;           // 1.25   obstacle line  y = m·x + rod_y
    s   = sqrt(m*m + 1);            // 1.6008 |normal|
    yc  = rod_y + 0.3*s;            // −24.520  the line, pushed 0.3 mm clear
    BIG = 300;
    TOP = 600;
    color("LemonChiffon", 0.45)
        difference() {
            intersection() {
                // the felt ring = a true 3 mm outward offset of the pentagon.
                // BOTH extrusions are `linear_extrude` from z=0, so each needs
                // its own shift to FILM_Z0 — this is what places the felt.
                translate([0, 0, FILM_Z0])
                    linear_extrude(height = FILM_Z1 - FILM_Z0)
                        difference() {
                            offset(delta = FILM_T) polygon(pent_outer);
                            polygon(pent_outer);
                        }
                // … clipped to the free side of the 0.3 mm clearance line
                translate([0, 0, FILM_Z0 - 1])
                    linear_extrude(height = FILM_Z1 - FILM_Z0 + 2)
                        polygon([[-BIG, m*(-BIG) + yc],
                                 [ BIG, m* BIG + yc],
                                 [ BIG, TOP],
                                 [-BIG, TOP]]);
            }
            // Ø14 window cut-out, one bore through BOTH ±X faces on the beam.
            // Kept in GLOBAL coords (z_win = 0) since it is outside the shifts.
            translate([(hx_f - half)/2, 0, z_win])
                rotate([0, 90, 0])
                    cylinder(d = 14, h = half + hx_f + 2*FILM_T + 1.0,
                             center = true, $fn = 60);
            // rev Q — the DS18B20 sensor moved to the top-cap roof, so the +Y
            // felt cut-out is GONE. The roof is never felted (see CUT-OUTS).
        }
}

// =============================================
// 2D / joint helpers (shareable by any module)
// =============================================
// rev G: _vecsum / _centroid / _sc are DELETED. They existed only to build the
// old centroid-SCALED gasket groove, which was the rev E bug — scaling is not
// offsetting and produced a 0.92..1.32 mm slot instead of a 2.0 mm one. The
// groove now uses offset(delta=). Leaving the exact helper that caused the
// defect in the file would invite re-introducing it.

// Trumpet loft: lo (bottom) → hi (top) polygon cross-sections, height zh
function _lerp2(a, b, t) = [a[0]+(b[0]-a[0])*t, a[1]+(b[1]-a[1])*t];
function _smooth(t) = t*t*(3-2*t);
function _profile(lo, hi, t) = [
    for (i=[0:len(lo)-1]) _lerp2(lo[i], hi[i], _smooth(t))
];
module TrumpetLoft(lo, hi, zh, n=24) {
    for (i=[0:n-1]) {
        t0 = i/n;
        t1 = (i+1)/n;
        hull() {
            translate([0, 0, zh*t0]) linear_extrude(height=0.01)
                polygon(_profile(lo, hi, t0));
            translate([0, 0, zh*t1]) linear_extrude(height=0.01)
                polygon(_profile(lo, hi, t1));
        }
    }
}

// GrooveRing — DELETED in rev I (USER: "删槽"). Four call sites went with it
//   (BaseModule, PentModule ×2, TopCapModule). It is not coming back as
//   written: its whole reason to exist was to let a Ø2.0 silicone cord sink
//   below each face, and that is the mechanism the user has dropped. The
//   history is kept in the rev G/H blocks only so the same defect is not
//   re-introduced — notably that a SCALE factor is not a WIDTH (the rev E
//   version produced a 0.92..1.32 mm slot from a nominal 0.86..0.94 band),
//   which is why the last working version used offset(delta =).
//   FilmGhost below still uses offset(delta =) for the same correct reason.
// Blind M3 brass-insert bores — REMOVED (the corner bores were air-leak paths;
//   the stack carries no screws or inserts — clamping is by the external
//   PRINTED RETAINER CAGE, see the CLAMPING note in the parameter block).
// =============================================
// Alignment pegs on a face (榫)
module Pegs(pos, zbase, d = j_pin_d, h = j_pin_h) {
    for (p = pos)
        translate([p[0], p[1], zbase])
            cylinder(d = d, h = h, $fn = 30);
}
// Matching peg sockets (卯) in the mating face.
//   rev F fix: this used to cut DOWNWARD (zface−h → zface), but BOTH call
//   sites pass a BOTTOM face whose material is ABOVE it (Pent bottom local
//   z=0, TopCap bottom local z=0) — so the pockets were carved into empty
//   space below the part, never appeared, and the tenons 榫 had nothing to
//   enter. The pocket now runs zface → zface+h, poking 0.01 below the face
//   so no carve face is coplanar with it.
module PegSockets(pos, zface, d = j_pin_d + 0.4, h = j_pin_h + 0.5) {
    for (p = pos)
        translate([p[0], p[1], zface - 0.01])
            cylinder(d = d, h = h + 0.01, $fn = 30);
}
// Ear lugs — REMOVED (no more screw joints; the wedge-hugging side must keep
//   nothing protruding. Clamping is by the external PRINTED RETAINER CAGE —
//   see the CLAMPING note in the parameter block.)

// =============================================
// BASE — fused 60×60 hollow well frame + hollow trumpet (Z∈[−34.6,−17] global)
//   Local Z = frame bottom (0) → trumpet top / joint face (17.6 = frame_h 8.6 +
//   trans_h 9; frame_h is byte-snapped to a binary grid — see the frame_h block).
//   NOTE: frame_h changed in rev G (10 → 7), trans_h grew 6 → 9 in rev O, and
//   rev V raised the frame 7 → 8.6 (z_cop 3.8 → 2.2, USER: 底框向下增高 1.6 mm),
//   so zjoint runs 16 → 13 → 16 → 17.6 (local) and always lands on the
//   global −17: z_frame_bot −34.6 + 17.6 = −17. Every downstream module is
//   therefore unaffected — verified by render: the joint face measures
//   z = 17.61 local / −17 global.
//   Top ring = joint face (wall w_j): flat, + anti-slip pegs 榫. rev I deleted
//   the gasket groove here — see the joint-gasket block.
//   Bottom open: 50 × 51.8 copper block (rev J) slides in, protrudes 2.2 mm
//   onto the TEC (rev V).
// =============================================
module BaseModule() {
    zjoint = frame_h + trans_h;            // 17.6  (global −17)
    // 5-vertex polygons (vertex-to-vertex mapping onto 5-vertex pentagon —
    // rev D fix).  rev U reshapes the +X/−Y quadrant of both lo_sq and lo_in
    // so the trumpet wall hugs the BS2 wedge at 0.625 mm margin; the −Y and
    // +X walls remain at the original 60×60 / 48×48 reach in the other
    // quadrants.
    lo_sq = [
        [-frame_outer/2, -frame_outer/2],
        [-4.5,           -frame_outer/2],  // rev U: BS2 wedge hugging (0.625 margin)
        [ frame_outer/2,  13.125],         // rev U: wedge-parallel diagonal y=1.25x−24.375
        [ frame_outer/2,  frame_outer/2],
        [-frame_outer/2,  frame_outer/2]
    ];
    // 48×48 inner loft base (5-vertex, collinear midpoint on the bottom edge).
    // rev I (USER: "喇叭口适应修改"): 40×40 → 48×48. The well opening had been
    // sized against the OLD, much smaller pentagon cavity; once w_c dropped to
    // 3 the trumpet was needlessly necking the cavity down on its way up.
    // ±24 keeps a 1.2 mm seating ledge on the X sides of the well bore (50.4)
    // and 2.1 mm on Y (52.2, rev J), keeps the trumpet wall at 30−24 = 6 mm at
    // the well (≥ w_j = 5, so the load path from the frame into the pentagon
    // ring is never thinner than the ring itself), and leaves 1.0 mm/side
    // clearance on X (1.9 on Y) to the copper block whose top face forms the
    // well ceiling at −26.
    // rev U: the +X/−Y quadrant is reshaped (same as lo_sq) so the inner
    // cavity wall stays ≥ 5 mm inside the outer along the wedge diagonal;
    // the −Y and +X walls retain the original 24 mm reach in other quadrants.
    lo_in = [
        [-24, -24],
        [-7.77, -24],  // rev U: parallel to outer wedge diag, 6.3 mm inset
        [ 24,  15.71], // rev U: y = 1.25·24 − 14.77
        [ 24,  24],
        [-24,  24]
    ];
    // rev W/W2 → W3 — well-mouth floor, FLAT at −26 on top and −27.0 underneath.
    //   W3 (USER-CONFIRMED 2026-09-18, "找平接触平面"): ONE 1.0 mm ring slab =
    //   `bore_rect − lo_in` (the W2 notch triangle is now just a corner of it):
    //     • underside at frame_h − seal_t = −27.0 FLUSH over the whole ring ⇒
    //       the copper top (−27.2) bears on a SINGLE level plane (0.2 seat-in),
    //       uniform stress — before, only the notch hung to −27.0 while the loft
    //       cap ring underside stayed at −26 ⇒ uneven 0.2/0.8 contact.
    //     • top at frame_h (−26), flush with the loft cap ring / frame top.
    //     • flush against all four bore walls, fused in the union = one body.
    //     • the funnel hole (lo_in) is cut back OUT ⇒ cuvette drop / rod are
    //       untouched. Entirely below the band floor −26; never enters the wedge.
    module WellFloorSlab() {
        difference() {
            translate([0, 0, frame_h - seal_t])
                linear_extrude(height = seal_t)
                square([bore_x, bore_y], center = true);
            // cut the funnel hole back out of the slab (lo_in profile at the
            // well), overshoot slightly downward so the −27.0 face stays whole
            translate([0, 0, frame_h - seal_t - 0.01])
                linear_extrude(height = seal_t + 0.01)
                polygon(lo_in);
        }
    }
    module _base() {
        // hollow well frame — bottom OPEN so the 50 × 51.8 copper block slides
        // in from below and protrudes to sit on the TEC (0.2 mm/side fit).
        // NON-SQUARE since rev J: bore_x 50.4 / bore_y 52.2.
        difference() {
            translate([-frame_outer/2, -frame_outer/2, 0])
                cube([frame_outer, frame_outer, frame_h]);
            translate([-bore_x/2, -bore_y/2, -0.01])
                cube([bore_x, bore_y, frame_h + 0.01]);
        }
        // hollow trumpet up to the pentagon ring; inner loft ends at the 7mm
        // JOINT-ring profile (pc_j) so the joint face has a 7mm ring for the
        // gasket groove + shallow peg sockets (rev E thicker trumpet).
        translate([0, 0, frame_h])
            difference() {
                TrumpetLoft(lo_sq, pent_outer, trans_h, n=24);
                TrumpetLoft(lo_in,  pc_j,      trans_h, n=24);
            }
    }
    // rev I: this used to be difference(){ _base(); GrooveRing(...); } — the
    // groove is deleted (USER: "删槽"), so the joint face is plain.
    _base();
    // rev W: the well-floor slab is ADDITIVE (after the bore/loft differences)
    // and fused to the frame by its flush contacts — one printed body. rev W3
    // flattened the whole ring to −27.0 so the copper bears on one level plane.
    WellFloorSlab();
    // light anti-slip tenons (榫) only — no screws or brass inserts anywhere
    // in the stack. Clamping is by the external PRINTED RETAINER CAGE — see
    // the CLAMPING note in the parameter block.
    Pegs(pent_pins, zjoint, j_pin_d, j_pin_h);
}

// =============================================
// PENTAGON observation frame — windows on X-axis centerline at beam Z=0
//   Local Z = pentagon bottom (0) → pentagon top (25). Beam at local 17.
//   BANDED wall: JOINT rings (pc_j, wall w_j = 5) at the two joint faces
//   0..6 and 19..25, observation mid (pc_inn, wall w_c = 3) 6..19. +X face
//   pulled back to X=14 (flat seat); diagonal (0,−20)–(14,−7) hugs the wedge.
//   Centre annular floor (rev Q) with an Ø18.5 bore — the cuvette's drop path
//   in calibration, the removable-insert seat in droplet mode; braced by 3
//   radial ribs to the cavity walls, fused 1 mm into the +X joint wall.
// =============================================
module PentModule() {
    hh = z_pent_top - z_pent_bot;            // 25
    zbeam = z_win - z_pent_bot;              // 17
    ped_top = z_sub_bot - z_pent_bot;        // 11 pedestal/substrate level

    // pent shell = outer extrusion minus the BANDED inner carves (rev E):
    // JOINT ring (wall w_j) at the bottom 0..6 and top 19..25, observation
    // mid-section (wall w_c) 6..19 — so both joint faces are full w_j rings.
    // rev I: the band HEIGHTS are untouched; only the two wall thicknesses
    // changed (w_c 5→3, w_j 7→5). The observation mid-section is where the
    // beam passes, so w_c is the one that matters optically — and a thinner
    // wall there also opens the +X side: the inner +X face moves 9 → 11, so
    // the Ø16 substrate/pedestal now clears it by 3 mm instead of 1 mm.
    // (inlined: this OpenSCAD build rejects module bodies in assignments).
    difference() {
        difference() {
            union() {
                linear_extrude(height = hh)
                    polygon(pent_outer);
                // rev Q: the DS18B20 probe moved to the TOP-CAP ROOF (qc_* block),
                // so the rev P +Y horizontal boss is DELETED (see rev P history).
            }
            // JOINT ring band (wall w_j) at the bottom — mate face with Base
            // (bands overlap 0.10 instead of 0.01 so no two carve faces are
            // COPLANAR at the z=6 / z=22 seams — coincident faces made the
            // whole pentagon non-2-manifold and CGAL resurrected the −X wall)
            translate([0, 0, -0.01])
                linear_extrude(height = 6.10)
                    polygon(pc_j);
            // observation mid-section (wall w_c)
            translate([0, 0, 6])
                linear_extrude(height = 13.11)
                    polygon(pc_inn);
            // JOINT ring band (wall w_j) at the top — mate face with TopCap
            translate([0, 0, 19])
                linear_extrude(height = 6.10)
                    polygon(pc_j);
            // rev F fix — all three window bores were missing `center = true`.
            // cylinder() grows from its origin along +Z, which rotate([0,90,0])
            // sends along +X, so an UN-centred bore only extends one way from
            // the translate() X. The ∅10 aperture therefore cut x ∈ [−3,+32]
            // instead of the intended [−20.5,+14.5] → the −X wall was never
            // bored at all, and the −X seat stopped 1 mm short of the face.
            // Every X in these translates is a CENTRE — hence center = true.
            // Φ10 aperture bore, full X span at beam plane: centred at
            // x=(hx_f−half)/2=−3, length half+hx_f+1 = 35 → x ∈ [−20.5,+14.5],
            // 0.5 mm clear beyond BOTH faces (never coplanar with a cup cap).
            translate([(hx_f - half)/2, 0, zbeam])
                rotate([0, 90, 0])
                    cylinder(d = aperture, h = half + hx_f + 1.0,
                             center = true, $fn = 40);
            // +X window seat — Ø13.1 pocket centred at x=13.01, 2.02 long →
            // x ∈ [12.00,+14.02]: opens at the face X=14, recesses 2mm inward,
            // pokes 0.02mm OUT past the face (never coplanar with it).
            translate([hx_f - win_r/2 + 0.01, 0, zbeam])
                rotate([0, 90, 0])
                    cylinder(d = win_d + win_clr, h = win_r + 0.02,
                             center = true, $fn = 80);
            // −X window seat — Ø13.1 pocket centred at x=−19.01, 2.02 long →
            // x ∈ [−20.02,−18.00]: opens at the face X=−20, recesses 2mm
            // inward, pokes 0.02mm OUT past the face. Same glass (0.5″ Ø12.7)
            // drops in from OUTSIDE, flush — mirror-symmetric to the +X seat.
            translate([-half + win_r/2 - 0.01, 0, zbeam])
                rotate([0, 90, 0])
                    cylinder(d = win_d + win_clr, h = win_r + 0.02,
                             center = true, $fn = 80);
            // rev Q: the DS18B20 probe bore moved to the top-cap roof — the rev P
            // +Y wall bore (sen_*) is DELETED. The roof bore is in TopCapModule /
            // TopCapTallModule; the probe body hangs in free cavity space.
        }
        // alignment peg sockets (卯) in the BOTTOM joint face (light anti-slip)
        PegSockets(pent_pins, 0, j_pin_d + 0.4, j_pin_h + 0.5);
        // rev I: the two GrooveRing calls that used to be here (0.8 mm into
        // each joint face) are DELETED — both joint faces are flat. See the
        // joint-gasket block for what that gives up.
    }
    // light anti-slip tenons (榫) on the TOP joint face (into the TopCap)
    Pegs(pent_pins, hh, j_pin_d, j_pin_h);

    // centre annular floor (rev Q, USER-CONFIRMED "支座改可拔插插芯"): fixed
    // printed ring Ø20 outer × 6 mm (z 0..6 = the bottom JOINT band) with an
    // Ø18.5 centre bore. Two jobs:
    //   • calibration — the bore passes the 12.5² cuvette (circumcircle Ø17.7,
    //     0.4 mm/side) so it drops straight onto the copper at −26.
    //   • droplet — the bore centres the removable insert (PedestalInsert,
    //     locator Ø17.4), whose Ø12 rod bore guides the Ø10 rod and whose top
    //     at local z=11 carries the Ø16 substrate seat.
    // The ring's outer Ø20 fuses into the +X JOINT wall (inner reach c_j=9 <
    // 10 — the deliberate 1 mm overlap) and is braced by the 3 ribs below.
    // (rev F fix kept: the ribs overlap 2 mm INTO the hub — a flat end face
    // tangent to a cylinder is a zero-area LINE contact CGAL rejects; the +Y
    // rib moves its ORIGIN so the extra length goes into the hub, not the wall.)
    rib_t = 3;                       // [mm] brace rib thickness
    rib_h = 6;                       // [mm] brace rib height (z 0..6, ring band)
    difference() {
        union() {
            translate([0, 0, 0])
                cylinder(d = flr_od, h = 6, $fn = 80);
            // −X rib → left wall (x=−15, JOINT-ring reach)
            translate([-c_j, -rib_t/2, 0])
                cube([c_j - flr_od/2 + 2, rib_t, rib_h]);
            // +Y rib → top wall (y=15)
            translate([-rib_t/2, flr_od/2 - 2, 0])
                cube([rib_t, c_j - flr_od/2 + 2, rib_h]);
            // −Y rib → bottom wall (y=−15)
            translate([-rib_t/2, -c_j, 0])
                cube([rib_t, c_j - flr_od/2 + 2, rib_h]);
        }
        // centre bore Ø18.5 — the calibration path for the cuvette (Ø17.7)
        translate([0, 0, -0.01])
            cylinder(d = flr_bo, h = 6 + 0.02, $fn = 80);
    }

    // ---- Windows: recessed seats (RTV/O-ring sealed, NO fused boss) ----
    //   Both faces are flat at X=−20 / +14. The Ø12.7 × 2 mm cups are carved
    //   into the body above; the glass is fixed with RTV-106 in the rim gap.
    //   rev I: with the glass 3 mm and the cup 2 mm the glass now stands 1.0 mm
    //   PROUD of each face (it used to be documented as flush against a stale
    //   win_g = 1.0). Net +X margin to BS2 at X=20 becomes 5.0 mm, not 6.0.
}

// =============================================
// PEDESTAL INSERT (rev Q) — removable centre core (USER-CONFIRMED)
//   The one-piece 一体支座 is replaced by this drop-in part + the Pent annular
//   floor. LOCAL Z: 0 = floor bore mouth, top at ins_h = 11 (= global −6).
//     z 0..6   locator Ø17.4, slides in the floor bore Ø18.5 (0.55 mm/side)
//     z 6..7   seat flange Ø19.4 (r9.7) resting on the floor's top annulus
//              (r9.25..10) so the insert cannot drop through
//     z 7..11  substrate seat Ø16 (r8), cavity mid-bands clear by ≥1 mm
//     Ø12 bore the whole height — the Ø10 rod passes through; the rod bottoms
//              on the copper at −26, so the insert only CENTRES, not carries.
//   Calibration: lift the insert out; the cuvette then lands flat on the copper.
// =============================================
module PedestalInsertModule() {
    difference() {
        union() {
            translate([0, 0, 0])
                cylinder(d = ins_loc, h = 6, $fn = 80);
            translate([0, 0, 6])
                cylinder(d = ins_flg, h = 1, $fn = 80);
            translate([0, 0, 7])
                cylinder(d = ins_od, h = ins_h - 7, $fn = 80);
        }
        translate([0, 0, -0.01])
            cylinder(d = rod_hole, h = ins_h + 0.02, $fn = 60);
    }
}

// =============================================
// TOP CAP — pentagon ceiling with solid 3 mm roof + Ø5 syringe-needle hole
//   Local Z = pentagon top (0) → +h_top (10). JOINT ring (wall w_j, pc_j); the
//   wall carve runs only up to the roof underside so the roof stays solid
//   (rev D fix — the previous carve removed the roof too), then the Ø5 needle
//   hole is bored through it. rev I: the bottom face is FLAT — the gasket
//   groove is deleted (USER: "删槽").
// =============================================
module TopCapModule() {
    cp_t = 3;                          // [mm] solid roof thickness
    difference() {
        union() {
            linear_extrude(height = h_top)
                polygon(pent_outer);
            // rev Q — DS18B20 probe boss: Ø16 × 4 on the roof top at (qc_x,qc_y);
            // the Ø15 ring head seats here with an RTV-106 ring (no ΔP seal —
            // open chamber, same rationale as the windows).
            translate([qc_x, qc_y, h_top])
                cylinder(d = qc_bd, h = qc_bh, $fn = 80);
        }
        // JOINT-ring hollow (wall w_j), up to the roof underside
        translate([0, 0, -0.01])
            linear_extrude(height = h_top - cp_t + 0.01)
                polygon(pc_j);
        // Ø5 syringe/needle pass-through on the drop axis (X=0, Y=0)
        translate([0, 0, -0.01])
            cylinder(d = ptfe, h = h_top + 0.02, $fn = 40);
        // Ø8.4 vertical through-bore for the probe body (roof + boss). At this
        // XY the bore below the roof is in free cavity air, so it only cuts the
        // solid roof (z 7..10) + boss (z 10..14).
        translate([qc_x, qc_y, -0.01])
            cylinder(d = qc_hd, h = h_top + qc_bh + 0.02, $fn = 40);
        // rev I: the GrooveRing call that used to sit here is DELETED.
        // light anti-slip peg sockets (卯) for the Pent top tenons
        PegSockets(pent_pins, 0, j_pin_d + 0.4, j_pin_h + 0.5);
    }
}

// =============================================
// TOP CAP TALL (rev Q) — calibration lid over the 50 mm cuvette
//   Same pentagon prism as TopCap but h_top_tall = 19.8: the roof underside sits
//   at local 15.8 (= global +24.8), 2 mm above the cuvette top (+22.8). Sports the
//   DS18B20 probe boss/bore at the SAME XY (qc_x,qc_y) as the short cap, so one
//   drilled sensor serves either config by swapping caps. NO needle hole (rev V):
//   calibration injects nothing — the sealed cuvette + free chamber need no drop
//   axis, and a +31.8 roof leak would dump the felt band. See also the TALL-column
//   datum block (rc_pin_tall): the tall roof + boss top at +31.8 is what swallowed
//   the old 82 mm pin tops — the Ø10 × 93 columns restore the keybar clamp here.
//   LOCAL Z = pentagon top (0) → h_top_tall (19.8).
// =============================================
module TopCapTallModule() {
    cp_t = 3;                          // [mm] solid roof thickness
    difference() {
        union() {
            linear_extrude(height = h_top_tall)
                polygon(pent_outer);
            translate([qc_x, qc_y, h_top_tall])
                cylinder(d = qc_bd, h = qc_bh, $fn = 80);
        }
        // JOINT-ring hollow (wall w_j), up to the roof underside
        translate([0, 0, -0.01])
            linear_extrude(height = h_top_tall - cp_t + 0.01)
                polygon(pc_j);
        // Ø8.4 probe through-bore at the same XY as the short cap (boss + roof)
        translate([qc_x, qc_y, -0.01])
            cylinder(d = qc_hd, h = h_top_tall + qc_bh + 0.02, $fn = 40);
        // light anti-slip peg sockets (卯) for the Pent top tenons
        PegSockets(pent_pins, 0, j_pin_d + 0.4, j_pin_h + 0.5);
    }
}

// =============================================
// NEEDLE HOLE PLUG — 打印锥形塞，封 Ø5 针孔
//   液滴模式塞住，标定模式拔出。RTV-106 薄圈密封。
//   锥形主体 Ø5.2→Ø4.8 × 4mm（过盈 0.1mm），法兰 Ø8 × 2mm。
// =============================================
module NeedleHolePlug() {
    union() {
        cylinder(d1 = 4.7, d2 = 4.3, h = 4, $fn = 40);
        translate([0, 0, 4])
            cylinder(d = 8, h = 2, $fn = 40);
    }
}

// =============================================
// WINDOW CAP — 光学窗防尘盖（±X 各打印一个)
//   中空圆柱 + 实心顶盖：外 Ø18 × 10，内腔 Ø14.5 × 8
//   底部开口，罩住窗座 Ø13.1 + 凸出 1mm 的玻璃。
// =============================================
module WindowCap() {
    difference() {
        // 外壁：实心圆柱 0..10
        cylinder(d = 18, h = 10, $fn = 80);
        // 内腔：Ø14.5，从底部向上 8mm（开口朝下）
        translate([0, 0, -0.1])
            cylinder(d = 14.5, h = 8.1, $fn = 80);
    }
}

// =============================================
// RETAINER CAGE (rev T) — TWO printed layers: press plate + arm layer
//   Clamping note: ONE closed loop
//          碟簧 → 压板 → 顶盖 → 接缝 → 底座 → 井顶台阶 → 铜块 → TEC → 水冷头
//             ↑                                                          ↓
//             └ 开口销 ← 轴销 ← 印刷长条销 ← 锚台套筒 ← ← ← ← ← ← ← ← ← ← ←┘
//   rev S proved one fused cage; rev T (USER-CONFIRMED "拆两层分开设计、打印")
//   splits it into TWO prints so the part budget, the boss routing and
//   printability stop fighting each other:
//     • LAYER 1 = PressPlate()   (+18..+20, show == 7): inset pentagon FLUSH on
//       the top-cap roof, Ø8 needle bore, Ø18 probe cut-out, + one Ø3.2
//       anti-rotation pin on top at rc_arot_pos. The flush face = Z datum.
//     • LAYER 2 = ArmsLayer()    (+20..+22, show == 11): centre HUB (ID 8.2 /
//       OD 11.8) sleeves the plate bore → X/Y register (0.2 mm slip), a Ø3.4
//       hole catches the plate's anti-rot pin, and INTEGRATED members (west
//       spine + centre flap + A1 legs + A2 west bar + A3 north stub) carry the
//       four Ø13 RING COLLARS on the Ø10.5 bores — rev T2 shrank the Ø16 bosses
//       to a 1.25-wall ring and widened + extended the A1/A2 seats so the rings
//       never overhang the member edges (A1 36.8→100 %, A2 37.3→100 %).
//     • Each ring bites 0.8 mm below the arm band (rc_boss_z0..z1) as a small
//       pedestal and carries a Ø3.4 RADIAL passage (X) at rc_tslot_z for the Ø3
//       SIDE KEY that locks the ring to the pin's TOP slot — a NON-LOAD-BEARING
//       anti-rotation guard; the preload is carried ONLY by the bottom key + cotter.
//   Member routing (clear of the Ø16 DS18B20 boss at (−10.5,+10.5), r 8;
//   nearest material ≥10 mm, re-verified by slice check):
//     A1 (0,+36): leg1 shifted +X 4.5 (left edge 10.0 from boss centre), leg2
//                 (WIDENED 14, rev T2) runs x=0, y 20..44 past the ring.
//     A2 (−24,−36): west bar (WIDENED 14, rev T2) x −31..−17, y −44..−8.
//     A3/A4 (−36,±15): west spine x −43..+5, y −22..−4 + A3 north stub.
//   Centre connectivity: spine ↔ stepped centre flap ↔ hub ↔ A1 leg1 — the flap
//   low part (−6..−0.5, y≤3.5) hugs below the boss bottom arc, the high part
//   (−0.5..7, y≤7) is right of the boss's right edge (−2.5) so it can rise to
//   meet leg1. ONE connected 2D region ⇒ one printed body.
//   GLOBAL Z throughout (show == 7 / 11 draw them at the origin; the assembly
//   preview calls the composite RetainerCage() in place, coded in green).
// =============================================
module PressPlate() {
    // LAYER 1 — print plate-down (arm underside = print bottom ... zero support;
    // the Ø18 cut-out and Ø8 bore are through-holes).
    difference() {
        union() {
            // inset pentagon plate, FLUSH on the cap roof (+18..+20).
            // Uses precomputed pent_plate (1.5 mm inset) to avoid the
            // OpenSCAD/Clipper self-intersection at the sharp 43° corner.
            translate([0, 0, rc_p_bot])
                linear_extrude(height = rc_p_t)
                    polygon(pent_plate);
            // anti-rotation pin Ø3.2 on top at rc_arot_pos → registers the
            // ArmsLayer's Ø3.4 hole (0.1 mm/side slip) so the two layers
            // cannot rotate about the hub. Starts at rc_p_bot (inside the plate)
            // and extends through rc_arm_bot into the arms layer (total height
            // 4 mm, 2 mm embedded + 2 mm protruding), guaranteeing CGAL merges
            // the pin and plate into one body (Volumes: 2).
            translate([rc_arot_pos[0], rc_arot_pos[1], rc_p_bot])
                cylinder(d = rc_arot_d, h = rc_arm_bot + rc_p_t - rc_p_bot, $fn = 40);
        }
        // centre needle bore Ø8 — doubles as the hub-sleeve register datum
        translate([0, 0, rc_p_bot - 0.01])
            cylinder(d = rc_p_hole, h = rc_p_t + 0.02, $fn = 40);
        // rev Q — DS18B20 roof boss clearance (Ø16 boss + 2) at the probe XY
        translate([qc_x, qc_y, rc_p_bot - 0.01])
            cylinder(d = qc_pclr, h = rc_p_t + 0.02, $fn = 60);
    }
}

module ArmsLayer() {
    // LAYER 2 — print plate-down (member underside flat, tip bosses bite 0.8 mm
    // below the band as small pedestals: no support needed).
    difference() {
        union() {
            // centre hub sleeve OD 11.8 — X/Y register over the plate's Ø8 bore
            translate([0, 0, rc_arm_bot])
                cylinder(d = rc_hub_od, h = rc_p_t, $fn = 60);
            // members extruded rc_p_t at rc_arm_bot (+20..+22)
            translate([0, 0, rc_arm_bot])
                linear_extrude(height = rc_p_t)
                    union() {
                        // A1 lower leg (offset +X 4.5 past the boss)
                        translate([4.5 - rc_arm_w/2, 4.5])
                            square([rc_arm_w, 21 - 4.5]);
                        // A1 upper leg (back on the x=0 centreline, above the boss).
                        // rev T2: WIDENED 10→14 and run to y=44 so the Ø13 ring
                        // collar (far edge 42.5) sits fully on material — was 36.8 %.
                        translate([-rc_arm_wide/2, 20])
                            square([rc_arm_wide, 44 - 20]);
                        // A2 west bar — south leg to the relocated (−24,−36) socket.
                        // rev T2: WIDENED to 14 and extended to y=−44 (ring far edge
                        // −42.5) — was ending at the boss centre, 37.3 % coverage.
                        translate([-24 - rc_arm_wide/2, -44])
                            square([rc_arm_wide, 44 - 8]);          // x −31..−17, y −44..−8
                        // west spine — A3/A4 ride this bar below the boss. Top edge
                        // −4 (was −8) so the anti-rot hole Ø3.4 at (−8,−6) keeps
                        // ≥2 mm land to the edge.
                        translate([-43, -22])
                            square([48, 18]);                // x −43..+5, y −22..−4
                        // centre flap — stepped slab: spine ↔ hub ↔ A1 leg1.
                        // Low part (−6..−0.5, y≤3.5) stays below the boss bottom
                        // arc; high part (−0.5..7, y≤7) is right of the boss's
                        // right edge (−2.5) so it rises to meet leg1's bottom edge.
                        polygon([[-6, -22], [-6, 3.5], [-0.5, 3.5],
                                 [-0.5, 7],  [7,   7],  [7,   -22]]);
                        // A3 north stub up to the (−36,+15) anchor
                        translate([-43, -13])
                            square([14, 35]);
                    }
            // arm-tip bosses = Ø13 RING COLLARS over each Ø10.5 pin bore — the
            // bore cut below turns each cylinder into a 1.25-wall ring (rev T2:
            // the old Ø16 solids half-floated over the A1/A2 member ends)
            for (p = col_pos)
                translate([p[0], p[1], rc_boss_z0])
                    cylinder(d = rc_boss_d, h = rc_boss_z1 - rc_boss_z0, $fn = 60);
        }
        // centre hub inner bore Ø8.2 — sleeves over the plate's Ø8
        translate([0, 0, rc_arm_bot - 0.01])
            cylinder(d = rc_hub_id, h = rc_p_t + 0.02, $fn = 60);
        // anti-rot hole Ø3.4 — catches the plate's Ø3.2 pin
        translate([rc_arot_pos[0], rc_arot_pos[1], rc_arm_bot - 0.01])
            cylinder(d = rc_arot_d + 0.2, h = rc_p_t + 0.02, $fn = 40);
        // Ø10.5 pin through-bores at the four tips (thread-free: the Ø10 pin
        // drops through, into the cradle's anchor socket)
        for (p = col_pos)
            translate([p[0], p[1], rc_boss_z0 - 0.01])
                cylinder(d = rc_pin_d + 0.5, h = rc_boss_z1 - rc_boss_z0 + 0.02, $fn = 40);
        // RADIAL side-key passages 3.4×3.4 SQUARE (along X, rev T2.2) at rc_tslot_z
        // in every ring — the square 3×3 key threads ring wall + the pin's square
        // TOP slot; replaces the old 22×6.4 top-key channel, which would have
        // sliced the 1.25 wall in two. Centred cube, axis X (rev T2.1: mirrored
        // to −X — a cube along ±X reads the same, geometry unchanged).
        for (p = col_pos)
            translate([p[0], p[1], rc_tslot_z])
                cube([rc_radkey_l, rc_radkey_s + 0.4, rc_radkey_s + 0.4], center = true);
    }
}

module RetainerCage() {
    // rev T composite — the ASSEMBLY view draws BOTH printed layers in place.
    // Single-part exports use PressPlate() (show == 7) / ArmsLayer() (show == 11).
    PressPlate();
    ArmsLayer();
}

// =============================================
// KEY BARS + PINS (rev T2 small hardware, show == 10 — print flat in one job)
//   4× BOTTOM keys 6×3×L, laid along X — the socket locator pins (preload runs
//     碟簧→压板←开口销←轴销←key→锚台). A1/A2 = 44; A3/A4 = 24 (rev T2.1: the old
//     44 for (−36,±15) had its +X end hanging into the cradle cavity ①).
//   4× Ø3 × 16 RADIAL side keys (laid along −X, row y=60) — thread each ring's
//     Ø3.4 passage + the pin's TOP slot at rc_tslot_z; they lock ring ↔ pin
//     anti-rotation. (The flat 6×3×22 top keys and the Ø16 bosses are GONE —
//     rev T2 shrank the bosses to Ø13 rings that a 22-long flat key would slice.)
//   4× pins Ø10 × 82, standing, three features (all pin-local, base = 0):
//     BOTTOM key slot:  rc_pin_slot_c ± key_t/2      = z 2..5   (socket ch 7..10)
//     TOP anti-rot slot: rc_tslot_z − rc_pin_bot ± topslot_t/2 = z 68.5..72.9
//        (narrowed to Ø-pin+0.5 long so it stays in the bore, never breaking
//         into the Ø13 ring wall in the assembly)
//     cotter hole:       rc_spr_seat − rc_pin_bot ± 1.0        = z 79.3..81.3
//   rev V — TALL columns (rc_pin_tall = 1): same feature set, length 93; the top
//     slot shifts up to rc_tslot_z_tall − rc_pin_bot = z 79.5..83.9 and the cotter
//     to rc_spr_seat_tall − rc_pin_bot = z 90.63..92.63 (pin top global +42.5). The
//     bottom slot (z 2..5) and pin base (−50.5) are IDENTICAL — the socket never
//     moves; only the roof datum lift (+9.8) raises the upper clamping hardware.
//   Material ASA. No threads anywhere.
// =============================================
module KeyBar() {
    // rev V — active pin variant. rc_pin_tall = 1 lifts the top slot + cotter to
    // the TALL roof datum; the bottom slot and pin base stay on the fixed socket.
    pin_h = rc_pin_tall ? rc_pin_h_tall : rc_pin_h;
    tslot_z = rc_pin_tall ? rc_tslot_z_tall : rc_tslot_z;
    cseat   = rc_pin_tall ? rc_spr_seat_tall : rc_spr_seat;
    // --- 4× BOTTOM keys: 6 (Y) × 3 (Z) × per-socket length (X), row y = 0 ---
    //   cols 2/3 (the A3/A4 sockets) are 24 not 44 — their old +X end reached
    //   into the cradle cavity ① (rev T2.1: keep them west of x −20.4).
    translate([0, 0, rc_key_t])
    for (i = [0:3])
        translate([i * 52, 0, -rc_key_t])
            cube([rc_key_l_col[i], rc_key_w, rc_key_t]);
    // --- 4× RADIAL side keys: 3×3 SQUARE × 16, laid along X, row y = 60 ---
    //   rev T2.2: square to match the pin's square 10.5×6.4 TOP slot (the old Ø3
    //   round dowel slopped in it). Centred bar, axis X; prints flat on the sheet.
    //   rev V: lifted to z 0..3 — the old center=true at z=0 sank the sheet's
    //   min-z to −1.5, so every slicer lifted the whole layer and re-floated
    //   the pins 1.5 mm off the bed.
    for (i = [0:3])
        translate([i * 30, 60, rc_radkey_s/2])
            cube([rc_radkey_l, rc_radkey_s, rc_radkey_s], center = true);
    // --- 4× pins: Ø10 × pin_h standing with BOTTOM slot + TOP slot + cotter hole ---
    //   base ON the build plate at sheet z=0 (rev V fix — the old
    //   translate([0,0,rc_key_t]) left the columns floating 3 mm over the bed)
    for (i = [0:3])
        translate([i * 30, 14, 0])
            difference() {
                cylinder(d = rc_pin_d, h = pin_h, $fn = 60);
                // BOTTOM key slot: 6.4 (Y) × 3.0 (Z) × 14 (X), through the pin,
                // 2..5 above the base (= the socket's z 7..10 band)
                translate([-7, -(rc_key_w/2 + rc_key_clr),
                           rc_pin_slot_c - rc_key_t/2])
                    cube([14, rc_key_w + 2*rc_key_clr, rc_key_t]);
                // TOP anti-rotation slot: same width, rc_topslot_t tall (4.4 =
                // dowel Ø3 + 1.4 slack → the radial side key guards, never loads).
                // NARROWED rev T2 to Ø-pin+0.5 long: sits inside the bore, so it
                // can never break into the Ø13 ring wall in the assembly.
                // (axis: +21.4 short / +31.2 tall — pinned by tslot_z)
                translate([-(rc_pin_d + 0.5)/2, -(rc_key_w/2 + rc_key_clr),
                           tslot_z - rc_pin_bot - rc_topslot_t/2])
                    cube([rc_pin_d + 0.5, rc_key_w + 2*rc_key_clr, rc_topslot_t]);
                // cotter hole Ø2.2, centred at cseat − rc_pin_bot (+31.33 short /
                // +41.13 tall). FIXED pin datum — NOT a δ knob: its bottom face
                // (+30.33 / +40.13) presses the collar; collar+dics (7.0+2.0=9.0)
                // compress into the arm-top→cotter-bottom span (8.33) ⇒ δ=0.67
                // (rev T4; identical in BOTH configs — the collar is NOT a new part).
                translate([0, 0, cseat - rc_pin_bot - 1.0])
                    cylinder(d = 2.2, h = 2.0, $fn = 20);
            }
}

// =============================================
// DISC SPRINGS (rev T3/T4, show == 12 — printable sheet; user: "没有打印文件")
//   4× Belleville washers Ø23/ID18.2×2.0, laid FLAT in one sheet at pitch 60 (X),
//   ONE disc per leg (user-confirmed; the 4 discs ARE the 4 leg springs).
//   Conical cross-section: OD rim rides rc_spr_cone ABOVE the ID rim (verified
//   from the rendered STL — measured ID z∈[0,1.2], OD z∈[0.8,2.0]). Cone slope
//   is printed face-up; reverse face is the compressing seat. Cone direction is
//   flip-equivalent for the preload result.
//   δ AND PRELOAD ARE SET BY THE COLLAR (show==13, rev T4), NOT BY THE COTTER:
//     disc free 2.0 + collar 7.0 = 9.0 compresses into the arm-top→cotter-bottom
//     span (22 → 30.33 = 8.33) ⇒ δ = 0.67 ⇒ ≈40 N/leg ⇒ ≈160 N total
//     (k≈59 N/mm @ Ø23 single disc; user-selected target).
//   ⚠ PHYSICAL NOTE: ASA discs creep at 40 N/leg over time — treat 160 N as a
//     fresh-print figure and CALIBRATE (pop cotters → re-pin) before relying on
//     the TEC preload; metal DIN 2093 washers of the same Ø are the stiffer,
//     creep-free alternative (change nothing in the geometry, just the material).
//   ⚠ Do NOT shrink these below Ø23 — A2↔A4 centre distance is 24.19 mm; Ø23
//     leaves 1.19 mm clearance (the original Ø28 overlapped by 3.8).
// =============================================
//   rc_spr_id / rc_spr_t / rc_spr_cone are DEFINED in the parameter block
//   (line ~1198) so the collar math can reference them — NOT duplicated here.

module DiscSpringsLayer() {
    for (i = [0:3])
        translate([i * 60, 0, 0])
            rotate_extrude($fn = 96)
                polygon([[rc_spr_id/2, 0],
                         [rc_spr_id/2, rc_spr_t],
                         [rc_spr_w/2,  rc_spr_t + rc_spr_cone],
                         [rc_spr_w/2,  rc_spr_cone]]);
}

// =============================================
// PRELOAD COLLARS (rev T4, show == 13 — NEW printable sheet)
//   4× plain washers Ø23/ID14 × 7.0, laid FLAT in one sheet at pitch 60 (X).
//   WHY THEY EXIST (physical audit, rev T4): the cotter hole is PIN-printed at
//   axis +31.33 (bottom +30.33); a single 2.0-tall disc sits at arm top +22 and
//   its top reaches only +23.33..+24.0 — the cotter would float 7.33 mm above it
//   and #NEVER TOUCH it ⇒ ZERO preload with discs alone. The collar fills that
//   gap: placed ON the disc OD rim, pressed by the cotter, forcing δ=0.67.
//   Collar OD = disc OD (same 1.19 mm A2↔A4 clearance), ID 14 clears the Ø13
//   boss ring (+0.5/side) and presses the disc OD annulus 18.2..23.
//   Tolerance ±0.3 mm ⇒ total preload 88..232 N, inside the TEC 80..240 window.
// =============================================
module CollarLayer() {
    for (i = [0:3])
        translate([i * 60, 0, 0])
            difference() {
                cylinder(d = rc_col_od, h = rc_col_h, $fn = 96);
                translate([0, 0, -0.01])
                    cylinder(d = rc_col_id, h = rc_col_h + 0.02, $fn = 96);
            }
}

// =============================================
// STACK CRADLE (rev L) — 热堆定位模块
//   定住 铜块 / TEC / 水冷头 的位置与相对位置，并把整堆托到 SupportBase 上。
//   LOCAL Z: 0 = 底板底面（落在支撑件顶板上），向上为正。
//   装配图里整体放在 cr_plt_z。
//
//   ── rev L 的定位原理（这是本模块存在的全部理由）────────────────────────
//   rev K 的 X/Y 是**两条互不相干的基准链**：
//     铜块   ← 保温筒井孔 50.4×52.2（单边 0.2），由水嘴/引线开口的位置决定；
//     水冷头 ← 套座孔 40.8²（单边 0.4）；
//   两链之间只靠"底板自由坐在支撑件平顶上"衔接，而那块底板**没有任何横向
//   定位**。铜块压在 TEC 上的单边余量只有 5.0 (X) / 5.9 (Y)：底板一滑，面接触
//   就变边接触，0.6–1 mm 的脆性氧化铝被静默压裂，而外观毫无异常。
//   rev L 让套座一路长上去，抱住铜块露出井外的那 3.8 mm（底面 −36.8 … 保温筒
//   底面 −33）里的 2.6 mm —— 于是 TEC / 水冷头自动与**铜块本体**对齐，两链合一。
//
//   抱箍孔 50.8 × 52.6 = 铜块 50 × 51.8 + 单边 0.4（与 TEC 腔同一条规则）。
//   它比 rev K 套座的外廓 46.8² 还宽，所以整个塔身必须放宽到统一的 58² 棱柱，
//   否则抱箍四面墙会整个悬在套座之外 —— 零件断成不连通的两块。
//
//   Z 链（本件只提供落座面，预紧力仍由 保温筒 → 铜块 → TEC → 水冷头 传递；
//      rev W 铜块下移 1.2 → 除抱箍口沿（follow 保温筒底面 −34.6）外整体 −1.2）：
//     水冷头落座面 = 底板顶面    = z_wb_bot = −51.5  （局部 4）
//     水冷头顶面   = −51.5 + 9.5 = −42.0             （局部 13.5）
//     TEC 底面     = 水冷头顶面  = −42.0             （局部 13.5）
//     TEC 顶面     = −42.0 + 4.0 = −38.0 = 铜块底面 （局部 17.5）
//     抱箍口沿     = −34.2                           （局部 20.1，未动）
//   套座孔在 X/Y 上把两个 40×40 的件对中（单边 0.4）；Z 上不做约束 ——
//   保温筒落下来，经 井顶台阶 → 铜块 → TEC → 水冷头 把三者压紧。
//
//   两个口沿为什么分别停在 −38.0 / −34.2（都用 cr_vclr = 1.2）：
//   铜块底面的 Z 由 plate_t 决定（z_cop_bot = z_frame_top − plate_t = −36.8），
//   而且铜块是随保温筒从上方落下来的。口沿一旦高于 −36.8，铜块就会先坐死在
//   套座上、根本压不到 TEC —— 预紧力全废。−38.0 比铜块底面低 1.2 mm，同时仍
//   环住 4 mm TEC 中的 2.8 mm。抱箍口沿同理必须低于保温筒底面 −33（取 −34.2），
//   否则保温筒改坐在抱箍上，预紧力同样被旁路。
//
//   +X 一侧必须留口（两个宝塔水嘴 Ø9.5 @ y=±10、轴 z=−45.55 从那一面出去，
//   且沿 Z 恰好占满水冷头整个高度 −50.3…−40.8），**且用户要求 TEC 也侧面接线**，
//   所以抱箍的 +X 墙整面切开、只在 |Y| ∈ [22, 26.3] 各留一道 3.6×4.3 角撑。
//   角撑的正下方是套座本来就有的 +X 角块（① 腔只切到 |Y| ≤ 20.4），所以不悬空。
//
//   4 个立柱锚台只是"落点"，柱身截面/螺钉/碟簧/压板形状仍是 CLAMPING 块的
//   TODO，未在此建模。
//
//   ── 关于共面接合（已核查，结论：此处不需要 0.01 搭接）──────────────────
//   套座底面、锚台底面都与底板顶面 z = cr_plt_t **精确共面**；SupportBase 的
//   四壁/十字筋上端与顶板下表面、筋端与管内壁同样共面。本文件其余各处的 0.01
//   搭接**全部是给差集切面加的**（PegSockets 下探、光阑孔留 0.5 余量、窗口座
//   外探 0.02），而 rev F 记录的两次故障也都属切面类：
//     (a) 加强筋平面端面**与圆柱相切** → 零面积线接触；
//     (b) 五边形两条**切带边界**共面 → 整块非流形、CGAL 复活 −X 壁。
//   本模块的接合是**并集 + 面对面**（大方块端面贴平面、圆柱端面贴平面），正是
//   CGAL Nef 多边形原生处理的情形，两者机理都不适用。
//   实测佐证（2026-09-10，`data/verify/20260910/revK/revK_volume_check.py`）：
//   两块件均 Simple: yes、**单连通分量**，且围合体积与手算值残差仅
//   +0.009 mm³ / +0.628 mm³（前者是 float32 STL 量化，后者是脚垫搭接面）。
//   若日后换 OpenSCAD/CGAL 版本渲染出现问题，**优先怀疑这里**，再按惯例补搭接。
// =============================================
module StackCradle() {
    so = cr_col_w/2;                // 29  统一棱柱外半宽（rev L；rev K 是 cr_bore/2+cr_wall）
    bx = cr_bore_x/2;               // 25.4  抱箍孔半宽 X
    by = cr_bore_y/2;               // 26.3  抱箍孔半宽 Y
    // 底板：只保留塔身（58²）+ 不受影响的 3 个锚台套筒（Ø20）所需的支撑区域
    // 删除 -Y 超出部分及对应的锚台 (-24,-36)
    linear_extrude(height = cr_plt_t)
        hull() {
            // 塔身外轮廓
            square([2*so, 2*so], center = true);
            // 保留 3 个锚台套筒底座轮廓：移除 (1) [-24,-36]
            for (p = [col_pos[0], col_pos[2], col_pos[3]])
                translate([p[0], p[1]])
                    circle(d = col_sock_od + 4, $fn = 60);
        }
    // 塔身 = 套座 + 抱箍一体（统一 58² 棱柱）+ 保留 3 个锚台套筒
    difference() {
        union() {
            translate([-so, -so, cr_plt_t])
                cube([2*so, 2*so, cr_top_lz - cr_plt_t]);
            // 保留 3 个锚台套筒
            for (p = [col_pos[0], col_pos[2], col_pos[3]])
                translate([p[0], p[1], cr_plt_t])
                    cylinder(d = col_sock_od, h = col_sock_h - cr_plt_t, $fn = 60);
        }
        // rev S — ①+② 之外的 4 个 Ø12 盲孔（套筒内，底 4 → 顶 19，收 Ø10 轴销）
        for (p = col_pos)
            translate([p[0], p[1], cr_plt_t - 0.01])
                cylinder(d = col_pin_br, h = col_sock_h - cr_plt_t + 0.02, $fn = 60);
        // rev S — key 通道：Y±3.2 / Z 7..10 的横槽，−X → +X 贯通每个套筒。
        // （(−36,±15) 的 +X 段深入塔身并被腔① x≥−20.4 的区域掏空 —— 接受的：
        // key 有 −X 壁槽 + 轴销槽在位，载荷只是把轴销定位。）
        for (p = col_pos)
            translate([p[0] - 25, p[1] - (rc_key_w/2 + rc_key_clr), col_key_z - 0.01])
                cube([50, rc_key_w + 2*rc_key_clr, rc_key_t + 0.02]);
        // ① 下部腔 40.8²：沿 +X 一直切穿（水嘴与 TEC 引线都走这一面）。
        //    X 终点 = −cr_bore/2 + (so + cr_bore/2 + 1) = so + 1 > so ✓
        translate([-cr_bore/2, -cr_bore/2, cr_plt_t - 0.01])
            cube([so + cr_bore/2 + 1, cr_bore, cr_rim_lz - cr_plt_t + 0.02]);
        // ② 抱箍腔 50.8×52.6，同样沿 +X **整面**切穿，只在中间留出
        //    cr_lip_y = 44 宽的口子走 TEC 引线 —— 两侧剩下的两道墙就是"角撑"。
        //    三段 hull 一次成形：下段锚进 ①、中段是直腔、上段收 1×45° 倒入角。
        //    倒角段故意伸到口沿**之上** cr_cham：切面若正好停在实体顶面上会留下
        //    共面切带（rev F 陷阱 b）。② 的底面 16.29 落在 ① 的 Z 区间内
        //    （① 顶面 16.31），且 ① 的顶面整个落在 ② 的轮廓里 ⇒ 有体积重叠、
        //    无共面切带。X 终点用 so+2 而非 so+1：别和 ① 的 X 终点同面。
        difference() {
            hull() {
                translate([-bx, -by, cr_rim_lz - cr_lap])
                    cube([bx + so + 2, 2*by, cr_lap]);
                translate([-bx, -by, cr_top_lz - cr_cham - cr_lap])
                    cube([bx + so + 2, 2*by, cr_lap]);
                translate([-(bx + 2*cr_cham), -(by + 2*cr_cham), cr_top_lz + cr_cham])
                    cube([bx + so + 2 + 4*cr_cham, 2*(by + 2*cr_cham), cr_lap]);
            }
            // 角撑的位置**从切腔里掏掉** ⇒ 塔身在这两处根本没被切除，角撑天然
            // 就是塔身的一部分，向下连到套座的 +X 角块（① 只切到 |Y| ≤ 20.4）。
            // ⚠ 不能反过来"先切整面、再把角撑并回来"：并集若只靠**零体积贴面**
            //   接触，CGAL 不合并 —— 实测直接产出两个游离小块（Volumes 2→4，
            //   components 从 1 变 3）。从切腔里掏空则完全不需要并集。
            // ⚠ 掏空的盒子在 ±Y 方向各外伸 2 mm：hull 的 |Y| 会随倒入角长到
            //   27.3，不外伸的话盒子的面会与 hull 的面共面（差集切带共面 =
            //   rev F 陷阱 b）。外伸后盒子的 ±Y 面始终落在 hull 之外，而它的
            //   X/Z 面始终落在 hull 之内（hull: X∈[−25.4,31]、Z∈[16.29,21.11]）。
            for (y = [cr_lip_y/2, -by - 2])
                translate([bx, y, cr_rim_lz])
                    cube([so - bx, by - cr_lip_y/2 + 2, cr_top_lz - cr_rim_lz]);
        }
    }
}

// =============================================
// SUPPORT BASE (rev K) — 支撑组件
//   把 底板 + 整堆 + 保温筒 托到高度调节台上。
//   LOCAL Z: 0 = 顶面（= 底板坐的那一面），向下到 −sup_h 为底面。
//   装配图里整体放在 cr_plt_z。
//
//   打印姿态：把顶面朝下直接贴板。承 底板 的那一面由热床保证平整 —— 这一面
//   直接决定水冷头的 Z 与倾角，进而决定 TEC 接触，所以它的平整度比别的都
//   重要。四壁与十字筋从顶板下表面向上长，底面完全开口 ⇒ 零支撑、零桥接。
//   (rev M: 底面 3 只 Ø8 脚垫已删除 —— 底面整体贴台面，四壁/筋直通到底。)
//
//   ⚠ 待实测确认：BS2 (X=+20) 的立柱 与 Y=−25 的支撑杆若一路伸到台面，就会
//     穿过这个 70×70 footprint。文件里"楔以下空间自由"的判断源自 rev G，
//     本件沿用同一假设 —— 装配前请目视确认。
// =============================================
module SupportBase() {
    ih = sup_w/2 - sup_wall;        // 31  内腔半宽
    // 顶板（打印时贴板的那一面 = 装配里的上面）
    translate([-sup_w/2, -sup_w/2, -sup_top_t])
        cube([sup_w, sup_w, sup_top_t]);
    // 四壁
    difference() {
        translate([-sup_w/2, -sup_w/2, -sup_body_h])
            cube([sup_w, sup_w, sup_body_h - sup_top_t]);
        translate([-ih, -ih, -sup_body_h - 0.01])
            cube([2*ih, 2*ih, sup_body_h - sup_top_t + 0.02]);
    }
    // 十字筋
    translate([-sup_rib_t/2, -ih, -sup_body_h])
        cube([sup_rib_t, 2*ih, sup_body_h - sup_top_t]);
    translate([-ih, -sup_rib_t/2, -sup_body_h])
        cube([2*ih, sup_rib_t, sup_body_h - sup_top_t]);
}

// =============================================
// EXTERNAL WRAP FRAME — REMOVED (rev F, user-directed)
//   FramePosts() and FramePlate() lived here (3 corner posts + feet + M3
//   stud bores + brass-insert seats, and the triangular press plate with its
//   hub boss and nut pockets). They were deleted together with every fr_*
//   global and z_plate_bot. The stack now has NO clamping hardware at all.
//   See the CLAMPING note in the parameter block above — rev G's printed
//   retainer cage replaces this and is not yet modelled.
// =============================================

// =============================================
// ASSEMBLY PREVIEW — global-Z layout, all parts in place (DEFAULT VIEW)
// Global Z (origin = beam focus):
//   Base    : Z ∈ [−33,−17]  fused frame+trumpet (joint face at −17)
//   Pent    : Z ∈ [−17,+8];  Φ10 aperture @ Z=0, Ø13.1 × 2 seat on BOTH ±X
//                            faces, holding the 3 mm glass (stands 1.0 mm
//                            proud of each face — no ΔP across it, so the
//                            1.000 mm seat floor carries no load)
//   TopCap  : Z ∈ [ +8,+18]; solid roof + Ø5 needle hole
//   Film    : Z ∈ [−17,+18]  external 3 mm aerogel felt (not a printed part)
//   Copper  : Z ∈ [−38.0,−27.2]; 50×51.8×10.8, top 1.2 below the well ceiling
//           (rev W: whole-copper drop cop_drop under the flat well-floor ring)
//   TEC     : Z ∈ [−42.0,−38.0] pressed on the copper bottom (grease only)
//   WaterBlk: Z ∈ [−51.5,−42.0]; 40×40×9.5 + 2 barbs Ø9.5, axis Z=−46.75
//   Cradle  : Z ∈ [−55.5,−34.2]; rev L printed stack locator + collar (see rev L block)
//   Support : Z ∈ [−113.5,−55.5]; rev K printed pedestal onto the height stage
//   (external clamping frame REMOVED in rev F; rev G replaces it with a
//    printed retainer cage, not yet modelled — see the CLAMPING note)
// =============================================
if (show == 0) {
    // ---- printed modules ----
    translate([0, 0, z_frame_bot]) BaseModule();
    translate([0, 0, z_pent_bot])  PentModule();
    translate([0, 0, cr_plt_z])   StackCradle();
    translate([0, 0, cr_plt_z])   SupportBase();
    // rev Q — dual config: droplet keeps the short cap, insert, rod, substrate
    // and the retainer cage; calibration swaps in the tall cap over the cuvette
    // with the centre core and rod removed. rev V — calibration does NOT park the
    // cage anymore: the SAME printed cage rides the TALL roof (+27.8..+31.8) on the
    // LONGER Ø10 × 93 columns (rc_pin_tall), restoring the keybar clamp loop.
    if (calib == 1) {
        translate([0, 0, z_pent_top])   TopCapTallModule();
        // cuvette ghost: 50 mm cell standing on the copper at −26, top +24
        translate([-cuv_w/2, -cuv_w/2, z_cop_top])
            color("RoyalBlue", 0.50)
                cube([cuv_w, cuv_w, cuv_top - z_cop_top]);
        // rev V — tall-clamp hardware ghosts: cage LIFTED by the roof delta
        // (h_top_tall − h_top = +9.8) and the taller pins at the SAME socket base
        // (−50.5, bottom slot 2..5). Top slot +31.2, cotter +41.13, pin top +42.5.
        color("Lime", 0.45)
            translate([0, 0, h_top_tall - h_top]) RetainerCage();
        color("Gray", 0.7)
            for (p = col_pos)
                translate([p[0], p[1], rc_pin_bot])
                    cylinder(d = rc_pin_d, h = rc_pin_h_tall, $fn = 40);
        color("Orange", 0.85)
            for (p = col_pos)
                translate([p[0], p[1], rc_arm_top_tall]) {
                    difference() {
                        cylinder(d = rc_spr_w, h = rc_spr_inst, $fn = 60);
                        translate([0, 0, -0.01])
                            cylinder(d = rc_spr_id, h = rc_spr_inst + 0.02, $fn = 60);
                    }
                    translate([0, 0, rc_spr_inst]) {
                        difference() {
                            cylinder(d = rc_col_od, h = rc_col_h, $fn = 60);
                            translate([0, 0, -0.01])
                                cylinder(d = rc_col_id, h = rc_col_h + 0.02, $fn = 60);
                        }
                    }
                }
        // bottom keys — same socket channel (cr_plt_z + col_key_z = 7..10)
        color("LightGray", 0.8)
            for (i = [0:3])
                translate([col_pos[i][0] - rc_key_l_col[i]/2,
                           col_pos[i][1] - rc_key_w/2, cr_plt_z + col_key_z])
                    cube([rc_key_l_col[i], rc_key_w, rc_key_t]);
        // radial side keys — same 3×3 bars, lifted to the tall ring axis +31.2
        color("LightGray", 0.8)
            for (p = col_pos)
                translate([p[0], p[1], rc_tslot_z_tall])
                    cube([rc_radkey_l, rc_radkey_s, rc_radkey_s], center = true);
    } else {
        translate([0, 0, z_pent_top])   TopCapModule();
        // 针孔塞（液滴模式塞住，标定模式拔出）
        color("Cyan", 0.8)
            translate([0, 0, z_pent_top + h_top - 3])
                NeedleHolePlug();
        // removable centre core (droplet only — calibration lifts it out)
        translate([0, 0, z_pent_bot])
            color("DeepSkyBlue", 0.65)
                PedestalInsertModule();
        // rev T — retainer cage: TWO layers (press plate + arm layer) ride the
        // top-cap roof; the pins/disc stacks/keys below are hardware ghosts.
        // Semi-transparent so the felt stays visible.
        color("Lime", 0.45) RetainerCage();
        // rev T / T2 / T3 — small cage hardware ghosts: Ø10 pins down the arm tips
        // into the anchor sockets, disc+collar stacks (Ø23, rev T4) on the arm tops
        // (+22, δ=0.67), and the BOTTOM keys crossing each socket + Ø3 radial SIDE
        // keys in the rings.
        // Pin base at −50.5 (= cr_plt_z + col_key_z − the 2 mm key-slot offset)
        // ⇒ the slot band 2..5 lands on the socket channel 7..10.
        color("Gray", 0.7)
            for (p = col_pos)
                translate([p[0], p[1],
                           cr_plt_z + col_key_z - (rc_pin_slot_c - rc_key_t/2)])
                    cylinder(d = rc_pin_d, h = rc_pin_h, $fn = 40);
        // rev T4 — disc (installed 1.33, +22..+23.33) + collar (7.0, +23.33..+30.33),
        // pressed by the cotter-hole bottom at +30.33 ⇒ the 8.33 span 22→30.33.
        // (The old "single Ø23 × 9.33 cylinder" ghost was WRONG — it implied a
        // disc touching the cotter; audit proved the cotter floated 7.33 above it.)
        color("Orange", 0.85)
            for (p = col_pos)
                translate([p[0], p[1], rc_arm_top]) {
                    difference() {
                        cylinder(d = rc_spr_w, h = rc_spr_inst, $fn = 60);
                        translate([0, 0, -0.01])
                            cylinder(d = rc_spr_id, h = rc_spr_inst + 0.02, $fn = 60);
                    }
                    translate([0, 0, rc_spr_inst]) {
                        difference() {
                            cylinder(d = rc_col_od, h = rc_col_h, $fn = 60);
                            translate([0, 0, -0.01])
                                cylinder(d = rc_col_id, h = rc_col_h + 0.02, $fn = 60);
                        }
                    }
                }
        color("LightGray", 0.8)
            for (i = [0:3])
                translate([col_pos[i][0] - rc_key_l_col[i]/2,
                           col_pos[i][1] - rc_key_w/2, cr_plt_z + col_key_z])
                    cube([rc_key_l_col[i], rc_key_w, rc_key_t]);
        // RADIAL SIDE KEYS — 3×3 square × 16 bars along X (rev T2.2), one per ring,
        // threading the ring's 3.4×3.4 square passage + the pin's square TOP slot
        // at rc_tslot_z (locks ring ↔ pin; the old flat 22-long top keys + the Ø3
        // round dowels are gone).
        color("LightGray", 0.8)
            for (p = col_pos)
                translate([p[0], p[1], rc_tslot_z])
                    cube([rc_radkey_l, rc_radkey_s, rc_radkey_s], center = true);
    }

    // ---- metal parts ----
    // 50 × 51.8 × 10.8 copper block (rev J: 51.8 on Y). rev G: the 50×50×3 shim
    // is GONE. rev W: the block is dropped cop_drop = 1.2 as a whole, so its
    // top face at −27.2 sits 0.2 (cop_seal_gap) BELOW the well-mouth floor
    // (frame ceiling + seal shelf, all at −26) — the springs consume that 0.2
    // as seat-in, then all further force becomes TEC preload (see note below).
    color("Orange", 0.85)
        translate([-plate_x/2, -plate_y/2, z_cop_bot])
            cube([plate_x, plate_y, plate_t]);
    // rod + substrate only in droplet mode (the cuvette takes the centre in calib)
    if (calib == 0) {
        color("Orange", 0.85)
            translate([-rod_d/2, -rod_d/2, z_rod_bot])
                cylinder(d = rod_d, h = rod_len, $fn = 40);
        color("Orange", 0.85)
            translate([0, 0, z_sub_bot])
                cylinder(d = sub_d, h = sub_t, $fn = 60);
    }

    // ---- thermal stack: TEC + water block + barb fittings ----
    // TEC1-12706 40×40. It nests INSIDE the frame's 50.4 × 52.2 bore (rev J:
    // 5.2 mm/side clear on X, 6.1 on Y), so its cold face reaches the copper
    // bottom at −38.0 with no boss.
    color("Gray", 0.55)
        translate([-tec_s/2, -tec_s/2, z_tec_bot])
            cube([tec_s, tec_s, tec_t]);
    // copper water block 40×40×9.5
    color("Bisque", 0.55)
        translate([-wb_s/2, -wb_s/2, z_wb_bot])
            cube([wb_s, wb_s, wb_t]);
    // two barb (宝塔) fittings Ø9.5 × 15, BOTH on the SAME +X side face
    // (barb_az = 0), each offset ±10 along it → 20 mm centre-to-centre.
    // barb_d == wb_t == 9.5, so each barb spans EXACTLY the block's height:
    // z_barb ± 4.75 = −49.30..−39.80. Verified off the render — the end-circle
    // vertices sit at z = −44.55 + 4.75·sin θ (19 symmetric levels, cosine
    // gaps 0.17→0.74→0.17), which is what proves the no-Z-conflict claim.
    rotate([0, 0, barb_az])
        for (o = barb_off)
            translate([wb_s/2 - 0.01, o, z_barb])
                rotate([0, 90, 0])
                    cylinder(d = barb_d, h = barb_l + 0.01, $fn = 40);

    // ---- external insulation (ghost; not a printable part) ----
    FilmGhost();

    ObstacleGhost();
}

// =============================================
// SINGLE-PART EXPORT — set `show` at the top of the file (see [Global])
//   Each sits at the LOCAL origin, already in print orientation
//   (bottom face on the plate, mating faces up).
// =============================================
if (show == 1) BaseModule();
if (show == 2) PentModule();
if (show == 3) TopCapModule();
if (show == 4) FilmGhost();
if (show == 5) StackCradle();
if (show == 6) SupportBase();
if (show == 7) PressPlate();
if (show == 8) TopCapTallModule();
if (show == 9) PedestalInsertModule();
if (show == 10) KeyBar();
if (show == 11) ArmsLayer();
if (show == 12) DiscSpringsLayer();
if (show == 13) CollarLayer();
if (show == 14) NeedleHolePlug();
if (show == 15) WindowCap();