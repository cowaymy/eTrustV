package com.coway.trust.web.scm;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.SalesPlanMngementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.FtpConnection;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class ScmBatchController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScmBatchController.class);
	private static FileInputStream inputStream;

	@Value("${scm.file.download.path}")
    private static String ftpPath;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/connection.do", method = RequestMethod.GET)
	public ResponseEntity<String> connection(@RequestParam Map<String, Object> params) {

		LOGGER.debug("selectSupplyCDC_ComboList : {}", params.toString());

		execute();

		return ResponseEntity.ok("OK");
	}

	public static void execute() {

		String filePath	= "";
		FTPClient client	= null;

		//	try ftp server & login & get files
		try {
			client	= new FTPClient();

			client.setControlEncoding("euc-kr");
			LOGGER.debug("Commons NET FTP Client Test Program");
			LOGGER.debug("Start GO");

			//	connection ftp server
			client.connect("10.101.3.40");

			//	in case abnormal reply code, close
			int reply	= client.getReplyCode();
			if ( ! FTPReply.isPositiveCompletion(reply) ) {
				client.disconnect();
				LOGGER.debug("FTP server refused connection");
			} else {
				LOGGER.debug(client.getReplyString());

				//	set time out
				client.setSoTimeout(100000);

				//	login
				client.login("etrustftp", "akffus#20!*");
				LOGGER.debug("etrustftp login success...");

				//	file 우리쪽 서버로 카피
				FTPFile[] ftpFiles	= client.listFiles("/");
				if ( null != ftpFiles ) {
					for ( int i = 0 ; i < ftpFiles.length ; i++ ) {
						FTPFile file	= ftpFiles[i];
						filePath	= ftpPath + file.getName();
						File getFile = new File(filePath);
						FileOutputStream outputstream	= new FileOutputStream(getFile);
						boolean result = client.retrieveFile("/" + file.getName(), outputstream);
						outputstream.close();
					}
				}
			}

			if ( executeQuery() ) {
				LOGGER.debug("insert success");
			} else {
				LOGGER.debug("insert failed");
			}
		} catch (Exception e) {
			LOGGER.debug("login failed...");
			e.printStackTrace();
			System.exit(-1);
		} finally {
			if(client != null && client.isConnected()){
				try {
					client.disconnect();
				}catch(IOException ioe) {
					ioe.printStackTrace();
				}
			}
		}
	}

	public static boolean executeQuery() {
		boolean ret	= true;

		Connection conn	= null;
		//ResultSet rs	= null;
		BufferedReader	br	= null;
		PreparedStatement stmt = null;
		PreparedStatement stmt1 = null;
		DateFormat	df1	= new SimpleDateFormat("yyyyMdd");
		DateFormat	df2	= new SimpleDateFormat("HHmmss");
		Date today	= new Date();
		String ifDate	= df1.format(today);
		String ifTime	= df2.format(today);
		String fileName	= "";
		//String filePath	= "c:\\temp\\";
		String row	= "";


		//	GI
		try {
			fileName	= "COWAY_GI_DATA_" + ifDate + ".TXT";
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.12:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017");
			br	= new BufferedReader(new FileReader(ftpPath + fileName));
			//String query	= "INSERT INTO ITF0300M VALUES(TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TO_CHAR(TO_NUMBER(TRIM(?))), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?))";
			String query1	= "UPDATE SCM0039M ";
			query1	= query1 + "   SET GI_QTY = TO_NUMBER(TRIM(?)) ";
			query1	= query1 + "     , GI_DT = TRIM(?) ";
			query1	= query1 + " WHERE PO_NO = TRIM(?) ";
			query1	= query1 + "   AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?)))";
			//stmt	= conn.prepareStatement(query);
			stmt1	= conn.prepareStatement(query1);

			String giQty	= "";
			String giDt	= "";
			String poNo	= "";
			String stockCode	= "";
			while ( null != (row = br.readLine()) ) {
				LOGGER.debug("ifDate : " + ifDate + ", ifTime : " + ifTime);
				LOGGER.debug("row : " + row);
				String col[]	= row.split("\\|");
				//stmt.setString(1, ifDate.toString());
				//stmt.setString(2, ifTime.toString());
				for ( int i = 0 ; i < col.length ; i++ ) {
					//LOGGER.debug("col : " + col[i]);
					if ( 0 == i )	poNo		= col[i];
					if ( 5 == i )	stockCode	= col[i];
					if ( 7 == i )	giQty		= col[i];
					if ( 10 == i )	giDt		= col[i];
					//stmt.setString(i + 3, col[i]);
					stmt1.setString(1, giQty);
					stmt1.setString(2, giDt);
					stmt1.setString(3, poNo);
					stmt1.setString(4, stockCode);
				}
				//stmt.executeUpdate();
				stmt1.executeUpdate();
			}
		} catch ( Exception e ) {
			ret	= false;
			e.printStackTrace();
		}

		//	SO
		try {
			fileName	= "COWAY_SO_DATA_" + ifDate + ".TXT";
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.12:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017");
			br	= new BufferedReader(new FileReader(ftpPath + fileName));
			//String query	= "INSERT INTO ITF0300M VALUES(TRIM(?), TRIM(?), TRIM(?), TRIM(?), TO_CHAR(TO_NUMBER(TRIM(?))), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?))";
			//String query1	= "UPDATE SCM0039M SET GI_QTY = TO_NUMBER(TRIM(?)), GI_DT = TRIM(?) WHERE PO_NO = TRIM(?) AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?)))";
			String query1	= "UPDATE SCM0039M ";
			query1	= query1 + "   SET SO_NO = TRIM(?) ";
			query1	= query1 + "     , SO_ITEM_NO = TRIM(?) ";
			query1	= query1 + "     , SO_QTY = TO_NUMBER(TRIM(?)) ";
			query1	= query1 + "     , SO_DT = TRIM(?) ";
			query1	= query1 + " WHERE PO_NO = TRIM(?) ";
			query1	= query1 + "   AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?)))";
			//stmt	= conn.prepareStatement(query);
			stmt1	= conn.prepareStatement(query1);

			String soQty	= "";
			String soDt	= "";
			String poNo	= "";
			String soNo	= "";
			String soItemNo	= "";
			String stockCode	= "";
			while ( null != (row = br.readLine()) ) {
				LOGGER.debug("ifDate : " + ifDate + ", ifTime : " + ifTime);
				LOGGER.debug("row : " + row);
				String col[]	= row.split("\\|");
				//stmt.setString(1, ifDate.toString());
				//stmt.setString(2, ifTime.toString());
				for ( int i = 0 ; i < col.length ; i++ ) {
					//	for ITF0310M
					//stmt.setString(i + 3, col[i]);

					//	for SCM0039M
					if ( 0 == i )	poNo		= col[i];
					if ( 2 == i )	soNo		= col[i];
					if ( 3 == i )	soItemNo	= col[i];
					if ( 4 == i )	stockCode	= col[i];
					if ( 9 == i )	soDt		= col[i];
					if ( 11 == i )	soQty		= col[i];

					stmt1.setString(1, soNo);
					stmt1.setString(2, soItemNo);
					stmt1.setString(3, soQty);
					stmt1.setString(4, soDt);
					stmt1.setString(5, poNo);
					stmt1.setString(6, stockCode);
				}
				stmt1.executeUpdate();
			}
		} catch ( Exception e ) {
			ret	= false;
			e.printStackTrace();
		}

		//	PP
		try {
			fileName	= "COWAY_PP_DATA_" + ifDate + ".TXT";
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.12:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017");
			br	= new BufferedReader(new FileReader(ftpPath + fileName));
			//String query	= "INSERT INTO ITF0300M VALUES(TRIM(?), TRIM(?), TRIM(?), TRIM(?), TO_CHAR(TO_NUMBER(TRIM(?))), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?), TRIM(?))";
			//String query1	= "UPDATE SCM0039M SET GI_QTY = TO_NUMBER(TRIM(?)), GI_DT = TRIM(?) WHERE PO_NO = TRIM(?) AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?)))";
			String query1	= "UPDATE SCM0039M ";
			query1	= query1 + "   SET PP_PLAN_QTY = TO_NUMBER(TRIM(?)) ";
			query1	= query1 + "     , PP_PROD_QTY = TO_NUMBER(TRIM(?)) ";
			query1	= query1 + "     , PP_PROD_START_DT = TRIM(?) ";
			query1	= query1 + "     , PP_PROD_END_DT = TRIM(?) ";
			query1	= query1 + " WHERE PO_NO = TRIM(?) ";
			query1	= query1 + "   AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?)))";
			//stmt	= conn.prepareStatement(query);
			stmt1	= conn.prepareStatement(query1);

			String planQty	= "";
			String prodQty	= "";
			String startDt	= "";
			String endDt	= "";
			String poNo		= "";
			String stockCode	= "";
			while ( null != (row = br.readLine()) ) {
				LOGGER.debug("ifDate : " + ifDate + ", ifTime : " + ifTime);
				LOGGER.debug("row : " + row);
				String col[]	= row.split("\\|");
				//stmt.setString(1, ifDate.toString());
				//stmt.setString(2, ifTime.toString());
				for ( int i = 0 ; i < col.length ; i++ ) {
					//	for ITF0310M
					//stmt.setString(i + 3, col[i]);

					//	for SCM0039M
					if ( 0 == i )	poNo		= col[i];
					if ( 3 == i )	stockCode	= col[i];
					if ( 5 == i )	planQty		= col[i];
					if ( 6 == i )	prodQty		= col[i];
					if ( 8 == i )	startDt		= col[i];
					if ( 9 == i )	endDt		= col[i];

					stmt1.setString(1, planQty);
					stmt1.setString(2, prodQty);
					stmt1.setString(3, startDt);
					stmt1.setString(4, endDt);
					stmt1.setString(5, poNo);
					stmt1.setString(6, stockCode);
				}
				//stmt.executeUpdate();
				stmt1.executeUpdate();
			}
		} catch ( Exception e ) {
			ret	= false;
			e.printStackTrace();
		}

		return	ret;
	}
}