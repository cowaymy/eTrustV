package com.coway.trust.web.payment.autodebit.controller;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.payment.autodebit.service.EnrollService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class EnrollController {

	@Resource(name = "enrollService")
	private EnrollService enrollService ;

	@Autowired
	private AdaptorService adaptorService;

	@Value("${autodebit.file.upload.path}")
	private String filePath;

	@Value("${autodebit.email.receiver}")
	private String emailReceiver;


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
		List<EgovMap> resultList = enrollService.selectViewEnrollmentList(params);

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("enrollInfo", enrollInfo);
		result.put("resultList", resultList);

		return ResponseEntity.ok(result);
	}

	/**
	 * Save Enroll
	 */
	@RequestMapping(value = "/saveEnroll", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveEnroll(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception{

		String frDate = CommonUtils.nvl(params.get("rdpCreateDateFr2")).equals("") ? "01/01/1900" : CommonUtils.nvl(params.get("rdpCreateDateFr2"));
		String toDate = CommonUtils.nvl(params.get("rdpCreateDateTo2")).equals("") ? "01/01/1900" : CommonUtils.nvl(params.get("rdpCreateDateTo2"));

		//parameter 객체를 생성한다. 프로시저에서 CURSOR 반환시 해당 paramter 객체에 리스트를 세팅한다.
    	//프로시저에서 사용하는 parameter가 없어도 객체는 생성한다.
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("cmbIssueBank2", params.get("cmbIssueBank2"));
		param.put("rdpCreateDateFr2", frDate);
		param.put("rdpCreateDateTo2", toDate);
		param.put("userId", sessionVO.getUserId());
    	//프로시저 함수 호출
		enrollService.saveEnroll(param);

    	//결과 뿌려보기 : 프로시저에서 p1이란 key값으로 객체를 반환한다.
    	List<EgovMap> p1List = (List<EgovMap>)param.get("p1");
    	EgovMap map = null;

    	if(p1List.size() > 0){

    		//Master Data
        	map = (EgovMap ) p1List.get(0);

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
		File file = new File(filePath + "/ALB/Enroll/" + sFile);

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

		// E-mail 전송하기
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("ALB Enrollment File - Debit Date From" + enrollMap.get("debtDtFrom") + " To " + enrollMap.get("debtDtTo"));
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
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
		File file = new File(filePath + "/ALB/Enroll/" + sFile);

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
		String hCreditAccNo = "140550010179955";
		String hCompanyName = "Coway (M) Sdn Bhd";
		String hFileBatchRefNo = String.valueOf(enrollMap.get("enrlId"));
		String hSellerID = "AD10000101";
		String headerStr = hRecordType + "|" + hCreditAccNo + "|" + hCompanyName + "|" + hFileBatchRefNo + "|" + hSellerID + "|";

        out.write(headerStr);
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
        String orderNo = "";
        String sellerInternalRefNo = "";
        String commencementDate = todayDate;
        String expiryDate = "31122099";
        String email1 = "";
        String email2 = "";
        String detailStr = "";

		if (enrollDetailList.size() > 0) {
			for(int i = 0 ; i < enrollDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)enrollDetailList.get(i);

				dDebtiAccNo = (String.valueOf(map.get("accNo"))).length() > 17 ? (String.valueOf(map.get("accNo"))).substring(0,17) :  String.valueOf(map.get("accNo"));
                dDebitAccName = (String.valueOf(map.get("accName"))).length() > 40 ? (String.valueOf(map.get("accName"))).substring(0,40) :  String.valueOf(map.get("accName"));
                dBuyerIDNo = (String.valueOf(map.get("accNric"))).length() > 20 ? (String.valueOf(map.get("accNric"))).substring(0,20) :  String.valueOf(map.get("accNric"));
                dMaxAmount =  CommonUtils.getNumberFormat( String.valueOf(map.get("billAmt")), "####0.00");
                orderNo = (String.valueOf(map.get("cntrctNOrdNo"))).trim();

                hashTotal += Long.parseLong(CommonUtils.right(dDebtiAccNo, 10));

                detailStr = dRecordType + "|" + dReqType + "|" + dDebtiAccNo + "|" + dDebitAccName + "|" +
                    dBankCode + "|" + dBuyerIDNo + "|" + dMaxAmount + "|" + dFreqMode + "|" + dNoFreq + "|" + orderNo + "|" +
                    sellerInternalRefNo + "|" + commencementDate + "|" + expiryDate + "|" + email1 + "|" + email2 + "|";

				out.write(detailStr);
				out.newLine();
				out.flush();

			}
		}

		//footer 작성
		String tRecordType = "T";
		String tTotalRecord = String.valueOf(enrollDetailList.size());
		String tHashTotal = CommonUtils.getNumberFormat( String.valueOf(hashTotal), "0000000000");
		String trailerStr = "";
        trailerStr = tRecordType + "|" + tTotalRecord + "|" + tHashTotal + "|";

		out.write(trailerStr);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();

		// E-mail 전송하기
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("ALB Enrollment File - Debit Date From" + enrollMap.get("debtDtFrom") + " To " + enrollMap.get("debtDtTo"));
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
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
		File file = new File(filePath + "/CIMB/Enroll/" + sFile);

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

		BigDecimal amount = null;
		BigDecimal hunred = new BigDecimal(100);

		if (enrollDetailList.size() > 0) {
			for(int i = 0 ; i < enrollDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)enrollDetailList.get(i);

				sDrAccNo = StringUtils.rightPad(String.valueOf(map.get("accNo")),14, " ");
				sDrName =  (String.valueOf(map.get("accName"))).trim().length() > 20 ?
                					(String.valueOf(map.get("accName"))).trim().substring(0,20) :
                						StringUtils.rightPad((String.valueOf(map.get("accName"))).trim(),20," ");


                //sLimit = String.valueOf(((java.math.BigDecimal) map.get("billAmt")).longValue()  * 100);
            	//금액 계산
        		amount = (BigDecimal)map.get("billAmt");
        		sLimit = String.valueOf(amount.multiply(hunred).longValue());

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

		// E-mail 전송하기
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("CIMB Enrollment File - Debit Date From" + enrollMap.get("debtDtFrom") + " To " + enrollMap.get("debtDtTo"));
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);

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
		File file = new File(filePath + "/MBB/Enroll/" + sFile);

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
        String strHeaderFix = "ENROL";
        String strHeaderBankCode = "27";
        String strHeaderOriginatorID = "02172";
        //String strHeaderOriginatorName = StringUtils.rightPad("WJIN COWAY", 13, " ");
        String strHeaderOriginatorName = StringUtils.rightPad("WOONGJINCOWAY", 13, " ");

        String strHeaderEnrollDate = CommonUtils.changeFormat(String.valueOf(enrollMap.get("debtDtFrom")), "yyyy-MM-dd" , "ddMMyyyy");
        String strHeaderFiller = StringUtils.rightPad("", 114, " ");

        strHeader = strHeaderFix + strHeaderBankCode + strHeaderOriginatorID +
        					strHeaderOriginatorName + strHeaderEnrollDate + strHeaderFiller;

        out.write(strHeader);
		out.newLine();
		out.flush();

		//본문 작성
		if (enrollDetailList.size() > 0) {
			for(int i = 0 ; i < enrollDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)enrollDetailList.get(i);

				String strRecord = "";
				String strRecordFix = "00";
				String strRecordTransCode = "A";
				String strRecordRefNo =  (String.valueOf(map.get("cntrctNOrdNo"))).trim().length() > 14 ?
						 								(String.valueOf(map.get("cntrctNOrdNo"))).trim().substring(0,14) :
						 										StringUtils.rightPad((String.valueOf(map.get("cntrctNOrdNo"))).trim(), 14, " ");
				String strRecordReserve = StringUtils.rightPad("", 6, " ");
				String strRecordAccNo =  (String.valueOf(map.get("accNo"))).trim().length() > 12 ?
						 								(String.valueOf(map.get("accNo"))).trim().substring(0,12) :
						 									StringUtils.rightPad((String.valueOf(map.get("accNo"))).trim(), 12, " ");
				String strRecordIssueIC = (String.valueOf(map.get("accNric"))).trim();
				String strRecordOldIC = "";
				String strRecordNRIC = "";

                if (strRecordIssueIC.length() >= 12) {
                    strRecordOldIC = StringUtils.rightPad("", 12, " ");
                    strRecordNRIC = strRecordIssueIC.substring(0,  12);
                } else {
                    strRecordOldIC = StringUtils.rightPad(strRecordIssueIC, 12, " ");
                    strRecordNRIC = StringUtils.rightPad("", 12, " ");
                }

                String strRecordName =  (String.valueOf(map.get("accName"))).trim().length() > 20 ?
                										(String.valueOf(map.get("accName"))).trim().substring(0,20) :
                											StringUtils.rightPad((String.valueOf(map.get("accName"))).trim(), 20, " ");

                String strRecordAuthLimit = StringUtils.leftPad(CommonUtils.getNumberFormat( String.valueOf(map.get("billAmt")), "00000"),5,"0");
                String strRecordValidValue = "";
                int validValue = this.calChkSum((String.valueOf( map.get("cntrctNOrdNo"))).trim(), (String.valueOf(map.get("accNo"))).trim());
                strRecordValidValue = StringUtils.leftPad(String.valueOf(validValue), 12, "0");
                String strRecordFiller = StringUtils.rightPad("", 54, " ");

                strRecord = strRecordFix + strRecordTransCode + strRecordRefNo + strRecordReserve +
                					strRecordAccNo + strRecordOldIC + strRecordNRIC + strRecordName +
                					strRecordAuthLimit + strRecordValidValue + strRecordFiller;
                iHashTot = iHashTot + validValue;

				out.write(strRecord);
				out.newLine();
				out.flush();
			}
		}


		//footer 작성
        String strTrailer = "";
        String strTrailerFix = "FF";
        String strTrailerTotalAdd = StringUtils.leftPad(String.valueOf(enrollDetailList.size()),6,"0");
        String strTrailerTotalDel = StringUtils.leftPad("", 6, "0");
        String strTrailerHashTotal = StringUtils.leftPad(String.valueOf(iHashTot),12,"0");
        String strTrailerFiller = StringUtils.rightPad("", 124, " ");

        strTrailer = strTrailerFix + strTrailerTotalAdd + strTrailerTotalDel + strTrailerHashTotal + strTrailerFiller;

        out.write(strTrailer);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();

		// E-mail 전송하기
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("MBB Enrollment File - Debit Date From" + enrollMap.get("debtDtFrom") + " To " + enrollMap.get("debtDtTo"));
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
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
		File file = new File(filePath + "/RHB/Enroll/" + sFile);

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

        BigDecimal amount = null;
    	BigDecimal hunred = new BigDecimal(100);


        if (enrollDetailList.size() > 0) {
        	for(int i = 0 ; i < enrollDetailList.size() ; i++){
        		Map<String, Object> map = (Map<String, Object>)enrollDetailList.get(i);

				sDrAccNo = StringUtils.rightPad((String.valueOf(map.get("accNo"))).trim(),14," ");
                sDocno = (String.valueOf(map.get("cntrctNOrdNo"))).trim().length() > 20 ?
                				(String.valueOf(map.get("cntrctNOrdNo"))).trim().substring(0,20) :
                					StringUtils.rightPad((String.valueOf(map.get("cntrctNOrdNo"))).trim(),20," ");
                //sLimit = CommonUtils.getNumberFormat( String.valueOf((((java.math.BigDecimal)map.get("billAmt")).intValue() * 100)), "000000000000000");

                //금액 계산
        		amount = (BigDecimal)map.get("billAmt");
        		sLimit = CommonUtils.getNumberFormat( String.valueOf(amount.multiply(hunred).longValue()), "000000000000000");

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

		// E-mail 전송하기
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("RHB Enrollment File - Debit Date From" + enrollMap.get("debtDtFrom") + " To " + enrollMap.get("debtDtTo"));
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
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
		File file = new File(filePath + "/BSN/Enroll/" + sFile);

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

		// E-mail 전송하기
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("BSN Enrollment File - Debit Date From" + enrollMap.get("debtDtFrom") + " To " + enrollMap.get("debtDtTo"));
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
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
