package com.coway.trust.web.scm;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.SocketException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPClientConfig;
import org.apache.commons.net.ftp.FTPFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.ibm.icu.util.Calendar;


@Controller
@RequestMapping(value = "/scm")
public class ScmBatchController2 {
	private FTPClient	client	= null;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ScmBatchController.class);
	
	@RequestMapping(value = "/connection2.do", method = RequestMethod.GET)
	public ResponseEntity<String> connection2(@RequestParam Map<String, Object> params) {

		LOGGER.debug("selectSupplyCDC_ComboList : {}", params.toString());
		/*
		 Hostname : cwrtftp1
		 IP : 10.101.3.40
		 OS : CentOS 7.5 64Bit
		 CPU : 4 Core
		 MEM : 4GB
		 HDD : / 46 GB
		 SFTP 계정 : etrustftp / akffus#20!*
		 etrustftp Home : /home/etrustftp/data
			 */
		//execute();
		connect("10.101.3.40", "etrustftp", "akffus#20!*", 21);
		
		disconnect();

		return ResponseEntity.ok("OK");
	}
	
	public void connect(String host, String name, String pass, int port) {
		client	= new FTPClient();
		client.setControlEncoding("euc-kr");
		
		FTPClientConfig	config	= new FTPClientConfig();
		client.configure(config);
		
		try {
			client.connect(host, port);
			LOGGER.debug("ftp connected==================");
			
			client.login(name, pass);
			LOGGER.debug("ftp login======================");
			
			read(client);
		} catch ( Exception se ) {
			se.printStackTrace();
		}
	}
	
	public void disconnect() {
		try {
			client.logout();
			if ( client.isConnected() ) {
				client.disconnect();
				LOGGER.debug("ftp disconnected===============");
			}
		} catch ( IOException e ) {
			e.printStackTrace();
		}
	}
	
	public static void read(FTPClient client) {
		BufferedReader reader	= null;
		String fileName	= "";
		SimpleDateFormat sdf	= new SimpleDateFormat("yyyyMMdd");
		Calendar cal	= Calendar.getInstance();
		String today	= sdf.format(cal.getTime());
		
		try {
			client.changeWorkingDirectory("/");
			FTPFile[] files = client.listFiles();
			LOGGER.debug("cnt : " + files.length);
			String soFileName	= "COWAY_SO_DATA_" + today + ".TXT";
			String ppFileName	= "COWAY_PP_DATA_" + today + ".TXT";
			String giFileName	= "COWAY_GI_DATA_" + today + ".TXT";
			
			for ( int i = 0 ; i < files.length ; i++ ) {
				LOGGER.debug(i + "th filename : " + files[i].getName() + ", filesize : " + files[i].getSize());
				if ( 0 < files[i].getSize() ) {
					fileName	= files[i].getName();
					if ( soFileName.equals(fileName) ) {
						InputStream is	= client.retrieveFileStream("/" + fileName);
						if ( null != is ) {
							reader	= new BufferedReader(new InputStreamReader(is, "utf-8"));
							LOGGER.debug("writing to DB : " + reader.readLine());
							executeQuery(reader, fileName);
							LOGGER.debug("writing to DB(log) ");
							//executeQueryLog(reader, fileName, today);
						} else {
							LOGGER.debug("did not write");
						}
					}
				}
			}
			
			for ( int i = 0 ; i < files.length ; i++ ) {
				LOGGER.debug(i + "th filename : " + files[i].getName() + ", filesize : " + files[i].getSize());
				if ( 0 < files[i].getSize() ) {
					fileName	= files[i].getName();
					if ( ppFileName.equals(fileName) ) {
						InputStream is	= client.retrieveFileStream("/" + fileName);
						if ( null != is ) {
							reader	= new BufferedReader(new InputStreamReader(is, "utf-8"));
							LOGGER.debug("writing to DB : " + reader.readLine());
							executeQuery1(reader, fileName);
							LOGGER.debug("writing to DB(log) ");
							//executeQueryLog(reader, fileName, today);
						} else {
							LOGGER.debug("did not write");
						}
					}
				}
			}
			
			for ( int i = 0 ; i < files.length ; i++ ) {
				LOGGER.debug(i + "th filename : " + files[i].getName() + ", filesize : " + files[i].getSize());
				if ( 0 < files[i].getSize() ) {
					fileName	= files[i].getName();
					if ( giFileName.equals(fileName) ) {
						InputStream is	= client.retrieveFileStream("/" + fileName);
						if ( null != is ) {
							reader	= new BufferedReader(new InputStreamReader(is, "utf-8"));
							LOGGER.debug("writing to DB : " + reader.readLine());
							executeQuery2(reader, fileName);
							LOGGER.debug("writing to DB(log) ");
							//executeQueryLog(reader, fileName, today);
						} else {
							LOGGER.debug("did not write");
						}
					}
				}
			}
		} catch ( IOException e ) {
			e.printStackTrace();
		} finally {
			try {
				if ( null != reader )	try { reader.close(); } catch (IOException logOrIgnore) {}
			} catch ( Exception e ) {
				e.printStackTrace();
			}
		}
	}
	
	public static void executeQueryLog(BufferedReader br, String fileName, String today) {
		Connection conn	= null;
		PreparedStatement ps	= null;
		
		try {
			String query	= "";
			Class.forName("oracle.jdbc.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.180:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017#");
			
			String remark	= "";
			if ( null == br ) {
				remark	= "this file is empty";
			}
			LOGGER.debug("1. fileName is : " + fileName);
			query	= "INSERT INTO SCM0055S ";
			query	+= "( ";
			query	+= "       READ_DT ";
			query	+= "     , FILE_NAME ";
			query	+= "     , CONTS ";
			query	+= "     , REMARK ";
			query	+= " ) ";
			query	+= "VALUES ";
			query	+= "( ";
			query	+= "       ? ";
			query	+= "     , ? ";
			query	+= "     , ? ";
			query	+= "     , ? ";
			query	+= " ) ";
			ps	= conn.prepareStatement(query);
			ps.setString(1, today);
			ps.setString(2, fileName);
			ps.setString(3, br.toString());
			ps.setString(4, remark);
			ps.executeQuery();
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	public static void executeQuery(BufferedReader br, String fileName) {
		Connection conn	= null;
		PreparedStatement ps	= null;
		
		try {
			String query	= "";
			Class.forName("oracle.jdbc.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.180:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017#");
			
			String poNo	= "";	String poDt		= "";	String stockCode	= "";	String row	= "";
			String soNo	= "";	int soItemNo	= 0;
			
			LOGGER.debug("1. fileName is : " + fileName);
			//	SO
			String soDt	= "";		int soQty		= 0;	
			/*query	= "MERGE INTO SCM0015D ";
			query	+= "USING DUAL ON (PO_NO = TRIM(?) AND PO_DT = TRIM(?) AND SO_NO = TRIM(?) AND SO_ITEM_NO = TO_NUMBER(TRIM(?)) AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?)))) ";
			query	+= "WHEN MATCHED THEN ";
			query	+= "UPDATE ";
			query	+= "   SET SO_QTY = TO_NUMBER(TRIM(?)) ";
			query	+= "     , SO_DT = TRIM(?) ";
			query	+= "WHEN NOT MATCHED THEN ";
			query	+= "INSERT ";
			query	+= "( ";
			query	+= "       PO_NO ";
			query	+= "     , PO_DT ";
			query	+= "     , SO_NO ";
			query	+= "     , SO_ITEM_NO ";
			query	+= "     , STOCK_CODE ";
			query	+= "     , SO_QTY ";
			query	+= "     , SO_DT ";
			query	+= " ) ";
			query	+= "VALUES ";
			query	+= "( ";
			query	+= "       TRIM(?) ";
			query	+= "     , TRIM(?) ";
			query	+= "     , TRIM(?) ";
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TO_CHAR(TO_NUMBER(TRIM(?))) ";
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TRIM(?) ";
			query	+= " ) ";*/
			query	= "UPDATE SCM0039M ";
			query	+= "   SET UPD_DT = SYSDATE ";
			query	+= "     , UPD_USER_ID = 'BATCH' ";
			query	+= "     , SO_NO = TRIM(?) ";
			query	+= "     , SO_ITEM_NO = TO_NUMBER(TRIM(?)) ";
			query	+= "     , SO_DT = TRIM(?) ";
			query	+= "     , SO_QTY = TO_NUMBER(TRIM(?)) ";
			query	+= " WHERE PO_NO = TRIM(?) ";
			query	+= "   AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?))) ";
			ps	= conn.prepareStatement(query);
			while ( null != (row = br.readLine()) ) {
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i )	poNo	= col[i];
					if ( 1 == i )	poDt	= col[i];
					if ( 2 == i )	soNo	= col[i];
					if ( 3 == i )	soItemNo	= Integer.parseInt(col[i].toString());
					if ( 4 == i )	stockCode	= col[i];
					if ( 6 == i )	soDt	= col[i];
					if ( 8 == i )	soQty	= Integer.parseInt(col[i].toString().replace(" ", "").replace(".000", ""));
					/*ps.setString(1, poNo);
					ps.setString(2, poDt);
					ps.setString(3, soNo);
					ps.setInt(4, soItemNo);
					ps.setString(5, stockCode);
					ps.setInt(6, soQty);
					ps.setString(7, soDt);
					ps.setString(8, poNo);
					ps.setString(9, poDt);
					ps.setString(10, soNo);
					ps.setInt(11, soItemNo);
					ps.setString(12, stockCode);
					ps.setInt(13, soQty);
					ps.setString(14, soDt);*/
					ps.setString(1, soNo);
					ps.setInt(2, soItemNo);
					ps.setString(3, soDt);
					ps.setInt(4, soQty);
					ps.setString(5, poNo);
					ps.setString(6, stockCode);
				}
				LOGGER.debug(query);
				ps.executeQuery();
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	public static void executeQuery1(BufferedReader br, String fileName) {
		Connection conn	= null;
		PreparedStatement ps	= null;
		
		try {
			String query	= "";
			Class.forName("oracle.jdbc.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.180:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017#");
			
			String poNo	= "";	String poDt		= "";	String stockCode	= "";	String row	= "";
			String soNo	= "";	int soItemNo	= 0;
			
			LOGGER.debug("2. fileName is : " + fileName);
			//	PP
			int ppPlanQty	= 0;			int ppProdQty	= 0;
			String ppProdStartDt	= "";	String ppProdEndDt	= "";
			query	= "MERGE INTO SCM0014D ";
			query	+= "USING DUAL ON (PO_NO = TRIM(?) AND SO_NO = TRIM(?) AND SO_ITEM_NO = TO_NUMBER(TRIM(?)) AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?)))) ";
			query	+= "WHEN MATCHED THEN ";
			query	+= "UPDATE ";
			query	+= "   SET PP_PLAN_QTY = TO_NUMBER(TRIM(?)) ";
			query	+= "     , PP_PROD_QTY = TO_NUMBER(TRIM(?)) ";
			query	+= "     , PP_PROD_START_DT = TRIM(?) ";
			query	+= "     , PP_PROD_END_DT = TRIM(?) ";
			query	+= "WHEN NOT MATCHED THEN ";
			query	+= "INSERT ";
			query	+= "( ";
			query	+= "       PO_NO ";
			query	+= "     , SO_NO ";
			query	+= "     , SO_ITEM_NO ";
			query	+= "     , STOCK_CODE ";
			query	+= "     , PP_PLAN_QTY ";
			query	+= "     , PP_PROD_QTY ";
			query	+= "     , PP_PROD_START_DT ";
			query	+= "     , PP_PROD_END_DT ";
			query	+= " ) ";
			query	+= "VALUES ";
			query	+= "( ";
			query	+= "       TRIM(?) ";
			query	+= "     , TRIM(?) ";
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TO_CHAR(TO_NUMBER(TRIM(?))) ";
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TRIM(?) ";
			query	+= "     , TRIM(?) ";
			query	+= " ) ";
			ps	= conn.prepareStatement(query);
			while ( null != (row = br.readLine()) ) {
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i )	poNo	= col[i];
					if ( 1 == i )	soNo	= col[i];
					if ( 2 == i )	soItemNo	= Integer.parseInt(col[i].toString());
					if ( 3 == i )	stockCode	= col[i];
					if ( 5 == i )	ppPlanQty	= Integer.parseInt(col[i].toString().replace(" ", "").replace(".000", ""));
					if ( 6 == i )	ppProdQty	= Integer.parseInt(col[i].toString().replace(" ", "").replace(".000", ""));
					if ( 8 == i )	ppProdStartDt	= col[i];
					if ( 9 == i )	ppProdEndDt		= col[i];
					
					ps.setString(1, poNo);
					ps.setString(2, soNo);
					ps.setInt(3, soItemNo);
					ps.setString(4, stockCode);
					ps.setInt(5, ppPlanQty);
					ps.setInt(6, ppProdQty);
					ps.setString(7, ppProdStartDt);
					ps.setString(8, ppProdEndDt);
					ps.setString(9, poNo);
					ps.setString(10, soNo);
					ps.setInt(11, soItemNo);
					ps.setString(12, stockCode);
					ps.setInt(13, ppPlanQty);
					ps.setInt(14, ppProdQty);
					ps.setString(15, ppProdStartDt);
					ps.setString(16, ppProdEndDt);
				}
				LOGGER.debug(query);
				ps.executeQuery();
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	public static void executeQuery2(BufferedReader br, String fileName) {
		Connection conn	= null;
		PreparedStatement ps	= null;
		
		try {
			String query	= "";
			Class.forName("oracle.jdbc.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.180:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017#");
			
			String poNo	= "";	String poDt		= "";	String stockCode	= "";	String row	= "";
			String soNo	= "";	int soItemNo	= 0;
			
			LOGGER.debug("3. fileName is : " + fileName);
			//	GI
			String giDt		= "";	int giQty		= 0;
			String delvNo	= "";	int delvItemNo	= 0;
			query	= "MERGE INTO SCM0013D ";
			query	+= "USING DUAL ON (PO_NO = TRIM(?) AND SO_NO = TRIM(?) AND SO_ITEM_NO = TO_NUMBER(TRIM(?)) AND DELV_NO = TRIM(?) AND DELV_ITEM_NO = TO_NUMBER(TRIM(?)) AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?)))) ";
			query	+= "WHEN MATCHED THEN ";
			query	+= "UPDATE ";
			query	+= "   SET GI_QTY = TO_NUMBER(TRIM(?)) ";
			query	+= "     , GI_DT = TRIM(?) ";
			query	+= "WHEN NOT MATCHED THEN ";
			query	+= "INSERT ";
			query	+= "( ";
			query	+= "       PO_NO ";
			query	+= "     , SO_NO ";
			query	+= "     , SO_ITEM_NO ";
			query	+= "     , DELV_NO ";
			query	+= "     , DELV_ITEM_NO ";
			query	+= "     , STOCK_CODE ";
			query	+= "     , GI_QTY ";
			query	+= "     , GI_DT ";
			query	+= " ) ";
			query	+= "VALUES ";
			query	+= "( ";
			query	+= "       TRIM(?) ";
			query	+= "     , TRIM(?) ";
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TRIM(?) "; 
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TO_CHAR(TO_NUMBER(TRIM(?))) ";
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TRIM(?) ";
			query	+= " ) ";
			ps	= conn.prepareStatement(query);
			while ( null != (row = br.readLine()) ) {
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i )	poNo	= col[i];
					if ( 1 == i )	soNo	= col[i];
					if ( 2 == i )	soItemNo	= Integer.parseInt(col[i].toString());
					if ( 3 == i )	delvNo	= col[i];
					if ( 4 == i )	delvItemNo	= Integer.parseInt(col[i].toString());
					if ( 5 == i )	stockCode	= col[i];
					if ( 7 == i )	giQty	= Integer.parseInt(col[i].toString().replace(" ", "").replace(".000", ""));
					if ( 10 == i )	giDt	= col[i];
					
					ps.setString(1, poNo);
					ps.setString(2, soNo);
					ps.setInt(3, soItemNo);
					ps.setString(4, delvNo);
					ps.setInt(5, delvItemNo);
					ps.setString(6, stockCode);
					ps.setInt(7, giQty);
					ps.setString(8, giDt);
					ps.setString(9, poNo);
					ps.setString(10, soNo);
					ps.setInt(11, soItemNo);
					ps.setString(12, delvNo);
					ps.setInt(13, delvItemNo);
					ps.setString(14, stockCode);
					ps.setInt(15, giQty);
					ps.setString(16, giDt);
				}
				LOGGER.debug(query);
				ps.executeQuery();
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	public void download(String dir, String fileName, String path) {
		FileOutputStream out	= null;
		InputStream	in	= null;
		dir	+= fileName;
		
		try {
			in	= client.retrieveFileStream(dir);
			LOGGER.debug("in success ======================");
			
			out	= new FileOutputStream(new File(dir));
			LOGGER.debug("out success =====================");
			
			int i;
			
			while ( (i = in.read()) != -1 ) {
				LOGGER.debug("file conts : " + in);
				out.write(i);
			}
		} catch ( IOException e ) {
			e.printStackTrace();
		} finally {
			try {
				in.close();
				out.close();
			} catch ( IOException e ) {
				e.printStackTrace();
			}
		}
	}
}