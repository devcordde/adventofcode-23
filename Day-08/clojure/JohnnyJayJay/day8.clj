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

;; TODO: implement more general solution without assuming
;; - that cycle lengths don't share a divisor
;; - that cycles end with a ..Z state
;; - that there is exactly one ..Z state per cycle
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

(defn -main [input-file]
  (let [input (-> input-file slurp str/split-lines parse-input)]
    (println (part-1 input))
    (println (part-2 input))))
