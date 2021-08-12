package com.coway.trust.web.payment.autodebit.controller;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.biz.payment.autodebit.service.EnrollH2HService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.claim.ClaimFileALBHandler;
/*import com.coway.trust.web.common.claim.ClaimFileCIMBHandler;
import com.coway.trust.web.common.claim.ClaimFileCrcCIMBHandler;
import com.coway.trust.web.common.claim.ECashDeductionFileCIMBHandler;
import com.coway.trust.web.common.claim.FileInfoVO;
import com.coway.trust.web.common.claim.FormDef;
*/
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class enrollmentH2HController {

	private static final Logger LOGGER = LoggerFactory.getLogger(enrollmentH2HController.class);

	@Value("${autodebit.file.upload.path}")
	private String filePath;

	@Value("${autodebit.email.receiver}")
	private String emailReceiver;

	@Autowired
	private AdaptorService adaptorService;

	@Resource(name = "enrollH2HService")
	private EnrollH2HService enrollH2HService;

	@Autowired
	private LargeExcelService largeExcelService;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	private String[] enrollItemColumns = new String[] { "enrollmentId", "stusName", "bankName", "debtDt",
			"crtDt", "crtName", "updDt", "updName", "salesOrderId", "accName",
			"accNric", "limitAmt", "billAmt", "appvDt" };


	@RequestMapping(value = "/enrollmentH2H.do")
	public String initSearchPayment(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/autodebit/enrollmentH2H";
	}

	@RequestMapping(value = "/selectEnrollmentH2H", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectEnrollmentH2H(@ModelAttribute("searchVO") SampleDefaultVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {
		// 조회.
        List<EgovMap> resultList = enrollH2HService.selectEnrollmentH2H(params);

        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectH2HEnrollmentById.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectH2HEnrollmentById(@ModelAttribute("searchVO") SampleDefaultVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {

        List<EgovMap> resultList = enrollH2HService.selectEnrollmentH2HListById(params);

        return ResponseEntity.ok(resultList);
	}


	@RequestMapping(value = "/selectH2HEnrollmentSubListById.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectH2HEnrollmentSubListById(@ModelAttribute("searchVO") SampleDefaultVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {

        List<EgovMap> resultList = enrollH2HService.selectH2HEnrollmentSubListById(params);

        return ResponseEntity.ok(resultList);
	}


	@RequestMapping(value = "/selectH2HEnrollmentListById.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectH2HEnrollmentListById(@ModelAttribute("searchVO") SampleDefaultVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap returnMap = null;
		// 조회.
        List<EgovMap> resultList = enrollH2HService.selectEnrollmentH2HListById(params);

        if(resultList != null && resultList.size() > 0){
        	returnMap = resultList.get(0);
        }else{
        	returnMap = new EgovMap();
        }

        // 조회 결과 리턴.
        return ResponseEntity.ok(returnMap);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/generateNewEEnrollment.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> generateNewEEnrollment(@RequestParam Map<String, Object> params,
    		Model model, SessionVO sessionVO) throws Exception {
		String returnCode = "";
		String frDate = CommonUtils.changeFormat(String.valueOf(params.get("debitDt3")), "dd/MM/yyyy","yyyyMMdd");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("issueBank", params.get("new_issueBank"));
		param.put("debitDt1", frDate);
		// param.put("rdpCreateDateTo2", toDate);
		param.put("userId", sessionVO.getUserId());
		// 프로시저 함수 호출
		enrollH2HService.generateNewEEnrollment(param);
		List<EgovMap> h2hList = (List<EgovMap>) param.get("p1");
		EgovMap h2hMap = null;

		if (h2hList.size() > 0) {
			returnCode = "FILE_OK";
			h2hMap = (EgovMap) h2hList.get(0);
			List<EgovMap> resultH2HList = enrollH2HService.selectEnrollmentH2HListById(h2hMap);


			createEnrollmentH2HFileCIMB(h2hMap, resultH2HList);
		}
		else{
			returnCode = "FAIL";
		}
        // 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(returnCode);
    	message.setData(h2hMap);
    	message.setMessage("Claim successfully saved. \n File Batch ID : ");

		return ResponseEntity.ok(message);

    }


	public void createEnrollmentH2HFileCIMB(EgovMap enrollH2HMap, List<EgovMap> enrollH2HDetailList) throws Exception {

		String sFile = "MANDATE_ORG2120_"
				+ CommonUtils.changeFormat(String.valueOf(enrollH2HMap.get("debtDt")), "dd/MM/yyyy", "ddMMyy")
				+ ".txt";

		// 파일 디렉토리
		File file = new File(filePath + "/FTPFolder/H2H eEnrollment/CIMB/" + sFile);

		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}

		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);

		// ************************************************
		// * 파일 내용 쓰기
		// *************************************************
		String sRcdType = "50";
		String sDrAccNo = "";
		String sOrgCode = "2120";
		String sDrName = "";
		String sLimit = "";
		String sFixAmt = "00000000000000";
		String sDocno = "";
		String sNRIC = "000000000000";
		String sfreq = "00";
		String sfreql = "999";
		String sReserve = StringUtils.rightPad("", 85, " ");
		String stextDetails = "";

		BigDecimal amount = null;
		BigDecimal hunred = new BigDecimal(100);

		String fixLimit = null;

		if (enrollH2HDetailList.size() > 0) {
			for (int i = 0; i < enrollH2HDetailList.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) enrollH2HDetailList.get(i);

				sDrAccNo = StringUtils.rightPad(String.valueOf(map.get("accNo")), 14, " ");
				sDrName = (String.valueOf(map.get("accName"))).trim().length() > 20
						? (String.valueOf(map.get("accName"))).trim().substring(0, 20)
						: StringUtils.rightPad((String.valueOf(map.get("accName"))).trim(), 20, " ");

				// sLimit = String.valueOf(((java.math.BigDecimal) map.get("billAmt")).longValue() * 100);
				// 금액 계산
				amount = (BigDecimal) map.get("billAmt");
				sLimit = String.valueOf((amount.multiply(hunred).longValue()));
								fixLimit = StringUtils.leftPad(sLimit, 14, '0');

				sDocno = (String.valueOf(map.get("cntrctNOrdNo"))).trim().length() > 30
						? (String.valueOf(map.get("cntrctNOrdNo"))).trim().substring(0, 30)
						: StringUtils.rightPad((String.valueOf(map.get("cntrctNOrdNo"))).trim(), 30, " ");
				sDrName = (String.valueOf(map.get("accName"))).trim().length() > 20
						? (String.valueOf(map.get("accName"))).trim().substring(0, 20)
						: StringUtils.rightPad((String.valueOf(map.get("accName"))).trim(), 20, " ");
				/*sNRIC = (String.valueOf(map.get("accNric"))).trim().length() > 12
						? (String.valueOf(map.get("accNric"))).trim().substring(0, 12)
						: StringUtils.rightPad((String.valueOf(map.get("accNric"))).trim(), 12, " ");*/

				stextDetails = sRcdType + sDrAccNo + sOrgCode + sDrName + fixLimit + sFixAmt + sDocno + sNRIC + sfreq
						+ sfreql + sReserve;

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
		email.setSubject("CIMB E-Enrollment File - Debit Date From" + enrollH2HMap.get("debtDt") + " To "
				+ enrollH2HMap.get("debtDt"));
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);

	}


		@RequestMapping(value = "/createEEnrollment.do", method = RequestMethod.GET)
		public ResponseEntity<ReturnMessage> createEEnrollment(@RequestParam Map<String, Object> params,
	    		Model model, SessionVO sessionVO) throws Exception {
			Map<String, Object> param = new HashMap<String, Object>();

			param.put("enrollId", params.get("enrollmentId"));

			LOGGER.debug("param : "+ param);

			List<EgovMap> h2hList = enrollH2HService.selectEnrollmentH2HById(param);
			EgovMap h2hMap = null;

			if (h2hList.size() > 0) {
				h2hMap = (EgovMap) h2hList.get(0);

				//LOGGER.debug("H2HMap : " + h2hMap);
				List<EgovMap> resultH2HList = enrollH2HService.selectEnrollmentH2HListById(h2hMap);

				createEnrollmentH2HFileCIMB(h2hMap, resultH2HList);
			}

			// 결과 만들기
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);

		}

		@RequestMapping(value = "/eEnrollmentDeactivate.do", method = RequestMethod.GET)
	    public ResponseEntity<ReturnMessage> eEnrollmentDeactivate(@RequestParam Map<String, Object> params,
	    		Model model, SessionVO sessionVO) {
			params.put("enrollId", params.get("enrollmentId"));
			params.put("userId", sessionVO.getUserId());
	    	// 처리.
			enrollH2HService.deactivateEEnrollmentStatus(params);

			// 결과 만들기.
			ReturnMessage message = new ReturnMessage();
	    	message.setCode(AppConstants.SUCCESS);
	    	message.setMessage("Saved Successfully");

	    	return ResponseEntity.ok(message);
	    }
}
