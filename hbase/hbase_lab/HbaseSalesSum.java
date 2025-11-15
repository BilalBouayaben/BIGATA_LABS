import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.util.Bytes;

public class HbaseSalesSum {
    
    public static void main(String[] args) {
        try {
            // Configuration HBase
            Configuration config = HBaseConfiguration.create();
            config.set("hbase.zookeeper.quorum", "hadoop-master");
            config.set("hbase.zookeeper.property.clientPort", "2181");
            
            System.out.println("=====================================");
            System.out.println("CALCUL DE LA SOMME DES VENTES");
            System.out.println("=====================================\n");
            
            // Connexion a HBase
            Connection connection = ConnectionFactory.createConnection(config);
            Table table = connection.getTable(TableName.valueOf("products"));
            
            // Scan de toute la table
            Scan scan = new Scan();
            ResultScanner scanner = table.getScanner(scan);
            
            double totalSum = 0.0;
            int count = 0;
            
            System.out.println("Lecture des enregistrements...\n");
            
            // Parcourir tous les resultats
            for (Result result : scanner) {
                byte[] paymentBytes = result.getValue(Bytes.toBytes("cf"), Bytes.toBytes("payment"));
                
                if (paymentBytes != null) {
                    String paymentStr = Bytes.toString(paymentBytes);
                    double payment = Double.parseDouble(paymentStr);
                    
                    byte[] rowKey = result.getRow();
                    String rowKeyStr = Bytes.toString(rowKey);
                    
                    System.out.println("  Produit " + rowKeyStr + ": " + payment + " EUR");
                    
                    totalSum += payment;
                    count++;
                }
            }
            
            System.out.println("\n=====================================");
            System.out.println("RESULTATS:");
            System.out.println("  Nombre de produits: " + count);
            System.out.println("  SOMME TOTALE DES VENTES: " + String.format("%.2f", totalSum) + " EUR");
            System.out.println("=====================================");
            
            // Fermeture des ressources
            scanner.close();
            table.close();
            connection.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
