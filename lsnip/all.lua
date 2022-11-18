return {
  s("date", p(os.date, "%Y-%m-%d")),
  s("diso", p(os.date, "%Y-%m-%d %H:%M:%S%z")),
  s("time", p(os.date, "%H:%M")),
  s("modeline", fmt([[vim: set {}:]], { i(0, "opt=value") })),
}
