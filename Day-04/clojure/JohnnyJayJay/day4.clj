(ns day4
  (:require
   [clojure.string :as str]
   [clojure.set :as set]))

(defn nums-part->set [nums]
  (->> (str/split nums #"\s+")
       (remove empty?)
       (map parse-long)
       set))

(defn parse-card [line]
  (-> line
      (subs (inc (str/index-of line \:)))
      (str/split #"\|")
      (->> (map nums-part->set) (reduce set/intersection))
      count))

(defn point-sum [cards]
  (->> cards
       (remove zero?)
       (map #(bit-shift-left 1 (dec %)))
       (reduce +')))

(defn card-sum [cards]
  (->> cards
       (reductions
        (fn [[this & remaining] num]
          (let [[affected unaffected] (split-at num remaining)]
            (concat
             (map (partial + this) affected)
             unaffected)))
        (repeat 1))
       (map first)
       butlast
       (reduce +)))

(defn -main [input-file]
  (let [cards (->> input-file slurp str/split-lines (map parse-card))]
    (println (point-sum cards))
    (println (card-sum cards))))
