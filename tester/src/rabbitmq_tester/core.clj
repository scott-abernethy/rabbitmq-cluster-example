(ns rabbitmq-tester.core
  (:gen-class)
  (:require [langohr.core :as mq]
            [langohr.channel :as mqch]
            [langohr.queue :as mqq]
            [langohr.consumers :as mqc]
            [langohr.basic :as mqb]))

(def ^{:const true}
  default-exchange-name "test.exchange")

(defn message-handler
  [ch {:keys [content-type delivery-tag type] :as meta} ^bytes payload]
  ; (mqb/ack ch delivery-tag)
  (println (format "[sub ] Received message: %s"
                   (String. payload "UTF-8"))))

(def counter (atom 0))

(defn do-q
  [host fq]
  (while true
    (println "[main] Connecting to" host)
    (try
      (let [conn (mq/connect {:host host})
            ch (mqch/open conn)]
        (fq ch)
        (mq/close ch)
        (mq/close conn))
      (catch Exception e (println "[main] Oops with" host "waiting 10 seconds before reconnect...")))
    (Thread/sleep 10000)))

(defn pub
  [ch]
  (while true
    (let [rname "test.route2"
          msg (str "**" @counter "**")]
      (mqb/publish ch default-exchange-name rname msg :content-type "text/plain" :type "greetings.hi")
      (println "[pub ] Sent " msg)
      (swap! counter inc)
      (Thread/sleep (rand-int 500)))))

(defn sub
  [ch]
  (Thread/sleep 3000)
  (while true
    (let [qname "test.queue2"
          consumer (mqc/create-default ch :handle-delivery-fn message-handler)]
      (if-let [[metadata payload] (mqb/get ch qname)]
        (do
          (message-handler ch metadata payload)
          (Thread/sleep (rand-int 50)))
        (Thread/sleep (+ 10000 (rand-int 30000)))))))

(defn -main
  [& args]
  (.start (Thread. (fn [] (do-q "192.168.64.20" sub))))
	(Thread/sleep 1000)
  (do-q "192.168.64.10" pub))
