(ns aoc-2023.day4)

(defn cards-to-ints [cards]
  (->> (clojure.string/split cards #" ")
       (map #(Integer/parseInt %))))

(defn extract-card-parts [line]
  (->> line
       (map #(clojure.string/replace % #"[ ]+" " "))
       (map #(clojure.string/split % #": "))
       (map last)
       (map #(clojure.string/split % #" \| "))
       (map #(map cards-to-ints %))))

(defn part1 [lines]
  (->> lines
       (extract-card-parts)
       (map #(filter (set (first %)) (last %)))
       (filter not-empty)
       (map #(Math/pow 2 (- (count %) 1)))
       (reduce +)
       (int)))

(defn part2 [lines]
  "TODO")

(defn -main []
  (let [lines (clojure.string/split-lines (slurp "input.txt"))]
    (println "Part 1:" (part1 lines))
    (println "Part 2:" (part2 lines))))
