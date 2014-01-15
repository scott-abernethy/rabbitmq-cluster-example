## RabbitMQ cluster and federation examples
An working example of two multi-machine RabbitMQ setups...
1. RabbitMQ two node [cluster](http://www.rabbitmq.com/clustering.html)
2. RabbitMQ two node [federation](http://www.rabbitmq.com/federation.html)

### Usage
1. Install [Vagrant](http://www.vagrantup.com)
2. In the project root do: 

    ```bash
    cd cluster
    vagrant up
    ```

    OR

    ```bash
    cd federated
    vagrant up
    ```

#### Pub/sub simulation
To test each setup you can use the (very basic) tester included...
1. Install [Leiningen](http://leiningen.org/#install)
2. In the project root do:

    ```bash
    cd tester
    lein run
    ```

