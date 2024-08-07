package com.coway.trust.web.scm;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPClientConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.ScmConstants;
import com.coway.trust.biz.scm.ScmBatchService;
import com.coway.trust.biz.scm.ScmCommonService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class ScmBatchController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScmBatchController.class);
	
	@Autowired
	private ScmCommonService scmCommonService;
	@Autowired
	private ScmBatchService scmBatchService;
	
	private static FTPClient client;
	private static FTPClientConfig config;
	private static InputStream inputStream;
	private static FileInputStream fileInputStream;
	private static BufferedReader bufferedReader;
	
	//	for log
	private static String ifDate;
	private static String ifTime;
	private static String ifType;
	private static String ifCycle;
	private static String ifStatus;
	private static int ifSeq;
	private static int execCnt;
	private static String fileName;
	private static long fileSize;
	private static String errMsg;
	
	private static SimpleDateFormat sdf	= new SimpleDateFormat("yyyyMMddHHmmss");
	private static Calendar cal	= Calendar.getInstance();
	private static String today;
	private static int scmYearCbBox;
	private static int scmWeekCbBox;
	
	private static int planFstSpltWeek;
	private static int planWeekTh;
	private static int m0WeekCnt;
	private static int m1WeekCnt;
	private static int m2WeekCnt;
	private static int m3WeekCnt;
	private static int m4WeekCnt;
	
	private static int m0FstWeek;	private static int m0FstSpltWeek;
	private static int m1FstWeek;	private static int m1FstSpltWeek;
	private static int m2FstWeek;	private static int m2FstSpltWeek;
	private static int m3FstWeek;	private static int m3FstSpltWeek;
	private static int m4FstWeek;	private static int m4FstSpltWeek;

	@Value("${scm.file.download.path}")
    private static String ftpPath;

	@Value("${scm.file.serverurl}")
    private static String ftpUrl;
	
	@Value("${scm.file.serverport}")
    private static int ftpPort;

	@Value("${scm.file.username}")
    private static String ftpUsername;

	@Value("${scm.file.password}")
    private static String ftpPassword;

	@Value("${scm.file.encoding}")
    private static String ftpEncoding;

	@Value("${spring.datasource.driver-class-name}")
    private static String datasourceDriver;

	@Value("${spring.datasource.url}")
	private static String datasourceUrl;

	@Value("${spring.datasource.username}")
    private static String datasourceUsername;

	@Value("${spring.datasource.password}")
    private static String datasourcePassword;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	/*
	@RequestMapping(value = "/executeSupplyPlanRtp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> executeSupplyPlanRtp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		LOGGER.debug("executeSupplyPlanRtp : {}", params.toString());
		
		//	variables
		int totCnt	= 0;
		today	= sdf.format(cal.getTime());
		LOGGER.debug("========== today : " + today);
		fileName	= "COWAY_SU_DATA_" + today.substring(0, 8) + ".TXT";
		
		//	1. get today weekth
		List<EgovMap> selectTodayWeekTh	= scmBatchService.selectTodayWeekTh(params);
		scmYearCbBox	= Integer.parseInt(selectTodayWeekTh.get(0).get("scmYear").toString());
		scmWeekCbBox	= Integer.parseInt(selectTodayWeekTh.get(0).get("scmWeek").toString());
		LOGGER.debug("========== scmYearCbBox : " + scmYearCbBox + ", scmWeekCbBox : " + scmWeekCbBox);
		
		//	2. get Scm Total Info
		Map<String, Object> basParams	= new HashMap<String, Object>();
		basParams.put("scmYearCbBox", scmYearCbBox);
		basParams.put("scmWeekCbBox", scmWeekCbBox);
		List<EgovMap> selectScmTotalInfo	= scmCommonService.selectScmTotalInfo(basParams);
		
		planFstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planFstSpltWeek").toString());
		planWeekTh	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeekTh").toString());
		m0WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m0WeekCnt").toString());
		m1WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m1WeekCnt").toString());
		m2WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m2WeekCnt").toString());
		m3WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m3WeekCnt").toString());
		m4WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m4WeekCnt").toString());
		
		m0FstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m0FstWeek").toString());
		m1FstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m1FstWeek").toString());
		m2FstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m2FstWeek").toString());
		m3FstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m3FstWeek").toString());
		m4FstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m4FstWeek").toString());
		
		m0FstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m0FstSpltWeek").toString());
		m1FstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m1FstSpltWeek").toString());
		m2FstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m2FstSpltWeek").toString());
		m3FstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m3FstSpltWeek").toString());
		m4FstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m4FstSpltWeek").toString());
		
		//	3. set log variable
		Map<String, Object> logParams	= new HashMap<String, Object>();
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_SUPP_RTP);
		List<EgovMap> selectScmIfSeq	= scmBatchService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.FAIL);
		logParams.put("execCnt", 0);
		logParams.put("fileName", "");
		logParams.put("fileSize", 0);
		
		//	4. ftp batch
		try {
			this.connect(ScmConstants.IF_SUPP_RTP);
			if ( null != client ) {
				this.fileRead(ScmConstants.IF_SUPP_RTP);
				//this.writeSupplyPlanRtp();
				if ( null != bufferedReader ) {
					totCnt	= this.mergeSupplyPlanRtp();
					if ( totCnt < 1 ) {
						logParams.put("errMsg", ScmConstants.EXEC_ZERO);
						insertLog(logParams);
						LOGGER.debug("========== ScmConstants.EXEC_ZERO ==========");
					}
				} else {
					logParams.put("errMsg", ScmConstants.FILE_EMPTY);
					insertLog(logParams);
					LOGGER.debug("========== ScmConstants.FILE_EMPTY ==========");
				}
			} else {
				logParams.put("errMsg", ScmConstants.FTP_CONN_ERR);
				insertLog(logParams);
				LOGGER.debug("========== ScmConstants.FTP_CONN_ERR ==========");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		//	2. each month sum batch
		//totCnt	= scmBatchService.updateSupplyPlanRtp(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	/*
	 * Otd
	 
	@RequestMapping(value = "/executeOtd.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> executeOtd(@RequestBody Map<String, List<Map<String, Object>>> params,	SessionVO sessionVO) {
		LOGGER.debug("executeOtd : {}", params.toString());
		
		int totCnt	= 0;	int soCnt	= 0;	int ppCnt	= 0;	int giCnt	= 0;
		today	= sdf.format(cal.getTime());
		
		if ( 0 == params.size() ) {
			//	매일 수행하는 자동배치
			fileName	= "COWAY_SO_DATA_" + today.substring(0, 8) + ".TXT";
			soCnt	= this.updateOtdSo();
			fileName	= "COWAY_PP_DATA_" + today.substring(0, 8) + ".TXT";
			ppCnt	= this.mergeOtdPp();
			fileName	= "COWAY_GI_DATA_" + today.substring(0, 8) + ".TXT";
			giCnt	= this.mergeOtdGi();
			totCnt	= soCnt + ppCnt + giCnt;
		} else if ( 0 < params.size() ) {
			//	Scm Interface 수동배치
			if ( ScmConstants.IF_OTD_SO.equals(ifType) ) {
				fileName	= "COWAY_SO_DATA_" + today.substring(0, 8) + ".TXT";
				soCnt	= this.updateOtdSo();
			} else if ( ScmConstants.IF_OTD_PP.equals(ifType) ) {
				fileName	= "COWAY_PP_DATA_" + today.substring(0, 8) + ".TXT";
				ppCnt	= this.mergeOtdPp();
			} else if ( ScmConstants.IF_OTD_GI.equals(ifType) ) {
				fileName	= "COWAY_GI_DATA_" + today.substring(0, 8) + ".TXT";
				giCnt	= this.mergeOtdGi();
			}
			totCnt	= soCnt + ppCnt + giCnt;
		}
		LOGGER.debug("totCnt : " + totCnt + ", soCnt : " + soCnt + ", ppCnt : " + ppCnt + ", giCnt : " + giCnt);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	/*
	 * isert log
	 
	public void insertLog(Map<String, Object> params) {
		//	3. insert log
		//Map<String, Object> logParams	= new HashMap<String, Object>();
		try {
			scmBatchService.insertLog(params);
			//LOGGER.debug("========== log inserted ==========");
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	/*
	 * Supply Plan RTP merge
	 
	public int mergeSupplyPlanRtp() {
		String row	= "";
		String yyyymm	= "";
		String stockCode	= "";
		
		int totCnt		= 0;
		int planYear	= 0;	int planWeek	= 0;
		int w01	= 0;	int w02	= 0;	int w03	= 0;	int w04	= 0;	int w05	= 0;	int w06	= 0;	int w07	= 0;	int w08	= 0;	int w09	= 0;	int w10	= 0;
		int w11	= 0;	int w12	= 0;	int w13	= 0;	int w14	= 0;	int w15	= 0;	int w16	= 0;	int w17	= 0;	int w18	= 0;	int w19	= 0;	int w20	= 0;
		int w21	= 0;	int w22	= 0;	int w23	= 0;	int w24	= 0;	int w25	= 0;	int w26	= 0;	int w27	= 0;	int w28	= 0;	int w29	= 0;	int w30	= 0;
		int ws1	= 0;	int ws2	= 0;	int ws3	= 0;	int ws4	= 0;	int ws5	= 0;
		
		Map<String, Object> params	= new HashMap<String, Object>();
		
		Map<String, Object> logParams	= new HashMap<String, Object>();
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_SUPP_RTP);
		List<EgovMap> selectScmIfSeq	= scmBatchService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.SUCCESS);
		logParams.put("fileName", fileName);
		
		try {
			while ( null != (row = bufferedReader.readLine()) ) {
				fileSize	+= row.length();
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i ) {
						yyyymm	= col[i];
						planYear	= Integer.parseInt(yyyymm.substring(0, 4));
						planWeek	= Integer.parseInt(yyyymm.substring(4, 6));
					}
					if ( 1 == i ) {
						/*
						 * 본사 stock code는 6자리, 7자리코드가 들어온다.
						 * 전체 숫자가 아니라 문자도 소수 포함된 경우가 있어서 parseInt로 캐스팅하면 안됨
						 * 전체 18자리 문자열중 우측에서 7자리만 자른 다음
						 * 해당 7자리 문자열의 시작이 "0"이면 다시 제일 앞 1자리를 잘라서 6자리로 만들고
						 * "0"이 아니면 그대로 사용
						 
						stockCode	= col[i].substring(11, 18);
						LOGGER.debug("1. stockCode : " + stockCode);
						if ( stockCode.startsWith("0") ) {
							stockCode	= stockCode.substring(1, 7);
							LOGGER.debug("2. stockCode : " + stockCode);
						}
					}
					if ( 2 == i )	w01	= (int) Double.parseDouble(col[i].trim());
					if ( 3 == i )	w02	= (int) Double.parseDouble(col[i].trim());
					if ( 4 == i )	w03	= (int) Double.parseDouble(col[i].trim());
					if ( 5 == i )	w04	= (int) Double.parseDouble(col[i].trim());
					if ( 6 == i )	w05	= (int) Double.parseDouble(col[i].trim());
					if ( 7 == i )	w06	= (int) Double.parseDouble(col[i].trim());
					if ( 8 == i )	w07	= (int) Double.parseDouble(col[i].trim());
					if ( 9 == i )	w08	= (int) Double.parseDouble(col[i].trim());
					if ( 10 == i )	w09	= (int) Double.parseDouble(col[i].trim());
					if ( 11 == i )	w10	= (int) Double.parseDouble(col[i].trim());
					if ( 12 == i )	w11	= (int) Double.parseDouble(col[i].trim());
					if ( 13 == i )	w12	= (int) Double.parseDouble(col[i].trim());
				}
				
				//	set params
				params.put("planYear", planYear);
				params.put("planWeek", planWeek);
				params.put("stockCode", stockCode);
				params.put("w01", w01);	params.put("w02", w02);	params.put("w03", w03);	params.put("w04", w04);	params.put("w05", w05);
				params.put("w06", w06);	params.put("w07", w07);	params.put("w08", w08);	params.put("w09", w09);	params.put("w10", w10);
				params.put("w11", w11);	params.put("w12", w12);	params.put("w13", w13);	params.put("w14", w14);	params.put("w15", w15);
				params.put("w16", w16);	params.put("w17", w17);	params.put("w18", w18);	params.put("w19", w19);	params.put("w20", w20);
				params.put("w21", w21);	params.put("w22", w22);	params.put("w23", w23);	params.put("w24", w24);	params.put("w25", w25);
				params.put("w26", w26);	params.put("w27", w27);	params.put("w28", w28);	params.put("w29", w29);	params.put("w30", w30);
				params.put("ws1", ws1);	params.put("ws2", ws2);	params.put("ws3", ws3);	params.put("ws4", ws4);	params.put("ws5", ws5);
				LOGGER.debug(totCnt + ". params : {}", params.toString());
				scmBatchService.mergeSupplyPlanRtp(params);
				totCnt++;
			}
			logParams.put("execCnt", totCnt);
			logParams.put("fileSize", fileSize);
			logParams.put("errMsg", "");
			insertLog(logParams);
			LOGGER.debug("========== ScmConstants.SUCCESS ==========");
		} catch ( IOException e ) {
			e.printStackTrace();
		}
		//scmBatchService.updateSupplyPlanRtp(params);
		
		return	totCnt;
	}
	
	/*
	 * update so
	 
	public int updateOtdSo() {
		int totCnt		= 0;
		String row		= "";
		String poNo		= "";	String poDt		= "";	String stockCode	= "";
		String soNo		= "";	int soItemNo	= 0;	String soDt			= "";	int soQty	= 0;
		
		Map<String, Object> params		= new HashMap<String, Object>();	//	for update
		Map<String, Object> logParams	= new HashMap<String, Object>();	//	for log
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_OTD_SO);
		List<EgovMap> selectScmIfSeq	= scmBatchService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.SUCCESS);
		logParams.put("fileName", fileName);
		
		try {
			while ( null != (row = bufferedReader.readLine()) ) {
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i )	poNo	= col[i].trim();
					if ( 1 == i )	poDt	= col[i].trim();
					if ( 2 == i )	soNo	= col[i].trim();
					if ( 3 == i )	soItemNo	= Integer.parseInt(col[i].trim());
					if ( 4 == i ) {
						/*
						 * 본사 stock code는 6자리, 7자리코드가 들어온다.
						 * 전체 숫자가 아니라 문자도 소수 포함된 경우가 있어서 parseInt로 캐스팅하면 안됨
						 * 전체 18자리 문자열중 우측에서 7자리만 자른 다음
						 * 해당 7자리 문자열의 시작이 "0"이면 다시 제일 앞 1자리를 잘라서 6자리로 만들고
						 * "0"이 아니면 그대로 사용
						 
						stockCode	= col[i].substring(11, 18);
						LOGGER.debug("1. stockCode : " + stockCode);
						if ( stockCode.startsWith("0") ) {
							stockCode	= stockCode.substring(1, 7);
							LOGGER.debug("2. stockCode : " + stockCode);
						}
					}
					if ( 8 == i )	soQty	= (int) Double.parseDouble(col[i].trim());
					if ( 9 == i )	soDt	= col[i].trim();
					
					//	set params
					params.put("poNo", poNo);
					params.put("poDt", poDt);
					params.put("soNo", soNo);
					params.put("soItemNo", soItemNo);
					params.put("stockCode", stockCode);
					params.put("soQty", soQty);
					params.put("soDt", soDt);
					LOGGER.debug(totCnt + ". params : {}", params.toString());
					scmBatchService.updateOtdSo(params);
					totCnt++;
				}
				logParams.put("execCnt", totCnt);
				logParams.put("fileSize", fileSize);
				logParams.put("errMsg", "");
				insertLog(logParams);
				LOGGER.debug("========== ScmConstants.SUCCESS ==========");
			}
		} catch ( IOException e ) {
			e.printStackTrace();
		}
		
		return	totCnt;
	}
	
	/*
	 * merge pp
	 
	public int mergeOtdPp() {
		int totCnt		= 0;
		String row		= "";
		String poNo		= "";	String stockCode	= "";
		String soNo		= "";	int soItemNo		= 0;
		int ppPlanQty	= 0;	int ppProdQty		= 0;
		String ppProdStartDt	= "";	String ppProdEndDt	= "";
		
		Map<String, Object> params		= new HashMap<String, Object>();	//	for update
		Map<String, Object> logParams	= new HashMap<String, Object>();	//	for log
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_OTD_SO);
		List<EgovMap> selectScmIfSeq	= scmBatchService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.SUCCESS);
		logParams.put("fileName", fileName);
		
		try {
			//	1. delete before pp info
			scmBatchService.deleteOtdPp(params);
			
			//	2. merge new pp info
			while ( null != (row = bufferedReader.readLine()) ) {
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i )	poNo	= col[i].trim();
					if ( 1 == i )	soNo	= col[i].trim();
					if ( 2 == i )	soItemNo	= Integer.parseInt(col[i].trim());
					if ( 3 == i ) {
						/*
						 * 본사 stock code는 6자리, 7자리코드가 들어온다.
						 * 전체 숫자가 아니라 문자도 소수 포함된 경우가 있어서 parseInt로 캐스팅하면 안됨
						 * 전체 18자리 문자열중 우측에서 7자리만 자른 다음
						 * 해당 7자리 문자열의 시작이 "0"이면 다시 제일 앞 1자리를 잘라서 6자리로 만들고
						 * "0"이 아니면 그대로 사용
						 
						stockCode	= col[i].substring(11, 18);
						LOGGER.debug("1. stockCode : " + stockCode);
						if ( stockCode.startsWith("0") ) {
							stockCode	= stockCode.substring(1, 7);
							LOGGER.debug("2. stockCode : " + stockCode);
						}
					}
					if ( 5 == i )	ppPlanQty	= (int) Double.parseDouble(col[i].trim());
					if ( 6 == i )	ppProdQty	= (int) Double.parseDouble(col[i].trim());
					if ( 8 == i )	ppProdStartDt	= col[i].trim();
					if ( 9 == i )	ppProdEndDt		= col[i].trim();
					
					//	set params
					params.put("poNo", poNo);
					params.put("soNo", soNo);
					params.put("soItemNo", soItemNo);
					params.put("stockCode", stockCode);
					params.put("ppPlanQty", ppPlanQty);
					params.put("ppProdQty", ppProdQty);
					params.put("ppProdStartDt", ppProdStartDt);
					params.put("ppProdEndDt", ppProdEndDt);
					LOGGER.debug(totCnt + ". params : {}", params.toString());
					scmBatchService.mergeOtdPp(params);
					totCnt++;
				}
				logParams.put("execCnt", totCnt);
				logParams.put("fileSize", fileSize);
				logParams.put("errMsg", "");
				insertLog(logParams);
				LOGGER.debug("========== ScmConstants.SUCCESS ==========");
			}
		} catch ( IOException e ) {
			e.printStackTrace();
		}
		
		return	totCnt;
	}
	
	/*
	 * merge gi
	 
	public int mergeOtdGi() {
		int totCnt		= 0;
		String row		= "";
		String poNo		= "";	String stockCode	= "";
		String soNo		= "";	int soItemNo		= 0;	String delvNo	= "";	int delvItemNo	= 0;
		int giQty		= 0;	String giDt			= "";
		
		Map<String, Object> params		= new HashMap<String, Object>();	//	for update
		Map<String, Object> logParams	= new HashMap<String, Object>();	//	for log
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_OTD_SO);
		List<EgovMap> selectScmIfSeq	= scmBatchService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.SUCCESS);
		logParams.put("fileName", fileName);
		
		try {
			while ( null != (row = bufferedReader.readLine()) ) {
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i )	poNo	= col[i].trim();
					if ( 1 == i )	soNo	= col[i].trim();
					if ( 2 == i )	soItemNo	= Integer.parseInt(col[i].trim());
					if ( 3 == i )	delvNo	= col[i].trim();
					if ( 4 == i )	delvItemNo	= Integer.parseInt(col[i].trim());
					if ( 5 == i ) {
						/*
						 * 본사 stock code는 6자리, 7자리코드가 들어온다.
						 * 전체 숫자가 아니라 문자도 소수 포함된 경우가 있어서 parseInt로 캐스팅하면 안됨
						 * 전체 18자리 문자열중 우측에서 7자리만 자른 다음
						 * 해당 7자리 문자열의 시작이 "0"이면 다시 제일 앞 1자리를 잘라서 6자리로 만들고
						 * "0"이 아니면 그대로 사용
						 
						stockCode	= col[i].substring(11, 18);
						LOGGER.debug("1. stockCode : " + stockCode);
						if ( stockCode.startsWith("0") ) {
							stockCode	= stockCode.substring(1, 7);
							LOGGER.debug("2. stockCode : " + stockCode);
						}
					}
					if ( 7 == i )	giQty	= Integer.parseInt(col[i].trim());
					if ( 10 == i )	giDt	= col[i].trim();
					
					//	set params
					params.put("poNo", poNo);
					params.put("soNo", soNo);
					params.put("soItemNo", soItemNo);
					params.put("delvNo", delvNo);
					params.put("delvItemNo", delvItemNo);
					params.put("stockCode", stockCode);
					params.put("giQty", giQty);
					params.put("giDt", giDt);
					LOGGER.debug(totCnt + ". params : {}", params.toString());
					scmBatchService.mergeOtdGi(params);
					totCnt++;
				}
				logParams.put("execCnt", totCnt);
				logParams.put("fileSize", fileSize);
				logParams.put("errMsg", "");
				insertLog(logParams);
				LOGGER.debug("========== ScmConstants.SUCCESS ==========");
			}
		} catch ( IOException e ) {
			e.printStackTrace();
		}
		
		return	totCnt;
	}
	
	/*
	 * Connect/Disconnect to FTP Server
	 
	public void connect(String ifType) {
		client	= new FTPClient();
		client.setControlEncoding("euc-kr");
		
		config	= new FTPClientConfig();
		client.configure(config);
		
		Map<String, Object> logParams	= new HashMap<String, Object>();
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_SUPP_RTP);
		List<EgovMap> selectScmIfSeq	= scmBatchService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.FAIL);
		logParams.put("execCnt", 0);
		logParams.put("fileName", fileName);
		logParams.put("fileSize", 0);
		
		try {
			client.connect("10.101.3.40", 21);
			LOGGER.debug("========== FTP Server connected ==========");
			client.login("etrustftp3", "akffus#20!*");
			LOGGER.debug("========== FTP Server loged in ==========");
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	public static void disconnect() {
		try {
			client.logout();
			LOGGER.debug("========== FTP Server loged out ==========");
			if ( client.isConnected() ) {
				client.disconnect();
				LOGGER.debug("========== FTP Server disconnected ==========");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	/*
	 * File Read
	 
	public void fileRead(String ifType) {
		Map<String, Object> logParams	= new HashMap<String, Object>();
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_SUPP_RTP);
		List<EgovMap> selectScmIfSeq	= scmBatchService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.FAIL);
		logParams.put("execCnt", 0);
		logParams.put("fileName", fileName);
		logParams.put("fileSize", 0);
		
		try {
			inputStream	= client.retrieveFileStream("/" + fileName);
			
			if ( null != inputStream ) {
				bufferedReader	= new BufferedReader(new InputStreamReader(inputStream, "utf-8"));
			} else {
				logParams.put("errMsg", ScmConstants.FILE_EMPTY);
				insertLog(logParams);
				LOGGER.debug("========== ScmConstants.FILE_EMPTY ==========");
				disconnect();
			}
		} catch ( Exception e ) {
			logParams.put("errMsg", ScmConstants.FTP_FILE_READ_ERR);
			insertLog(logParams);
			e.printStackTrace();
		}
	}
	
	/*
	 * Supply Plan RTP write
	 */
	/*
	public void writeSupplyPlanRtp() {
		String sql	= "";
		String row	= "";
		Connection conn	= null;
		PreparedStatement ps	= null;
		
		//	file contents
		String stockCode	= "";	String yyyymm	= "";
		int planYear	= 0;	int planWeek	= 0;
		int w01	= 0;	int w02	= 0;	int w03	= 0;	int w04	= 0;	int w05	= 0;	int w06	= 0;	int w07	= 0;	int w08	= 0;	int w09	= 0;	int w10	= 0;
		int w11	= 0;	int w12	= 0;	int w13	= 0;	int w14	= 0;	int w15	= 0;	int w16	= 0;	int w17	= 0;	int w18	= 0;	int w19	= 0;	int w20	= 0;
		int w21	= 0;	int w22	= 0;	int w23	= 0;	int w24	= 0;	int w25	= 0;	int w26	= 0;	int w27	= 0;	int w28	= 0;	int w29	= 0;	int w30	= 0;
		int ws1	= 0;	int ws2	= 0;	int ws3	= 0;	int ws4	= 0;	int ws5	= 0;
		
		try {
			//Class.forName(datasourceDriver);
			//conn	= DriverManager.getConnection(datasourceUrl, datasourceUsername, datasourcePassword);
			Class.forName("oracle.jdbc.OracleDriver");
			conn	= DriverManager.getConnection("jdbc:oracle:thin:@10.201.32.180:1521:gbslcvd", "GBSLCVAPL1", "GBSLCVD#2017#");
			
			sql	= "MERGE INTO SCM0056S ";
			sql	+= "USING DUAL ON (PLAN_YEAR = TO_NUMBER(TRIM(?)) AND PLAN_WEEK = TO_NUMBER(TRIM(?)) AND STOCK_CODE = TO_CHAR(TO_NUMBER(TRIM(?)))) ";
			sql	+= "WHEN MATCHED THEN ";
			sql	+= "UPDATE ";
			sql	+= "   SET W01 = TO_NUMBER(TRIM(?)), W02 = TO_NUMBER(TRIM(?)), W03 = TO_NUMBER(TRIM(?)), W04 = TO_NUMBER(TRIM(?)), W05 = TO_NUMBER(TRIM(?)), W06 = TO_NUMBER(TRIM(?)) ";
			sql	+= "     , W07 = TO_NUMBER(TRIM(?)), W08 = TO_NUMBER(TRIM(?)), W09 = TO_NUMBER(TRIM(?)), W10 = TO_NUMBER(TRIM(?)), W11 = TO_NUMBER(TRIM(?)), W12 = TO_NUMBER(TRIM(?)) ";
			sql	+= "     , W13 = TO_NUMBER(TRIM(?)), W14 = TO_NUMBER(TRIM(?)), W15 = TO_NUMBER(TRIM(?)), W16 = TO_NUMBER(TRIM(?)), W17 = TO_NUMBER(TRIM(?)), W18 = TO_NUMBER(TRIM(?)) ";
			sql	+= "     , W19 = TO_NUMBER(TRIM(?)), W20 = TO_NUMBER(TRIM(?)), W21 = TO_NUMBER(TRIM(?)), W22 = TO_NUMBER(TRIM(?)), W23 = TO_NUMBER(TRIM(?)), W24 = TO_NUMBER(TRIM(?)) ";
			sql	+= "     , W25 = TO_NUMBER(TRIM(?)), W26 = TO_NUMBER(TRIM(?)), W27 = TO_NUMBER(TRIM(?)), W28 = TO_NUMBER(TRIM(?)), W29 = TO_NUMBER(TRIM(?)), W29 = TO_NUMBER(TRIM(?)) ";
			sql	+= "WHEN NOT MATCHED THEN ";
			sql	+= "INSERT ";
			sql	+= "(PLAN_YEAR, PLAN_WEEK, STOCK_CODE, ";
			sql	+= "W01, W02, W03, W04, W05, W06, W07, W08, W09, W10, W11, W12, W13, W14, W15, W16, W17, W18, W19, W20, W21, W22, W23, W24, W25, W26, W27, W28, W29, W30) ";
			sql	+= "VALUES ";
			sql	+= "(TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_CHAR(TO_NUMBER(TRIM(?))), ";
			sql	+= "TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), ";
			sql	+= "TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), ";
			sql	+= "TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), ";
			sql	+= "TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), ";
			sql	+= "TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?)), TO_NUMBER(TRIM(?))) ";
			
			ps	= conn.prepareStatement(sql);
			
			while ( null != (row = bufferedReader.readLine()) ) {
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i ) {
						yyyymm	= col[i];
						planYear	= Integer.parseInt(yyyymm.substring(0, 4));
						planWeek	= Integer.parseInt(yyyymm.substring(4, 6));
					}
					if ( 1 == i )	stockCode	= col[i];
					if ( 2 == i )	w01	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 3 == i )	w02	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 4 == i )	w03	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 5 == i )	w04	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 6 == i )	w05	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 7 == i )	w06	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 8 == i )	w07	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 9 == i )	w08	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 10 == i )	w09	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 11 == i )	w10	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 12 == i )	w11	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					if ( 13 == i )	w12	= Integer.parseInt(col[i].toLowerCase().replace(" ", "").replace(".000", ""));
					
					ps.setInt(1, planYear);
					ps.setInt(2, planWeek);
					ps.setString(3, stockCode);
					ps.setInt(4, w01);
					ps.setInt(5, w02);
					ps.setInt(6, w03);
					ps.setInt(7, w04);
					ps.setInt(8, w05);
					ps.setInt(9, w06);
					ps.setInt(10, w07);
					ps.setInt(11, w08);
					ps.setInt(12, w09);
					ps.setInt(13, w10);
					ps.setInt(14, w11);
					ps.setInt(15, w12);
					ps.setInt(16, w13);
					ps.setInt(17, w14);
					ps.setInt(18, w15);
					ps.setInt(19, w16);
					ps.setInt(20, w17);
					ps.setInt(21, w18);
					ps.setInt(22, w19);
					ps.setInt(23, w20);
					ps.setInt(24, w21);
					ps.setInt(25, w22);
					ps.setInt(26, w23);
					ps.setInt(27, w24);
					ps.setInt(29, w25);
					ps.setInt(30, w26);
					ps.setInt(31, w27);
					ps.setInt(32, w28);
					ps.setInt(33, w29);
					ps.setInt(34, w30);
					ps.setInt(35, planYear);
					ps.setInt(36, planWeek);
					ps.setString(37, stockCode);
					ps.setInt(38, w01);
					ps.setInt(39, w02);
					ps.setInt(40, w03);
					ps.setInt(41, w04);
					ps.setInt(42, w05);
					ps.setInt(43, w06);
					ps.setInt(44, w07);
					ps.setInt(45, w08);
					ps.setInt(46, w09);
					ps.setInt(47, w10);
					ps.setInt(48, w11);
					ps.setInt(49, w12);
					ps.setInt(50, w13);
					ps.setInt(51, w14);
					ps.setInt(52, w15);
					ps.setInt(53, w16);
					ps.setInt(54, w17);
					ps.setInt(55, w18);
					ps.setInt(56, w19);
					ps.setInt(57, w20);
					ps.setInt(58, w21);
					ps.setInt(59, w22);
					ps.setInt(60, w23);
					ps.setInt(61, w24);
					ps.setInt(62, w25);
					ps.setInt(63, w26);
					ps.setInt(64, w27);
					ps.setInt(65, w28);
					ps.setInt(66, w29);
					ps.setInt(67, w30);
					LOGGER.debug("========== i : " + i + ", planYear : " + planYear + ", planWeek : " + planWeek + ", stockCode : " + stockCode + ", w01 : " + w01 + " ==========");
				}
				ps.executeQuery();
			}
		} catch ( ClassNotFoundException cnfe ) {
			LOGGER.debug("========== Class Not Found Exception : " + cnfe.getMessage());
		} catch ( SQLException sqle ) {
			LOGGER.debug("========== DB Connection Failed : " + sqle.getMessage());
		} catch ( Exception e ) {
			e.printStackTrace();
		} finally {
			try {
				if ( null != ps )	ps.close();
				if ( null != conn )	conn.close();
			} catch ( Exception e ) {
				throw new RuntimeException(e.getMessage());
			}
		}
	}*/
}