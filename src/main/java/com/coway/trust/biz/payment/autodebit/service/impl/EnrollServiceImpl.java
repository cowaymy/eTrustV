package com.coway.trust.biz.payment.autodebit.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.antlr.grammar.v3.ANTLRParser.exceptionGroup_return;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.autodebit.service.EnrollService;
import com.ibm.icu.text.SimpleDateFormat;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import java.io.*;
import org.apache.commons.lang.StringUtils;


/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("enrollService")
public class EnrollServiceImpl extends EgovAbstractServiceImpl implements EnrollService {

	private static final Logger logger = LoggerFactory.getLogger(EnrollServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "enrollMapper")
	private EnrollMapper enrollMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	
	
	/**
	 * EnrollmentList(Master Grid) 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectEnrollmentList(Map<String, Object> params) {
		return enrollMapper.selectEnrollmentList(params);
	}


	/**
	 * View Enrollment Master 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectViewEnrollment(Map<String, Object> params) {
		return enrollMapper.selectViewEnrollment(params);
	}


	/**
	 * View Enrollment List 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectViewEnrollmentList(Map<String, Object> params) {
		return enrollMapper.selectViewEnrollmentList(params);
	}


	/**
	 * Save Enroll(저장 + 파일생성)
	 * @param params
	 * @return
	 */
	@Override
	 public Map<String, Object> saveEnroll(Map<String, Object> param){
		return enrollMapper.saveEnroll(param);
	}
	
	/**
	 * EnrollmentDetView 조회
	 * @param params
	 * @return
	 */
	@Override
	public void selectEnrollmentDetView(Map<String, Object> params) {
		
		List<EgovMap> result = enrollMapper.selectEnrollmentDetView(params);
		
		String issueBank = (String) params.get("cmbIssueBank2");
		String rdpCreateDateFr = (String) params.get("rdpCreateDateFr2");
		String enrlId = String.valueOf(params.get("enrlId"));
			
		switch (issueBank) {
		case "2":
			this.createEnrollmentFile_ALB(result, issueBank, rdpCreateDateFr);
			this.createEnrollmentFile_ALB_NEW(result, issueBank, enrlId);
			break;
			
		default:
			break;
		}

	}
	
