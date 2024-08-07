package com.coway.trust.web.scm;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.Writer;
import java.net.SocketException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPClientConfig;
import org.apache.commons.net.ftp.FTPFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.ibm.icu.util.Calendar;

import oracle.jdbc.OracleResultSet;
import oracle.sql.CLOB;


@Controller
@RequestMapping(value = "/scm")
public class ScmBatchController2 {
	private FTPClient	client	= null;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ScmBatchController.class);
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	/*
	@RequestMapping(value = "/supplyPlanRtp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> supplyPlanRtp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		int resultCnt	= 0;
		ReturnMessage message = new ReturnMessage();
		
		BufferedReader reader	= null;
		SimpleDateFormat sdf	= new SimpleDateFormat("yyyyMMdd");
		Calendar cal	= Calendar.getInstance();
		String today	= sdf.format(cal.getTime());
		
		String fileName	= "COWAY_SU_DATA_" + today + ".TXT";
		fileName	= "COWAY_SU_DATA_20190116.TXT";
		
		client	= new FTPClient();
		client.setControlEncoding("euc-kr");
		
		FTPClientConfig	config	= new FTPClientConfig();
		client.configure(config);
		
		try {
			client.connect("10.101.3.40", 21);
			LOGGER.debug("ftp connected==================");
			
			client.login("etrustftp3", "akffus#20!*");
			LOGGER.debug("ftp login======================");
			
			//read(client);
			try {
				InputStream is	= client.retrieveFileStream("/" + fileName);
				if ( null != is ) {
					reader	= new BufferedReader(new InputStreamReader(is, "utf-8"));
				} else {
					//	접속종료
					message.setCode(AppConstants.FAIL);
					message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
					disconnect();
				}
			} catch ( Exception se ) {
				se.printStackTrace();
			}
		} catch ( Exception se ) {
			se.printStackTrace();
		}
		if ( true ) {
			message.setCode(AppConstants.SUCCESS);
			message.setData(resultCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}

		return ResponseEntity.ok(message);
	}
	*/
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
		
		try {
			connect("10.101.3.40", "etrustftp3", "akffus#20!*", 21);
			disconnect();
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		try {
			connect1("10.101.3.40", "etrustftp3", "akffus#20!*", 21);
			disconnect();
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		try {
			connect2("10.101.3.40", "etrustftp3", "akffus#20!*", 21);
			disconnect();
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
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
	
	public void connect1(String host, String name, String pass, int port) {
		client	= new FTPClient();
		client.setControlEncoding("euc-kr");
		
		FTPClientConfig	config	= new FTPClientConfig();
		client.configure(config);
		
		try {
			client.connect(host, port);
			LOGGER.debug("ftp connected==================");
			
			client.login(name, pass);
			LOGGER.debug("ftp login======================");
			
			read1(client);
		} catch ( Exception se ) {
			se.printStackTrace();
		}
	}
	
	public void connect2(String host, String name, String pass, int port) {
		client	= new FTPClient();
		client.setControlEncoding("euc-kr");
		
		FTPClientConfig	config	= new FTPClientConfig();
		client.configure(config);
		
		try {
			client.connect(host, port);
			LOGGER.debug("ftp connected==================");
			
			client.login(name, pass);
			LOGGER.debug("ftp login======================");
			
			read2(client);
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
	
	@SuppressWarnings("deprecation")
	public static void read(FTPClient client) {
		BufferedReader reader	= null;
		SimpleDateFormat sdf	= new SimpleDateFormat("yyyyMMdd");
		Calendar cal	= Calendar.getInstance();
		String today	= sdf.format(cal.getTime());
		String fileName	= "";
		String fileExistYn	= "N";
		long fileSize	= 0;
		
		CLOB conts		= null;
		Writer wr		= null;
		Reader rd		= null;
		String cmd		= "SELECT * FROM SCM0055S FOR UPDATE";
		
		try {
			client.changeWorkingDirectory("/");
			String[] names	= client.listNames();
			//LOGGER.debug("cnt : " + names.length);
			//LOGGER.debug("names : {}", names);
			FTPFile[] files = client.listFiles();
			LOGGER.debug("cnt : " + files.length);
			String soFileName	= "COWAY_SO_DATA_" + today + ".TXT";
			//soFileName	= "COWAY_SO_DATA_" + "TEST" + ".TXT";
			
			for ( int i = 0 ; i < files.length ; i++ ) {
				LOGGER.debug(i + "th filename : " + files[i].getName() + ", filesize : " + files[i].getSize());
				//if ( 0 < files[i].getSize() ) {
					if ( soFileName.equals(files[i].getName()) ) {
						//	SO DB에 쓰기
						InputStream is	= client.retrieveFileStream("/" + files[i].getName());
						if ( null != is ) {
							//	parameter setting
							//ifDate		= today;
							fileName	= files[i].getName();
							fileExistYn	= "Y";
							fileSize	= files[i].getSize();
							reader	= new BufferedReader(new InputStreamReader(is, "utf-8"));
							
							//conts	= ((OracleResultSet))
							
							LOGGER.debug("writing to DB : " + reader.readLine());
							executeQuery(reader, fileName);
							//LOGGER.debug("writing to DB(log) ");
							//executeQueryLog(reader, fileName, today, fileExistYn, fileSize);
						} else {
							LOGGER.debug("did not write");
						}
						/*
						//	IF LOG DB에 쓰기
						File file	= new File(files[i].getName());
						FileReader in	= new FileReader(file);
						try {
							Writer out	= conts.getCharacterOutputStream();
							
							int chunk	= conts.getChunkSize();
							System.out.print("The chunk size is : " + chunk);
							char[] buffer	= new char[chunk];
							int length;
							
							while ( (length = in.read(buffer, 0, chunk)) != -1 )
							out.write(buffer, 0, length);
							
							in.close();
							out.close();
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						
						*/
					}
				//}
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
	
	public static void read1(FTPClient client) {
		BufferedReader reader	= null;
		SimpleDateFormat sdf	= new SimpleDateFormat("yyyyMMdd");
		Calendar cal	= Calendar.getInstance();
		String today	= sdf.format(cal.getTime());
		String fileName	= "";
		String fileExistYn	= "N";
		long fileSize	= 0;
		BufferedInputStream bis	= null;
		
		try {
			client.changeWorkingDirectory("/");
			String[] names	= client.listNames();
			//LOGGER.debug("cnt : " + names.length);
			//LOGGER.debug("names : {}", names);
			FTPFile[] files = client.listFiles();
			LOGGER.debug("cnt : " + files.length);
			//String soFileName	= "COWAY_SO_DATA_" + today + ".TXT";
			String ppFileName	= "COWAY_PP_DATA_" + today + ".TXT";
			//String giFileName	= "COWAY_GI_DATA_" + today + ".TXT";
			//soFileName	= "COWAY_SO_DATA_" + "20181205" + ".TXT";
			//ppFileName	= "COWAY_PP_DATA_" + "20181214" + ".TXT";
			//giFileName	= "COWAY_GI_DATA_" + "20181205" + ".TXT";
			
			for ( int i = 0 ; i < files.length ; i++ ) {
				//LOGGER.debug(i + "th filename : " + files[i].getName() + ", filesize : " + files[i].getSize());
				//if ( 0 < files[i].getSize() ) {
				if ( ppFileName.equals(files[i].getName()) ) {
					InputStream is	= client.retrieveFileStream("/" + files[i].getName());
					if ( null != is ) {
						//	parameter setting
						//ifDate		= today;
						fileName	= files[i].getName();
						fileExistYn	= "Y";
						fileSize	= files[i].getSize();
						reader	= new BufferedReader(new InputStreamReader(is, "utf-8"));
						
						//conts	= ((OracleResultSet))
						
						LOGGER.debug("writing to DB : " + reader.readLine());
						executeQuery1(reader, fileName, today);
						//LOGGER.debug("writing to DB(log) ");
						//executeQueryLog(reader, fileName, today, fileExistYn, fileSize);
					} else {
						LOGGER.debug("did not write");
					}
				}
			//}
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
	
	public static void read2(FTPClient client) {
		BufferedReader reader	= null;
		SimpleDateFormat sdf	= new SimpleDateFormat("yyyyMMdd");
		Calendar cal	= Calendar.getInstance();
		String today	= sdf.format(cal.getTime());
		String fileName	= "";
		String fileExistYn	= "N";
		long fileSize	= 0;
		
		try {
			client.changeWorkingDirectory("/");
			String[] names	= client.listNames();
			//LOGGER.debug("cnt : " + names.length);
			//LOGGER.debug("names : {}", names);
			FTPFile[] files = client.listFiles();
			LOGGER.debug("cnt : " + files.length);
			//String soFileName	= "COWAY_SO_DATA_" + today + ".TXT";
			//String ppFileName	= "COWAY_PP_DATA_" + today + ".TXT";
			String giFileName	= "COWAY_GI_DATA_" + today + ".TXT";
			//soFileName	= "COWAY_SO_DATA_" + "20181205" + ".TXT";
			//ppFileName	= "COWAY_PP_DATA_" + "20181214" + ".TXT";
			//giFileName	= "COWAY_GI_DATA_" + "TEST" + ".TXT";
			//BufferedReader brLog	= new BufferedReader(brLog);
			for ( int i = 0 ; i < files.length ; i++ ) {
				//LOGGER.debug(i + "th filename : " + files[i].getName() + ", filesize : " + files[i].getSize());
				//if ( 0 < files[i].getSize() ) {
				if ( giFileName.equals(files[i].getName()) ) {
					InputStream is	= client.retrieveFileStream("/" + files[i].getName());
					if ( null != is ) {
						//	parameter setting
						//ifDate		= today;
						fileName	= files[i].getName();
						fileExistYn	= "Y";
						fileSize	= files[i].getSize();
						reader	= new BufferedReader(new InputStreamReader(is, "utf-8"));
						
						//conts	= ((OracleResultSet))
						
						LOGGER.debug("writing to DB : " + reader.readLine());
						executeQuery2(reader, fileName);
						//LOGGER.debug("writing to DB(log) ");
						//executeQueryLog(reader, fileName, today, fileExistYn, fileSize);
					} else {
						LOGGER.debug("did not write");
					}
				}
			//}
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
	
	public static void executeQueryLog(BufferedReader br, String fileName, String today, String fileExistYn, long fileSize) {
		try {
			LOGGER.debug("================================ : " + br.toString());
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
/*	public static void executeQueryLog(BufferedReader br, String fileName, String today, String fileExistYn, long fileSize) {
		Connection conn	= null;
		PreparedStatement ps	= null;
		Statement st	= null;
		ResultSet rs	= null;
		
		try {
			String query	= "";	String query1	= "";
			Class.forName("oracle.jdbc.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.180:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017#");
			
			String remark	= "";
			if ( null == br ) {
				remark	= "this file is empty";
			}
			
			query1	= "";
			query1	+= "";
			LOGGER.debug("1. fileName is : " + fileName);
			query	= "MERGE INTO SCM0055S ";
			query	+= "USING DUAL ON (IF_DATE = ? AND FILE_NAME = ?) ";
			query	+= "WHEN MATCHED THEN ";
			query	+= "UPDATE ";
			query	+= "   SET UPD_DT = SYSDATE ";
			query	+= "     , UPD_USER_ID = 'SCM_BATCH' ";
			query	+= "     , FILE_EXIST_YN = ? ";
			query	+= "     , FILE_SIZE = ? ";
			query	+= "     , CONTS = EMPTY_CLOB() ";
			query	+= "     , REMARK = ? ";
			query	+= "WHEN NOT MATCHED THEN ";
			query	+= "INSERT ";
			query	+= "( ";
			query	+= "       IF_DATE ";
			query	+= "     , FILE_NAME ";
			query	+= "     , FILE_EXIST_YN ";
			query	+= "     , FILE_SIZE ";
			query	+= "     , CONTS ";
			query	+= "     , REMARK ";
			query	+= "     , CRT_USER_ID ";
			query	+= " ) ";
			query	+= "VALUES ";
			query	+= "( ";
			query	+= "       ? ";
			query	+= "     , ? ";
			query	+= "     , ? ";
			query	+= "     , ? ";
			query	+= "     , EMPTY_CLOB() ";
			query	+= "     , ? ";
			query	+= "     , 'SCM_BATCH' ";
			query	+= " ) ";
			ps	= conn.prepareStatement(query);
			ps.setString(1, today);
			ps.setString(2, fileName);
			ps.setString(3, fileExistYn);
			ps.setLong(4, fileSize);
			//ps.setString(5, br.toString());
			ps.setString(5, remark);
			ps.setString(6, today);
			ps.setString(7, fileName);
			ps.setString(8, fileExistYn);
			ps.setLong(9, fileSize);
			//ps.setString(11, br.toString());
			ps.setString(10, remark);
			
			ps.executeQuery();
			LOGGER.debug("TODAY : " + today + ", FILE NAME : " + fileName + ", FILE SIZE : " + fileSize);
			//LOGGER.debug(ps.toString());
			
			query	= "SELECT CONTS FROM SCM0055S WHERE IF_DATE = ? AND FILE_NAME = ? ";
			st	= conn.createStatement();
			rs	= st.executeQuery(query);
			
			if ( rs.next() ) {
				CLOB clob	= null;
				Writer wr	= null;
				Reader rd	= null;
				char[] buffer	= null;
				int read	= 0;
				//clob	= ((OracleResultSet)rs).g
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}*/
	
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
					if ( 8 == i )	soQty	= Integer.parseInt(col[i].toString().replace(" ", "").replace(".000", ""));
					if ( 9 == i )	soDt	= col[i];
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
				//LOGGER.debug(ps.toString());
				LOGGER.debug("PO NO : " + poNo + ", PO DT : " + poDt + ", SO NO : " + soNo + ", SO ITEM NO : " + soItemNo + ", STOCK CODE : " + stockCode);
				ps.executeQuery();
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	public static void executeQuery1(BufferedReader br, String fileName, String ifDate) {
		Connection conn	= null;
		PreparedStatement ps	= null;
		//PreparedStatement ps1	= null;
		CallableStatement cs	= null;
		String result	= "";
		
		try {
			String query	= "";
			//String query1	= "";
			Class.forName("oracle.jdbc.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.180:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017#");
			
			String poNo	= "";	String poDt		= "";	String stockCode	= "";	String row	= "";
			String soNo	= "";	int soItemNo	= 0;
			
			LOGGER.debug("2. fileName is : " + fileName);
			//	PP
			int ppPlanQty	= 0;			int ppProdQty	= 0;
			String ppProdStartDt	= "";	String ppProdEndDt	= "";
			/*query	= "MERGE INTO SCM0014D ";
			query	+= "USING DUAL ON (IF_DATE = ? AND PP_PROD_END_DT = TRIM(?) AND PO_NO = TRIM(?) AND SO_NO = TRIM(?) AND SO_ITEM_NO = TO_NUMBER(TRIM(?)) AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?)))) ";
			query	+= "WHEN MATCHED THEN ";
			query	+= "UPDATE ";
			query	+= "   SET PP_PLAN_QTY = TO_NUMBER(TRIM(?)) ";
			query	+= "     , PP_PROD_QTY = TO_NUMBER(TRIM(?)) ";
			query	+= "     , PP_PROD_START_DT = CASE WHEN TRIM(?) = '00000000' THEN PP_PROD_START_DT ELSE CASE WHEN PP_PROD_START_DT > TRIM(?) THEN TRIM(?) ELSE PP_PROD_START_DT END END ";
			//query	+= "     , PP_PROD_END_DT = CASE WHEN TRIM(?) = '00000000' THEN PP_PROD_END_DT ELSE CASE WHEN PP_PROD_END_DT < TRIM(?) THEN TRIM(?) ELSE PP_PROD_END_DT END END ";
			query	+= "WHEN NOT MATCHED THEN ";
			query	+= "INSERT ";
			query	+= "( ";
			query	+= "       IF_DATE ";
			query	+= "     , PO_NO ";
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
			query	+= "       ? ";
			query	+= "     , TRIM(?) ";
			query	+= "     , TRIM(?) ";
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TO_CHAR(TO_NUMBER(TRIM(?))) ";
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TO_NUMBER(TRIM(?)) ";
			query	+= "     , TRIM(?) ";
			query	+= "     , TRIM(?) ";
			query	+= " ) ";
			
			query1	= "DELETE FROM SCM0014D ";
			query1	+= " WHERE IF_DATE < ? ";
			query1	+= "   AND PO_NO = ? ";
			query1	+= "   AND SO_NO = ? ";
			query1	+= "   AND SO_ITEM_NO = ? ";
			query1	+= "   AND STOCK_CODE = ? ";*/
			
			cs	= conn.prepareCall("{call SP_SCM_0014D_INSERT(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
			//ps1	= conn.prepareStatement(query1);
			//ps	= conn.prepareStatement(query);
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
					
					cs.setString(1, poNo);
					cs.setString(2, soNo);
					cs.setInt(3, soItemNo);
					cs.setString(4, stockCode);
					cs.setInt(5, ppPlanQty);
					cs.setInt(6, ppProdQty);
					cs.setString(7, ppProdStartDt);
					cs.setString(8, ppProdEndDt);
					cs.registerOutParameter(9, java.sql.Types.VARCHAR);
					
					/*ps.setString(1, ppProdEndDt);
					ps.setString(2, ppProdEndDt);
					ps.setString(3, poNo);
					ps.setString(4, soNo);
					ps.setInt(5, soItemNo);
					ps.setString(6, stockCode);
					ps.setInt(7, ppPlanQty);
					ps.setInt(8, ppProdQty);
					ps.setString(9, ppProdStartDt);
					ps.setString(10, ppProdStartDt);
					ps.setString(11, ppProdStartDt);
					//ps.setString(12, ppProdEndDt);
					//ps.setString(13, ppProdEndDt);
					//ps.setString(14, ppProdEndDt);
					ps.setString(12, ifDate);
					ps.setString(13, poNo);
					ps.setString(14, soNo);
					ps.setInt(15, soItemNo);
					ps.setString(16, stockCode);
					ps.setInt(17, ppPlanQty);
					ps.setInt(18, ppProdQty);
					ps.setString(19, ppProdStartDt);
					ps.setString(20, ppProdEndDt);
					
					ps1.setString(1, ifDate);
					ps1.setString(2, poNo);
					ps1.setString(3, soNo);
					ps1.setInt(4, soItemNo);
					ps1.setString(5, stockCode);*/
				}
				//LOGGER.debug(ps.toString());
				cs.execute();
				result	= cs.getString(9);
				//ps1.executeQuery();
				//ps.executeQuery();
				//LOGGER.debug("IF_DATE : " + ifDate + " : " + query1);
				//LOGGER.debug("IF_DATE : " + ifDate + " : " + query);
				LOGGER.debug("Result : " + result + ", PO NO : " + poNo + ", SO NO : " + soNo + ", SO ITEM NO : " + soItemNo + ", STOCK CODE : " + stockCode + ", PP_PLAN_QTY : " + ppPlanQty + ", PP_PROD_QTY : " + ppProdQty);
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		try {
			String query	= "";
			Class.forName("oracle.jdbc.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.180:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017#");
			
			query	= "DELETE FROM SCM0014D ";
			query	+= " WHERE PO_NO||SO_NO||SO_ITEM_NO||STOCK_CODE||PP_PROD_END_DT IN (";
			query	+= " SELECT PO_NO||SO_NO||SO_ITEM_NO||STOCK_CODE||PP_PROD_END_DT ";
			query	+= "   FROM SCM0014D ";
			query	+= "  GROUP BY PO_NO||SO_NO||SO_ITEM_NO||STOCK_CODE||PP_PROD_END_DT ";
			query	+= "  HAVING COUNT(*) > 1) ";
			query	+= "   AND IF_DATE < ? ";
			
			ps	= conn.prepareStatement(query);
			
			ps.setString(1, ifDate);
			
			ps.executeQuery();
			LOGGER.debug("DELETED");
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
				//LOGGER.debug(ps.toString());
				LOGGER.debug("PO NO : " + poNo + ", SO NO : " + soNo + ", SO ITEM NO : " + soItemNo + ", DELV NO : " + delvNo + ", DELV ITEM NO : " + delvItemNo + ", STOCK CODE : " + stockCode + ", GI_QTY : " + giQty + ", GI_DT : " + giDt);
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