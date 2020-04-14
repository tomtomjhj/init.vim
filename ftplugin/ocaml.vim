if !exists('b:AutoPairs')
    let b:AutoPairs = AutoPairsDefine({}, ["'"])
endif

setl tabstop=2 shiftwidth=2

call SetupCoc()
