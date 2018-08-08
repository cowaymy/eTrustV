package com.coway.trust.web.payment.ecash.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
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
import com.coway.trust.biz.payment.ecash.service.ECashDeductionService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.claim.ClaimFileALBHandler;
import com.coway.trust.web.common.claim.ClaimFileCIMBHandler;
import com.coway.trust.web.common.claim.ClaimFileCrcCIMBHandler;
import com.coway.trust.web.common.claim.ECashDeductionFileCIMBHandler;
import com.coway.trust.web.common.claim.ECashDeductionFileMBBHandler;
import com.coway.trust.web.common.claim.ECashGrpDeductionFileCIMBHandler;
import com.coway.trust.web.common.claim.ECashGrpDeductionFileMBBHandler;
import com.coway.trust.web.common.claim.FileInfoVO;
import com.coway.trust.web.common.claim.FormDef;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class ECashDeductionController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ECashDeductionController.class);

	@Value("${autodebit.file.upload.path}")
	private String filePath;

	@Value("${autodebit.email.receiver}")
	private String emailReceiver;

	@Autowired
	private AdaptorService adaptorService;

	@Resource(name = "eCashDeductionService")
	private ECashDeductionService eCashDeductionService;

	@Autowired
	private LargeExcelService largeExcelService;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	private String[] claimFileColumns = new String[] { "bankDtlId", "bankDtlCtrlId", "salesOrdId", "bankDtlDrDt",
			"bankDtlDrBankTypeId", "bankDtlDrAccNo", "bankDtlDrName", "bankDtlAmt", "taskId", "crtUserId",
			"crtDt", "updUserId", "updDt", "bankDtlDrNric", "bankDtlRenStus", "svcCntrctId", "bankDtlBankId",
			"bankAppv", "bankDtlApprDt", "bic", "bankDtlFpxId", "fpxCode", "salesOrdNo", "bankDtlRptAmt",
			"bankDtlRenAmt", "bankDtlCrcExpr", "srvCntrctRefNo", "billNo", "cntrctNOrdNo" };

	/******************************************************
	 * Claim List
	 *****************************************************/
	/**
	 * ClaimList 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/eCashDeductionList.do")
	public String eCashDeductionList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/ecash/eCashDeductionList";
	}

	/**
	 * Claim List List(Master Grid) 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectECashDeductList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectECashDeductList(@ModelAttribute("searchVO") SampleDefaultVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {
		// 조회.
        List<EgovMap> resultList = eCashDeductionService.selectECashDeductList(params);

        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/generateNewEDeduction.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> generateNewEDeduction(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model, SessionVO sessionVO) {

		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

		Map<String, Object> returnMap = new HashMap<String, Object>();
		Map<String, Object> searchMap = null;
		String returnCode = "";

    	//form 객체 값을 담을 Map
    	Map<String, Object> eCashDeduction = new HashMap<String, Object>();

    	//form 객체 데이터 세팅
    	if (formList.size() > 0) {
    		formList.forEach(obj -> {
                Map<String, Object> map = (Map<String, Object>) obj;
                eCashDeduction.put((String)map.get("name"),map.get("value"));
    		});
    	}
		//검색 파라미터 확인.(화면 Form객체 입력값)
    	LOGGER.debug("claimType : {}", eCashDeduction.get("claimType"));
    	LOGGER.debug("new_issueBank : {}", eCashDeduction.get("new_issueBank"));
    	LOGGER.debug("cardType : {}", eCashDeduction.get("new_cardType"));

    	int isGrp = eCashDeduction.get("v_isGrp") != null ? 1 : 0;
		// HasActiveBatch : 동일한 bankId, eCashDeduction Type 에 해당하는 active 건이 있는지 확인한다.
		searchMap = new HashMap<String, Object>();
		searchMap.put("issueBank", eCashDeduction.get("new_issueBank"));
		//searchMap.put("claimType", eCashDeduction.get("claimType"));
		searchMap.put("status", "1");

        List<EgovMap> isActiveBatchList = eCashDeductionService.selectECashDeductList(searchMap);

        //Active인 배치가 있는 경우
        if(isActiveBatchList.size() > 0){
        	returnCode = "IS_BATCH";
        	returnMap = (Map<String, Object>)isActiveBatchList.get(0);
        }else{
        	String bankId  = CommonUtils.nvl(String.valueOf(eCashDeduction.get("new_issueBank")));
        	String cardType  = CommonUtils.nvl(String.valueOf(eCashDeduction.get("new_cardType")));

        	eCashDeduction.put("new_issueBank", bankId);
        	eCashDeduction.put("new_cardType", cardType);
        	eCashDeduction.put("new_isGrp", isGrp);
        	eCashDeduction.put("userId", sessionVO.getUserId());

        	eCashDeductionService.createECashDeduction(eCashDeduction);		        	//프로시저 함수 호출
        	List<EgovMap> resultMapList = (List<EgovMap>)eCashDeduction.get("eCash");         	//결과 뿌려보기 : 프로시저에서 p1이란 key값으로 객체를 반환한다.

        	if(resultMapList.size() > 0){
        		//프로시저 결과 Map
        		returnMap = (Map<String, Object>)resultMapList.get(0);
        		returnCode = "FILE_OK";
        	}else{
        		returnCode = "FAIL";
        	}
        }

        // 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(returnCode);
    	message.setData(returnMap);
    	message.setMessage("Claim successfully saved. \n File Batch ID : ");

		return ResponseEntity.ok(message);

    }

	/**
	 * E-Cash By Id  (Master Grid) 조회 -
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectECashDeductionById.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectECashDeductionById(@ModelAttribute("searchVO") SampleDefaultVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap returnMap = null;
		// 조회.
        List<EgovMap> resultList = eCashDeductionService.selectECashDeductList(params);

        if(resultList != null && resultList.size() > 0){
        	returnMap = resultList.get(0);
        }else{
        	returnMap = new EgovMap();
        }

        // 조회 결과 리턴.
        return ResponseEntity.ok(returnMap);
	}

	/**
	 * E-Cash By Id  (Master Grid) 조회 -
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectECashSubDeductionById.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectECashSubDeductionById(@ModelAttribute("searchVO") SampleDefaultVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {

        List<EgovMap> resultList = eCashDeductionService.selectECashDeductSubList(params);

        return ResponseEntity.ok(resultList);
	}

	/**
	 * E Cash - Deactivate 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/eCashDeactivate.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> updateDeactivate(@RequestParam Map<String, Object> params,
    		Model model, SessionVO sessionVO) {

		params.put("userId", sessionVO.getUserId());
    	// 처리.
		eCashDeductionService.deactivateECashDeductionStatus(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage("Saved Successfully");

    	return ResponseEntity.ok(message);
    }
//
//	/**
//	 * Claim Result - Fail Deduction SMS 재발송 처리
//	 * @param params
//	 * @param model
//	 * @return
//	 */
//	@RequestMapping(value = "/sendFaileDeduction.do", method = RequestMethod.GET)
//    public ResponseEntity<ReturnMessage> sendFaileDeduction(@RequestParam Map<String, Object> params,
//    		Model model, SessionVO sessionVO) {
//
//		params.put("userId", sessionVO.getUserId());
//    	// 처리.
//		claimService.sendFaileDeduction(params);
//
//		// 결과 만들기.
//		ReturnMessage message = new ReturnMessage();
//    	message.setCode(AppConstants.SUCCESS);
//    	message.setMessage("Saved Successfully");
//
//    	return ResponseEntity.ok(message);
//
//    }
//
//	/**
//     * Claim Result Upload File 처리
//     * @param params
//     * @param model
//     * @return
//     * @RequestParam Map<String, Object> params
//     */
    @RequestMapping(value = "/updateECashDeductionResultItem.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateECashDeductionResultItem(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model) {

    	List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
    	List<Object> resultItemList = new ArrayList<Object>();
    	Map<String, Object> uploadMap = null;
    	int totalApproved = 0;
    	int totalRejected = 0;
    	int itmCnt = 0;
    	String settleDate = "";

		Map<String, Object> eCashMap = (Map<String, Object>)formList.get(0);

    	if (gridList.size() > 0) {
    		Map<String, Object> hm = null;
    		for (Object map : gridList) {
    			hm = (HashMap<String, Object>) map;

				// 첫번째 값이 없으면 skip
				if (hm.get("0") == null || String.valueOf(hm.get("0")).equals("")
						|| String.valueOf(hm.get("0")).trim().length() < 1) {
					continue;
				}

				if(settleDate == "" || settleDate == null){
					settleDate = String.valueOf(hm.get("9")).trim();
				}

    			uploadMap = new HashMap<String, Object>();

//				if ("3".equals(String.valueOf(eCashMap.get("fileBatchBankId")))) {
				uploadMap.put("itmId", (String.valueOf(hm.get("6"))).trim());
				uploadMap.put("appvCode", (String.valueOf(hm.get("8"))).trim());
				uploadMap.put("respnsCode", (String.valueOf(hm.get("7"))).trim());
				itmCnt += 1;
				uploadMap.put("itmCnt", itmCnt);
//				}
//				else if ("19".equals(String.valueOf(eCashMap.get("fileBatchBankId")))) {
//					uploadMap.put("itmId", (String.valueOf(hm.get("6"))).trim());
//					uploadMap.put("appvCode", (String.valueOf(hm.get("7"))).trim());
//					uploadMap.put("respnsCode", (String.valueOf(hm.get("7"))).trim());
//					uploadMap.put("itmCnt", (String.valueOf(hm.get("0"))).trim());
//				}

				resultItemList.add(uploadMap);

				if ("".equals(String.valueOf(uploadMap.get("appvCode")))) {
					totalRejected++;
				} else if (!"".equals(String.valueOf(uploadMap.get("appvCode")))) {
					totalApproved++;
				}
    		}

    	}

    	eCashMap.put("totalItem", gridList.size());
    	eCashMap.put("totalApproved", totalApproved);
    	eCashMap.put("totalRejected", totalRejected);
    	eCashMap.put("settleDate", settleDate);

    	// 데이터 등록
    	eCashDeductionService.updateECashDeductionResultItem(eCashMap, resultItemList);

    	// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(eCashMap);
    	message.setMessage("Saved Successfully");

    	return ResponseEntity.ok(message);
    }

    /**
     * eCash Result Update
     * @param params
     * @param model
     * @return
     * @RequestParam Map<String, Object> params
     */
    @RequestMapping(value = "/updateECashDeductionResult.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateECashDeductionResult(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model, SessionVO sessionVO) {

    	List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

    	// 폼객체 처리.
		Map<String, Object> eCashMap = (Map<String, Object>)formList.get(0);
		eCashMap.put("userId", sessionVO.getUserId());

		// 데이터 수정
		eCashDeductionService.updateECashDeductionResult(eCashMap);
    	// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(eCashMap);
    	message.setMessage("Saved Successfully");

    	return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/createECashDeductionFile.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> createECashDeductionFile(@RequestBody Map<String, ArrayList<Object>> params,
			Model model) throws Exception {

		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

		// Calim Master 데이터 조회
		Map<String, Object> map = (Map<String, Object>) formList.get(0);
		EgovMap claimMap = eCashDeductionService.selectECashDeductById(map);
		boolean isGrp = map.get("v_isGrp") != null ? true : false;

    		if(isGrp){
    			// For Credit Card Grouping Only
    			 //CIMB
        		if ("3".equals(String.valueOf(claimMap.get("fileBatchBankId")))) {
        			//10000건 단위로 추출하기 위해 전체 건수 조회
        			int totRowCount = eCashDeductionService.selectECashDeductCCSubByIdCnt(map);
        			int pageCnt = (int) Math.round(Math.ceil(totRowCount / 10000.0));

        			if (pageCnt > 0){
        				for(int i = 1 ; i <= pageCnt ; i++){
        					claimMap.put("pageNo", i);
        					claimMap.put("rowCount", 10000);
        					this.createECashGrpDeductionFileCIMB(claimMap);
        				}
        			}
                }else if ("19".equals(String.valueOf(claimMap.get("fileBatchBankId")))){// Standard Charted merchant getting MBB's cardHolder

                	int totRowCount = eCashDeductionService.selectECashDeductCCSubByIdCnt(map);
                	int totBatToday =  eCashDeductionService.selectECashDeductBatchGen(map);
        			int pageCnt = (int) Math.round(Math.ceil(totRowCount / 999.0));

        			if (pageCnt > 0){
        				for(int i = 1 ; i <= pageCnt ; i++){
        					claimMap.put("pageNo", i);
        					claimMap.put("rowCount", 999);
        					claimMap.put("batchNo",totBatToday);
        					claimMap.put("pageCnt", pageCnt);
        					this.createECashGrpDeductionFileMBB(claimMap);
        				}
        			}
                }

    		}else{
                //CIMB
        		if ("3".equals(String.valueOf(claimMap.get("fileBatchBankId")))) {
        			//10000건 단위로 추출하기 위해 전체 건수 조회
        			int totRowCount = eCashDeductionService.selectECashDeductSubByIdCnt(map);
        			int pageCnt = (int) Math.round(Math.ceil(totRowCount / 10000.0));

        			if (pageCnt > 0){
        				for(int i = 1 ; i <= pageCnt ; i++){
        					claimMap.put("pageNo", i);
        					claimMap.put("rowCount", 10000);
        					this.createECashDeductionFileCIMB(claimMap);
        				}
        			}
                }else if ("19".equals(String.valueOf(claimMap.get("fileBatchBankId")))){// Standard Charted merchant getting MBB's cardHolder

                	int totRowCount = eCashDeductionService.selectECashDeductSubByIdCnt(map);
                	int totBatToday =  eCashDeductionService.selectECashDeductBatchGen(map);
        			int pageCnt = (int) Math.round(Math.ceil(totRowCount / 999.0));

        			if (pageCnt > 0){
        				for(int i = 1 ; i <= pageCnt ; i++){
        					claimMap.put("pageNo", i);
        					claimMap.put("rowCount", 999);
        					claimMap.put("batchNo",totBatToday);
        					claimMap.put("pageCnt", pageCnt);
        					this.createECashDeductionFileMBB(claimMap);
        				}
        			}
                }
        }

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	private ECashDeductionFileCIMBHandler getTextDownloadCIMBHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ECashDeductionFileCIMBHandler(excelDownloadVO, params);
	}

	/**
	 * CRC CIMB - Create eCash Deduction File
	 *
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createECashDeductionFileCIMB(EgovMap claimMap) throws Exception {

		ECashDeductionFileCIMBHandler downloadHandler = null;
		String sFile;
		String todayDate;
		String inputDate;

		try {
			inputDate = CommonUtils.nvl(claimMap.get("fileBatchCrtDt")).equals("") ? "1900-01-01" : (String) claimMap.get("fileBatchCrtDt");
			todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
			sFile = "eCash_CIMB_CIMB_" + todayDate + "_" + String.valueOf(claimMap.get("pageNo"))   + ".csv";

			downloadHandler = getTextDownloadCIMBHandler(sFile, claimFileColumns, null, filePath, "/CRC/", claimMap);

			largeExcelService.downLoadECashDeductionFileCIMB(claimMap, downloadHandler);
			//downloadHandler.writeFooter();

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}

		// E-mail 전송하기
		File file = new File(filePath + "/CRC/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("CIMB eAuto Debit CRC Deduction File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);

	}

	@RequestMapping(value="/failedDeductionListPop.do")
	public String orderSalesYSListingPop(){

		return "payment/ecash/failedDeductionListPop";
	}

	private ECashDeductionFileMBBHandler getTextDownloadMBBHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ECashDeductionFileMBBHandler(excelDownloadVO, params);
	}

	/**
	 * CRC MMB - Create eCash Deduction File
	 *
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createECashDeductionFileMBB(EgovMap claimMap) throws Exception {

		ECashDeductionFileMBBHandler downloadHandler = null;
		String sFile;
		String todayDate;
		String inputDate;

		try {
			inputDate = CommonUtils.nvl(claimMap.get("fileBatchCrtDt")).equals("") ? "1900-01-01" : (String) claimMap.get("fileBatchCrtDt");
			todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "yyMMdd");
			//sFile = "CZ" + todayDate + StringUtils.leftPad(String.valueOf(claimMap.get("pageNo")), 2, "0") + ".dat";
			sFile = "CZ" + todayDate + ".dat";

			downloadHandler = getTextDownloadMBBHandler(sFile, claimFileColumns, null, filePath, "/CRC/", claimMap);
			largeExcelService.downLoadECashDeductionFileMBB(claimMap, downloadHandler);
			if(claimMap.get("pageNo") == claimMap.get("pageCnt")){
				downloadHandler.writeFooter();
			}

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}

		// E-mail 전송하기
		File file = new File(filePath + "/CRC/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("SCB eCash CRC Deduction File - Batch Date : " + inputDate + "_ "+ String.valueOf(claimMap.get("pageNo")));
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);

	}

	/**
	 * CRC CIMB - Create eCash Deduction Credit Card File
	 *
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createECashGrpDeductionFileCIMB(EgovMap claimMap) throws Exception {

		ECashGrpDeductionFileCIMBHandler downloadHandler = null;
		String sFile;
		String todayDate;
		String inputDate;

		try {
			inputDate = CommonUtils.nvl(claimMap.get("fileBatchCrtDt")).equals("") ? "1900-01-01" : (String) claimMap.get("fileBatchCrtDt");
			todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
			sFile = "eCash_CIMB_CIMB_" + todayDate + "_" + String.valueOf(claimMap.get("pageNo"))   + ".csv";

			downloadHandler = getTextDownloadCIMBGrpHandler(sFile, claimFileColumns, null, filePath, "/CRC/", claimMap);

			largeExcelService.downLoadECashGrpDeductionFileCIMB(claimMap, downloadHandler);
			//downloadHandler.writeFooter();

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}

		// E-mail 전송하기
		File file = new File(filePath + "/CRC/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("CIMB eAuto Debit CRC Deduction File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);

	}

	/**
	 * CRC MMB - Create eCash Deduction File
	 *
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createECashGrpDeductionFileMBB(EgovMap claimMap) throws Exception {

		ECashGrpDeductionFileMBBHandler downloadHandler = null;
		String sFile;
		String todayDate;
		String inputDate;

		try {
			inputDate = CommonUtils.nvl(claimMap.get("fileBatchCrtDt")).equals("") ? "1900-01-01" : (String) claimMap.get("fileBatchCrtDt");
			todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "yyMMdd");
			//sFile = "CZ" + todayDate + StringUtils.leftPad(String.valueOf(claimMap.get("pageNo")), 2, "0") + ".dat";
			sFile = "CZ" + todayDate + ".dat";

			downloadHandler = getTextDownloadMBBGrpHandler(sFile, claimFileColumns, null, filePath, "/CRC/", claimMap);
			largeExcelService.downLoadECashGrpDeductionFileMBB(claimMap, downloadHandler);
			if(claimMap.get("pageNo") == claimMap.get("pageCnt")){
				downloadHandler.writeFooter();
			}

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}

		// E-mail 전송하기
		File file = new File(filePath + "/CRC/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("SCB eCash CRC Grouping Deduction File - Batch Date : " + inputDate + "_ "+ String.valueOf(claimMap.get("pageNo")));
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);

	}

	private ECashGrpDeductionFileCIMBHandler getTextDownloadCIMBGrpHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ECashGrpDeductionFileCIMBHandler(excelDownloadVO, params);
	}

	private ECashGrpDeductionFileMBBHandler getTextDownloadMBBGrpHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ECashGrpDeductionFileMBBHandler(excelDownloadVO, params);
	}


	@RequestMapping(value = "/eCashDeductionGrpList.do")
	public String eCashDeductionGrpList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/ecash/eCashDeductionGrpList";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/generateNewECashGrpDeduction.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> generateNewECashGrpDeduction(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model, SessionVO sessionVO) {

		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

		Map<String, Object> returnMap = new HashMap<String, Object>();
		Map<String, Object> searchMap = null;
		String returnCode = "";

    	//form 객체 값을 담을 Map
    	Map<String, Object> eCashDeduction = new HashMap<String, Object>();

    	//form 객체 데이터 세팅
    	if (formList.size() > 0) {
    		formList.forEach(obj -> {
                Map<String, Object> map = (Map<String, Object>) obj;
                eCashDeduction.put((String)map.get("name"),map.get("value"));
    		});
    	}
		//검색 파라미터 확인.(화면 Form객체 입력값)
    	LOGGER.debug("claimType : {}", eCashDeduction.get("claimType"));
    	LOGGER.debug("new_issueBank : {}", eCashDeduction.get("hiddenIssueBank"));
    	LOGGER.debug("new_merchantBank : {}", eCashDeduction.get("new_merchantBank"));
    	LOGGER.debug("cardType : {}", eCashDeduction.get("new_cardType"));

    	int isGrp = eCashDeduction.get("v_isGrp") != null ? 1 : 0;
		// HasActiveBatch : 동일한 bankId, eCashDeduction Type 에 해당하는 active 건이 있는지 확인한다.
		searchMap = new HashMap<String, Object>();
		searchMap.put("issueBank", eCashDeduction.get("new_issueBank"));
		//searchMap.put("claimType", eCashDeduction.get("claimType"));
		searchMap.put("status", "1");

        List<EgovMap> isActiveBatchList = eCashDeductionService.selectECashDeductList(searchMap);

        //Active인 배치가 있는 경우
        if(isActiveBatchList.size() > 0){
        	returnCode = "IS_BATCH";
        	returnMap = (Map<String, Object>)isActiveBatchList.get(0);
        }else{
        	String bankId  = CommonUtils.nvl(String.valueOf(eCashDeduction.get("new_merchantBank")));
        	String cardType  = CommonUtils.nvl(String.valueOf(eCashDeduction.get("new_cardType")));
        	String issueBank  = CommonUtils.nvl(String.valueOf(eCashDeduction.get("hiddenIssueBank")));

        	eCashDeduction.put("new_merchantBank", bankId);
        	eCashDeduction.put("new_issueBank", issueBank);
        	eCashDeduction.put("new_cardType", cardType);
        	eCashDeduction.put("new_isGrp", isGrp);
        	eCashDeduction.put("userId", sessionVO.getUserId());

        	eCashDeductionService.createECashGrpDeduction(eCashDeduction);		        	//프로시저 함수 호출
        	List<EgovMap> resultMapList = (List<EgovMap>)eCashDeduction.get("eCash");         	//결과 뿌려보기 : 프로시저에서 p1이란 key값으로 객체를 반환한다.

        	if(resultMapList.size() > 0){
        		//프로시저 결과 Map
        		returnMap = (Map<String, Object>)resultMapList.get(0);
        		returnCode = "FILE_OK";
        	}else{
        		returnCode = "FAIL";
        	}
        }

        // 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(returnCode);
    	message.setData(returnMap);
    	message.setMessage("Claim successfully saved. \n File Batch ID : ");

		return ResponseEntity.ok(message);

    }

    @RequestMapping(value = "/updateECashGrpDeductionResult.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateECashGrpDeductionResult(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model, SessionVO sessionVO) {

    	List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

    	// 폼객체 처리.
		Map<String, Object> eCashMap = (Map<String, Object>)formList.get(0);
		eCashMap.put("userId", sessionVO.getUserId());

		// 데이터 수정
		eCashDeductionService.updateECashGrpDeductionResult(eCashMap);
    	// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(eCashMap);
    	message.setMessage("Saved Successfully");

    	return ResponseEntity.ok(message);
    }


}