	public void createEnrollmentFile_ALB(List<EgovMap> params, String issueBank, String rdpCreateDateFr){
		
		String debtDateFr = rdpCreateDateFr;
		String day = rdpCreateDateFr.substring(0,2);
		String month = rdpCreateDateFr.substring(3,5);
		String year = rdpCreateDateFr.substring(6,10);
		debtDateFr = year+month+day;
		String sFile = "ALB" + debtDateFr + "ENROLL01.txt";
		String location = "D://WebShare//FTP Folder//CRT//ALB/EnrollALB//" + sFile;
		
		File file = new File(location);
		FileWriter fw;
		try {
			fw = new FileWriter(file, false);
			String sText = "H|ADCUSPRO|";
			sText += "\r\n";
			
			/*if(!file.exists()){
				logger.debug("디렉토리존재유무 체크:"+"해당 디렉토리존재안함!");
				file.mkdirs();
			}*/
			fw.write(sText);
			fw.flush();

    		//String schksum = "";
            int iHashTot = 0;
            int iTotAmt = 0;
            int icntdel = 0;
    
            //String sDocno = "";
            String sreserve = "";
            //String sDrAccNo = "";
            String sOldIC = "";
            //String sNRIC = "";
            //String sDrName = "";
            String sLimit = "";
            String sFiller = "";
            //String stextDetails = "";
            String sBatchTot = "";
            String sTotAdd = "";
            String sTotDel = "";
            String sHashTot = "";
            String sTextBtn = "";
		
    		if (params.size() > 0) {
    			
    			params.forEach(obj -> {
                    Map<String, Object> map2 = (Map<String, Object>) obj;
                    
                    //수정할 데이터 확인.(그리드 값)
                    logger.debug("enrlId : {}", map2.get("enrlId"));//프로시저 반환 enrId값
    				logger.debug("ENRL_ITM_ID : {}", map2.get("enrlItmId"));
                    logger.debug("ACC_NAME : {}", map2.get("accName"));					
                    logger.debug("ACC_NO : {}", map2.get("accNo"));
                    logger.debug("ACC_NRIC : {}", map2.get("accNric"));
                    logger.debug("APPV_DT : {}", map2.get("appvDt"));
                    logger.debug("BILL_AMT : {}", map2.get("billAmt"));
                    logger.debug("CLM_AMT : {}", map2.get("clmAmt"));
                    logger.debug("ENRL_ID : {}", map2.get("enrlId"));
                    logger.debug("LIMIT_AMT : {}", map2.get("limitAmt"));
                    logger.debug("SALES_ORD_ID : {}", map2.get("salesOrdId"));
                    logger.debug("SALES_ORD_NO : {}", map2.get("salesOrdNo"));
                    logger.debug("SVC_CNTRCT_ID : {}", map2.get("svcCntrctId"));
                    logger.debug("C1 : {}", map2.get("c1"));
                    String sDocno = ((String) map2.get("salesOrdNo")).trim();
                    String sDrAccNo = StringUtils.leftPad(((String) map2.get("accNo")).trim(), 15, ' ');
                    String sNRIC = ((String) map2.get("accNric")).trim();
                    String sDrName = ((String) map2.get("accName")).trim();
                    //String billAmt = (String) map2.get("billAmt");
                    //logger.debug("billAmt:"+billAmt);
                    //sLimit = string.Format(det.BillAmt.ToString(), "#####.00");
                    /*if (sLimit == ".00")
                    sLimit = "0.00";*/
                    //String schksum = Integer.toString(calChkSum(sDocno, sDrAccNo));
                    //String schksumPadLef = StringUtils.leftPad(schksum,12 , "0");
                    String stextDetails = "D" + "|" + "101" + "|" + sDrName.toUpperCase().trim() + "|" + sNRIC.toUpperCase().trim() + "|" + sDrAccNo.toUpperCase().trim() + "|" + "sLimit" + "|" + "D" + "|" + sDocno + "|";
                    stextDetails += "\r\n";
                    try {
    					fw.write(stextDetails);
    					fw.flush();
    	                
    				} catch (Exception e) {
    					e.printStackTrace();
    				}
    
        		});
    	        sTotAdd = Integer.toString(params.size());
    	        sTextBtn = "T|" + sTotAdd + "|";
    	        sTextBtn += "\r\n";
    	        fw.write(sTextBtn);
    	        fw.flush();
    	        fw.close();
        	}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void createEnrollmentFile_ALB_NEW(List<EgovMap> params, String issueBank, String enrlId){

		Date date = new Date();
        SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy");
        String toDate = df.format(date);
		String sFile = "AD_Enrolment_" + toDate + ".txt";
		String location = "D:/WebShare/FTP Folder/CRT/ALB/EnrollALB/" + sFile;
		
		File file = new File(location);
		FileWriter fw;
		try {
			fw = new FileWriter(file, false);
			
			//-------- HEADER -------------
            String hRecordType = "H"; 
            String hCreditAccNo = "140550010078613";
            String hCompanyName = "Coway (M) Sdn Bhd";
            String hFileBatchRefNo = enrlId;
            String hSellerID = "AD10000101";
            String HeaderStr = hRecordType + "|" + hCreditAccNo + "|" + hCompanyName + "|" + hFileBatchRefNo + "|" + hSellerID + "|";
            HeaderStr += "\r\n";
			fw.write(HeaderStr);
			fw.flush();
            //-------- END HEADER -------------
			
			
			/*if(!file.exists()){
				logger.debug("디렉토리존재유무 체크:"+"해당 디렉토리존재안함!");
				file.mkdirs();
			}*/
			
			
			//-------- DETAILS---------------
            int hashTotal = 0;
            String dRecordType = "D";
            String dReqType = "C";
            //String dDebtiAccNo = "";
            //String dDebitAccName = "";
            String dBankCode = "MFBBMYKL";
            //String dBuyerIDNo = "";
            String dMaxAmount = "";
            String dFreqMode = "M";
            String dNoFreq = "0008";
            String OrderNo = "";
            String SellerInternalRefNo = "";
            String CommencementDate = toDate;
            String ExpiryDate = "31122099";
            String Email1 = "";
            String Email2 = "";
            //String DetailStr = "";
		
    		if (params.size() > 0) {
    			
    			params.forEach(obj -> {
                    Map<String, Object> map2 = (Map<String, Object>) obj;
                    
                    //수정할 데이터 확인.(그리드 값)
                    logger.debug("enrlId : {}", map2.get("enrlId"));//프로시저 반환 enrId값
    				logger.debug("ENRL_ITM_ID : {}", map2.get("enrlItmId"));
                    logger.debug("ACC_NAME : {}", map2.get("accName"));					
                    logger.debug("ACC_NO : {}", map2.get("accNo"));
                    logger.debug("ACC_NRIC : {}", map2.get("accNric"));
                    logger.debug("APPV_DT : {}", map2.get("appvDt"));
                    logger.debug("BILL_AMT : {}", map2.get("billAmt"));
                    logger.debug("CLM_AMT : {}", map2.get("clmAmt"));
                    logger.debug("ENRL_ID : {}", map2.get("enrlId"));
                    logger.debug("LIMIT_AMT : {}", map2.get("limitAmt"));
                    logger.debug("SALES_ORD_ID : {}", map2.get("salesOrdId"));
                    logger.debug("SALES_ORD_NO : {}", map2.get("salesOrdNo"));
                    logger.debug("SVC_CNTRCT_ID : {}", map2.get("svcCntrctId"));
                    logger.debug("C1 : {}", map2.get("c1"));
                    
                    String dDebtiAccNo = (String) map2.get("accNo");
                    if(dDebtiAccNo.length() > 17){
                    	dDebtiAccNo.substring(0, 17);
                    }else{
                    	//dDebtiAccNo = dDebtiAccNo;
                    }
                    
                    String dDebitAccName = (String) map2.get("accName");
                    if(dDebitAccName.length() > 40){
                    	dDebitAccName.substring(0, 40);
                    }else{
                    	//dDebitAccName = dDebitAccName;
                    }
                    
                    String dBuyerIDNo = (String) map2.get("accNric");
                    if(dBuyerIDNo.length() > 20){
                    	dBuyerIDNo.substring(0, 20);
                    }else{
                    	//dBuyerIDNo = dBuyerIDNo;
                    }
                    //dMaxAmount = string.Format("{0:0.00}", det.BillAmt);
                    //OrderNo = det.ContractNOrderNo.Trim();
					//int strAccNo =subStrRirght(dDebtiAccNo,10);
                    //hashTotal += subStr;

                    String DetailStr = dRecordType + "|" + dReqType + "|" + dDebtiAccNo + "|" + dDebitAccName + "|" +
                        dBankCode + "|" + dBuyerIDNo + "|" + dMaxAmount + "|" + dFreqMode + "|" + dNoFreq + "|" + OrderNo + "|" +
                        SellerInternalRefNo + "|" + CommencementDate + "|" + ExpiryDate + "|" + Email1 + "|" + Email2 + "|";
                    try {
                    	DetailStr += "\r\n";
    					fw.write(DetailStr);
    					fw.flush();
    	                
    				} catch (Exception e) {
    					e.printStackTrace();
    				}
    
        		});
    			//-------- TRAILER ---------------
    			String tRecordType = "T";
    			String tTotalRecord = Integer.toString(params.size());
    			//String tHashTotal = string.Format("{0:0000000000}", hashTotal);
    			String TrailerStr = "";
                TrailerStr = tRecordType + "|" + tTotalRecord + "|" + "tHashTotal" + "|";
                TrailerStr += "\r\n";
                fw.write(TrailerStr);
                fw.flush();
    	        fw.close();
                //-------- END TRAILER ---------------
        	}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
	
	public int subStrRirght(String sAccNo, int length){
		String accNo = sAccNo;
		int accNoLength = length;
		int result = 0;
		
		if(sAccNo.length() > 0){
			accNo = accNo.substring(accNoLength-length);
		}else{
			accNo= "0";
		}
		result = Integer.parseInt(accNo);
		
		return result;
	}
	
	public int calChkSum(String sBillNo, String sAccNo){
		
		int iResult = 0;
        String schar = "";
        String billNo = sBillNo;
        billNo = billNo.trim();
        String accNo = sAccNo;
        accNo = accNo.trim();
        if (!billNo.isEmpty()){
        	billNo = StringUtils.rightPad(billNo, 5,' ');
            for (int i = 0; i <= 4; i++){
                schar = billNo.substring(i, i+1);
                if (StringUtils.isNumeric(schar))
                    iResult = iResult + Integer.parseInt(schar);
            }
        }
        
        accNo = accNo.substring(accNo.length() -4);
        
        for (int i = 0; i <= 3; i++){
            schar = accNo.substring(i, i+1);
            if (StringUtils.isNumeric(schar))
                iResult = iResult + Integer.parseInt(schar);
        }
        return iResult;
	}
}
