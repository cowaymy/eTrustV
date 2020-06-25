package com.coway.trust.web.scm;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPClientConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.scm.ScmInterfaceManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.AppConstants;
import com.coway.trust.ScmConstants;
import com.coway.trust.biz.scm.ScmCommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class ScmInterfaceManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScmInterfaceManagementController.class);

	@Autowired
	private ScmCommonService scmCommonService;
	@Autowired
	private ScmCommonService scmBatchService;
	@Autowired
	private ScmInterfaceManagementService	scmInterfaceManagementService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	//	FTP
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

	//	SCM
	private static SimpleDateFormat sdf	= new SimpleDateFormat("yyyyMMddHHmmss");
	private static Calendar cal	= Calendar.getInstance();
	private static String today;
	private static int scmYearCbBox;
	private static int scmWeekCbBox;

	//	view
	@RequestMapping(value = "/interface.do")
	public String interfaceManagement(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/scmInterfaceManagement";
	}

	@RequestMapping(value = "/selectScmIfType.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmIfType(@RequestParam Map<String, Object> params) {

		LOGGER.debug("selectScmIfType : {}", params.toString());

		List<EgovMap> selectScmIfType	= scmCommonService.selectScmIfType(params);
		return ResponseEntity.ok(selectScmIfType);
	}
	@RequestMapping(value = "/selectScmIfStatus.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmIfStatus(@RequestParam Map<String, Object> params) {

		LOGGER.debug("selectScmIfTranStatus : {}", params.toString());

		List<EgovMap> selectScmIfStatus	= scmCommonService.selectScmIfStatus(params);
		return ResponseEntity.ok(selectScmIfStatus);
	}
	@RequestMapping(value = "/selectScmIfErrCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmIfErrCode(@RequestParam Map<String, Object> params) {

		LOGGER.debug("selectScmIfErrCode : {}", params.toString());

		List<EgovMap> selectScmIfErrCode	= scmCommonService.selectScmIfErrCode(params);
		return ResponseEntity.ok(selectScmIfErrCode);
	}

	//	test
	@RequestMapping(value = "/scmtest.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Map<String, Object>> scmtest(@RequestBody Map<String, Object> params) {
		LOGGER.debug("scmtest : {}", params.toString());

		scmInterfaceManagementService.testSupplyPlanRtp(params);

		Map<String, Object> map	= new HashMap<>();

		map.put("selectInterfaceList", "");

		return	ResponseEntity.ok(map);
	}

	//	search
	@RequestMapping(value = "/selectInterfaceList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Map<String, Object>> selectInterfaceList(@RequestBody Map<String, Object> params) {
		LOGGER.debug("selectInterfaceList : {}", params.toString());

		List<EgovMap> selectInterfaceList	= scmInterfaceManagementService.selectInterfaceList(params);

		Map<String, Object> map	= new HashMap<>();

		map.put("selectInterfaceList", selectInterfaceList);

		return	ResponseEntity.ok(map);
	}

	//	do interface
	@RequestMapping(value = "/doInterface.do", method = {RequestMethod.GET, RequestMethod.POST})
	//public ResponseEntity<ReturnMessage> doInterface(@RequestBody Map<String, List<Map<String, Object>>> params) {
	public ResponseEntity<ReturnMessage> doInterface(@RequestParam Map<String, List<Map<String, Object>>> params) {

		int totCnt	= 0;	int soCnt	= 0;	int ppCnt	= 0;	int giCnt	= 0;	int suppCnt	= 0;	int procCnt	= 0;
		List<Map<String, Object>> chkList	= params.get(AppConstants.AUIGRID_CHECK);
		LOGGER.debug("chkList : {}", chkList.toString());
		init();
		today	= sdf.format(cal.getTime());
		LOGGER.debug("========== today : " + today);

		Map<String, Object> logParams	= new HashMap<String, Object>();
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		List<EgovMap> selectScmIfSeq	= scmInterfaceManagementService.selectScmIfSeq(logParams);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.FAIL);
		logParams.put("execCnt", 0);
		logParams.put("fileName", "");
		logParams.put("fileSize", 0);

		for ( Map<String, Object> list : chkList ) {
			ifType	= list.get("ifType").toString();
			if ( ScmConstants.IF_OTD_SO.equals(ifType) || ScmConstants.IF_OTD_SO.equals(ifType) || ScmConstants.IF_OTD_SO.equals(ifType) || ScmConstants.IF_OTD_SO.equals(ifType) ) {
				//
			}
			if ( ScmConstants.IF_OTD_SO.equals(ifType) ) {
				fileName	= "COWAY_SO_DATA_" + today.substring(0, 8) + ".TXT";
				try {
					logParams.put("ifType", ifType);
					logParams.put("ifCycle", ScmConstants.DAILY);
					this.connect(ifType);
					if ( null != client ) {
						bufferedReader	= null;
						this.fileRead(ifType);
						if ( null != bufferedReader ) {
							totCnt	= this.updateOtdSo();
						}
					} else {
						logParams.put("errMsg", ScmConstants.FTP_CONN_ERR);
						scmInterfaceManagementService.insertLog(logParams);
						LOGGER.debug("========== doInterface : ScmConstants.FTP_CONN_ERR ==========");
					}
				} catch ( Exception e ) {
					e.printStackTrace();
				} finally {
					if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
				}
				soCnt++;
			} else if ( ScmConstants.IF_OTD_PP.equals(ifType) ) {
				fileName	= "COWAY_PP_DATA_" + today.substring(0, 8) + ".TXT";
				try {
					logParams.put("ifType", ifType);
					logParams.put("ifCycle", ScmConstants.DAILY);
					this.connect(ifType);
					if ( null != client ) {
						bufferedReader	= null;
						this.fileRead(ifType);
						if ( null != bufferedReader ) {
							totCnt	= this.mergeOtdPp();
						}
					} else {
						logParams.put("errMsg", ScmConstants.FTP_CONN_ERR);
						scmInterfaceManagementService.insertLog(logParams);
						LOGGER.debug("========== doInterface : ScmConstants.FTP_CONN_ERR ==========");
					}
				} catch ( Exception e ) {
					e.printStackTrace();
				} finally {
					if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
				}
				ppCnt++;
			} else if ( ScmConstants.IF_OTD_GI.equals(ifType) ) {
				fileName	= "COWAY_GI_DATA_" + today.substring(0, 8) + ".TXT";
				try {
					logParams.put("ifType", ifType);
					logParams.put("ifCycle", ScmConstants.DAILY);
					this.connect(ifType);
					if ( null != client ) {
						bufferedReader	= null;
						this.fileRead(ifType);
						if ( null != bufferedReader ) {
							totCnt	= this.mergeOtdGi();
						}
					} else {
						logParams.put("errMsg", ScmConstants.FTP_CONN_ERR);
						scmInterfaceManagementService.insertLog(logParams);
						LOGGER.debug("========== doInterface : ScmConstants.FTP_CONN_ERR ==========");
					}
				} catch ( Exception e ) {
					e.printStackTrace();
				} finally {
					if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
				}
				giCnt++;
			} else if ( ScmConstants.IF_SUPP_RTP.equals(ifType) ) {
				fileName	= "COWAY_SU_DATA_" + today.substring(0, 8) + ".TXT";
				try {
					logParams.put("ifType", ifType);
					logParams.put("ifCycle", ScmConstants.DAILY);
					this.connect(ifType);
					if ( null != client ) {
						bufferedReader	= null;
						this.fileRead(ifType);
						if ( null != bufferedReader ) {
							totCnt	= this.mergeSupplyPlanRtp();
						}
					} else {
						logParams.put("errMsg", ScmConstants.FTP_CONN_ERR);
						scmInterfaceManagementService.insertLog(logParams);
						LOGGER.debug("========== doInterface : ScmConstants.FTP_CONN_ERR ==========");
					}
				} catch ( Exception e ) {
					e.printStackTrace();
				} finally {
					if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
				}
				suppCnt++;
			} else {
				scmInterfaceManagementService.executeProcedureBatch(list);
				procCnt++;
			}
		}
		close();
		totCnt	= soCnt + ppCnt + giCnt + suppCnt + procCnt;

		ReturnMessage message = new ReturnMessage();

		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/executeBackDateOtd.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<ReturnMessage> executeBackDateOtd(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {
	    LOGGER.debug("executeBackDateOtd : ", params.toString());
	    int bDateCnt = 0;
	    int soTotCnt = 0;
	    int ppTotCnt = 0;
	    int giTotCnt = 0;
	    int rtpTotCnt = 0;

	    String fDateString = "2020-03-11";
//	    String fDateString = "2020-06-01";
	    LocalDate fDate = LocalDate.parse(fDateString);

	    String cDateString = "2020-06-25";
	    LocalDate cDate = LocalDate.parse(cDateString);

	    Long dayDiff = ChronoUnit.DAYS.between(fDate, cDate);

	    LOGGER.debug("DayDiff :: " + dayDiff);

	    for(int i = dayDiff.intValue(); 0 < i; i--) {
	        LOGGER.debug("i :: " + i);
	        LOGGER.debug(" ==== start ==== ");
	        Date dt = new Date();
	        Calendar startCal = Calendar.getInstance();
	        startCal.setTime(dt);
	        startCal.add(Calendar.DATE, -i);

	        StringBuffer currDt = new StringBuffer();
	        currDt.append(String.format("%04d", startCal.get(startCal.YEAR)));
	        currDt.append(String.format("%02d", startCal.get(startCal.MONTH) + 1));
	        currDt.append(String.format("%02d", startCal.get(startCal.DATE)));
	        String startCalStr = currDt.toString();
	        LOGGER.debug("startCalStr :: " + startCalStr);

	        Map<String, Object> logParams = new HashMap<String, Object>();

	        LOGGER.debug(" ==== Otd SO :: Start ==== ");
	        try {
	            init();

	            today = sdf.format(cal.getTime());
	            logParams.put("ifDate", today.substring(0, 8));
	            logParams.put("ifTime", today.substring(8, 14));
	            logParams.put("ifCycle", ScmConstants.DAILY);
	            logParams.put("ifStatus", ScmConstants.FAIL);
	            logParams.put("execCnt", 0);
	            logParams.put("fileName", "");
	            logParams.put("fileSize", 0);
	            logParams.put("ifType", ScmConstants.IF_OTD_SO);
	            List<EgovMap> selectScmIfSeq    = scmInterfaceManagementService.selectScmIfSeq(logParams);
	            logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));

	            fileName = "COWAY_SO_DATA_" + startCalStr + ".TXT";
	            this.connect(ScmConstants.IF_OTD_SO);
	            if(null != client) {
	                bufferedReader = null;
	                this.fileRead(ScmConstants.IF_OTD_SO);
	                if(null != bufferedReader) {
	                    soTotCnt = this.updateOtdSo();
	                }
	            } else {
	                logParams.put("errMsg", ScmConstants.FAIL);
	                scmInterfaceManagementService.insertLog(logParams);
	                LOGGER.debug(" ==== executeBackDateOtd :: Otd SO :: ScmConstants.FTP_CONN_ERR ==== ");
	            }

	        } catch (Exception ex) {
	            ex.printStackTrace();
	            LOGGER.error(ex.toString());
	        } finally {
	            if(null != bufferedReader )
	                try {
	                    bufferedReader.close();
	                    bufferedReader = null;
	                } catch ( IOException e ) {
	                    // DO NOTHING
	                }
	        }
	        close();

	        LOGGER.debug(" ==== Otd SO :: End ==== ");
	      //===================================================================================================================
	        LOGGER.debug(" ==== Otd PP :: Start ==== ");
            try {
                init();

                today = sdf.format(cal.getTime());
                logParams.put("ifDate", today.substring(0, 8));
                logParams.put("ifTime", today.substring(8, 14));
                logParams.put("ifCycle", ScmConstants.DAILY);
                logParams.put("ifStatus", ScmConstants.FAIL);
                logParams.put("execCnt", 0);
                logParams.put("fileName", "");
                logParams.put("fileSize", 0);
                logParams.put("ifType", ScmConstants.IF_OTD_PP);
                List<EgovMap> selectScmIfSeq    = scmInterfaceManagementService.selectScmIfSeq(logParams);
                logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));

                fileName = "COWAY_PP_DATA_" + startCalStr + ".TXT";
                this.connect(ScmConstants.IF_OTD_PP);
                if(null != client) {
                    bufferedReader = null;
                    this.fileRead(ScmConstants.IF_OTD_PP);
                    if(null != bufferedReader) {
                        ppTotCnt = this.mergeOtdPp();
                    }
                } else {
                    logParams.put("errMsg", ScmConstants.FAIL);
                    scmInterfaceManagementService.insertLog(logParams);
                    LOGGER.debug(" ==== executeBackDateOtd :: Otd PP :: ScmConstants.FTP_CONN_ERR ==== ");
                }

            } catch (Exception ex) {
                ex.printStackTrace();
                LOGGER.error(ex.toString());
            } finally {
                if(null != bufferedReader )
                    try {
                        bufferedReader.close();
                        bufferedReader = null;
                    } catch ( IOException e ) {
                        // DO NOTHING
                    }
            }
            close();

            LOGGER.debug(" ==== Otd PP :: End ==== ");
          //===================================================================================================================
            LOGGER.debug(" ==== Otd GI :: Start ==== ");
            try {
                init();

                today = sdf.format(cal.getTime());
                logParams.put("ifDate", today.substring(0, 8));
                logParams.put("ifTime", today.substring(8, 14));
                logParams.put("ifCycle", ScmConstants.DAILY);
                logParams.put("ifStatus", ScmConstants.FAIL);
                logParams.put("execCnt", 0);
                logParams.put("fileName", "");
                logParams.put("fileSize", 0);
                logParams.put("ifType", ScmConstants.IF_OTD_GI);
                List<EgovMap> selectScmIfSeq    = scmInterfaceManagementService.selectScmIfSeq(logParams);
                logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));

                fileName = "COWAY_GI_DATA_" + startCalStr + ".TXT";
                this.connect(ScmConstants.IF_OTD_GI);
                if ( null != client ) {
                    bufferedReader  = null;
                    this.fileRead(ScmConstants.IF_OTD_GI);
                    if ( null != bufferedReader ) {
                        LOGGER.debug("========== executeOtdGi : " + bufferedReader);
                        giTotCnt  = this.mergeOtdGi();
                    }
                } else {
                    logParams.put("errMsg", ScmConstants.FAIL);
                    scmInterfaceManagementService.insertLog(logParams);
                    LOGGER.debug(" ==== executeBackDateOtd :: Otd GI :: ScmConstants.FTP_CONN_ERR ==== ");
                }

            } catch (Exception ex) {
                ex.printStackTrace();
                LOGGER.error(ex.toString());
            } finally {
                if(null != bufferedReader )
                    try {
                        bufferedReader.close();
                        bufferedReader = null;
                    } catch ( IOException e ) {
                        // DO NOTHING
                    }
            }
            close();

            LOGGER.debug(" ==== Otd GI :: End ==== ");
          //===================================================================================================================
            LOGGER.debug(" ==== Otd RTP :: Start ==== ");
            try {
                init();

                today = sdf.format(cal.getTime());
                logParams.put("ifDate", today.substring(0, 8));
                logParams.put("ifTime", today.substring(8, 14));
                logParams.put("ifCycle", ScmConstants.DAILY);
                logParams.put("ifStatus", ScmConstants.FAIL);
                logParams.put("execCnt", 0);
                logParams.put("fileName", "");
                logParams.put("fileSize", 0);
                logParams.put("ifType", ScmConstants.IF_SUPP_RTP);
                List<EgovMap> selectScmIfSeq    = scmInterfaceManagementService.selectScmIfSeq(logParams);
                logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));

                fileName = "COWAY_SU_DATA_" + startCalStr + ".TXT";
                this.connect(ScmConstants.IF_SUPP_RTP);
                if ( null != client ) {
                    bufferedReader  = null;
                    this.fileRead(ScmConstants.IF_SUPP_RTP);
                    if ( null != bufferedReader ) {
                        rtpTotCnt  = this.mergeSupplyPlanRtp();
                    } else {
                        logParams.put("errMsg", ScmConstants.FAIL);
                        scmInterfaceManagementService.insertLog(logParams);
                        LOGGER.debug(" ==== executeBackDateOtd :: Otd RTP :: ScmConstants.FTP_CONN_ERR ==== ");
                    }
                } else {
                    logParams.put("errMsg", ScmConstants.FTP_CONN_ERR);
                    scmInterfaceManagementService.insertLog(logParams);
                    LOGGER.debug("========== executeSupplyPlanRtp : ScmConstants.FTP_CONN_ERR ==========");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                LOGGER.error(ex.toString());
            } finally {
                if(null != bufferedReader )
                    try {
                        bufferedReader.close();
                        bufferedReader = null;
                    } catch ( IOException e ) {
                        // DO NOTHING
                    }
            }
            close();

            LOGGER.debug(" ==== Otd RTP :: End ==== ");

	        LOGGER.debug(" ==== end ==== ");
	    }

	    ReturnMessage message = new ReturnMessage();

        message.setCode(AppConstants.SUCCESS);
        message.setData(bDateCnt);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/executeOtdSo.do", method = {RequestMethod.GET, RequestMethod.POST})
	//public ResponseEntity<ReturnMessage> executeOtdSo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
	public ResponseEntity<ReturnMessage> executeOtdSo(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {
		LOGGER.debug("executeOtdBatch : {}", params.toString());
		int totCnt	= 0;
		init();
		today	= sdf.format(cal.getTime());
		LOGGER.debug("========== executeOtdSo : today : " + today);

		Map<String, Object> logParams	= new HashMap<String, Object>();
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_OTD_SO);
		logParams.put("ifCycle", ScmConstants.DAILY);
		List<EgovMap> selectScmIfSeq	= scmInterfaceManagementService.selectScmIfSeq(logParams);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.FAIL);
		logParams.put("execCnt", 0);
		logParams.put("fileName", "");
		logParams.put("fileSize", 0);

		try {
			fileName	= "COWAY_SO_DATA_" + today.substring(0, 8) + ".TXT";
			this.connect(ScmConstants.IF_OTD_SO);
			if ( null != client ) {
				bufferedReader	= null;
				this.fileRead(ScmConstants.IF_OTD_SO);
				if ( null != bufferedReader ) {
					totCnt	= this.updateOtdSo();
				}
			} else {
				logParams.put("errMsg", ScmConstants.FTP_CONN_ERR);
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== executeOtdSo : ScmConstants.FTP_CONN_ERR ==========");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		} finally {
			if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
		}
		close();
		LOGGER.debug("totCnt : " + totCnt);

		ReturnMessage message = new ReturnMessage();

		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/executeOtdPp.do", method = {RequestMethod.GET, RequestMethod.POST})
	//public ResponseEntity<ReturnMessage> executeOtdPp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
	public ResponseEntity<ReturnMessage> executeOtdPp(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {
		int totCnt	= 0;
		init();
		today	= sdf.format(cal.getTime());
		LOGGER.debug("========== executeOtdPp : today : " + today);

		Map<String, Object> logParams	= new HashMap<String, Object>();
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_OTD_PP);
		logParams.put("ifCycle", ScmConstants.DAILY);
		List<EgovMap> selectScmIfSeq	= scmInterfaceManagementService.selectScmIfSeq(logParams);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.FAIL);
		logParams.put("execCnt", 0);
		logParams.put("fileName", "");
		logParams.put("fileSize", 0);

		try {
			fileName	= "COWAY_PP_DATA_" + today.substring(0, 8) + ".TXT";
			this.connect(ScmConstants.IF_OTD_PP);
			if ( null != client ) {
				bufferedReader	= null;
				this.fileRead(ScmConstants.IF_OTD_PP);
				if ( null != bufferedReader ) {
					totCnt	= this.mergeOtdPp();
				}
			} else {
				logParams.put("errMsg", ScmConstants.FTP_CONN_ERR);
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== executeOtdPp : ScmConstants.FTP_CONN_ERR ==========");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		} finally {
			if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
		}
		close();
		LOGGER.debug("totCnt : " + totCnt);

		ReturnMessage message = new ReturnMessage();

		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/executeOtdGi.do", method = {RequestMethod.GET, RequestMethod.POST})
	//public ResponseEntity<ReturnMessage> executeOtdGi(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
	public ResponseEntity<ReturnMessage> executeOtdGi(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {
		int totCnt	= 0;
		init();
		today	= sdf.format(cal.getTime());
		LOGGER.debug("========== executeOtdGi : today : " + today);

		Map<String, Object> logParams	= new HashMap<String, Object>();
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_OTD_GI);
		logParams.put("ifCycle", ScmConstants.DAILY);
		List<EgovMap> selectScmIfSeq	= scmInterfaceManagementService.selectScmIfSeq(logParams);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.FAIL);
		logParams.put("execCnt", 0);
		logParams.put("fileName", "");
		logParams.put("fileSize", 0);

		try {
			fileName	= "COWAY_GI_DATA_" + today.substring(0, 8) + ".TXT";
			this.connect(ScmConstants.IF_OTD_GI);
			if ( null != client ) {
				bufferedReader	= null;
				this.fileRead(ScmConstants.IF_OTD_GI);
				if ( null != bufferedReader ) {
					LOGGER.debug("========== executeOtdGi : " + bufferedReader);
					totCnt	= this.mergeOtdGi();
				}
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		} finally {
			if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
		}
		close();
		LOGGER.debug("totCnt : " + totCnt);

		ReturnMessage message = new ReturnMessage();

		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/executeSupplyPlanRtp.do", method = {RequestMethod.GET, RequestMethod.POST})
	//public ResponseEntity<ReturnMessage> executeSupplyPlanRtp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
	public ResponseEntity<ReturnMessage> executeSupplyPlanRtp(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {
		LOGGER.debug("executeSupplyPlanRtp : {}", params.toString());
		int totCnt	= 0;
		init();
		today	= sdf.format(cal.getTime());
		LOGGER.debug("========== executeSupplyPlanRtp : today : " + today);

		Map<String, Object> logParams	= new HashMap<String, Object>();
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ScmConstants.IF_SUPP_RTP);
		List<EgovMap> selectScmIfSeq	= scmInterfaceManagementService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.FAIL);
		logParams.put("execCnt", 0);
		logParams.put("fileName", "");
		logParams.put("fileSize", 0);

		try {
			//	1. so
			fileName	= "COWAY_SU_DATA_" + today.substring(0, 8) + ".TXT";
			this.connect(ScmConstants.IF_SUPP_RTP);
			if ( null != client ) {
				bufferedReader	= null;
				this.fileRead(ScmConstants.IF_SUPP_RTP);
				LOGGER.debug("BUFFERED_READER : " + bufferedReader);
				//LOGGER.debug("BUFFERED_READER : " + bufferedReader.toString());
				if ( null != bufferedReader ) {
					LOGGER.debug("========== executeSupplyPlanRtp : bufferedReader is not null so mergeSupplyPlanRtp executed ==========");
					totCnt	= this.mergeSupplyPlanRtp();
				} else {
					LOGGER.debug("========== executeSupplyPlanRtp : bufferedReader is null so mergeSupplyPlanRtp not executed ==========");
				}
			} else {
				logParams.put("errMsg", ScmConstants.FTP_CONN_ERR);
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== executeSupplyPlanRtp : ScmConstants.FTP_CONN_ERR ==========");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		} finally {
			if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
		}
		close();
		LOGGER.debug("totCnt : " + totCnt);

		ReturnMessage message = new ReturnMessage();

		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

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
		List<EgovMap> selectScmIfSeq	= scmInterfaceManagementService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.SUCCESS);
		logParams.put("fileName", fileName);

		try {
			while ( null != (row = bufferedReader.readLine()) ) {
				fileSize	+= row.length();
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
						 */
						stockCode	= col[i].substring(11, 18);
						LOGGER.debug("1. stockCode : " + stockCode);
						if ( stockCode.startsWith("0") ) {
							stockCode	= stockCode.substring(1, 7);
							LOGGER.debug("2. stockCode : " + stockCode);
						}
					}
					if ( 8 == i )	soQty	= (int) Double.parseDouble(col[i].trim());
					if ( 9 == i )	soDt	= col[i].trim();
					//LOGGER.debug(i + " : '" + col[i] + "'");
				}
				//	set params
				params.put("poNo", poNo);
				params.put("poDt", poDt);
				params.put("soNo", soNo);
				params.put("soItemNo", soItemNo);
				params.put("stockCode", stockCode);
				params.put("soQty", soQty);
				params.put("soDt", soDt);
				LOGGER.debug(totCnt + ". params : {}", params.toString());
				scmInterfaceManagementService.updateOtdSo(params);
				totCnt++;
			}
			logParams.put("execCnt", totCnt);
			logParams.put("fileSize", fileSize);
			if ( 0 == fileSize ) {
				logParams.put("ifStatus", ScmConstants.FAIL);
				logParams.put("errMsg", ScmConstants.FILE_EMPTY);
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== updateOtdSo : ScmConstants.FAIL ==========");
			} else {
				logParams.put("errMsg", "");
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== updateOtdSo : ScmConstants.SUCCESS ==========");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		} finally {
			if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
		}

		return	totCnt;
	}
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
		logParams.put("ifType", ScmConstants.IF_OTD_PP);
		List<EgovMap> selectScmIfSeq	= scmInterfaceManagementService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.SUCCESS);
		logParams.put("fileName", fileName);

		try {
			//	1. delete before pp info
			scmInterfaceManagementService.deleteOtdPp(params);

			//	2. merge new pp info
			while ( null != (row = bufferedReader.readLine()) ) {
				fileSize	+= row.length();
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i )	poNo	= col[i].trim();
					if ( 1 == i )	soNo	= col[i];
					if ( 2 == i )	soItemNo	= Integer.parseInt(col[i]);
					if ( 3 == i ) {
						/*
						 * 본사 stock code는 6자리, 7자리코드가 들어온다.
						 * 전체 숫자가 아니라 문자도 소수 포함된 경우가 있어서 parseInt로 캐스팅하면 안됨
						 * 전체 18자리 문자열중 우측에서 7자리만 자른 다음
						 * 해당 7자리 문자열의 시작이 "0"이면 다시 제일 앞 1자리를 잘라서 6자리로 만들고
						 * "0"이 아니면 그대로 사용
						 */
						stockCode	= col[i].substring(11, 18);
						LOGGER.debug("1. stockCode : " + stockCode);
						if ( stockCode.startsWith("0") ) {
							stockCode	= stockCode.substring(1, 7);
							LOGGER.debug("2. stockCode : " + stockCode);
						}
					}
					if ( 5 == i )	ppPlanQty	= (int) Double.parseDouble(col[i].trim());
					if ( 6 == i )	ppProdQty	= (int) Double.parseDouble(col[i].trim());
					if ( 8 == i )	ppProdStartDt	= col[i];
					if ( 9 == i )	ppProdEndDt		= col[i];
					//LOGGER.debug(i + " : '" + col[i] + "'");
				}
				//	set params
				params.put("ifDate", today.subSequence(0, 8));
				params.put("poNo", poNo);
				params.put("soNo", soNo);
				params.put("soItemNo", soItemNo);
				params.put("stockCode", stockCode);
				params.put("ppPlanQty", ppPlanQty);
				params.put("ppProdQty", ppProdQty);
				params.put("ppProdStartDt", ppProdStartDt);
				params.put("ppProdEndDt", ppProdEndDt);
				LOGGER.debug(totCnt + ". params : {}", params.toString());
				scmInterfaceManagementService.mergeOtdPp(params);
				totCnt++;
			}
			logParams.put("execCnt", totCnt);
			logParams.put("fileSize", fileSize);
			if ( 0 == fileSize ) {
				logParams.put("ifStatus", ScmConstants.FAIL);
				logParams.put("errMsg", ScmConstants.FILE_EMPTY);
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== mergeOtdPp : ScmConstants.FAIL ==========");
			} else {
				logParams.put("errMsg", "");
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== mergeOtdPp : ScmConstants.SUCCESS ==========");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		} finally {
			if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
		}

		return	totCnt;
	}
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
		logParams.put("ifType", ScmConstants.IF_OTD_GI);
		List<EgovMap> selectScmIfSeq	= scmInterfaceManagementService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.SUCCESS);
		logParams.put("fileName", fileName);

		try {
			while ( null != (row = bufferedReader.readLine()) ) {
				fileSize	+= row.length();
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i )	poNo	= col[i].trim();
					if ( 1 == i )	soNo	= col[i];
					if ( 2 == i )	soItemNo	= Integer.parseInt(col[i]);
					if ( 3 == i )	delvNo	= col[i];
					if ( 4 == i )	delvItemNo	= Integer.parseInt(col[i]);
					if ( 5 == i ) {
						/*
						 * 본사 stock code는 6자리, 7자리코드가 들어온다.
						 * 전체 숫자가 아니라 문자도 소수 포함된 경우가 있어서 parseInt로 캐스팅하면 안됨
						 * 전체 18자리 문자열중 우측에서 7자리만 자른 다음
						 * 해당 7자리 문자열의 시작이 "0"이면 다시 제일 앞 1자리를 잘라서 6자리로 만들고
						 * "0"이 아니면 그대로 사용
						 */
						stockCode	= col[i].substring(11, 18);
						LOGGER.debug("1. stockCode : " + stockCode);
						if ( stockCode.startsWith("0") ) {
							stockCode	= stockCode.substring(1, 7);
							LOGGER.debug("2. stockCode : " + stockCode);
						}
					}
					if ( 7 == i )	giQty	= (int) Double.parseDouble(col[i].trim());
					if ( 10 == i )	giDt	= col[i];
					//LOGGER.debug(i + " : '" + col[i] + "'");
				}
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
				scmInterfaceManagementService.mergeOtdGi(params);
				totCnt++;
			}
			logParams.put("execCnt", totCnt);
			logParams.put("fileSize", fileSize);
			if ( 0 == fileSize ) {
				logParams.put("ifStatus", ScmConstants.FAIL);
				logParams.put("errMsg", ScmConstants.FILE_EMPTY);
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== mergeOtdGi : ScmConstants.FAIL ==========");
			} else {
				logParams.put("errMsg", "");
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== mergeOtdGi : ScmConstants.SUCCESS ==========");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		} finally {
			if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
		}

		return	totCnt;
	}
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
		List<EgovMap> selectScmIfSeq	= scmInterfaceManagementService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.SUCCESS);
		logParams.put("fileName", fileName);

		try {
			//	1. File Read and DB Write
			while ( null != (row = bufferedReader.readLine()) ) {
				fileSize	+= row.length();
				String col[]	= row.split("\\|");
				for ( int i = 0 ; i < col.length ; i++ ) {
					if ( 0 == i ) {
						yyyymm	= col[i];
						planYear	= Integer.parseInt(yyyymm.substring(0, 4));
						planWeek	= Integer.parseInt(yyyymm.substring(4, 6));
					}
					//	삭제 부분 추가
					if ( 0 == totCnt ) {
						//	첫번째만 삭제
						params.put("planYear", planYear);
						params.put("planWeek", planWeek);
						LOGGER.debug("just one delete");
						scmInterfaceManagementService.deleteSupplyPlanRtp(params);
					}
					if ( 1 == i ) {
						/*
						 * 본사 stock code는 6자리, 7자리코드가 들어온다.
						 * 전체 숫자가 아니라 문자도 소수 포함된 경우가 있어서 parseInt로 캐스팅하면 안됨
						 * 전체 18자리 문자열중 우측에서 7자리만 자른 다음
						 * 해당 7자리 문자열의 시작이 "0"이면 다시 제일 앞 1자리를 잘라서 6자리로 만들고
						 * "0"이 아니면 그대로 사용
						 */
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
					//LOGGER.debug(i + " : '" + col[i] + "'");
				}
				//	set params
				params.put("planYear", planYear);	params.put("scmYearCbBox", planYear);
				params.put("planWeek", planWeek);	params.put("scmWeekCbBox", planWeek);
				params.put("stockCode", stockCode);
				params.put("w01", w01);	params.put("w02", w02);	params.put("w03", w03);	params.put("w04", w04);	params.put("w05", w05);
				params.put("w06", w06);	params.put("w07", w07);	params.put("w08", w08);	params.put("w09", w09);	params.put("w10", w10);
				params.put("w11", w11);	params.put("w12", w12);	params.put("w13", w13);	params.put("w14", w14);	params.put("w15", w15);
				params.put("w16", w16);	params.put("w17", w17);	params.put("w18", w18);	params.put("w19", w19);	params.put("w20", w20);
				params.put("w21", w21);	params.put("w22", w22);	params.put("w23", w23);	params.put("w24", w24);	params.put("w25", w25);
				params.put("w26", w26);	params.put("w27", w27);	params.put("w28", w28);	params.put("w29", w29);	params.put("w30", w30);
				params.put("ws1", ws1);	params.put("ws2", ws2);	params.put("ws3", ws3);	params.put("ws4", ws4);	params.put("ws5", ws5);
				LOGGER.debug(totCnt + ". params : {}", params.toString());
				scmInterfaceManagementService.mergeSupplyPlanRtp(params);
				totCnt++;
			}

			//	2. Newly update merged data
			scmInterfaceManagementService.updateSupplyPlanRtp(params);

			//	3. Insert log
			logParams.put("execCnt", totCnt);
			logParams.put("fileSize", fileSize);
			if ( 0 == fileSize ) {
				logParams.put("ifStatus", ScmConstants.FAIL);
				logParams.put("errMsg", ScmConstants.FILE_EMPTY);
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== mergeSupplyPlanRtp : ScmConstants.FAIL ==========");
			} else {
				logParams.put("errMsg", "");
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== mergeSupplyPlanRtp : ScmConstants.SUCCESS ==========");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		} finally {
			if ( null != bufferedReader )	try { bufferedReader.close();	bufferedReader	= null; }	catch ( IOException e )	{}
		}

		return	totCnt;
	}

	/*
	 * FTP
	 */
	public void connect(String ifType) {
		client	= new FTPClient();
		client.setControlEncoding("euc-kr");

		config	= new FTPClientConfig();
		client.configure(config);

		try {
			client.connect("10.101.3.40", 21);
			LOGGER.debug("========== FTP Server connected ==========");
			client.login("etrustftp3", "akffus#20!*");
			LOGGER.debug("========== FTP Server loged in ==========");
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	public void disconnect() {
		try {
			client.logout();
			LOGGER.debug("========== FTP Server loged out ==========");
			if ( client.isConnected() ) {
				client.disconnect();
				client	= null;
				LOGGER.debug("========== FTP Server disconnected ==========");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		} finally {
			if ( null != client ) {
				try {
					client.disconnect();
					client	= null;
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}
	public void fileRead(String ifType) {
		Map<String, Object> logParams	= new HashMap<String, Object>();
		logParams.put("ifDate", today.substring(0, 8));
		logParams.put("ifTime", today.substring(8, 14));
		logParams.put("ifType", ifType);
		List<EgovMap> selectScmIfSeq	= scmInterfaceManagementService.selectScmIfSeq(logParams);
		logParams.put("ifCycle", ScmConstants.DAILY);
		logParams.put("ifSeq", Integer.parseInt(selectScmIfSeq.get(0).get("seq").toString()));
		logParams.put("ifStatus", ScmConstants.FAIL);
		logParams.put("execCnt", 0);
		logParams.put("fileName", fileName);
		logParams.put("fileSize", 0);

		try {
//			inputStream	= client.retrieveFileStream("/" + fileName);
		    File inFile = new File("D:/Users/HQ-KITWAI/Desktop/SCM_OTD/" + fileName);
			inputStream  = new FileInputStream(inFile);
			LOGGER.debug("========== fileRead : fileName : /" + fileName);
			if ( null != inputStream ) {
				bufferedReader	= new BufferedReader(new InputStreamReader(inputStream, "utf-8"));
			} else {
				logParams.put("errMsg", ScmConstants.FILE_DOES_NOT_EXIST);
				scmInterfaceManagementService.insertLog(logParams);
				LOGGER.debug("========== fileRead : ScmConstants.FILE_DOES_NOT_EXIST ==========");
				disconnect();
			}
		} catch ( Exception e ) {
			LOGGER.debug("========== fileRead : ScmConstants.FTP_FILE_READ_ERR ==========");
			e.printStackTrace();
		}
	}

	private void init() {
		//	init all private variables
		ifSeq	= 0;	execCnt	= 0;	fileSize	= 0;
		ifDate	= "";	ifTime	= "";	ifType	= "";	ifCycle	= "";	ifStatus	= "";	fileName	= "";	errMsg	= "";

		today	= "";

		if ( null != bufferedReader ) {
			try {
				bufferedReader.close();
				bufferedReader	= null;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		if ( null != inputStream ) {
			try {
				inputStream.close();
				inputStream	= null;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		if ( null != sdf ) {
			sdf	= null;
		}
		sdf	= new SimpleDateFormat("yyyyMMddHHmmss");

		if ( null != cal ) {
			cal	= null;
		}
		cal	= Calendar.getInstance();
	}

	private void close() {
		if ( null != bufferedReader ) {
			try {
				bufferedReader.close();
				bufferedReader	= null;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		if ( null != inputStream ) {
			try {
				inputStream.close();
				inputStream	= null;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}