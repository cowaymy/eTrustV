package com.coway.trust.web.payment.autodebit.controller;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.payment.autodebit.service.EnrollService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class EnrollController {

	private static final Logger logger = LoggerFactory.getLogger(EnrollController.class);

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "enrollService")
	private EnrollService enrollService ;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	/******************************************************
	 * EnrollmentList  
	 *****************************************************//*	
	*//**
	 * EnrollmentList초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initEnrollmentList.do")
	public String initEnrollmentList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/autodebit/enrollmentList";
	}
	
	/**
	 * selectEnrollmentList 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectEnrollmentList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectEnrollmentList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {
        // 조회.
        List<EgovMap> resultList = enrollService.selectEnrollmentList(params);
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * ViewEnrollment 팝업 Master
	 */
	@RequestMapping(value = "/selectViewEnrollment", method = RequestMethod.GET)
	public ResponseEntity<Map> selectViewEnrollment(@RequestParam Map<String, Object>params, ModelMap model) {
		
		params.put("enrollId", params.get("enrollId"));
		EgovMap enrollInfo = enrollService.selectViewEnrollment(params);
		
		Map result = new HashMap();
		result.put("enrollInfo", enrollInfo);
		
		return ResponseEntity.ok(result);
	}
		
	/**
	* ViewEnrollmentList 팝업 Detail
	*/
	@RequestMapping(value = "/selectViewEnrollmentList")
	public ResponseEntity<List<EgovMap>> selectViewEnrollmentList(@RequestParam Map<String, Object>params, ModelMap model) {
			
		params.put("enrollId", params.get("enrollId"));
		List<EgovMap> result = enrollService.selectViewEnrollmentList(params);
		
		return ResponseEntity.ok(result);
	}
	
	/**
	 * Save Enroll
	 */
	@RequestMapping(value = "/saveEnroll", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveEnroll(@RequestBody Map<String, Object> params, Model model) throws Exception{

		String frDate = CommonUtils.nvl(params.get("rdpCreateDateFr2")).equals("") ? "01/01/1900" : CommonUtils.nvl(params.get("rdpCreateDateFr2"));
		String toDate = CommonUtils.nvl(params.get("rdpCreateDateTo2")).equals("") ? "01/01/1900" : CommonUtils.nvl(params.get("rdpCreateDateTo2"));
		
		//parameter 객체를 생성한다. 프로시저에서 CURSOR 반환시 해당 paramter 객체에 리스트를 세팅한다.
    	//프로시저에서 사용하는 parameter가 없어도 객체는 생성한다.
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("cmbIssueBank2", params.get("cmbIssueBank2"));
		param.put("rdpCreateDateFr2", frDate);
		param.put("rdpCreateDateTo2", toDate);
    	//프로시저 함수 호출
		enrollService.saveEnroll(param);
    	
    	//결과 뿌려보기 : 프로시저에서 p1이란 key값으로 객체를 반환한다.
    	List<EgovMap> resultMapList = (List<EgovMap>)param.get("p1");
    	
    	//Master Data 
    	EgovMap map = (EgovMap ) resultMapList.get(0);
    	
    	//Detail Data Search
    	List<EgovMap> resultList = enrollService.selectEnrollmentDetView(map);
    	
		// 파일 생성하기
    	if("2".equals(String.valueOf(map.get("bankId")))) {
    		this.createEnrollmentFileALB(map , resultList);
    		this.createEnrollmentFileNewALB(map , resultList);
    		
    	}else if("3".equals(String.valueOf(map.get("bankId")))){
    		this.createEnrollmentFileCIMB(map , resultList);
    		
    	}else if("21".equals(String.valueOf(map.get("bankId")))){
    		this.createEnrollmentFileMBB(map , resultList);
    		
    	}else if("7".equals(String.valueOf(map.get("bankId")))){
    		this.createEnrollmentFileRHB(map , resultList);
    		
    	}else if("9".equals(String.valueOf(map.get("bankId")))){
    		this.createEnrollmentFileBSN(map , resultList);
    		
    	}			

		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(map);
    	message.setMessage("Enrollment successfully saved. \n Enroll ID : ");
		
		return ResponseEntity.ok(message);
	}
	
	/**********************************************
	 *
	 * 파일 생성하기 
	 * 
	 ***********************************************/
	/**
	 * ALB - Enrollment File Create
	 * @param enrollMap
	 * @param enrollDetailList
	 * @throws Exception
	 */
	public void createEnrollmentFileALB(EgovMap enrollMap, List<EgovMap> enrollDetailList) throws Exception{
		
		String sFile = "ALB" + CommonUtils.changeFormat(String.valueOf(enrollMap.get("debtDtFrom")), "yyyy-MM-dd" , "yyyyMMdd") + "ENROLL01.txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/ALB/Enroll/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		 *  파일 내용 쓰기
		 ************************************************/
		//헤더 작성
		String sText = "H|ADCUSPRO|";
        
		out.write(sText);
		out.newLine();
		out.flush();
		
		//본문 작성
		String schksum = "";
        long iHashTot = 0;
        double iTotAmt = 0;
        long icntdel = 0;

        String sDocno = "";
        String sreserve = "";
        String sDrAccNo = "";
        String sOldIC = "";
        String sNRIC = "";
        String sDrName = "";
        String sLimit = "";
        String sFiller = "";
        String stextDetails = "";
        String sBatchTot = "";
        String sTotAdd = "";
        String sTotDel = "";
        String sHashTot = "";
        String sTextBtn = "";
		
		if (enrollDetailList.size() > 0) {
			for(int i = 0 ; i < enrollDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)enrollDetailList.get(i);
				
                sDocno = (String.valueOf(map.get("cntrctNOrdNo"))).trim();
                sreserve = StringUtils.leftPad(sreserve, 6, " ");
                sDrAccNo = StringUtils.leftPad((String.valueOf(map.get("accNo"))).trim(), 15 ," ");
                sOldIC = StringUtils.leftPad(sOldIC, 12, " ");
                
                sNRIC = (String.valueOf(map.get("accNric"))).trim();
                sDrName = (String.valueOf(map.get("accName"))).trim();
                sLimit = CommonUtils.getNumberFormat( String.valueOf(map.get("billAmt")), "####0.00");
                schksum = StringUtils.leftPad(String.valueOf(this.calChkSum(sDocno, sDrAccNo)),12,"0");
                sFiller = StringUtils.leftPad(sFiller, 54, " ");
                
                stextDetails = "D" + "|" + "101" + "|" + sDrName.toUpperCase().trim() + "|" + sNRIC.toUpperCase().trim() + "|" + sDrAccNo.toUpperCase().trim() + "|" + sLimit + "|" + "D" + "|" + sDocno + "|";
                iHashTot = iHashTot + Long.parseLong(schksum.trim());
				
				out.write(stextDetails);
				out.newLine();
				out.flush();
			}    		
		}
		
		//footer 작성
		sBatchTot = StringUtils.leftPad(String.valueOf(iTotAmt), 15, "0");
		sTotAdd = String.valueOf(enrollDetailList.size());
		sTotDel = StringUtils.leftPad(String.valueOf(icntdel), 6, "0");
		sHashTot = StringUtils.leftPad(String.valueOf(iHashTot), 12, "0");
		
		sTextBtn = "T|" + sTotAdd + "|";
        
		out.write(sTextBtn);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		String emailTitle = "ALB Enrollment File - Debit Date From" + String.valueOf(enrollMap.get("debtDtFrom")) + " To " + String.valueOf(enrollMap.get("debtDtTo"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	
	/**
	 * NEW ALB - Enrollment File Create
	 * @param enrollMap
	 * @param enrollDetailList
	 * @throws Exception
	 */
	public void createEnrollmentFileNewALB(EgovMap enrollMap, List<EgovMap> enrollDetailList) throws Exception{
		
		String todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
		String sFile = "AD_Enrolment_" + todayDate + ".txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/ALB/Enroll/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		 *  파일 내용 쓰기
		************************************************/
		//헤더 작성
		String hRecordType = "H"; 
		String hCreditAccNo = "140550010078613";
		String hCompanyName = "Coway (M) Sdn Bhd";
		String hFileBatchRefNo = String.valueOf(enrollMap.get("enrlId"));
		String hSellerID = "AD10000101";
		String HeaderStr = hRecordType + "|" + hCreditAccNo + "|" + hCompanyName + "|" + hFileBatchRefNo + "|" + hSellerID + "|";

        out.write(HeaderStr);
		out.newLine();
		out.flush();
		
		//본문 작성
		long hashTotal = 0;
        String dRecordType = "D";
        String dReqType = "C";
        String dDebtiAccNo = "";
        String dDebitAccName = "";
        String dBankCode = "MFBBMYKL";
        String dBuyerIDNo = "";
        String dMaxAmount = "";
        String dFreqMode = "M";
        String dNoFreq = "0008";
        String OrderNo = "";
        String SellerInternalRefNo = "";
        String CommencementDate = todayDate;
        String ExpiryDate = "31122099";
        String Email1 = "";
        String Email2 = "";
        String DetailStr = "";
		
		if (enrollDetailList.size() > 0) {
			for(int i = 0 ; i < enrollDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)enrollDetailList.get(i);
				
				dDebtiAccNo = (String.valueOf(map.get("accNo"))).length() > 17 ? (String.valueOf(map.get("accNo"))).substring(0,17) :  String.valueOf(map.get("accNo"));				
                dDebitAccName = (String.valueOf(map.get("accName"))).length() > 40 ? (String.valueOf(map.get("accName"))).substring(0,40) :  String.valueOf(map.get("accName"));
                dBuyerIDNo = (String.valueOf(map.get("accNric"))).length() > 20 ? (String.valueOf(map.get("accNric"))).substring(0,20) :  String.valueOf(map.get("accNric"));
                dMaxAmount =  CommonUtils.getNumberFormat( String.valueOf(map.get("billAmt")), "####0.00");
                OrderNo = (String.valueOf(map.get("cntrctNOrdNo"))).trim(); 

                hashTotal += Long.parseLong(CommonUtils.right(dDebtiAccNo, 10));

                DetailStr = dRecordType + "|" + dReqType + "|" + dDebtiAccNo + "|" + dDebitAccName + "|" +
                    dBankCode + "|" + dBuyerIDNo + "|" + dMaxAmount + "|" + dFreqMode + "|" + dNoFreq + "|" + OrderNo + "|" +
                    SellerInternalRefNo + "|" + CommencementDate + "|" + ExpiryDate + "|" + Email1 + "|" + Email2 + "|";
				
				out.write(DetailStr);
				out.newLine();
				out.flush();
				
			}    		
		}
		
		//footer 작성
		String tRecordType = "T";
		String tTotalRecord = String.valueOf(enrollDetailList.size());
		String tHashTotal = CommonUtils.getNumberFormat( String.valueOf(hashTotal), "0000000000");
		String TrailerStr = "";
        TrailerStr = tRecordType + "|" + tTotalRecord + "|" + tHashTotal + "|";
        
		out.write(TrailerStr);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		String emailTitle = "ALB Enrollment File - Debit Date From" + String.valueOf(enrollMap.get("debtDtFrom")) + " To " + String.valueOf(enrollMap.get("debtDtTo"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	
	
	/**
	 * CIMB - Enrollment File Create
	 * @param enrollMap
	 * @param enrollDetailList
	 * @throws Exception
	 */
	public void createEnrollmentFileCIMB(EgovMap enrollMap, List<EgovMap> enrollDetailList) throws Exception{
		
		String sFile = "CIMB" + CommonUtils.changeFormat(String.valueOf(enrollMap.get("debtDtFrom")), "yyyy-MM-dd" , "yyyyMMdd") + "E01.txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/CIMB/Enroll/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		 *  파일 내용 쓰기
		************************************************/
		String sRcdType = "50";
		String sDrAccNo = "";
		String sOrgCode = "2120";
		String sDrName = "";
		String sLimit = "";
		String sFixAmt = "00000000000000";
		String sDocno = "";
		String sNRIC = "";
		String sfreq = "00";
		String sfreql = "999";
		String sReserve = StringUtils.rightPad("", 85, " ");
		String stextDetails = "";
		
		if (enrollDetailList.size() > 0) {
			for(int i = 0 ; i < enrollDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)enrollDetailList.get(i);
				
				sDrAccNo = StringUtils.rightPad(String.valueOf(map.get("accNo")),14, " ");
				sDrName =  (String.valueOf(map.get("accName"))).trim().length() > 20 ?
                					(String.valueOf(map.get("accName"))).trim().substring(0,20) :
                						StringUtils.rightPad((String.valueOf(map.get("accName"))).trim(),20," ");
                sLimit = String.valueOf(((java.math.BigDecimal) map.get("billAmt")).longValue()  * 100);
                sDocno = (String.valueOf(map.get("cntrctNOrdNo"))).trim().length() > 30 ?
                					(String.valueOf(map.get("cntrctNOrdNo"))).trim().substring(0,30) :
                						StringUtils.rightPad((String.valueOf(map.get("cntrctNOrdNo"))).trim(),30," ");
                sDrName = (String.valueOf(map.get("accName"))).trim().length() > 20 ?
                					(String.valueOf(map.get("accName"))).trim().substring(0,20) :
                						StringUtils.rightPad((String.valueOf(map.get("accName"))).trim(),20," ");
                sNRIC = (String.valueOf(map.get("accNric"))).trim().length() > 12 ?
                					(String.valueOf(map.get("accNric"))).trim().substring(0,12) :
                						StringUtils.rightPad((String.valueOf(map.get("accNric"))).trim(),12," ");
                
                		
                stextDetails = sRcdType + sDrAccNo + sOrgCode + sDrName + sLimit + sFixAmt + sDocno + sNRIC + sfreq + sfreql + sReserve;
				
				out.write(stextDetails);
				out.newLine();
				out.flush();
			}    		
		}
		
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		String emailTitle = "CIMB Enrollment File - Debit Date From" + String.valueOf(enrollMap.get("debtDtFrom")) + " To " + String.valueOf(enrollMap.get("debtDtTo"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	
	/**
	 * MBB - Enrollment File Create
	 * @param enrollMap
	 * @param enrollDetailList
	 * @throws Exception
	 */
	public void createEnrollmentFileMBB(EgovMap enrollMap, List<EgovMap> enrollDetailList) throws Exception{
		
		String sFile = "EnrollMBB.txt";
		long iHashTot = 0;
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/MBB/Enroll/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		*  파일 내용 쓰기
		************************************************/
		//헤더 작성
		String strHeader = "";
        String strHeader_Fix = "ENROL";
        String strHeader_BankCode = "27";
        String strHeader_OriginatorID = "02172";
        String strHeader_OriginatorName = StringUtils.rightPad("WJIN COWAY", 13, " ");
        
        String strHeader_EnrollDate = CommonUtils.changeFormat(String.valueOf(enrollMap.get("debtDtFrom")), "yyyy-MM-dd" , "yyyyMMdd");
        String strHeader_Filler = StringUtils.rightPad("", 117, " ");
        
        strHeader = strHeader_Fix + strHeader_BankCode + strHeader_OriginatorID +
        					strHeader_OriginatorName + strHeader_EnrollDate + strHeader_Filler;
    	        
        out.write(strHeader);
		out.newLine();
		out.flush();
		
		//본문 작성
		if (enrollDetailList.size() > 0) {
			for(int i = 0 ; i < enrollDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)enrollDetailList.get(i);
				
				String strRecord = "";
				String strRecord_Fix = "00";
				String strRecord_TransCode = "A";
				String strRecord_RefNo =  (String.valueOf(map.get("cntrctNOrdNo"))).trim().length() > 14 ?
						 								(String.valueOf(map.get("cntrctNOrdNo"))).trim().substring(0,14) :
						 										StringUtils.rightPad((String.valueOf(map.get("cntrctNOrdNo"))).trim(), 14, " ");
				String strRecord_Reserve = StringUtils.rightPad("", 6, " ");
				String strRecord_AccNo =  (String.valueOf(map.get("accNo"))).trim().length() > 12 ?
						 								(String.valueOf(map.get("accNo"))).trim().substring(0,12) :
						 									StringUtils.rightPad((String.valueOf(map.get("accNo"))).trim(), 12, " ");
				String strRecord_IssueIC = (String.valueOf(map.get("accNric"))).trim();
				String strRecord_OldIC = "";
				String strRecord_NRIC = "";
				
                if (strRecord_IssueIC.length() >= 12) {
                    strRecord_OldIC = StringUtils.rightPad("", 12, " ");                    
                    strRecord_NRIC = strRecord_IssueIC.substring(0,  12);
                } else {
                    strRecord_OldIC = StringUtils.rightPad(strRecord_IssueIC, 12, " ");  
                    strRecord_NRIC = StringUtils.rightPad("", 12, " ");
                }
                
                String strRecord_Name =  (String.valueOf(map.get("accName"))).trim().length() > 20 ?
                										(String.valueOf(map.get("accName"))).trim().substring(0,20) :
                											StringUtils.rightPad((String.valueOf(map.get("accName"))).trim(), 20, " ");
                
                String strRecord_AuthLimit = StringUtils.leftPad(CommonUtils.getNumberFormat( String.valueOf(map.get("billAmt")), "00000"),5,"0");
                String strRecord_ValidValue = "";
                int validValue = this.calChkSum((String.valueOf( map.get("cntrctNOrdNo"))).trim(), (String.valueOf(map.get("accNo"))).trim());
                strRecord_ValidValue = StringUtils.leftPad(String.valueOf(validValue), 12, "0");
                String strRecord_Filler = StringUtils.rightPad("", 54, " ");
                
                strRecord = strRecord_Fix + strRecord_TransCode + strRecord_RefNo + strRecord_Reserve +
                					strRecord_AccNo + strRecord_OldIC + strRecord_NRIC + strRecord_Name +
                					strRecord_AuthLimit + strRecord_ValidValue + strRecord_Filler;
                iHashTot = iHashTot + validValue;
				
				out.write(strRecord);
				out.newLine();
				out.flush();
			}    		
		}
		
		
		//footer 작성
        String strTrailer = "";
        String strTrailer_Fix = "FF";
        String strTrailer_TotalAdd = StringUtils.leftPad(String.valueOf(enrollDetailList.size()),6,"0");        
        String strTrailer_TotalDel = StringUtils.leftPad("", 6, "0");        
        String strTrailer_HashTotal = StringUtils.leftPad(String.valueOf(iHashTot),12,"0");        
        String strTrailer_Filler = StringUtils.rightPad("", 124, " ");
        
        strTrailer = strTrailer_Fix + strTrailer_TotalAdd + strTrailer_TotalDel + strTrailer_HashTotal + strTrailer_Filler;
        
        out.write(strTrailer);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		String emailTitle = "MBB Enrollment File - Debit Date From" + String.valueOf(enrollMap.get("debtDtFrom")) + " To " + String.valueOf(enrollMap.get("debtDtTo"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	
	
	/**
	 * RHB - Enrollment File Create
	 * @param enrollMap
	 * @param enrollDetailList
	 * @throws Exception
	 */
	public void createEnrollmentFileRHB(EgovMap enrollMap, List<EgovMap> enrollDetailList) throws Exception{
		
		String todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyy");
		String sFile = "AB_00035_AutoMaint_" + todayDate + ".txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/RHB/Enroll/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		*  파일 내용 쓰기
		************************************************/
		String sDrAccNo = "";
        String sbiller = "00035";
        String sDocno = "";
        String sLimit = "";
        String sDrName = "";
        String sOldIC = "";
        String stextDetails = "";
        String sSrvChg = "N";
        String sSrvChgAmt = StringUtils.rightPad("", 9, "0");
        String sCommRate = StringUtils.rightPad("", 5, "0");
        String sMinComm =StringUtils.rightPad("", 9, "0");
        String sMaxComm = StringUtils.rightPad("", 9, "0");
        String sReserve = StringUtils.rightPad("", 266, " ");
		
        if (enrollDetailList.size() > 0) {
        	for(int i = 0 ; i < enrollDetailList.size() ; i++){
        		Map<String, Object> map = (Map<String, Object>)enrollDetailList.get(i);
				
				sDrAccNo = StringUtils.rightPad((String.valueOf(map.get("accNo"))).trim(),14," ");                
                sDocno = (String.valueOf(map.get("cntrctNOrdNo"))).trim().length() > 20 ?
                				(String.valueOf(map.get("cntrctNOrdNo"))).trim().substring(0,20) : 
                					StringUtils.rightPad((String.valueOf(map.get("cntrctNOrdNo"))).trim(),20," ");
                sLimit = CommonUtils.getNumberFormat( String.valueOf((((java.math.BigDecimal)map.get("billAmt")).intValue() * 100)), "000000000000000");
                sDrName = (String.valueOf(map.get("accName"))).trim().length() > 35 ?
                		(String.valueOf(map.get("accName"))).trim().substring(0,35) : 
                			StringUtils.rightPad((String.valueOf(map.get("accName"))).trim(),35," ");
                sOldIC = (String.valueOf(map.get("accNric"))).trim().length() > 12 ?
                		(String.valueOf(map.get("accNric"))).trim().substring(0,12) : 
                			StringUtils.rightPad((String.valueOf(map.get("accNric"))).trim(),12," ");
                
                stextDetails = sDrAccNo + sbiller + sDocno + sLimit + sDrName + sOldIC +
                    sSrvChg + sSrvChgAmt + sCommRate + sMinComm + sMaxComm + sReserve;
				
				out.write(stextDetails);
				out.newLine();
				out.flush();
			
        	}    		
		}
		
		out.close();
		fileWriter.close();
		
		//메일 보내기는 나중에
		String emailTitle = "RHB Enrollment File - Debit Date From" + String.valueOf(enrollMap.get("debtDtFrom")) + " To " + String.valueOf(enrollMap.get("debtDtTo"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	
	/**
	 * BSN - Enrollment File Create
	 * @param enrollMap
	 * @param enrollDetailList
	 * @throws Exception
	 */
	public void createEnrollmentFileBSN(EgovMap enrollMap, List<EgovMap> enrollDetailList) throws Exception{
		
		String sFile = "BSN" + CommonUtils.changeFormat(String.valueOf(enrollMap.get("debtDtFrom")), "yyyy-MM-dd" , "yyyyMMdd") + "E01.txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/BSN/Enroll/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		*  파일 내용 쓰기
		************************************************/
		String sDocno = "";
		String sDrAccNo = "";
		String sFiller = "";
		String stextDetails = "";
		String sorigid = "M4743600";
		String sOrgAcc = "1410029000510851";
		
		if (enrollDetailList.size() > 0) {
			for(int i = 0 ; i < enrollDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)enrollDetailList.get(i);
				
				sDocno = StringUtils.rightPad((String.valueOf(map.get("cntrctNOrdNo"))).trim(),20," ");
				sDrAccNo = StringUtils.leftPad((String.valueOf(map.get("accNo"))).trim(),16," ");
                sFiller = StringUtils.leftPad(sFiller,20," ");
                
                stextDetails = sorigid + sOrgAcc + sDrAccNo + sDocno + sFiller;
				
				out.write(stextDetails);
				out.newLine();
				out.flush();
			}    		
		}
		
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		String emailTitle = "BSN Enrollment File - Debit Date From" + String.valueOf(enrollMap.get("debtDtFrom")) + " To " + String.valueOf(enrollMap.get("debtDtTo"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}

	/**
	 * 
	 * @param sBillNo
	 * @param sAccNo
	 * @return
	 */
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
