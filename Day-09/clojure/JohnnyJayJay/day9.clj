;; SPDX-License-Identifier: 0BSD
(ns day9
  (:require [clojure.string :as str]))

(defn parse-input [s]
  (mapv #(mapv parse-long (str/split % #"\s+")) (str/split-lines s)))

(defn diff-seq [history]
  (->> history
       (iterate #(mapv - (rest %) %))
       (take-while (partial not-every? zero?))))

(defn extrapolate-next [diff-seq]
  (->> diff-seq
       (map (comp first rseq))
       (reduce +)))

(defn extrapolate-prev [diff-seq]
  (->> diff-seq
       (map first)
       (map * (cycle [1 -1]))
       (reduce +)))

(defn extrapolate [histories]
  (->> histories
       (map diff-seq)
       (map (juxt extrapolate-prev extrapolate-next))
       (reduce (partial mapv +))))

(defn -main [input-file]
  (->> input-file slurp parse-input extrapolate (run! println)))
