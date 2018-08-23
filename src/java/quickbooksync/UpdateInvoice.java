/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package quickbooksync;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.SQLException;
import java.util.List;
import org.apache.log4j.Logger;

/**
 *
 * @author nmohamed
 */
public class UpdateInvoice {
    static Logger log = Logger.getLogger(UpdateInvoice.class.getName());
    
    public void updateInvoice (List<QBInvoice> updatelist, Config config)
    {
    // take the input(which has the ID from invoicelineitem and the new itemAmount) and looping through them to update item amount column in QB InvoiceLineItem table based on the invoiceid
        
   try{
        DBconnection connectQB = new DBconnection();
        connectQB.createconnQB(config);
        String fixamount;
      
        for (QBInvoice invoice : updatelist) {
            double dd=  invoice.getAmount();///100;
         fixamount = Double.toString(dd);
             
            connectQB.statementQB.executeUpdate("update InvoiceLineItems SET ItemAmount = '"+ fixamount + "' where ID = '"+invoice.getId()+"'");
        }
        }catch (SQLException ex) {
            
            StringWriter errors = new StringWriter();
ex.printStackTrace(new PrintWriter(errors));
log.error(ex+errors.toString());
        }
    
    }

    
    
}
