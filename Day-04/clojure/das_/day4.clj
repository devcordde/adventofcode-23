(ns day4
    (:require [clojure.string :as str]))

(defn input-parts [line]
      (-> line
          (str/replace #" +" " ")
          (str/split #": ")))

(defn game-number [game-string]
      (-> game-string
          (str/split #" ")
          (last)
          (Integer/parseInt)))

(defn string-to-ints [cards]
      (->> (str/split cards #" ")
           (map #(Integer/parseInt %))))

(defn extract-card-parts [line]
      (let [parts (input-parts line)
            numbers (last parts)]
           {:game-number (game-number (first parts))
            :card-parts (->> (str/split numbers #" \| ")
                             (map string-to-ints))}))

(defn intersection [s]
      (filter (set (first s)) (last s)))

(defn associate-count [element count]
      (hash-map element count))

(defn next-numbers [start, n, count]
      (->> (range start (+ start n))
           (map #(associate-count % count))
           (apply merge)))

(defn calculate-score [card1, card2]
      (let [matches (count (:card-parts card2))
            card-number (:game-number card2)
            new-cards (next-numbers (+ 1 card-number) matches (+ 1 (get card1 card-number 0)))]
           (merge-with + (dissoc card1 :game-number) (dissoc card2 :card-parts) new-cards)))

(defn part1 [lines]
      (->> lines
           (map extract-card-parts)
           (map :card-parts)
           (map intersection)
           (filter not-empty)
           (map #(Math/pow 2 (- (count %) 1)))
           (reduce +)
           (int)))

(defn update-first-element [element]
      (if (= (:game-number element) 1)
        (merge element (next-numbers 2 (count (:card-parts element)) 1))
        element))

(defn part2 [lines]
      (->> (dissoc (->> lines
                        (map extract-card-parts)
                        (map #(assoc-in % [:card-parts] (intersection (:card-parts %))))
                        (map #(assoc-in % [(:game-number %)] 1))
                        (map update-first-element)
                        (reduce calculate-score))
                   :game-number :card-parts)
           (map val)
           (reduce +)))

(defn -main []
      (let [lines (str/split-lines (slurp "input.txt"))]
           (println "Part 1: " (part1 lines))
           (println "Part 2: " (part2 lines))))
