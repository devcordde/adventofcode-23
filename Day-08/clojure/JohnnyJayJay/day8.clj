(ns day8
  (:require [clojure.string :as str]))

(defn parse-input [[directions _ & nodes]]
  {:directions (map (partial str/index-of "LR") directions)
   :nodes (->> nodes
               (map (partial re-seq #"[A-Z0-9]+"))
               (map (juxt first (comp vec rest)))
               (into {}))})

(def real-input (parse-input (str/split-lines (slurp "input"))))

(def test-input (parse-input (str/split-lines "LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)")))

(defn steps-2 [{:keys [directions nodes]}]
  (loop [fringe (->> nodes keys (filter #(str/ends-with? % "A")))
         steps 0
         [next-direction & rem] (cycle directions)]

    (if (every? #(str/ends-with? % "Z") fringe)
      steps
      (recur
       (->> fringe
            (map #(get-in nodes [% next-direction]))
            set)
       (inc steps)
       rem))))

(defn find-cycle [{:keys [directions nodes]} start]
  (loop [current start
         steps 0
         visited {}
         [next-direction & rem] (cycle directions)]
    (if-let [cycle-start-steps (get visited current)]
      [cycle-start-steps (- steps cycle-start-steps)]
      (recur (get-in nodes [current next-direction])
             (inc steps)
             (assoc visited current steps)
             rem))))

(defn steps [{:keys [directions nodes]}]
  (loop [current "AAA"
         steps 0
         [next-direction & rem] (cycle directions)]
    (if (= "ZZZ" current)
      steps
      (recur (get-in nodes [current next-direction]) (inc steps) rem))))
