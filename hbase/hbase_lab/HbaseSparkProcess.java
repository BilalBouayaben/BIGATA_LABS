import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.io.ImmutableBytesWritable;
import org.apache.hadoop.hbase.mapreduce.TableInputFormat;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

public class HbaseSparkProcess {
    
    public static void createHbaseTable() {
        Configuration config = HBaseConfiguration.create();
        config.set("hbase.zookeeper.quorum", "hadoop-master");
        config.set("hbase.zookeeper.property.clientPort", "2181");
        config.set(TableInputFormat.INPUT_TABLE, "products");
        
        System.out.println("Configuration HBase:");
        System.out.println("  Zookeeper: " + config.get("hbase.zookeeper.quorum"));
        System.out.println("  Table: " + config.get(TableInputFormat.INPUT_TABLE));
        
        SparkConf sparkConf = new SparkConf()
                .setAppName("SparkHBaseTest")
                .setMaster("local[*]");
        
        JavaSparkContext jsc = new JavaSparkContext(sparkConf);
        
        JavaPairRDD<ImmutableBytesWritable, Result> hbaseRDD = 
            jsc.newAPIHadoopRDD(
                config, 
                TableInputFormat.class, 
                ImmutableBytesWritable.class, 
                Result.class
            );
        
        // Extraire les valeurs de payment et calculer la somme
        JavaRDD<Double> paymentsRDD = hbaseRDD.map(tuple -> {
            Result result = tuple._2();
            byte[] paymentBytes = result.getValue(Bytes.toBytes("cf"), Bytes.toBytes("payment"));
            if (paymentBytes != null) {
                String paymentStr = Bytes.toString(paymentBytes);
                // Nettoyer la valeur (supprimer les virgules et symboles)
                paymentStr = paymentStr.replace(",", "").trim();
                try {
                    return Double.parseDouble(paymentStr);
                } catch (NumberFormatException e) {
                    System.out.println("Erreur parsing: " + paymentStr);
                    return 0.0;
                }
            }
            return 0.0;
        });
        
        long count = hbaseRDD.count();
        double totalSales = paymentsRDD.reduce((a, b) -> a + b);
        
        System.out.println("\n=== RESULTAT - ACTIVITE SUPPLEMENTAIRE ===");
        System.out.println("Nombre de produits vendus: " + count);
        System.out.println("SOMME TOTALE DES VENTES: " + String.format("%.2f", totalSales) + " $");
        System.out.println("==========================================\n");
        
        jsc.close();
    }
    
    public static void main(String[] args) {
        HbaseSparkProcess admin = new HbaseSparkProcess();
        admin.createHbaseTable();
    }
}
