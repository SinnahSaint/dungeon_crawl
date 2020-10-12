class ::Hash

  # h1 = { a: { c: 3, d: 4}, b: 2 }
  # h2 = { a: { d: 40, e: 50} }
  # h3 = h1.deep_merge(h2)
  # h3 # { a: { c: 3, d: 40, e: 50}, b: 2 }
  def deep_merge(other)
    merge_proc = ->(key, first, second) {
      if Hash === first && Hash === second
        first.merge(second, &merge_proc)
      else
        second || first
      end
    }

    self.merge(other, &merge_proc)
  end
end

# I think this should work ^_^ -- Meg
