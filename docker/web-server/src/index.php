<?php
class Application
{
    // MySQL connection
    //const DBHOST = '192.168.56.201'; // <- vagrant guest OS IP
    const DBHOST = '172.17.0.1'; // '127.0.0.1'; // <- mysql docker server IP in vagrant
    const DBNAME = 'dev';
    const DBUSER = 'dev';
    const DBPASS = 'dev';

    public function __construct()
    {
    }
 
    public function info()
    {
        // Show all information, defaults to INFO_ALL
        phpinfo();

        // Show just the module information.
        // phpinfo(8) yields identical results.
        phpinfo(INFO_MODULES);
    }

    public function dbCheck()
    {
        // MySQL params
        $dbhost = self::DBHOST;
        $dbname = self::DBNAME;
        $dbuser = self::DBUSER;
        $dbpass = self::DBPASS;
        
        try {
            mysqli_report(MYSQLI_REPORT_ALL); // Traps all mysqli error
            $connect = mysqli_connect($dbhost, $dbuser, $dbpass) or die("Unable to Connect to '$dbhost'");
            mysqli_select_db($connect, $dbname) or die("Could not open the db '$dbname'");
        } catch (Exception $e) {
            echo "==> MySQL Error: " . $e->getMessage() . '<br>';
        }

        if ($connect) {
            echo "==> Connected to MySQL database [$dbname] at host [$dbhost] successfully.";
        } else {
            echo "==> Error: Could not connect to the database $dbname at $dbhost";
        }

        echo '<p/>';
    }

    public function redisCheck()
    {
        try {
            //Connecting to Redis server on localhost
            $redis = new Redis(); 
            $redis->connect('172.17.0.1', 6379); 
            echo "==> Connection to redis server successfully";
            //set the data in redis string
            $val =  "Redis test data";
            $redis->set("test-key", $val); 
            // Get the stored data and print it 
            if ($val === $redis->get("test-key")) {
                echo '<br/>';
                echo "==> Set and get data works"; 
            }
        } catch (Exception $e) {
            echo "==> Error: Failed to connect redis server." . $e->getMessage();
        }

        echo '<p/>';
    }
}

echo "This file comes with docker image. Remote IP [" . $_SERVER['REMOTE_ADDR'] . "].";

$app = new Application();
$app->dbCheck();
$app->redisCheck();
$app->info();