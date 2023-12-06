(require '[clojure.string :as cstr])

(def input (cstr/split-lines (slurp "input.txt")))

(defn parse-games []
  (map #(for [game (cstr/split (cstr/replace-first % #"^Game [0-9]*: " "") #"; ")]
          (apply merge (for [cube (cstr/split game #", ")
                             :let [splitted-cube (cstr/split cube #" ")]]
                         {(keyword (second splitted-cube)) (Integer/parseInt (first splitted-cube))})))
       input))

;;; Part 1

(def possible {:red 12 :green 13 :blue 14})

(defn possible? [game]
  (not-any? (fn [round]
              (or (and (contains? round :red)
                       (> (:red round) (:red possible)))
                  (and (contains? round :green)
                       (> (:green round) (:green possible)))
                  (and (contains? round :blue)
                       (> (:blue round) (:blue possible))))) game))

(defn possible-games [parsed-games]
  (filter some? (let [possible-res (map possible? parsed-games)]
                  (for [id (range (count possible-res))]
                    (when (nth possible-res id)
                      (inc id))))))

;;; Part 2

(defn most-cubes [parsed-games]
  (for [game parsed-games]
    (apply merge-with (concat [#(first (reverse (sort [%1 %2])))] game))))

(defn power-of-games [parsed-games]
  (map #(apply * %) (map vals (most-cubes parsed-games))))

(println (str "Part 1: " (apply + (possible-games (parse-games)))))

(println (str "Part 2: " (apply + (power-of-games (parse-games)))))
