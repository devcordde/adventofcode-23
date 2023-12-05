(require '[clojure.string :as cstr])

(def input (slurp "input.txt"))

(defn read-nums []
  (for [result (for [cv (cstr/split-lines input)]
                 (cstr/join (re-seq #"[1-9]" cv)))]
    (Integer/parseInt (str (first result) (last result)))))

(println (str "Part 1: " (apply + (read-nums))))
