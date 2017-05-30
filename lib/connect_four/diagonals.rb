module Diagonals
  DIAGONALS =
    [{ side:       :left,
       diagonal1: { start: { y: 3, x: 0 }, finish: { y: 0, x: 3 } },
       diagonal2: { start: { y: 4, x: 0 }, finish: { y: 0, x: 4 } },
       diagonal3: { start: { y: 5, x: 0 }, finish: { y: 0, x: 5 } },
       diagonal4: { start: { y: 5, x: 1 }, finish: { y: 0, x: 6 } },
       diagonal5: { start: { y: 5, x: 2 }, finish: { y: 1, x: 6 } },
       diagonal6: { start: { y: 5, x: 3 }, finish: { y: 2, x: 6 } } },

     { side:      :right,
       diagonal1: { start: { y: 2, x: 0 }, finish: { y: 5, x: 3 } },
       diagonal2: { start: { y: 1, x: 0 }, finish: { y: 5, x: 4 } },
       diagonal3: { start: { y: 0, x: 0 }, finish: { y: 5, x: 5 } },
       diagonal4: { start: { y: 0, x: 1 }, finish: { y: 5, x: 6 } },
       diagonal5: { start: { y: 0, x: 2 }, finish: { y: 4, x: 6 } },
       diagonal6: { start: { y: 0, x: 3 }, finish: { y: 3, x: 6 } } }].freeze
end
