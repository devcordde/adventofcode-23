(ns day8
  (:require [clojure.string :as str]))

(defn parse-input [[directions _ & nodes]]
  (let [dirs (map (partial str/index-of "LR") directions)]
    {:directions dirs
     :length (count dirs)
     :nodes (->> nodes
                 (map (partial re-seq #"[A-Z0-9]+"))
                 (map (juxt first (comp vec rest)))
                 (into {}))}))

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
         visited {start 0}]
    (let [result (reduce (comp (partial get-in nodes) vector) current directions)]
      (if-let [cycle-start-steps (get visited result)]
        {:start cycle-start-steps
         :length (inc (- steps cycle-start-steps))
         :end-states (select-keys visited (filter #(str/ends-with? % "Z") (keys visited)))}
        (recur
         result
         (inc steps)
         (assoc visited result (inc steps)))))))

(defn part-1 [{:keys [length] :as input}]
  (-> (find-cycle input "AAA")
      (get-in [:end-states "ZZZ"])
      (* length)))

;; TODO: use gcd, more general solution
(defn part-2 [{:keys [length nodes] :as input}]
  (let [cycles (map (partial find-cycle input) (filter #(str/ends-with? % "A") (keys nodes)))]
    (->> cycles
         (map :length)
         (reduce *)
         (* length))))

(defn steps [{:keys [directions nodes]}]
  (loop [current "AAA"
         steps 0
         [next-direction & rem] (cycle directions)]
    (if (= "ZZZ" current)
      steps
      (recur (get-in nodes [current next-direction]) (inc steps) rem))))
